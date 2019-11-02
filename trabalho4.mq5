//+------------------------------------------------------------------+
//|                                                    trabalho4.mq5 |
//|      Copyright 2018, MetaQuotes Software Corp. guilherme_santana |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2018, MetaQuotes Software Corp. guilherme_santana"
#property link      "https://www.mql5.com"
#property version   "1.00"
//#property indicator_separate_window
#property indicator_chart_window
#property indicator_buffers 2
#property indicator_plots   2
//--- plot Fechamento
#property indicator_label1  "Fechamento"
#property indicator_type1   DRAW_LINE
#property indicator_color1  clrBlue
#property indicator_style1  STYLE_SOLID
#property indicator_width1  5
//--- plot Baixa
#property indicator_label2  "Baixa"
#property indicator_type2   DRAW_LINE
#property indicator_color2  clrRed
#property indicator_style2  STYLE_SOLID
#property indicator_width2  5
//--- input parameters
input int      media_longa=15;
input int      media_curta=5;
//--- indicator buffers
double         FechamentoBuffer[];
double         BaixaBuffer[];
int            mediaMovelLonga;
int            mediaMovelCurta;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
//--- indicator buffers mapping
   SetIndexBuffer(0,FechamentoBuffer,INDICATOR_DATA);
   SetIndexBuffer(1,BaixaBuffer,INDICATOR_DATA);
   
   IndicatorSetInteger(INDICATOR_DIGITS,Digits());
  
   ArraySetAsSeries(FechamentoBuffer,true);
   ArraySetAsSeries(BaixaBuffer,true);
   
   ResetLastError();
   
   mediaMovelLonga = iMA(NULL,PERIOD_CURRENT,media_longa,0,MODE_SMA,PRICE_CLOSE);
   mediaMovelCurta = iMA(NULL,PERIOD_CURRENT,media_curta,0,MODE_SMA,PRICE_LOW);
   if(mediaMovelLonga ==INVALID_HANDLE || mediaMovelCurta == INVALID_HANDLE)
   {
      Print("The iMA(",(string)media_longa,") object was not created: Error ",GetLastError());
      return INIT_FAILED;
   }
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int OnCalculate(const int rates_total,
                const int prev_calculated,
                const datetime &time[],
                const double &open[],
                const double &high[],
                const double &low[],
                const double &close[],
                const long &tick_volume[],
                const long &volume[],
                const int &spread[])
  {
//---

   ArraySetAsSeries(close,true);
   ArraySetAsSeries(low,true);
   Print("Rates total(",(string)rates_total,")");
   if(rates_total < media_longa) return 0;
   
   ArrayInitialize(FechamentoBuffer,EMPTY_VALUE);
   ArrayInitialize(BaixaBuffer,EMPTY_VALUE);
   int copied = CopyBuffer(mediaMovelCurta,0,0,rates_total,BaixaBuffer);
   if(copied!=rates_total) return 0;
   copied = CopyBuffer(mediaMovelLonga,0,0,rates_total,FechamentoBuffer);
   if(copied!=rates_total) return 0;
   int limit=rates_total-prev_calculated;
//--- return value of prev_calculated for next call
   return(rates_total);
  }