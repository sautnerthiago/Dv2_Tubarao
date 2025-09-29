
#Include 'Protheus.ch'
#Include 'FWMVCDef.ch'

/*/{Protheus.doc} MT120FIM
Ponto de Entrada 

@author Victor Ramon
@since 16/10/2024
@version 1.0
    @return Nil, Função não tem retorno
    @example
    @obs 
/*/

User Function MT120FIM()

	Local cNumPC    := PARAMIXB[2]   // Numero do Pedido de Compras
	Local nOpcA     := PARAMIXB[3]   // Indica se a ação foi Cancelada = 0  ou Confirmada = 1.CODIGO DE APLICAÇÃO DO USUARIO.....
	Local aAreaSC7	:= SC7->(GetArea())
	Local cFornece  := ""

	If nOpcA == 1

		cFornece:= AllTrim(POSICIONE('SA2',1,XFILIAL('SA2')+SC7->C7_FORNECE+SC7->C7_LOJA,'A2_NOME'))

		DbSelectArea("SC7")
		SC7->(DbSetorder(1))
		SC7->(Dbgotop())

		If SC7->(DbSeek(xFilial("SC7")+cNumPC))
			While SC7->( !EOF() ) .And. SC7->C7_FILIAL+SC7->C7_NUM == xFilial("SC7")+cNumPC

				SC7->(RecLock("SC7", .F.))

				Replace SC7->C7_X_NOME With cFornece

				SC7->(MsUnlock())

				SC7->(dBSkip())

			EndDo
		EndIf
	EndIf

	RestArea(aAreaSC7)

Return
