#Include 'Protheus.ch'

//Adi��o de op��o no menu de a��es relacionadas do Pedido de Vendas
User Function MA410MNU()

	Local aArea := GetArea()
	//Adicionando  de vincular funÃ§Ã£o função
	
	aadd(aRotina,{"Pre Nota",	"MATR730",	0 , 4, 0 , Nil})
	aadd(aRotina,{"Ordem Sep.",	"U_CERTSCENS",	0 , 4, 0 , Nil})
	
	RestArea(aArea)

Return
