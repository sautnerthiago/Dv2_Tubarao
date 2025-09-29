#INCLUDE "PROTHEUS.CH"
#INCLUDE "FWMVCDEF.CH"
#INCLUDE "FWEditPanel.CH"
#INCLUDE "TBICONN.CH"
#Include "Totvs.ch"

#DEFINE CRLF CHR(13)+CHR(10)

/*/{Protheus.doc} u_EVSPRCVE() 

Manuten��o Integra��o Dados Financeiros

@author Victor Ramon - DV2
@since 12/11/2024
@version 1.0
/*/

User Function ORCPRCVE()

	Local lRet     := .T.
	Local nPrcMi   := 0
	Local nPosPrd  := aScan(aHeader, {|X| ALLTRIM(X[2])=="CK_PRODUTO"})
	Local cTabela  := M->CJ_TABELA
	Local cEvsPrc  := GETMV("MV_EVSPRC",.f.,"")
	Local cProduto := CK_PRODUTO

	If  !__cUserId $ Alltrim(cEvsPrc)

		nPrcMi := Posicione("DA1",1,xFilial("DA1")+cTabela+CK_PRODUTO,"DA1_XPRCMI")

		If M->CK_PRCVEN < nPrcMi

			MsgAlert("O pre�o de venda informado est� abaixo do permitido. Pre�o minimo permitido: R$ "+ AllTrim(Transform(nPrcMi,"@E 999,999,999.99"))+CRLF+CRLF+"Por favor, solicite a libera��o para prosseguir.","Aten��o")

			lRet := .F.

		EndIf
	Else
		nPrcMi := Posicione("DA1",1,xFilial("DA1")+cTabela+CK_PRODUTO,"DA1_XPRCMI")
		MsgAlert("O pre�o de venda informado est� abaixo do permitido. Pre�o minimo permitido: R$ "+ AllTrim(Transform(nPrcMi,"@E 999,999,999.99"))+CRLF+CRLF+"Por favor, solicite a libera��o para prosseguir.","Aten��o")
	EndIf

Return lRet
