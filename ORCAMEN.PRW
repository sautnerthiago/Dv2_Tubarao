#INCLUDE "PROTHEUS.CH"
#INCLUDE "COLORS.CH"
#INCLUDE "FONT.CH"
#INCLUDE "PRINT.CH"
#INCLUDE "TopConn.ch"
#INCLUDE "RPTDEF.CH"
#INCLUDE "FWPrintSetup.ch"

#DEFINE PD_ISTOTVSPRINTER     1
#DEFINE PD_DISABLEDESTINATION 2
#DEFINE PD_DISABLEORIENTATION 4
#DEFINE PD_DISABLEPAPERSIZE   8
#DEFINE PD_DISABLEPREVIEW     16

#DEFINE PD_DESTINATION 1
#DEFINE PD_PRINTTYPE   2
#DEFINE PD_ORIENTATION 3
#DEFINE PD_PAPERSIZE   4
#DEFINE PD_PREVIEW     5
#DEFINE PD_VALUETYPE   6
#DEFINE PD_MARGIN      7

#DEFINE PD_OK 1

#DEFINE PD_PORTRAIT  1 // Portrait(retrato);
#DEFINE PD_LANDSCAPE 2 // Landscape(paisagem)

#DEFINE _PAG_TCOL 2200 
#DEFINE _PAG_TLIN 2700
#DEFINE _PAG_COL1 0050

#DEFINE _ITEM       1
#DEFINE _CODIGO     2
#DEFINE _DESCR      3
#DEFINE _CLFISC     4
#DEFINE _QUANT      5
#DEFINE _VLUNIT     6
#DEFINE _ALIQIPI    7
#DEFINE _ALIQICM    8
#DEFINE _VLTOT      9
#DEFINE _PRAZOENTR 10
#DEFINE _PVCLI     11

Static VAL_MERC  := 0
Static VAL_IPI	 := 0
Static VAL_ICM	 := 0
Static VAL_SOL	 := 0
Static VAL_TOT	 := 0
Static VAL_PES	 := 0

//Informa a versao do Programa, conforme no JEDI
Static NomePrt		:= "ORCAMEN"
Static VersaoJedi	:= "V1.16"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออ อออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณORCAMEN   บAutor  ณ Jackson Santos     บ Data ณ  07/02/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Impressao do Or็amento                                     บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
                                                                             					
USER FUNCTION ORCAMEN()
Local 	cQuery		:= nil
Local 	cTitulo		:= "Or็amento de Venda" 
Local 	_cPath		:= GetTempPath(.T.)
Local 	cAliasRel	:= GetNextAlias()

Private cPerg 		:= 'PORCVEN'  


//grupo de perguntas
fAsrPerg(cPerg)

//chama os parametros
If !(AllTrim(FunName()) == "MATA415")
	If !Pergunte(cPerg,.T.,cTitulo)
		Return
	EndIf
Else
	MV_PAR01 := SCJ->CJ_NUM
	MV_PAR02 := SCJ->CJ_NUM
	MV_PAR03 := SCJ->CJ_FILIAL
	MV_PAR04 := SCJ->CJ_FILIAL
EndIf

nFlags   := PD_ISTOTVSPRINTER + PD_DISABLEORIENTATION + PD_DISABLEPAPERSIZE
cSession := GetPrinterSession()
cDevice  := GetProfString( cSession, "PRINTTYPE", "PDF", .T. )

nLocal := If( GetProfString( cSession, "LOCAL", "SERVER", .T. ) == "SERVER", 1, 2 )

oSetup  := Nil
aDevice := {}

Aadd( aDevice, "DISCO" )
Aadd( aDevice, "SPOOL" )
Aadd( aDevice, "EMAIL" )
Aadd( aDevice, "EXCEL" )
Aadd( aDevice, "HTML"  )
Aadd( aDevice, "PDF"   )

nPrintType := aScan( aDevice,{ |x| x == cDevice } )

oSetup := FWPrintSetup():New( nFlags, cTitulo)

oSetup:SetUserParms( {|| Pergunte( cPerg, .T. ) } )

oSetup:SetProperty( PD_ORIENTATION, PD_LANDSCAPE )
oSetup:SetProperty( PD_DESTINATION, 2 )
oSetup:SetProperty( PD_PAPERSIZE  , 2 )

cArquivo := Lower(cUserName + "_" + DToS(dDataBase) + "_" + StrTran(Time(), ":", ""))

oPrn := FWMSPrinter():New(cArquivo, IMP_SPOOL , .T., _cPath, .T., , , , IsBlind(), , , .F.)

If .not. oSetup:Activate() == PD_OK //1 Confirma - 2 Cancela
	MsgAlert('Opera็ใo Cancelada.')
	Return Nil
Else
   	oPrn:lServer := oSetup:GetProperty(PD_DESTINATION) == AMB_SERVER	
  	oPrn:SetDevice(oSetup:GetProperty(PD_PRINTTYPE))
  	oPrn:setCopies(Val(oSetup:cQtdCopia))

	If oSetup:GetProperty(PD_PRINTTYPE) == IMP_SPOOL
		lPreview := .F.
		oPrn:nDevice  := IMP_SPOOL
		fwWriteProfString(GetPrinterSession(),"DEFAULT", oSetup:aOptions[PD_VALUETYPE], .T.)
		oPrn:cPrinter := oSetup:aOptions[PD_VALUETYPE]
	Else 
		oPrn:nDevice  := IMP_PDF
		oPrn:cPathPDF := oSetup:aOptions[PD_VALUETYPE]
		oPrn:SetViewPDF(.T.)
	Endif
	EndIf
         
cQuery := " SELECT SCJ.CJ_FILIAL,SCJ.CJ_NUM "
cQuery += " FROM "+RETSQLNAME("SCJ")+" SCJ "
cQuery += " WHERE SCJ.D_E_L_E_T_ <> '*' "
                              
//Executa filtros
If !Empty(MV_PAR01) .AND. !Empty(MV_PAR02)
	cQuery += " AND SCJ.CJ_NUM BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"' "
Endif	
	
If !Empty(MV_PAR03) .AND. !Empty(MV_PAR04)
	cQuery += " AND SCJ.CJ_FILIAL BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"' "
EndIf

//ณCria temporaria
DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),(cAliasRel),.F.,.T.)
ProcRegua(RecCount())
(cAliasRel)->(DbGoTop())

//ณLoop de processamento da rotina               ณ
Do While !(cAliasRel)->(EOF())
	MsAguarde({|| Imprime((cAliasRel)->CJ_FILIAL,AllTrim((cAliasRel)->CJ_NUM)) },"Aguarde","Processando...")

	(cAliasRel)->(DbSkip())
EndDo

VerTabela(cAliasRel)

oPrn:Preview()

Return()

Static Function Imprime(cFil,cNum)

LOCAL oDlg          := NIL
LOCAL aDbArea       := GetArea()
Private ccaminho	:= AllTrim(SuperGetMv("MV_RELT",.t.,'\spool\'))
Private nPag        := 0
PRIVATE cTitulo     := " ORวAMENTO DE VENDAS " //- " + VersaoJedi
PRIVATE lPreview    := .F.  //Abir tela do Preview do relatorio
PRIVATE nSitImpr    := 2    //Modelo 1=simplificado 2=completo
PRIVATE cQuery      := ""
PRIVATE cQuery2     := ""
//PRIVATE oPrn        := NIL 
PRIVATE oArial14    := NIL
PRIVATE oArial25B   := NIL
PRIVATE oArial08    := NIL
PRIVATE oArial08B   := NIL
PRIVATE oArial08I   := NIL
PRIVATE oArial09    := NIL
PRIVATE oArial10B   := NIL
PRIVATE oArial10    := NIL
PRIVATE oArial11    := NIL
PRIVATE oArial11B   := NIL
PRIVATE oArial12    := NIL
PRIVATE oArial12B   := NIL
PRIVATE oArial12BI  := NIL
PRIVATE nConsTex    := 2 // Constante para concertar o cแlculo retornado pelo GetTextWidth.
PRIVATE nLin
PRIVATE lProspect	:= .F.
PRIVATE lCliente	:= .F.


DEFINE FONT oArial08   NAME "Arial" SIZE 0,08 OF oPrn
DEFINE FONT oArial08B  NAME "Arial" SIZE 0,08 OF oPrn BOLD
DEFINE FONT oArial09   NAME "Arial" SIZE 0,09 OF oPrn
DEFINE FONT oArial10   NAME "Arial" SIZE 0,09 OF oPrn
//DEFINE FONT oArial10   NAME "Arial" SIZE 0,10 OF oPrn
DEFINE FONT oArial10B  NAME "Arial" SIZE 0,10 OF oPrn BOLD
DEFINE FONT oArial10I  NAME "Arial" SIZE 0,10 OF oPrn ITALIC
DEFINE FONT oArial11   NAME "Arial" SIZE 0,11 OF oPrn
DEFINE FONT oArial11B  NAME "Arial" SIZE 0,11 OF oPrn BOLD
DEFINE FONT oArial12   NAME "Arial" SIZE 0,12 OF oPrn
DEFINE FONT oArial12B  NAME "Arial" SIZE 0,12 OF oPrn BOLD
DEFINE FONT oArial12BI NAME "Arial" SIZE 0,12 OF oPrn BOLD ITALIC
DEFINE FONT oArial14   NAME "Arial" SIZE 0,14 OF oPrn
DEFINE FONT oArial14B  NAME "Arial" SIZE 0,14 OF oPrn BOLD
DEFINE FONT oArial17B  NAME "Arial" SIZE 0,17 OF oPrn BOLD
DEFINE FONT oArial25B  NAME "Arial" SIZE 0,25 OF oPrn BOLD

//oPrn := nil /* TMSPrinter():New(cTitulo) */
//oPrn:SetPortrait()				     	// Modo retrato
//oPrn:SetLandScape()
//oPrn:SetPaperSize(9)					// Papel A4

MV_PAR01 := cNum
 
//ณlocalizo o cabe็alho do pedidoณ
DbSelectArea("SCJ")
DbSetOrder(1)
DbSeek(cFil+MV_PAR01)        

//ณValida se na tabela SCK tem itens referente ao pedidoณ
DbSelectArea("SCK")
DbSetOrder(1)
IF !DbSeek(xFilial("SCK")+MV_PAR01)
	Alert("Nใo foi localizado itens do or็amento "+MV_PAR01)
	RestArea(aDbArea)
	oPrn:end()
	RETURN
ENDIF

//If SCJ->CJ_CLIENTE == "000001" .And. SCJ->CJ_LOJA == "01" .And. !Empty(CJ_PROSPE)
If SCJ->CJ_CLIENTE + SCJ->CJ_LOJA == SuperGetMV("MV_ORCLIPD") .And. !Empty(SCJ->CJ_PROSPE)
	//ณPosicionando no cadastro de prospects ณ
	lProspect 	:= .T.
	lCliente	:= .F.
	SUS->(DbSelectArea("SUS"))
	SUS->(DbSetOrder(1))
	SUS->(DbSeek( XFILIAL("SUS")+SCJ->CJ_PROSPE+SCJ->CJ_LOJPRO ))
Else
	//ณPosicionando no cadastro de clientes ณ
	lProspect 	:= .F.
	lCliente	:= .T.	
	SA1->(DbSelectArea("SA1"))
	SA1->(DbSetOrder(1))
	SA1->(DbSeek( XFILIAL("SA1")+SCJ->CJ_CLIENTE+SCJ->CJ_LOJA ))
EndIf


//ณPosicionando no cadastro de vendedores ณ
DbSelectArea("SA3")
DbSetOrder(1)
DbSeek( XFILIAL("SA3")+SCJ->CJ_VEND1  )

//ณPosicionando no cadastro de condicao de pagamentoณ
DbSelectArea("SE4")
DbSetOrder(1)
DbSeek( XFILIAL("SE4")+SCJ->CJ_CONDPAG )

//ณPosicionando no cadastro de transportadoraณ
DbSelectArea("SA4")
DbSetOrder(1)
DbSeek( XFILIAL("SA4")+SCJ->CJ_TRANSP )

oPrn:StartPage()

DadosPv() // Imprime dados do PV
//Quadro()  // Imprime quadros inferiores na ultima pagina no PV

oPrn:EndPage()
//oPrn:End()

RestArea(aDbArea)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณDadosPv   บAutor  ณ Marcos             บ Data ณ  07/02/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Imprime dados do PV                                        บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
STATIC FUNCTION DadosPv

Local cMensagem1   := ""  
LOCAL nTamLin	   := 0
LOCAL nLinMen	   := 0
LOCAL cLinMsg	   := ""
LOCAL nColMsg	   := 0
LOCAL nMsg		   := 1
LOCAL lCab1		   := .T.
LOCAL aMsgCompl    := {}
LOCAL cMsgCompl    := ""
LOCAL aTexto       := {}
LOCAL cTelefone    := ""
LOCAL cFAX         := ""
Local nx
LOCAL oFntObs
Local cTelPict
Local cNomeRepres  := IF( !Empty(SCJ->CJ_VEND1),AllTrim(SCJ->CJ_VEND1)+"-"+Alltrim(SA3->A3_NREDUZ),"")
Local cTransp      := IF( !Empty(SA4->A4_NREDUZ) , SA4->A4_NREDUZ , SA4->A4_NOME )
Local cEndEntr     := ""
Local cInfoContrib := "" //IF( Empty(SA1->A1_CONTRIB) .OR. SA1->A1_CONTRIB=="1","CONTRIBUINTE ICMS","NรO CONTRIBUINTE")
Local cPictCli     := PicPes(SA1->A1_PESSOA)

If lProspect
	If !empty(SUS->US_END)
		cEndEntr := Alltrim(SUS->US_END) + " - "+ Alltrim(SUS->US_BAIRRO)
	Endif	
Else
	If !empty(SA1->A1_ENDENT)
		cEndEntr := Alltrim(SA1->A1_ENDENT) + " - "+ Alltrim(SA1->A1_BAIRROE)
	EndIf
Endif	

// Prepara mascara do campo telefone
If lProspect
	If !empty(SUS->US_DDD)
		cTelefone += IF( EMPTY(SUS->US_DDD) , "" , "("+ALLTRIM(SUS->US_DDD)+") ")+SUS->US_TEL
		IF !EMPTY(SUS->US_FAX)
			cFAX += IF( EMPTY(SUS->US_DDD) , "" , "("+ALLTRIM(SUS->US_DDD)+") ")+SUS->US_FAX
		ENDIF
	Endif	
Else
	If !empty(SA1->A1_DDD)
	    cTelefone += IF( EMPTY(SA1->A1_DDD) , "" , "("+ALLTRIM(SA1->A1_DDD)+") ")+SA1->A1_TEL
		IF !EMPTY(SA1->A1_FAX)
			cFAX += IF( EMPTY(SA1->A1_DDD) , "" , "("+ALLTRIM(SA1->A1_DDD)+") ")+SA1->A1_FAX
		ENDIF
	endif		
Endif

dbSelectArea("SCJ")

Cabec()      // Imprime cabecalho

//ณDados do cliente destinatario apenas na primeira paginaณ
IF nPag == 1  

	nLin:=nLin+15

	nC1 := 100
	nC2 := 350
	nC3 := 1320
	nC4 := 1570
    
	cCol := 480


	If lProspect
			//Linha 1
			oPrn:Say(nLin,nC1,"Nome:",oArial10)
			oPrn:Say(nLin,nC2, SUS->US_COD+"-"+Alltrim(SUS->US_NOME),oArial10)
		
			oPrn:Say(nLin,nC3,"Representante: ",oArial10)
			oPrn:Say(nLin,nC4,cNomeRepres,oArial10)
			
			//Linha 2
			oPrn:Say(nLin+=0050,nC1,"Endere็o:",oArial10)
			oPrn:Say(nLin,nC2,Left(Alltrim(SUS->US_END) + "-"+ Alltrim(SUS->US_BAIRRO),45) ,oArial10)
			
			oPrn:Say(nLin,nC3,"Condi็ใo",oArial10)
			oPrn:Say(nLin,nC4,SCJ->CJ_CONDPAG + '- '+ Alltrim(SE4->E4_DESCRI),oArial10)
			
			//Linha 3
			oPrn:Say(nLin+=0050,nC1,"Cidade:",oArial10)
			oPrn:Say(nLin,nC2, Alltrim(SUS->US_MUN) ,oArial10)
		
			oPrn:Say(nLin,nC3,"Cobran็a:",oArial10)
			oPrn:Say(nLin,nC4,Substr(Alltrim(SUS->US_END) + " - "+ Alltrim(SUS->US_BAIRRO),1,36) ,oArial10)
			
			//Linha 4
			oPrn:Say(nLin+=0050,nC1,"Estado:",oArial10)
			oPrn:Say(nLin,nC2, SUS->US_EST, oArial10) 
		
			oPrn:Say(nLin,nC3,"Cidade cobr:",oArial10)
			oPrn:Say(nLin,nC4,Alltrim(SUS->US_MUN),oArial10)
				
			//Linha 5
			oPrn:Say(nLin+=0050,nC1,"CEP:",oArial10)
			oPrn:Say(nLin,nC2, TRANSFORM(SUS->US_CEP,"@R 99999-999"), oArial10) 
		
			oPrn:Say(nLin,nC3,"Estado cobr:",oArial10)
			oPrn:Say(nLin,nC4,Alltrim(SUS->US_EST),oArial10)
			
			//Linha 6
			oPrn:Say(nLin+=0050,nC1,"Emissao:",oArial10)
			oPrn:Say(nLin,nC2, DTOC(STOD(DTOS(SCJ->CJ_EMISSAO))), oArial10) 
		
			//oPrn:Say(nLin,0730,"Nota: ",oArial10)
			//oPrn:Say(nLin,0860, SCJ->CJ_NOTA+ "-"+SCJ->CJ_SERIE,oArial10)
			//oPrn:Say(nLin,nC3,"Nota: ",oArial10)
			//oPrn:Say(nLin,nC4, SCJ->CJ_NOTA+ "-"+SCJ->CJ_SERIE,oArial10)
		
			nLin+=0050
			oPrn:Say(nLin,nC1,"CEP Cobr:",oArial10)
			oPrn:Say(nLin,nC2,TRANSFORM(SUS->US_CEP,"@R 99999-999"),oArial10)
		                                                    
			//Linha 7
			//oPrn:Say(nLin+=0050,nC1,"Tel contato:",oArial10)
			//oPrn:Say(nLin,nC2, SCJ->CJ_TELCOMP, oArial10) 
		
			//nLin+=0050
			//oPrn:Say(nLin,0730,"FAX: ",oArial10)
			//oPrn:Say(nLin,0860, SA1->A1_FAX,oArial10B)
		
			oPrn:Say(nLin,nC3,"Transp:",oArial10)
			oPrn:Say(nLin,nC4,cTransp,oArial10)
		
		    nLin+=0050
			oPrn:Say(nLin,nC1,"FAX: ",oArial10)
			oPrn:Say(nLin,nC2, SUS->US_FAX,oArial10)
		
			//Linha 8
			//oPrn:Say(nLin+=0050,nC1,"E-mail contato:",oArial10)
			//oPrn:Say(nLin,nC2, SCJ->CJ_EMACOMP, oArial10) 
		
			oPrn:Say(nLin,nC3,"Local entrega:",oArial10)
			oPrn:Say(nLin,nC4,cEndEntr,oArial08B)
		
			//Linha 9
			oPrn:Say(nLin+=0050,nC1,"CNPJ/CPF:",oArial10)
		    oPrn:Say(nLin,nC2,TRANSFORM( SUS->US_CGC , SUBSTR(cPictCli,1,LEN(cPictCli)-2) ),oArial10) 
		
			oPrn:Say(nLin,nC3,"Cidade entrega:",oArial10)
			oPrn:Say(nLin,nC4,SUS->US_MUN,oArial10)
		
			//Linha 10
			oPrn:Say(nLin+=0050,nC1,"I.E.:",oArial10)
			oPrn:Say(nLin,nC2, SUS->US_INSCR, oArial10) 
		
			oPrn:Say(nLin,nC3,"Estado entrega:",oArial10)
			oPrn:Say(nLin,nC4,SUS->US_EST,oArial10)
		
			//linha 11
			//oPrn:Say(nLin+=0050,nC1,"Nบ Ped. Cliente:",oArial10)
			//oPrn:Say(nLin,nC2, SCJ->CJ_COTACAO,oArial10)
		
			//linha 12
			oPrn:Say(nLin+=0050,nC1,"Moeda:",oArial10)
			oPrn:Say(nLin,nC2, DescriMoed(SCJ->CJ_MOEDA),oArial10)
		
			oPrn:Say(nLin,nC3,"Frete:",oArial10)
			oPrn:Say(nLin,nC4, DescrFrete(SCJ->CJ_TPFRETE),oArial10)
						
			//LINHA HORIZONTAL SUPERIOR
			oPrn:Line(nLin+=0050,_PAG_COL1,nLin,_PAG_TCOL)
			oPrn:Line(nLin+=0005,_PAG_COL1,nLin,_PAG_TCOL)
		
	Else
		    //Linha 1
			oPrn:Say(nLin,nC1,"Nome:",oArial10)
			oPrn:Say(nLin,nC2, SA1->A1_COD+"-"+Alltrim(SA1->A1_NOME),oArial10)
		
			oPrn:Say(nLin,nC3,"Representante: ",oArial10)
			oPrn:Say(nLin,nC4,cNomeRepres,oArial10)
			
			//Linha 2
			oPrn:Say(nLin+=0050,nC1,"Endere็o:",oArial10)
			oPrn:Say(nLin,nC2,Left(Alltrim(SA1->A1_END) + "-"+ Alltrim(SA1->A1_BAIRRO),45) ,oArial10)
			
			oPrn:Say(nLin,nC3,"Condi็ใo",oArial10)
			oPrn:Say(nLin,nC4,SCJ->CJ_CONDPAG + '- '+ Alltrim(SE4->E4_DESCRI),oArial10)
			
			//Linha 3
			oPrn:Say(nLin+=0050,nC1,"Cidade:",oArial10)
			oPrn:Say(nLin,nC2, Alltrim(SA1->A1_MUN) ,oArial10)
		
			oPrn:Say(nLin,nC3,"Cobran็a:",oArial10)
			If empty(SA1->A1_ENDCOB)
				oPrn:Say(nLin,nC4,Substr(Alltrim(SA1->A1_END) + " - "+ Alltrim(SA1->A1_BAIRRO),1,36) ,oArial10)
			Else
				oPrn:Say(nLin,nC4,Substr(Alltrim(SA1->A1_ENDCOB) + " - "+ Alltrim(SA1->A1_BAIRROC),1,36) ,oArial10)
			Endif 
			
			//Linha 4
			oPrn:Say(nLin+=0050,nC1,"Estado:",oArial10)
			oPrn:Say(nLin,nC2, SA1->A1_EST, oArial10) 
		
			oPrn:Say(nLin,nC3,"Cidade cobr:",oArial10)
			If empty(SA1->A1_MUNC)
				oPrn:Say(nLin,nC4,Alltrim(SA1->A1_MUN),oArial10)
			Else
				oPrn:Say(nLin,nC4,Alltrim(SA1->A1_MUNC),oArial10)
			Endif	
		
			//Linha 5
			oPrn:Say(nLin+=0050,nC1,"CEP:",oArial10)
			oPrn:Say(nLin,nC2, TRANSFORM(SA1->A1_CEP,"@R 99999-999"), oArial10) 
		
			oPrn:Say(nLin,nC3,"Estado cobr:",oArial10)
			If empty(SA1->A1_ESTC) 
				oPrn:Say(nLin,nC4,Alltrim(SA1->A1_EST),oArial10)
			Else
				oPrn:Say(nLin,nC4,Alltrim(SA1->A1_ESTC),oArial10)
			Endif	
		
			//Linha 6
			oPrn:Say(nLin+=0050,nC1,"Emissao:",oArial10)
			oPrn:Say(nLin,nC2, DTOC(STOD(DTOS(SCJ->CJ_EMISSAO))), oArial10) 
		
			//oPrn:Say(nLin,0730,"Nota: ",oArial10)
			//oPrn:Say(nLin,0860, SCJ->CJ_NOTA+ "-"+SCJ->CJ_SERIE,oArial10)
			//oPrn:Say(nLin,nC3,"Nota: ",oArial10)
			//oPrn:Say(nLin,nC4, SCJ->CJ_NOTA+ "-"+SCJ->CJ_SERIE,oArial10)
		
			nLin+=0050
			oPrn:Say(nLin,nC1,"CEP Cobr:",oArial10)
			If empty(SA1->A1_CEPC) 
				oPrn:Say(nLin,nC2,TRANSFORM(SA1->A1_CEP,"@R 99999-999"),oArial10)
		    Else
		    	oPrn:Say(nLin,nC2,TRANSFORM(SA1->A1_CEPC,"@R 99999-999"),oArial10)
		    Endif
		                                                
			//Linha 7
			//oPrn:Say(nLin+=0050,nC1,"Tel contato:",oArial10)
			//oPrn:Say(nLin,nC2, SCJ->CJ_TELCOMP, oArial10) 
		
			//nLin+=0050
			//oPrn:Say(nLin,0730,"FAX: ",oArial10)
			//oPrn:Say(nLin,0860, SA1->A1_FAX,oArial10B)
		
			oPrn:Say(nLin,nC3,"Transp:",oArial10)
			oPrn:Say(nLin,nC4,cTransp,oArial10)
		
		    nLin+=0050
			oPrn:Say(nLin,nC1,"FAX: ",oArial10)
			oPrn:Say(nLin,nC2, SA1->A1_FAX,oArial10)
		
			//Linha 8
			//oPrn:Say(nLin+=0050,nC1,"E-mail contato:",oArial10)
			//oPrn:Say(nLin,nC2, SCJ->CJ_EMACOMP, oArial10) 
		
			oPrn:Say(nLin,nC3,"Local entrega:",oArial10)
			oPrn:Say(nLin,nC4,cEndEntr,oArial08B)
		
			//Linha 9
			oPrn:Say(nLin+=0050,nC1,"CNPJ/CPF:",oArial10)
		    oPrn:Say(nLin,nC2,TRANSFORM( SA1->A1_CGC , SUBSTR(cPictCli,1,LEN(cPictCli)-2) ),oArial10) 
		
			oPrn:Say(nLin,nC3,"Cidade entrega:",oArial10)
			oPrn:Say(nLin,nC4,SA1->A1_MUNE,oArial10)
		
			//Linha 10
			oPrn:Say(nLin+=0050,nC1,"I.E.:",oArial10)
			oPrn:Say(nLin,nC2, SA1->A1_INSCR, oArial10) 
		
			oPrn:Say(nLin,nC3,"Estado entrega:",oArial10)
			oPrn:Say(nLin,nC4,SA1->A1_ESTE,oArial10)
		
			//linha 11
			//oPrn:Say(nLin+=0050,nC1,"Nบ Ped. Cliente:",oArial10)
			//oPrn:Say(nLin,nC2, SCJ->CJ_COTACAO,oArial10)
		
			//linha 12
			oPrn:Say(nLin+=0050,nC1,"Moeda:",oArial10)
			oPrn:Say(nLin,nC2, DescriMoeda(SCJ->CJ_MOEDA),oArial10)
			
			oPrn:Say(nLin,nC3,"Frete:",oArial10)
			oPrn:Say(nLin,nC4, DescrFrete(SCJ->CJ_TPFRETE),oArial10)			
			
			//LINHA HORIZONTAL SUPERIOR
			oPrn:Line(nLin+=0050,_PAG_COL1,nLin,_PAG_TCOL)
			oPrn:Line(nLin+=0005,_PAG_COL1,nLin,_PAG_TCOL)
	Endif
	
ELSE
	nLin:=nLin + 50
ENDIF

//ณImprimir itens do PV ณ
IF Detalhe()
	
	//VERIFICA SE O nLIN ATINGE 2400
	fVerPag()

	//BOX DOS TOTAIS DO PEDIDO
	nLin := nLin+=50
	LinBox(oPrn,2,nLin-40, 1350, nLin+260,_PAG_TCOL)
	oPrn:Say(nLin,1400,"Total Mercadoria >>>>>>",oArial12)
	oPrn:Say(nLin,1800,Transform(VAL_MERC,"@E 999,999,999.99"),oArial12,,,,1)	//VALOR IPI
	
	nLin += 50
	oPrn:Say(nLin,1400,"Total valor IPI >>>>>>>>>",oArial12)
	oPrn:Say(nLin,1800,Transform(VAL_IPI,"@E 999,999,999.99"),oArial12,,,,1)  	//VALOR TOTAL
	
	nLin += 50
	oPrn:Say(nLin,1400,"Total valor ICM >>>>>>>>",oArial12)
	oPrn:Say(nLin,1800,Transform(VAL_ICM,"@E 999,999,999.99"),oArial12,,,,1) 	//VALOR TOTAL
	
	nLin += 50
	oPrn:Say(nLin,1400,"Total valor SUBST >>>>>",oArial12)
	oPrn:Say(nLin,1800,Transform(VAL_SOL,"@E 999,999,999.99"),oArial12,,,,1) 	//VALOR TOTAL
	
	nLin += 50
	oPrn:Say(nLin,1400,"Total com IPI >>>>>>>>>",oArial12)
	oPrn:Say(nLin,1800,Transform(VAL_TOT,"@E 999,999,999.99"),oArial12,,,,1) 	//VALOR TOTAL
ENDIF

//ณImpressao das observacoes do PVณ
cMensagem1:=SCJ->CJ_OBSERV

IF !Empty( cMensagem1 )
	nLin += 70
	
	
	nTamLin := 100
	oFntObs := oArial10B
	aTexto  := _ConvText(oPrn,cMensagem1,oFntObs, (_PAG_TCOL-50)) //oPrn:nHorzRes())
	oFntObs := oArial10
	
	nLinMen:=Len(aTexto)
	
	IF (nLinMen*40)+60 >= (_PAG_TLIN-nLin)
		FVerPag()
	ENDIF
	
	lCab1:=.T.
	For nx:=1 to nLinMen
		IF lCab1
			lCab1:=.F.
			//LinBox(oPrn,2,nLin,_PAG_COL1,nLin+60,_PAG_TCOL)  
			oPrn:Line(nLin+=0050,_PAG_COL1,nLin,_PAG_TCOL)
			oPrn:Say(nLin+50,Round((_PAG_TCOL/2),0),"Observa็๕es Gerais",oArial12BI,,,,2)
			nLin += 50
		ENDIF
		nLin:=nLin+40
		
		cLinMsg:=aTexto[nx]
		nColMsg:=IIF( Left(cLinMsg,1)=="(",_PAG_COL1, _PAG_COL1+50)  //recuo ap๓s segunda linha
		oPrn:Say(nLin,nColMsg,cLinMsg	,oFntObs)
		
		lCab1:=fVerPag()
		
	Next nx
ENDIF

FVerPag()

VAL_MERC := 0
VAL_IPI  := 0
VAL_ICM  := 0
VAL_SOL  := 0
VAL_TOT  := 0

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCabec     บAutor  ณMarcos              บ Data ณ  02/07/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function Cabec
Local nCol	    := 0
Local cNumPed   := SCJ->CJ_NUM
Local nLoop
Private aMSGCAB := {"","","","","",""} // Armazena as mensagem que 
                                        // serao impressas no cabecalho
                                        // do pedido de vendas. Essas sao
                                        // atualizadas pela funcao 
                                        // fAtuMsgCab()

nLin:=0  // controle de linha
nPag ++

//IMPRESSAO DO DESENHO(LOGO)
//oPrn:SayBitmap( 0105, 0070,Alltrim(cCaminho+alltrim("Logo_OrcVen.bmp")),0355,0113)
If File(cArqLogo := "logo" + Alltrim(SM0->M0_CODFIL) + "m.bmp")
	//Caso exista, definir como imagem de LOGO a ser impresso no cabecalho
    oPrn:SayBitmap( 085, 0070,cArqLogo,0150,0150)
Endif

//oPrn:Say(200,700,cTitulo ,oArial14B)
oPrn:Say(100,700,SM0->M0_NOMECOM,oArial12)
oPrn:Say(140,700,SM0->M0_ENDENT,oArial12)
oPrn:Say(180,700,Transform(SM0->M0_CGC,"@r 99.999.999/9999-99") + SPACE(10) + " I.E.: " + Transform(SM0->M0_INSC,"@R 999.999.999.999"),oArial12)
oPrn:Say(220,700, Alltrim(SM0->M0_BAIRENT) + " - " + Alltrim(SM0->M0_CIDENT) + " - " + Alltrim(SM0->M0_ESTENT) + " - " + Transform(SM0->M0_CEPENT,"@r 99999-999"),oArial12) 
oPrn:Say(260,700,"Tel:" + Alltrim(SM0->M0_TEL) + SPACE(10) + "Fax:" + Alltrim(SM0->M0_FAX),oArial12)

oPrn:Say(250,070,"ORวAMENTO - "+cNumPed ,oArial14B)
//oPrn:Say(240,070,SM0->M0_"ORวAMENTO - "+cNumPed ,oArial11B)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณFuncao fAtuMsgCab atualiza conteudo do array aMSGCAB      ณ
//ณcom as mensagem abaixo, sera verificado o conteudo de cadaณ
//ณcampo, estando com "S" a mensagem sera inserida no array  ณ
//ณpara impressao no cabecalho do pedido                     ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

//fAtuMsgCab(SCJ->CJ_PEDINSP , "PEDIDO P/INSPEวรO      ")
//fAtuMsgCab(SCJ->CJ_PEDMULT , "PEDIDO COM MULTA       ")
//fAtuMsgCab(SCJ->CJ_PEDCONT , "PEDIDO CONTRATO        ")
//fAtuMsgCab(SCJ->CJ_PEDPROG , "ENTREGA PROGRAMADA     ")
//fAtuMsgCab(SCJ->CJ_PEDTAG  , "TAG                    ")
//fAtuMsgCab(SCJ->CJ_PEDCERT , "PEDIDO COM CERTIFICACAO")
     
oPrn:Say(000,500,aMSGCAB[1],oArial17B)
oPrn:Say(070,500,aMSGCAB[2],oArial17B)
oPrn:Say(140,500,aMSGCAB[3],oArial17B)

oPrn:Say(000,1200,aMSGCAB[4],oArial17B)
oPrn:Say(070,1200,aMSGCAB[5],oArial17B)
oPrn:Say(140,1200,aMSGCAB[6],oArial17B)          

//oPrn:Say( 050,_PAG_TCOL,"NIVEL "+SCJ->CJ_PEDNIVE,oArial14B,,,,1)     //NIVEL DO PEDIDO 1 ou 2
oPrn:Say( 140, _PAG_TCOL-130, "Pแgina: " + CVALTOCHAR(nPag),oArial09,,,,1)   //NUMERO PAGINA
//oPrn:Say( 200, _PAG_TCOL-220, "USO INTERNO",oArial12B,,,,1)                  //NUMERO PAGINA
oPrn:Say( 260, _PAG_TCOL-350, "Data de Emissใo: "+Transform(SCJ->CJ_EMISSAO,"@D"),oArial09,,,,1)

LinBox( oPrn, 1, 310, _PAG_COL1, 310,_PAG_TCOL)                        //LINHA HORIZ ABAIXO DO LOGOTIPO

nLin:=320

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณDetalhe   บAutor  ณMarcos              บ Data ณ  02/07/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Realiza a leitura da tabela SCK e relaiza a impressao dos  บฑฑ
ฑฑบ          ณ itens do pedido de venda escolhido pelo usuario            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑบ          ณ obs. esta sendo posicionado no primeiro registro da SCK    บฑฑ
ฑฑบ          ณ      na funcao fImpPV                                      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/        

Static Function Detalhe
Local nVlIPI		:= 0
Local nVlSIPI		:= 0
Local cDesNia		:= ""
Local lCAbItem		:= .T.
Local nAdc			:= 0
LOCAL aSay			:= {}
LOCAL nCol			:= 0
LOCAL nn			:= 0
LOCAL nDiasEntrega  := 0
LOCAL nMaFisItem	:= 0
LOCAL nAliqIcm		:= 0
LOCAL nAliqIPI		:= 0
LOCAL aTexto		:= {}
LOCAL aICM			:= {}
LOCAL nPercIncluso  := 0
Local nLoop, nx
LOCAL aDescTec      := {}  // Usada para controlar a quantidade de "descricoes tecnicas" foram impressas no orc

nLin:=nLin+35
LinBox(oPrn,1, nLin, _PAG_COL1, nLin,_PAG_TCOL)         //Linha superior do cabec itens
LinBox(oPrn,1, nLin+50, _PAG_COL1, nLin+50, _PAG_TCOL)  //Linha inferior cabec itens

lCabItem:=.T.
nMaFisItem:=0

//ณInicializa a funcao fiscal                   ณ
MaFisSave()
MaFisEnd()
MaFisIni((SCJ->CJ_CLIENTE),;	// 1-Codigo Cliente/Fornecedor
			 SCJ->CJ_LOJA,;	// 2-Loja do Cliente/Fornecedor
			 "C",;				// 3-C:Cliente , F:Fornecedor
			 "N",;				// 4-Tipo da NF
			 SA1->A1_TIPO,;		// 5-Tipo do Cliente/Fornecedor
			 Nil,;
			 Nil,;
			 Nil,;
			 Nil,;
			 "MATA415")

aDescTec := {}

SB1->(DbSetOrder(1))

WHILE SCK->(!eof()) .AND. SCK->CK_FILIAL==XFILIAL("SCK") .AND. SCK->CK_NUM==SCJ->CJ_NUM

	SB1->(DbSeek(XFILIAL("SB1")+SCK->CK_PRODUTO))
	
	IF .NOT. lCabItem
		//ณcalculo dos valores fiscais                  ณ

		nMaFisItem+=1

		MaFisAdd(SCK->CK_PRODUTO,;   	    // 1-Codigo do Produto ( Obrigatorio )
					SCK->CK_TES,;	   	    // 2-Codigo do TES ( Opcional )
					SCK->CK_QTDVEN,; 		// 3-Quantidade ( Obrigatorio )
					SCK->CK_PRCVEN,;		// 4-Preco Unitario ( Obrigatorio )
					SCK->CK_DESCONT,;		// 5-Valor do Desconto ( Opcional )
					"",;	   				// 6-Numero da NF Original ( Devolucao/Benef )
					"",;					// 7-Serie da NF Original ( Devolucao/Benef )
					0,;						// 8-RecNo da NF Original no arq SD1/SD2
					0,;						// 9-Valor do Frete do Item ( Opcional )
					0,;						// 10-Valor da Despesa do item ( Opcional )
					0,;						// 11-Valor do Seguro do item ( Opcional )
					0,;						// 12-Valor do Frete Autonomo ( Opcional )
					SCK->CK_VALOR,;		    // 13-Valor da Mercadoria ( Obrigatorio )
					0)						// 14-Valor da Embalagem ( Opiconal )
		
		nAliqIcm:=MaFisREt(nMaFisItem,"IT_ALIQICM")
		nAliqIPI:=MaFisRet(nMaFisItem,"IT_ALIQIPI")
		
		aICM:=MaFisRet(nMaFisItem,"IT_ICMS")
		IF aIcm[16] <> 0
			nPercIcmIncluso:=Round( (nAliqICM * (aIcm[16]/100)), 1)
		ELSE
			nPercIcmIncluso:=nAliqICM
		ENDIF
		
	ENDIF
	
	aSay:={{"",""},{"",""},{"",""},{"",""},{"",""},{"",""},{"",""},{"",""},{"",""},{"",""},{"",""}} // 11
	
	IF lCabItem
		aSay[_ITEM]      := {"Item"         ,oArial08B}
		aSay[_CODIGO]    := {"Codigo"       ,oArial08B}
		aSay[_CLFISC]	 := {"CF"		    ,oArial08B}
		aSay[_QUANT]     := {"Quant."       ,oArial08B}
		aSay[_VLUNIT]	 := {"Unitario"     ,oArial08B}
		aSay[_ALIQIPI]   := {"IPI Exclusivo",oArial08B}
		aSay[_ALIQICM]   := {"ICMS Incluso" ,oArial08B}
		aSay[_VLTOT]     := {"Total "       ,oArial08B}
		aSay[_PRAZOENTR] := {"Prazo Entrega",oArial08B}
		aSay[_PVCLI]     := {"Ped.Cliente"  ,oArial08B}
		aSay[_DESCR]	 := {" "            ,oArial08B}
		nn:=70
	ELSE
	
	    cDesNia := "" // Variavel usada para armazenar descricao tecnica do item
	
		aSay[_ITEM]     :={SCK->CK_ITEM                                    ,oArial10}
		aSay[_CODIGO]   :={SCK->CK_PRODUTO                                 ,oArial10}
		aSay[_CLFISC]   :={SB1->B1_POSIPI                                  ,oArial10}
		aSay[_QUANT]    :={Transform(SCK->CK_QTDVEN  ,"@E 999,999.99")     ,oArial10}
		aSay[_VLUNIT]   :={Transform(SCK->CK_PRCVEN  ,"@E 999,999,999.99") ,oArial10}
		aSay[_ALIQIPI]  :={Transform(nAliqIPI        ,"@RE 999.99%")       ,oArial10}
		aSay[_ALIQICM]  :={Transform(nPercIcmIncluso ,"@RE 999.99%")       ,oArial10}
		aSay[_VLTOT]    :={Transform(SCK->CK_VALOR   ,"@E 999,999,999.99") ,oArial10}
		aSay[_PRAZOENTR]:={DTOC(SCK->CK_ENTREG)                            ,oArial10}
		aSay[_PVCLI]    :={SCK->CK_PEDCLI                                  ,oArial10}

		IF nSitImpr==1 // Imprime B1_DESC sendo "impressao simplificada"
			aSay[_DESCR] :={ Alltrim(SB1->B1_DESC),oArial10B}
		ENDIF

		nn:=50
		
		oPrn:Line( nLin,_PAG_COL1, nLin, _PAG_TCOL)        //linha topo separa itens
		
	ENDIF
	
	nCol:=_PAG_COL1
	LinBox(oPrn,1,nLin,nCol,nLin+nn,nCol)     //linha vert margem esquerda dos itens
	oPrn:Say (nLin+30,nCol+10,aSay[_ITEM,1], aSay[_ITEM,2],,,,1)
	
	nCol:=nCol+100  //CODIGO
	IF !Empty(aSay[_CODIGO,1])
		oPrn:Line(nLin,nCol,nLin+50,nCol)//linha vert margem esquerda CODIGO
		oPrn:Say (nLin+30,nCol+10,aSay[_CODIGO,1], aSay[_CODIGO,2],,,,0)
	ENDIF
	
	nCol:=nCol+250  //CF
	IF !Empty(aSay[_CLFISC,1])
		oPrn:Line(nLin,nCol,nLin+50,nCol)//linha vert margem esquerda CF 
		oPrn:Say (nLin+30,nCol+50,aSay[_CLFISC,1], aSay[_CLFISC,2],,,,2)
	ENDIF
	
	nCol:=nCol+200 //QUANT
	IF  !Empty(aSay[_QUANT,1])
		oPrn:Line(nLin,nCol,nLin+50,nCol)   //linha vert margem esquerda QUANT 
		oPrn:Say (nLin+30,nCol+50,aSay[_QUANT,1], aSay[_QUANT,2],,,,1)
	ENDIF
	
	nCol:=nCol+220 //UNITARIO
	IF !Empty(aSay[_VLUNIT,1])
		oPrn:Line(nLin,nCol,nLin+50,nCol)  //linha vert margem esquerda UNITARIO
		oPrn:Say (nLin+30,nCol+50,aSay[_VLUNIT,1], aSay[_VLUNIT,2],,,,1)
	ENDIF
	
	nCol:=nCol+220 //IPI
	IF ! Empty(aSay[_ALIQIPI,1])
		oPrn:Line(nLin,nCol,nLin+50,nCol) //linha vert margem esquerda IPI
		oPrn:Say (nLin+30,nCol+50, aSay[_ALIQIPI,1], aSay[_ALIQIPI,2],,,,1)
	ENDIF
	
	nCol:=nCol+220 //ICM
	IF ! Empty(aSay[_ALIQICM,1])
		oPrn:Line(nLin,nCol,nLin+50,nCol)
		oPrn:Say (nLin+30,nCol+50, aSay[_ALIQICM,1], aSay[_ALIQICM,2],,,,1)
	ENDIF
	
	nCol:=nCol+220 //TOTAL
	IF ! Empty(aSay[_VLTOT,1])
		oPrn:Line(nLin,nCol,nLin+50,nCol)
		oPrn:Say (nLin+30,nCol+50,aSay[_VLTOT,1], aSay[_VLTOT,2],,,,1)
	ENDIF
	
	nCol:=nCol+220 //PRAZO ENTREGA 
	IF ! Empty(aSay[_PRAZOENTR,1])
		oPrn:Line(nLin,nCol,nLin+50,nCol)
		oPrn:Say (nLin+30,nCol+50,aSay[_PRAZOENTR,1], aSay[_PRAZOENTR,2],,,,0)
	ENDIF

	nCol:=nCol+250 //PV CLIENTE
	oPrn:Line(nLin,nCol,nLin+50,nCol)
	IF ! Empty(aSay[_PVCLI,1])
		oPrn:Say (nLin+30,nCol+50,aSay[_PVCLI,1]	,aSay[_PVCLI,2],,,,0)
	ENDIF

	nCol:=nCol+100
	LinBox(oPrn,1,nLin,_PAG_TCOL,nLin+nn, _PAG_TCOL)   //coluna direita fecha item
	
	nLin:=nLin+50  //pula linha
	nCol:=_PAG_COL1
	
	LinBox(oPrn,1,nLin-10, nCol, nLin+nn, nCol)           //Coluna esquerda

	oPrn:Line( nLin,_PAG_COL1, nLin,_PAG_TCOL)        //linha separa itens
	
	LinBox(oPrn,1,nLin,_PAG_TCOL, nLin+nn, _PAG_TCOL)   //coluna direita fecha item
	
	IF lCabItem
		lCabItem:=.F.
		LOOP
	ENDIF
	nCol:=nCol+100
	
	IF nSitImpr==1 // Imprime B1_DESC se for "tipo impressao simples"
		nLin:=nLin+10
		
		LinBox(oPrn,1,nLin,_PAG_COL1,nLin+nn, _PAG_COL1)
		oPrn:Say (nLin+30, nCol, aSay[_DESCR,1],aSay[_DESCR,2])
		LinBox(oPrn,1,nLin,_PAG_TCOL,nLin+nn, _PAG_TCOL)   //coluna direita fecha item
	ENDIF
	
	IF nSitImpr==2 //Versao COMPLETA 
		
		aSay[_DESCR] :={ Alltrim(SB1->B1_DESC),oArial10B}
		oFntObs := oArial09
		//aTexto  := _ConvText(oPrn,cDesNia,oFntObs, (_PAG_TCOL-100) ) //oPrn:nHorzRes())
		oFntObs := oArial08

		nLin:=nLin+15
		LinBox(oPrn,1,nLin,_PAG_COL1,nLin+nn, _PAG_COL1)
		oPrn:Say (nLin+30, nCol, aSay[_DESCR,1],aSay[_DESCR,2])
		LinBox(oPrn,1,nLin,_PAG_TCOL,nLin+nn, _PAG_TCOL)   //coluna direita fecha item
		nLin:=nLin+40
		aTxt := ALLTRIM(SB1->B1_XDESCRI)
		nMemCount := mlcount(aTxt,100,,.F.)
		aTexto := ''
		nLin:=nLin+20
		For nx:=1 to nMemCount //nLinMemo
			LinBox(oPrn,1,nLin,_PAG_COL1,nLin+(50*nMemCount), _PAG_COL1)
			oPrn:Say(nLin,nCol,MemoLine(aTxt, 100, nx),oArial11)
			LinBox(oPrn,1,nLin,_PAG_TCOL,nLin+(50*nMemCount), _PAG_TCOL)   //coluna direita fecha item
			fVerPag()
			nLin:=nLin+40
		Next nx
	ENDIF
	
	//VERIFICA SE O CLIN ATINGE 2400
	fVerPag()
	
	//nLin := nLin+10
	
	SCK->(DbSkip())        // aNfItem
Enddo

VAL_MERC := MaFisRet(,"NF_VALMERC") // CK_VALOR
VAL_IPI  := MaFisRet(,"NF_VALIPI")  // TOTAL IPI
VAL_ICM  := MaFisRet(,"NF_VALICM")	// VALOR ICMS
VAL_SOL  := MaFisRet(,"NF_VALSOL")	// VALOR ST
VAL_TOT  := MaFisRet(,"NF_TOTAL")	// TOTAL PEDIDO
                                     
LinBox(oPrn,1, nLin, _PAG_COL1, nLin, _PAG_TCOL)  //linha final fecha itens

Return .T.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfVerPag   บAutor  ณMarcos              บ Data ณ  02/08/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Funcao para analise de paginas                             บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function fVerPag  
LOCAL lReturn:=.F.
If ( nLin >= _PAG_TLIN )
	lReturn:=.T.

    LinBox(oPrn,1, nLin, _PAG_COL1, nLin, _PAG_TCOL)  //linha final fecha itens

	oPrn :EndPage()
	nLin  := 0500
	nLinu := 0510
	nLinf := 0635
	oPrn :StartPage()
	Cabec()
EndIf
Return lReturn

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณLinBox    บAutor  ณMarcos              บ Data ณ  02/08/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
STATIC FUNCTION LinBox(oObj,nTipo,nTop,nLeft    ,nBott  ,nRight   , nEsp)
LOCAL nn

nEsp:=Iif(VAltype(nEsp)<>"N",4,nEsp)
FOR nn:=0 to nEsp
	IF nTipo==1  //Line
		oObj:line(nTop+nn, nLeft+nn, nBott+nn, nRight+nn)
	ELSEIF nTipo==2
		oObj:box(nTop+nn, nLeft+nn, nBott+nn, nRight+nn)
	ENDIF
NEXT
RETURN


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ_CONVTEXT บAutor  ณMarcos              บ Data ณ  12/09/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ QUEBRA UM TEXTO EM LINHAS DE ACORDO COM O TAMANHO          บฑฑ
ฑฑบ          ณ DA FONTE                                                   บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
STATIC FUNCTION _ConvText(oTmSObj,cTexto,oFnt, nTotCol )
LOCAL xx     :=0
LOCAL cChar  :=""
LOCAL aRet   :={}
LOCAL nLen   :=0
LOCAL cLin   :=""
LOCAL nLenLn :=0

cTexto  :=RTrim(cTexto)
nConsTex:=oTmsObj:GetTextWidth ( "M", oFnt )
nLenLn  :=oTmsObj:nHorzRes()
nLenLN  :=nLenLn - 80 

FOR xx:=1 to Len(cTexto)
	cChar:=Substr( cTexto,xx,1)
	cLin+=cChar
	
	IF (CRLF $ cLin)  //QUEBRA DE LINHA
		AAdd(	aRet, StrTran(cLin,CRLF," "))
		cLin:=""
		LOOP
	ENDIF
	
	nLen:=oTmsObj:GetTextWidth( cLin, oFnt )
	IF nLen >= nTotCol 
		nLast:= Rat(" ",cLin)
		nLast:=IIf(nLast < 1, Len(cLin), nLast)
		AAdd(aRet, Left(cLin,nLast))
		xx:=xx-(Len(cLin)-nLast)
		cLin:=""
		nLen:=0
	ENDIF
NEXT

IF !Empty(cLin)
	AAdd(aRet,cLin)
ENDIF

RETURN aRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfAtuMsgCabบAutor  ณMarcos              บ Data ณ  08/02/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Atualiza conteudo do array aMSGCAB com mensagens a serem   บฑฑ
ฑฑบ          ณ impressas no cabecalho do PV, essas serao impressa de      บฑฑ
ฑฑบ          ณ acordo com as respostas das perguntas:                     บฑฑ
ฑฑบ          ณ CJ_PEDINSP PEDIDO PARA INSPECAO                            บฑฑ
ฑฑบ          ณ CJ_PEDMULT PEDIDO COM MULTA                                บฑฑ
ฑฑบ          ณ CJ_PEDCONT PEDIDO DE CONTRATO                              บฑฑ
ฑฑบ          ณ CJ_PEDPROG ENTREGA PROGRAMADA                              บฑฑ
ฑฑบ          ณ CJ_PEDTAG  PEDIDO COM TAG                                  บฑฑ
ฑฑบ          ณ CJ_PEDCERT PEDIDO COM CERTIFIC                             บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Funcao cabec()                                             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
STATIC FUNCTION fAtuMsgCab(cSN,cMSG)
Local I
IF .NOT. cSN=="S" // So entra msg se conteudo da variavel cSN="S"
   RETURN
ENDIF
FOR I:=1 TO LEN(aMSGCAB)
	IF EMPTY(aMSGCAB[I])  // Verifica qual posicao do array esta vazia
		aMSGCAB[I] := SUBSTR(ALLTRIM(cMSG)+SPACE(25),1,25)
		EXIT
	ENDIF
NEXT
Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณQuadro    บAutor  ณMarcos              บ Data ณ  11/02/2013 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Impressao rodape no final do relatorio                     บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ fImpPV                                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function Quadro

fVerPag()

L := 2700
C := 70 

oPrn:say(L-80,C,"XML: "+Alltrim(SA1->A1_EMAIL),oArial17B)
//oPrn:say(L-80,C+1200,IF(SCJ->CJ_PEDCONS=="S","CONSUMO","INDUSTRIALIZAวรO"),oArial17B)

//ณ****************** BOX 1 ******************ณ
oPrn:box(L,C,L+235,C+1000)
         
// LINHA 01
oPrn:say(L+035,C+030,"Desenhos",oArial10B)

oPrn:say(L+035,C+280,"Aprova็ใo",oArial10B)
check(L+030,C+500)

oPrn:say(L+035,C+630,"Certificados",oArial10B)
check(L+030,C+900)

// LINHA 02
oPrn:say(L+100,C+030,"Inspe็ใo",oArial10B)
check(L+095,C+250)

oPrn:say(L+100,C+500,"Certificados / Testes",oArial10B)
check(L+095,C+900)

// LINHA 03
oPrn:say(L+165,C+030,"Manuais",oArial10B) 
check(L+160,C+250)

oPrn:say(L+165,C+350,"Data book",oArial10B) 
check(L+160,C+600)

oPrn:say(L+165,C+750,"Tags",oArial10B) 
check(L+160,C+900)

//ณ****************** BOX 2 ******************ณ
C += 1010

oPrn:box(L,C,L+235,C+800)

// LINHA 1
oPrn:say(L+035,C+10,"Data",oArial10B)
oPrn:say(L+035,C+410,"Visto",oArial10B)
oPrn:Line(L+045,C,L+45,C+800)

// LINHA 2
oPrn:say(L+100,C+10,"Cr้dito",oArial10B)
oPrn:Line(L+110,C,L+110,C+800)

//oPrn:say(L+060,C+810,"Assinado eletronicamente por:",oArial08)
//oPrn:say(L+090,C+810,SCJ->CJ_ASSINAT,oArial08)

// LINHA 3
oPrn:say(L+165,C+10,"Pre็os",oArial10B) 
oPrn:Line(L+170,C,L+175,C+800)

// LINHA 4
oPrn:say(L+230,C+10,"Compras",oArial10B)

oPrn:say(L+230,C+810,DTOC(dDataBase)+" "+Left(Time(),5),oArial08)

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCheck     บAutor  ณMarcos              บ Data ณ  11/02/2013 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Impressao de checks no rodape do pedido de vendas          บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Quadro                                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function Check(L,C)
oPrn:box(L,C,L+40,C+50)
Return

Static Function fAsrPerg(cPer)
Local aArea := GetArea()
Local nI
//ณLimpa o conteฃdo de pergunta existenteณ
/*
DbSelectArea("SX1")
DbSetOrder(1)
For nI := 1 To 4
	If DbSeek(PADR(cPer,10)+PADL(cValtoChar(nI),2,"0"))
		RecLock("SX1",.F.)
		SX1->X1_CNT01 := ""
		SX1->(MsUnlock())
	EndIf
Next
DbCloseArea("SX1")
*/
PutSX1(cPer,"01","Codigo de:  "," "," ","mv_ch1","C", TAMSX3("CJ_NUM"   )[1],0,0,"G","","SCJ","","","mv_par01","","","","","","","","","","","","",""," "," "," ",{"Codigo de"},{""},{""})
PutSX1(cPer,"02","Codigo ate: "," "," ","mv_ch2","C", TAMSX3("CJ_NUM"   )[1],0,0,"G","","SCJ","","","mv_par02","","","","","","","","","","","","",""," "," "," ",{"Codigo ate"},{""},{""})
PutSx1(cPer,"03","De Filial:  "," "," ","mv_ch3","C", TAMSX3("CJ_FILIAL")[1],0,0,"G","","SM0","","","mv_par03","","","","","","","","","","","","",""," "," "," ",{"Empresa/Filial"},{""},{""})
PutSx1(cPer,"04","At้ Filial: "," "," ","mv_ch4","C", TAMSX3("CJ_FILIAL")[1],0,0,"G","","SM0","","","mv_par04","","","","","","","","","","","","",""," "," "," ",{"Empresa/Filial"},{""},{""})

RestArea(aArea)

Return   

Static Function VerTabela(Tab)
	If Select(Tab) > 0
		DbSelectArea(Tab)
		DbCloseArea(Tab)
	EndIf
Return()

Static Function DescrFrete(cCodigo)
	Local cRet := ''
	
	Do Case
		Case cCodigo == "C"
			cRet := "CIF"
		Case cCodigo == "F"
			cRet := "FOB"
		Case cCodigo == "T"
			cRet := "Por conta terceiros"
		Case cCodigo == "S"
			cRet := "Sem frete"
		Otherwise
			cRet := ""
	EndCase

Return cRet

Static Function DescriMoeda(nCodigo)
	Local cRet := ''
	
	Do Case
		Case nCodigo == 1   
			cRet := Alltrim(SuperGetMV("MV_MOEDA1",.F.,"Real"))
		Case nCodigo == 2
			cRet := Alltrim(SuperGetMV("MV_MOEDA2",.F.,"Real"))
		Case nCodigo == 3
			cRet := Alltrim(SuperGetMV("MV_MOEDA3",.F.,"Real"))
		Case nCodigo == 4
			cRet := Alltrim(SuperGetMV("MV_MOEDA4",.F.,"Real"))
		Case nCodigo == 5
			cRet := Alltrim(SuperGetMV("MV_MOEDA5",.F.,"Real"))
		Otherwise
			cRet := "Real"
	EndCase

Return cRet
