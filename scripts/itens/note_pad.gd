extends Control

# ========= CONFIG (arraste no Inspetor) =========
@export var total_pages: int = 10

@export var btn_left_path: NodePath            # Button_Left
@export var btn_right_path: NodePath           # Button_Right
@export var btn_exit_path: NodePath            # Button_Exit
@export var exit_scene: PackedScene            # (opcional) cena para voltar

@export var lbl_page_left_path: NodePath       # Label_Page_Left  (rodapé)
@export var lbl_page_right_path: NodePath      # Label_Page_Right (rodapé)
@export var lbl_page_id_main_path: NodePath    # Label_Page_ID_Principal (topo)

@export var page_left_container_path: NodePath  # Page_Left
@export var page_right_container_path: NodePath # Page_Right

@export var text_left_path: NodePath           # Text_Left  (TextEdit)
@export var text_right_path: NodePath          # Text_Right (TextEdit)

# ========= ESTADO =========
var selected_page: int = 1
var pages: Array[String] = []

# ========= REFS =========
@onready var btn_left: Button = get_node(btn_left_path)
@onready var btn_right: Button = get_node(btn_right_path)
@onready var lbl_left: Label = get_node(lbl_page_left_path)
@onready var lbl_right: Label = get_node(lbl_page_right_path)
@onready var lbl_page_id_main: Label = get_node(lbl_page_id_main_path)
@onready var page_left_container: Control = get_node(page_left_container_path)
@onready var page_right_container: Control = get_node(page_right_container_path)
@onready var text_left: TextEdit = get_node(text_left_path)
@onready var text_right: TextEdit = get_node(text_right_path)

func _ready() -> void:
	# garante pelo menos 1 página e vetor do tamanho certo
	total_pages = max(total_pages, 1)
	pages.resize(total_pages)
	for i in pages.size():
		if pages[i] == null:
			pages[i] = ""

	# conecta botões de navegação
	if btn_left and not btn_left.pressed.is_connected(_on_left_pressed):
		btn_left.pressed.connect(_on_left_pressed)
	if btn_right and not btn_right.pressed.is_connected(_on_right_pressed):
		btn_right.pressed.connect(_on_right_pressed)

	# conecta botão sair (se existir)
	if not btn_exit_path.is_empty():
		var btn_exit: Button = get_node(btn_exit_path)
		if btn_exit and not btn_exit.pressed.is_connected(_on_exit_pressed):
			btn_exit.pressed.connect(_on_exit_pressed)

	# salva texto ao digitar
	if text_left and not text_left.text_changed.is_connected(_on_text_left_changed):
		text_left.text_changed.connect(_on_text_left_changed)
	if text_right and not text_right.text_changed.is_connected(_on_text_right_changed):
		text_right.text_changed.connect(_on_text_right_changed)

	# clique para selecionar lado
	if page_left_container and not page_left_container.gui_input.is_connected(_on_left_page_gui_input):
		page_left_container.gui_input.connect(_on_left_page_gui_input)
	if page_right_container and not page_right_container.gui_input.is_connected(_on_right_page_gui_input):
		page_right_container.gui_input.connect(_on_right_page_gui_input)

	# garante seleção válida e desenha
	selected_page = clamp(selected_page, 1, total_pages)
	_refresh_ui()

# ======== NAVEGAÇÃO ========
func _on_left_pressed() -> void:
	if selected_page > 1:
		set_selected_page(selected_page - 1)

func _on_right_pressed() -> void:
	if selected_page < total_pages:
		set_selected_page(selected_page + 1)

func set_selected_page(p: int) -> void:
	selected_page = clamp(p, 1, total_pages)
	_refresh_ui()  # << ESSENCIAL: atualiza a UI sempre que a página muda

# ======== ATUALIZAÇÃO DE TELA ========
func _refresh_ui() -> void:
	# par visível (1–2, 3–4, ...)
	var left_page: int = ((selected_page - 1) / 2) * 2 + 1
	var right_page: int = left_page + 1
	if right_page > total_pages:
		right_page = total_pages
	var has_right: bool = right_page > left_page

	# rodapé
	if lbl_left:
		lbl_left.text = "Pág. %d" % left_page
	if lbl_right:
		lbl_right.visible = has_right
		if has_right:
			lbl_right.text = "Pág. %d" % right_page

	# visibilidade da página direita
	if page_right_container:
		page_right_container.visible = has_right

	# carregar textos
	if text_left:
		text_left.text = pages[left_page - 1]
	if text_right:
		text_right.text = pages[right_page - 1] if has_right else ""

	# botões nas pontas
	if btn_left:
		btn_left.disabled = (selected_page == 1)
	if btn_right:
		btn_right.disabled = (selected_page == total_pages)

	# label principal (topo)
	if lbl_page_id_main:
		lbl_page_id_main.text = "Página %d de %d" % [selected_page, total_pages]

	_apply_selection_highlight()

func _apply_selection_highlight() -> void:
	# sem destaque (ambos 100% opacos)
	if page_left_container:
		page_left_container.modulate = Color(1,1,1,1)
	if page_right_container:
		page_right_container.modulate = Color(1,1,1,1)

# ======== SALVAR TEXTO DIGITADO ========
func _on_text_left_changed() -> void:
	var left_page: int = ((selected_page - 1) / 2) * 2 + 1
	pages[left_page - 1] = text_left.text

func _on_text_right_changed() -> void:
	var left_page: int = ((selected_page - 1) / 2) * 2 + 1
	var right_page: int = left_page + 1
	if right_page > total_pages:
		return
	pages[right_page - 1] = text_right.text

# ======== CLIQUE PARA SELECIONAR LADO ========
func _on_left_page_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		set_selected_page(((selected_page - 1) / 2) * 2 + 1)

func _on_right_page_gui_input(event: InputEvent) -> void:
	if not page_right_container or not page_right_container.visible:
		return
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		set_selected_page(((selected_page - 1) / 2) * 2 + 2)

# ======== SAIR ========
func _on_exit_pressed() -> void:
	if exit_scene:
		get_tree().change_scene_to_packed(exit_scene)
	else:
		get_tree().quit()

# ======== ATALHOS ========
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):  # Esc
		_on_exit_pressed()
	elif event.is_action_pressed("ui_left"):
		_on_left_pressed()
	elif event.is_action_pressed("ui_right"):
		_on_right_pressed()
