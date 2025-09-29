#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"

/*/{Protheus.doc} MTA416PV
PONTO DE ENTRADA DE GRAVACAO DE DADOS DO ORCAMENTO PARA PEDIDO
@type function
@version  1.0.0
@author Victor Ramon 
@since 03/06/2025 
@param _pcOrigem, variant, E-mail Origem
@return variant, return
/*/
USER FUNCTION MTA416PV()

	Local a_Area   := GetArea()
	Local aAreaSCK := GetArea("SCK")
	Local nAux     := PARAMIXB

	M->C5_NATUREZ  := SA1->A1_NATUREZ
	M->C5_XCGC     := SA1->A1_CGC
    M->C5_X_NOME   := SA1->A1_NOME

	_aCols[nAux,GdFieldPos("C6_QTDLIB",_aHeader)] := SCK->CK_QTDVEN

	RestArea(aAreaSCK)
	RestArea(a_Area)

RETURN
