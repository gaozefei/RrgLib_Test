float Delt_H = 260;
float XL     =  800;
float XR     =  800;
float Height = 1000;
///////////////////////////////////////////
int Cluster_Count = 10;                       //设置数据拟合的程度。设置完之后， 获取的data 数目将变更为 {endstep-startstep}/ClusterCount


//package com.kristou.samples;
UrgDevice   device;         //定义设备对象
double      angle;
long        Distance_ini;

PVector     UpL ,UpR,DwL,DwR;   //定义四个点
ArrayList<PVector>  MyPoint; 






void setup()
{
/////////////////////////////////////////////////////////////////////////初始化定义四个角的坐标
          UpL = new PVector(-XL, Delt_H);
          UpR = new PVector(XL, Delt_H);
          DwL = new PVector(-XL, Delt_H+Height); 
          DwR = new PVector(XL, Delt_H+Height); 
           
          MyPoint   = new ArrayList<PVector>();                                                                       //存储有效点
          //////////////////////////////////////////////////////////////////////
        //Create an UrgDevice with the ethernet connection
        //UrgDevice device = new UrgDevice(new EthernetConnection());
         device = new UrgDevice(new EthernetConnection());                                                            /////新的版本
         //int times = 20;

        // Connect to the sensor
        if (device.connect("192.168.0.10"))
        {
            System.out.println("connected");

            //Get the sensor information
            RangeSensorInformation info = device.getInformation();
                  if(info != null)
                  {
                  System.out.println("Sensor model:" + info.product);
                  System.out.println("Sensor serial number:" + info.serial_number);
                  }
                  else
                  {
                      System.out.println("Sensor error:" + device.what());
                  }
            //Set the continuous capture type, Please refer to the SCIP protocol for further details
            device.setCaptureMode(CaptureSettings.CaptureMode.MD_Capture_mode);                                                //注意选择合适的模式来获取有效的数据，目前是MD  , 
            device.setStartStep(181);                                                                                           //起始步
            device.setEndStep(900);                                                                                            //终止步
            device.setSkipLines(Cluster_Count);
            
            //We set the capture type to a continuous mode so we have to start the capture                
            device.startCapture();   
        }
///////////////////////////////////////////////////////////////////////////////////////////原来版本

         

}

///////////////////////////////////////////////////////////////////////////////////主函数

void draw()
{
   ReceiveData();


  
  

}

////////////////////////////////////////////////////////////////////////////////////获取雷达数据
void ReceiveData()
{
      CaptureData data = device.capture();
      if(data != null) 
      {
          float  x,y;
        
          for(int i =0; i<data.steps.size();i++)
          {
                Distance_ini = data.steps.get(i).distances.get(0);
                System.out.println("Scan " + (i + 1) + ", distance is " + Distance_ini);                 ////////////////////////////////////////////////这一句是用于测试用,看一下获取的距离   
               
                angle = device.index2rad(181 +Cluster_Count*i) ;                                                              ////////////////////////////////////////////////获取角度 ,注意角度获取的index  与cluster counter 息息相关
                

                float angle1 = (float)angle;
                angle1 =  PI/2 - angle1;
                float  f1 = (float)Distance_ini;
            
                println("the angle is "+angle );
                 x = -f1 * cos(angle1);
                 y = f1 * sin(angle1);
                
               if(   (x<UpR.x && x>UpL.x)&& (y<DwR.y && y>UpR.y)  )                
               {
              
                   PVector  TempPoint = new PVector(x,y); 
                   MyPoint.add(TempPoint);
               }
          }
          
          println("the arraylist size is" + MyPoint.size());
          for(int j=0; j<MyPoint.size();j++ )
          {
            println("myPoint is "+ MyPoint.get(j));
          
          }   
  
      } else 
       {
          System.out.println("Sensor error:" + device.what());
       }
   
}