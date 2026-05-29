extends CommonSelectButton

@export 
var btn:Button

var form:SaveForm
var loading:bool = false

func initialize(index:int,form:SaveForm):
	#self.index = index
	self.form = form
	# 存档
	if form.isSave:
		btn.text = tr("存档-{0}").format([index+1])
		if btn.focus_entered.is_connected(onSaveBtnFocused):
			btn.focus_entered.disconnect(onSaveBtnFocused)
		btn.focus_entered.connect(onSaveBtnFocused.bind(index))
		if btn.pressed.is_connected(onBtnSaveClick):
			btn.pressed.disconnect(onBtnSaveClick)
		btn.pressed.connect(onBtnSaveClick.bind(index))
	else:
		btn.text = tr("读档-{0}").format([index+1])
		if btn.focus_entered.is_connected(onSaveBtnFocused):
			btn.focus_entered.disconnect(onSaveBtnFocused)
		btn.focus_entered.connect(onSaveBtnFocused.bind(index))
		if btn.pressed.is_connected(onBtnLoadClick):
			btn.pressed.disconnect(onBtnLoadClick)
		btn.pressed.connect(onBtnLoadClick.bind(index))

func onSaveBtnFocused(index:int):
	form.index = index
	form.cal_page(form.index)
	form.ShowSaveMsg(index)

func onBtnSaveClick(index:int):
	print("Save at ",index+1)
	MotaSystem.saveManager.Save(index)
	AudioManager.playSE("RPG3_UI_PositiveNotificationv2.wav")
	form.close()

func onBtnLoadClick(index:int):
	if !loading:
		print("Load at ",index+1)
		loading = MotaSystem.saveManager.Load(index)
