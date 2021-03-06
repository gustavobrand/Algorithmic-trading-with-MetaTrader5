//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
#include <Trade\Trade.mqh>
#include <funcdayofweek.mqh>
CTrade trade;

void OnTick()
  {
   //Ask price
  double ask = NormalizeDouble(SymbolInfoDouble(_Symbol,SYMBOL_ASK),_Digits);    
   
   //Bid price
   double bid = NormalizeDouble(SymbolInfoDouble(_Symbol,SYMBOL_BID),_Digits);
   
   //Call indicator function 
   string iMASignal = movingAverage();
   
   MqlDateTime tm;
   TimeCurrent(tm);
   
   //Only trade on wednesday
   if(tm.day_of_week == 3)
   {
   
   //Buy trade 
   if(iMASignal == "buy" && PositionsTotal()<1)   
     {
     //trade.Buy(0.010,NULL,ask,(ask - 250 *_Point),(ask + 100*_Point),NULL);
     trade.Buy(0.10,NULL,ask,0,(ask+150 * _Point),NULL); 	         
      //PrintFormat("Bought");
     }
     
   //Sell tarde
   if(iMASignal == "sell" && PositionsTotal()<1)
     {
     //trade.Sell(0.010,NULL,bid,(bid + 250 *_Point),(bid - 100 * _Point),NULL); 
     trade.Sell(0.10,NULL,bid,0,(bid-150 * _Point),NULL); 
      //PrintFormat("Sold");
     }  
     
    } 
   }


//+------------------------------------------------------------------+
//| Indicator                                            
//+------------------------------------------------------------------+

string movingAverage()
   {
   //Creating of price array
	MqlRates PriceInfo[];
	
   //Sort array. Starting with the newest candle
   ArraySetAsSeries(PriceInfo,true); 
   
   //Put price data in array
   int PriceData =CopyRates(Symbol(),Period(),0,3,PriceInfo);    

      
   //Create array for three moving average
   double SMA10Array[],SMA50Array[],SMA100Array[];
      
   //Define SMA10
   int SMA10Definition = iMA (_Symbol,_Period,10,0,MODE_SMA,PRICE_CLOSE);
      
   //Define SMA50
   int SMA50Definition = iMA (_Symbol,_Period,50,0,MODE_SMA,PRICE_CLOSE);
      
   //Define SMA100
   int SMA100Definition = iMA (_Symbol,_Period,100,0,MODE_SMA,PRICE_CLOSE);
      
   //Sort array downwards (SM10)
   ArraySetAsSeries(SMA10Array,true);
      
   //Sort array downwards (SM50)
   ArraySetAsSeries(SMA50Array,true);
      
   //Sort array downwards (SM100)
   ArraySetAsSeries(SMA100Array,true);
      
   //Fill array with price data (SM10)
   CopyBuffer(SMA10Definition,0,0,10,SMA10Array);
      
   //Fill array with price data (SM50)
   CopyBuffer(SMA50Definition,0,0,10,SMA50Array);
      
   //Fill array with price data (SM100)
   CopyBuffer(SMA100Definition,0,0,10,SMA100Array); 
   
   //Buy or sell signal
   string signal="";
   
   // Kaufen Signal
   if (SMA10Array[0]>SMA50Array[0])
    if (SMA50Array[0]>SMA100Array[0])
        { signal="buy";}
   
   // Verkaufen Signal
   if (SMA10Array[0]<SMA50Array[0])
    if (SMA50Array[0]<SMA100Array[0])
        { signal="sell";}
   
   return signal;
   }     