#Include 'Protheus.ch'

//Adição de opção no menu de ações relacionadas do Pedido de Vendas
User Function MA410MNU()

	Local aArea := GetArea()
	//Adicionando  de vincular funÃƒÂ§ÃƒÂ£o funÃ§Ã£o
	
	aadd(aRotina,{"Pre Nota",	"MATR730",	0 , 4, 0 , Nil})
	aadd(aRotina,{"Ordem Sep.",	"U_CERTSCENS",	0 , 4, 0 , Nil})
	
	RestArea(aArea)

Return
