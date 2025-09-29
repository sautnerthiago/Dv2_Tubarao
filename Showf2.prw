#INCLUDE "rwmake.ch"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"


User Function ChkExec()

	Local aArea     := FWGetArea()
	Local lContinua := .T.
	Private cFuncao    := Upper(ParamIXB)

	//Se vier da rotina Pedido de vendas, habilita o uso de atalhos, devido a tela não ter ponto de entrada para manipular o menu
	If ("MATA410" $ cFuncao)
		SetKey(VK_F2, {|| U_ShowSC6()})
	EndIf

	//Se vier da Rotina Orçamento, habilita o uso de atalhos, devido a tela não ter ponto de entrada para manipular o menu
	If ("MATA415" $ cFuncao)
		SetKey(VK_F2, {|| U_ShowSCK()})
	EndIf

	//Se vier da Rotina de Pedido de Compras, habilita o uso de atalhos, devido a tela não ter ponto de entrada para manipular o menu
	If ("MATA121" $ cFuncao)
		SetKey(VK_F2, {|| U_ShowSC7()})
	EndIf

	FWRestArea(aArea)

Return lContinua


User Function ShowSC6()

	Local cCampo:=AllTrim(Upper(ReadVar()))
	Local cLocal   := ""
	Local cProdSC6 := ""

	cFilBkp		:= cFilAnt
	cFilAnt     := "0101"

	cLocal  :=  aCols[n,aScan(aHeader,{|x| AllTrim(x[2])=="C6_LOCAL"})]
	cProdSC6:=  aCols[n,aScan(aHeader,{|x| AllTrim(x[2])=="C6_PRODUTO"})]
	MaViewSB2(cProdSC6)

	cFilAnt		:= cFilBkp

Return NIL


User Function ShowSCK()

	Local cCampo:=AllTrim(Upper(ReadVar()))
	Local cLocal   := ""
	Local cProdSCK := CK_PRODUTO

	cFilBkp		:= cFilAnt
	cFilAnt     := "0101"

	MaViewSB2(cProdSCK)

	cFilAnt		:= cFilBkp

Return NIL


User Function ShowSC7()

	Local cCampo:=AllTrim(Upper(ReadVar()))
	Local cLocal   := ""
	Local cProdSC7 := ""

	cFilBkp		:= cFilAnt
	cFilAnt     := "0101"

	cLocal  :=  aCols[n,aScan(aHeader,{|x| AllTrim(x[2])=="C7_LOCAL"})]
	cProdSC7 := aCols[n,aScan(aHeader,{|x| AllTrim(x[2])=="C7_PRODUTO"})]
	MaViewSB2(cProdSC7)

	cFilAnt		:= cFilBkp

Return NIL




