
#Include 'Protheus.ch'
#Include 'FWMVCDef.ch'

/*/{Protheus.doc} FAT001
Ponto de Entrada 

@author Victor Ramon
@since 24/10/2024
@version 1.0
    @return Nil, Função não tem retorno
    @example
    @obs 
/*/

User Function FAT001()

	Local cgc:= ""

	If !M->C5_TIPO = "D" 
		cgc:= AllTrim(POSICIONE('SA1',1,XFILIAL('SA1')+M->C5_CLIENTE+M->C5_LOJACLI,'A1_CGC')) //Cliente
	else
		cgc:= AllTrim(POSICIONE('SA2',1,XFILIAL('SA2')+M->C5_CLIENTE+M->C5_LOJACLI,'A2_CGC')) //Fornecedor
	EndIf

Return(cgc)
