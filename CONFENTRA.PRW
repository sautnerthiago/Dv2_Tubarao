#INCLUDE "RWMAKE.CH"
#INCLUDE "topconn.ch"
#INCLUDE "Protheus.ch"
#INCLUDE "FWPrintSetup.ch"
#INCLUDE "RPTDEF.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "COLORS.CH"
#include "ap5mail.ch"
/*
{Protheus.doc} CERTSCENS 
description 
Ordem de Separação Tubarão
@type function
@version  
@author Victor Ramon
@since 27/05/2025
@return variant, return_description
*/	
User Function CERTSCENS()

	Local cPerg 	:= PadR('CONFENTRA',10)
	Private _aArea  := GetArea()
	Private cNumPed :=""

	If Pergunte(cPerg,.T.)
		cNumPed   := mv_par01
		u_CERTSC()
	EndIf
	RestArea(_aArea)
RETURN(.t.)

/*
{Protheus.doc} CERTSC 
description 
CRIADO FUNCAO PARA EMISSAO DO RELATORIO VISANDO JOB. 
@type function
@version  
@author Ricardo.Cavalini 
@since 10/10/2023
@return variant, return_description
*/	
user function CERTSC()
	cCNPJSld	:= ""
	nTotIPI		:= 0
	nTotICM		:= 0
	nTotSOL		:= 0
	nValIPI		:= 0
	nValICM		:= 0
	nValSOL		:= 0
	nItem		:= 0
	nTotQtd		:= 0
	nTotGeral	:= 0
	nBasICM		:= 0
	nBasSOL		:= 0
	nTobICM		:= 0
	nTobSOL		:= 0
	Cabec1      := ""

	cNomearq	        := cNumPed

	Processa({|lEnd|MtaCert(cnomearq)})

Return()

/*
{Protheus.doc} MtaCert 
description 
montagem do relatorio 
@type function
@version  
@author Ricardo.Cavalini 
@since 10/10/2023
@return variant, return_description
*/	
Static Function MtaCert(cnomearq)

	local oPrint
	local oFont11c
	local oFont10
	local oFont14
	local oFont16n
	local oFont15
	local oFont14n
	local oFont24
	local _ARETOP :={}
	local nx := 1
	local ny := 1
	local cvalidNun := ""
	local ncont := 0
	local nsalta := 0
	local nNova := 0
	local nPag  :=0

	oBsComp     := ""

	Private cLogo		:= "lgrl01.bmp"
	cNomearq	        := "TESTE"

	oFont9		:= TFont():New("Arial"		,9, 9,.T.,.F.,5,.T.,5,.T.,.F.)
	oFont10		:= TFont():New("Arial"		,9,10,.T.,.F.,5,.T.,5,.T.,.F.)
	oFont10n	:= TFont():New("Arial"		,9,10,.T.,.T.,5,.T.,5,.T.,.F.)
	oFont11		:= TFont():New("Arial"		,9,11,.T.,.F.,5,.T.,5,.T.,.F.)
	oFont11n	:= TFont():New("Arial"		,9,11,.T.,.T.,5,.T.,5,.T.,.F.)
	oFont12		:= TFont():New("Arial"		,9,12,.T.,.F.,5,.T.,5,.T.,.F.)
	oFont14		:= TFont():New("Arial"		,9,14,.T.,.F.,5,.T.,5,.T.,.F.)
	oFont14n	:= TFont():New("Arial"		,9,14,.T.,.T.,5,.T.,5,.T.,.F.)
	oFont15		:= TFont():New("Arial"		,9,15,.T.,.F.,5,.T.,5,.T.,.F.)
	oFont15n	:= TFont():New("Arial"		,9,15,.T.,.T.,5,.T.,5,.T.,.F.)
	oFont16		:= TFont():New("Arial"		,9,16,.T.,.F.,5,.T.,5,.T.,.F.)
	oFont16n	:= TFont():New("Arial"		,9,16,.T.,.T.,5,.T.,5,.T.,.F.)
	oFont20		:= TFont():New("Arial"		,9,20,.T.,.F.,5,.T.,5,.T.,.F.)
	oFont21		:= TFont():New("Arial"		,9,21,.T.,.F.,5,.T.,5,.T.,.F.)
	oFont24		:= TFont():New("Arial"		,9,24,.T.,.F.,5,.T.,5,.T.,.F.)
	oFont28n	:= TFont():New("Arial"	,9,28,.T.,.T.,5,.T.,5,.T.,.F.)
	oFont11c	:= TFont():New("Courier New",9,11,.T.,.T.,5,.T.,5,.T.,.F.)

	If .T.
		lPreview := .T.
		oPrint 	 := FWMSPrinter():New(cNomearq,IMP_PDF)
		oPrint:cPathPDF := "C:\temp\"
		IF oPrint:nModalResult == PD_OK
			oPrint:StartPage()
		ELSE
			RETURN
		ENDIF
	EndIf

	//oPrint:StartPage()

	nLin	:= 200
	nNova      := 2350
	nitem      := 1

//  Busca Pedido e Vendas

	_ARETOP := ACHDADO(cnomearq)

	If len(_ARETOP)  > 0

		ncont :=len(_ARETOP)
		nsalta := 18
		nPag  := Ceiling(ncont/nsalta)

		For ny:= 1 to nPag

			If ny > 1
				oPrint:StartPage()
			EndIf

			oPrint:SayBitmap(010,100,cLogo,350,347)      // Imprime o Logo

			nLin		:= 200

			cvalidNun := _ARETOP[ny][1]

			// impressao quadro cabaçalho 1
			oPrint:Box( 010, 450, 350, 1380, "-4")

			// impressao quadro cabaçalho 2
			oPrint:Box( 010, 1382, 350, 1598, "-4")

			// impressao quadro cabaçalho 3
			oPrint:Box( 010, 1602, 350, 2250, "-4")

			// impressao quadro rodapé bloqco 1
			oPrint:Box( 2900, 100   ,2550, 1300, "-4")
			oPrint:Say( 2600, 120	,"Separador",oFont16)
			oPrint:Say( 2600, 700	,"Conferente",oFont16)
			oPrint:Say( 2680, 120	,"_______________________________________________________",oFont16)
			oPrint:Say( 2750, 120	,"Data",oFont16)
			oPrint:Say( 2750, 600	,"Inicio",oFont16)
			oPrint:Say( 2750, 910	,"Fim",oFont16)
			oPrint:Say( 2820, 120	,"_______________________________________________________",oFont16)
			oPrint:Say( 2890, 120	,"Visto para liberar faturamento",oFont9)

			// impressao quadro rodapé bloco 2
			oPrint:Box( 2900, 1303  ,2550, 2250, "-4")
			oPrint:Box( 2700, 1303  ,2550, 2250, "-4")
			oPrint:Say( 2600, 1310	,"Observação",oFont16)
			oPrint:Say( 2750, 1310	,"Transportadora",oFont16)
			oPrint:Say( 2820, 1310	,"Peso Liquido",oFont16)
			oPrint:Say( 2820, 1840	,"Volume",oFont16)

			// impressao quadro Fornecedor
			oPrint:Box( 354, 100, 480, 2250, "-4")

			// impressao quadro Descrição
			oPrint:Box( 485, 100, 560, 2250, "-4")

			//  impressão quadro cabeçalho 1
			oPrint:Say		(nLin 		,0630	,"Ordem de Serviço" 		,oFont28n)

			//	impressão quadro cabeçalho 2
			oPrint:Say		(nLin-=100 	,1440	,"Rota" 	,oFont16n)
			oPrint:Say		(nLin+=080  ,1440	,Left(AllTrim(_ARETOP[ny][13]),2) 		,oFont28n)
			If Len(_ARETOP[ny][14]) > 15
				oPrint:Say		(nLin+=080  ,1397	,Left(AllTrim(_ARETOP[ny][14]),15) 		,oFont9)
			Else
				oPrint:Say		(nLin+=080  ,1440	,Left(AllTrim(_ARETOP[ny][14]),15) 		,oFont9)
			EndIf

			//  impressão quadro cabeçalho 3
			oPrint:Say		(nLin-=160	,1610	,"Pedido de Compras:  " 			    ,oFont16n)
			oPrint:Say		(nLin 		,2000	,_ARETOP[ny][1] 					    ,oFont16)//Numero do Pedido
			oPrint:Say		(nLin+=050	,1610	,"Data: " 							    ,oFont16n)
			oPrint:Say		(nLin		,2000	,dtoc(_ARETOP[ny][10])				    ,oFont16)//Data do Pedido
			oPrint:Say		(nLin+=050	,1610	,"Empresa: " 							,oFont16n)
			oPrint:Say		(nLin		,2010	,cFilant							    ,oFont16)
			oPrint:Say		(nLin+=050	,1610	,"Vendedor:"							,oFont16n)
			oPrint:Say		(nLin		,1880	,Left(AllTrim(_ARETOP[ny][11]),15) 		,oFont16)
			//oPrint:Say		(nLin+=050	,1610	,"Vendedor:" 						,oFont16n)
			//oPrint:Say		(nLin		,1880	,Left(AllTrim(_ARETOP[ny][11]),15)	,oFont16)

			// quardro fornecedor
			oPrint:Say		(nLin+=180	,120	,"Entidade: "						,oFont16)
			oPrint:Say		(nLin+=10	,300	,Left(AllTrim(_ARETOP[ny][12]),50)	,oFont24)

			Cabec1 := "Local         " + "CA Marca          "	+ "	Código                 "	+"Quant         " +"	Unid.         " + "Descrição do Produto                                             "+ "Saldo Produto Pedido"
			oPrint:Say		(nLin+=88 	,120	,Cabec1 	   ,oFont14n)

			For nx:= nitem to len(_ARETOP)

				oPrint:Say	(nLin+=70	,100	,_ARETOP[nx][15]							,oFont14)//CA
				oPrint:Say	(nLin   	,300	,_ARETOP[nx][6]								,oFont14)//CA
				oPrint:Say	(nLin		,530	,_ARETOP[nx][2]								,oFont16)//PRODUTO
				oPrint:Say	(nLin		,800	,Transform(_ARETOP[nx][8],"@E 999,999.99")	,oFont16)//QUANTIDADE LIBERADA
				oPrint:Say	(nLin		,980	,_ARETOP[nx][3]								,oFont16)//TIPO DO PRODUTO
				oPrint:Say	(nLin		,1150	,Left(AllTrim(_ARETOP[nx][4]),28)			,oFont16)//DESCRIÇÃO DO PRODUTO
				oPrint:Say	(nLin		,1980	,Transform(_ARETOP[nx][5],"@E 999,999.99")	,oFont16)//QUANTIDADE EM ESTOQUE

				nLin+=40
				oPrint:Say	(nLin		,300	,_ARETOP[nx][7]								,oFont12)//FABRICANTE
				oPrint:Say	(nLin		,1150	,Left(AllTrim(_ARETOP[nx][9]),28)			,oFont12)//DESCRIÇÃO 2 DO PRODUTO
				nLin++

				nitem:= ++nitem

				If nLin >= nNova
					Exit
				End
			Next
			oPrint:EndPage()
		Next
		oPrint:Preview()
	endif

Return()

/*
{Protheus.doc} MTA720A 
description 
Ponto de Entrada para tratamento da aglunitaÃ§Ã£o da op. 
@type function
@version  
@author Ricardo.Cavalini 
@since 12/10/2023
@return variant, return_description
*/	
STATIC Function ACHDADO(_CNUMOP)

	Local  cQry     := ""
	Local  cLocaliz := ""
	Local  ADADRLT  := {}
	

	dbSelectArea("SBF")
	dbSetOrder(1)
	
	cQry := "SELECT   C5_NUM,  C6_PRODUTO,  B1_TIPO,  C6_DESCRI,  B2_QATU,  C6_QTDVEN, "
	cQry += "MAX(B1_ZZCA)      AS B1_ZZCA, "
	cQry += "MAX(B1_FABRIC)    AS B1_FABRIC, "
	cQry += "MAX(B1_DESC2)     AS B1_DESC2, "
	cQry += "MAX(C5_EMISSAO)   AS C5_EMISSAO, "
	cQry += "MAX(C5_XVEND1)    AS C5_XVEND1, "
	cQry += "MAX(A1_NOME)      AS A1_NOME, "
	cQry += "MAX(A1_ROTA)      AS A1_ROTA, "
	cQry += "MAX(A1_DESCROT)   AS A1_DESCROT, "
	cQry += "MAX(B1_LOCALIZ)   AS B1_LOCALIZ, "
	cQry += "MAX(C6_LOCAL)     AS C6_LOCAL "
	cQry += "FROM " +RetSqlName("SC6")+ " SC6 (NOLOCK) "
	cQry += "INNER JOIN "+RetSqlName("SC5")+ " (NOLOCK) SC5 ON SC5.D_E_L_E_T_ = ' ' AND SC5.C5_FILIAL = C6_FILIAL AND SC5.C5_NUM = C6_NUM "
	cQry += "INNER JOIN "+RetSqlName("SB1")+ " (NOLOCK) SB1 ON SB1.D_E_L_E_T_ = ' ' AND SB1.B1_COD = C6_PRODUTO "
	cQry += "INNER JOIN "+RetSqlName("SB2")+ " (NOLOCK) SB2 ON SB2.D_E_L_E_T_ = ' ' AND SB2.B2_COD = C6_PRODUTO "
	cQry += "INNER JOIN "+RetSqlName("SA1")+ " (NOLOCK) SA1 ON SA1.D_E_L_E_T_ = ' ' AND SA1.A1_COD = C5_CLIENT "
	cQry += "WHERE SC6.D_E_L_E_T_ = ' ' "
	cQry += "AND SC5.C5_NUM = '" + cNumPed + "' ""
	cQry += "GROUP BY C5_NUM, C6_PRODUTO, B1_TIPO, C6_DESCRI, B2_QATU,C6_QTDVEN "

//Executando a query
	PLSQuery(cQry, "QRY_SC5")

	cLocaliz := POSICIONE("SBF",1,xFilial("SBF")+QRY_SC5->C6_LOCAL+QRY_SC5->B1_LOCALIZ+QRY_SC5->C6_PRODUTO,"BF_LOCALIZ")

//Se houve dados
	If ! QRY_SC5->(EoF())
		//Pegando o total de registros
		DbSelectArea("QRY_SC5")
		QRY_SC5->(DbGoTop())

		//Enquanto houver dados
		While ! QRY_SC5->(EoF())
			AADD(ADADRLT, {QRY_SC5->C5_NUM,QRY_SC5->C6_PRODUTO,QRY_SC5->B1_TIPO,QRY_SC5->C6_DESCRI,QRY_SC5->B2_QATU,QRY_SC5->B1_ZZCA,QRY_SC5->B1_FABRIC,QRY_SC5->C6_QTDVEN,QRY_SC5->B1_DESC2,QRY_SC5->C5_EMISSAO,QRY_SC5->C5_XVEND1,QRY_SC5->A1_NOME,QRY_SC5->A1_ROTA,QRY_SC5->A1_DESCROT, cLocaliz})
			QRY_SC5->(DbSkip())
		EndDo
	Else
		MsgInfo("Pedido não esta diponivel para separação","Validar Pedido !!!")
	EndIf

	SBF->(dBcloseArea())

RETURN(ADADRLT)


