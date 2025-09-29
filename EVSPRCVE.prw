#INCLUDE "PROTHEUS.CH"
#INCLUDE "FWMVCDEF.CH"
#INCLUDE "FWEditPanel.CH"
#INCLUDE "TBICONN.CH"
#Include "Totvs.ch"

#DEFINE CRLF CHR(13)+CHR(10)

/*/{Protheus.doc} u_EVSPRCVE() 

Gatilho pedido de vendas

@author Victor Ramon - DV2
@since 12/11/2024
@version 1.0
/*/

User Function EVSPRCVE()

	Local lRet    := .T.
	Local nPrcMi  := 0
	Local nPosPrd := aScan(aHeader, {|X| ALLTRIM(X[2])=="C6_PRODUTO"})
	Local cTabela := M->C5_TABELA
	Local cEvsPrc := GETMV("MV_EVSPRC",.f.,"")

	If  !__cUserId $ Alltrim(cEvsPrc)

		nPrcMi := Posicione("DA1",1,xFilial("DA1")+cTabela+aCOLS[n][nPosPrd],"DA1_XPRCMI")

		If M->C6_PRCVEN < nPrcMi

			MsgAlert("O preço de venda informado está abaixo do permitido. Preço minimo permitido: R$ "+ AllTrim(Transform(nPrcMi,"@E 999,999,999.99"))+CRLF+CRLF+"Por favor, solicite a liberação para prosseguir.","Atenção")

			lRet := .F.
		EndIf
	Else
		nPrcMi := Posicione("DA1",1,xFilial("DA1")+cTabela+aCOLS[n][nPosPrd],"DA1_XPRCMI")
		MsgAlert("O preço de venda informado está abaixo do permitido. Preço minimo permitido: R$ "+ AllTrim(Transform(nPrcMi,"@E 999,999,999.99"))+CRLF+CRLF+"Por favor, solicite a liberação para prosseguir.","Atenção")
	EndIf


Return lRet
