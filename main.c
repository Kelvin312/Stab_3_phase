/*****************************************************
This program was produced by the
CodeWizardAVR V2.05.0 Professional
Automatic Program Generator
© Copyright 1998-2010 Pavel Haiduc, HP InfoTech s.r.l.
http://www.hpinfotech.com

Project : 
Version : 
Date    : 04.08.2015
Author  : 
Company : 
Comments: 


Chip type               : ATmega16
Program type            : Application
AVR Core Clock frequency: 16,000000 MHz
Memory model            : Small
External RAM size       : 0
Data Stack size         : 256
*****************************************************/

#include <mega16.h>

#include <delay.h>

#ifndef RXB8
#define RXB8 1
#endif

#ifndef TXB8
#define TXB8 0
#endif

#ifndef UPE
#define UPE 2
#endif

#ifndef DOR
#define DOR 3
#endif

#ifndef FE
#define FE 4
#endif

#ifndef UDRE
#define UDRE 5
#endif

#ifndef RXC
#define RXC 7
#endif

#define FRAMING_ERROR (1<<FE)
#define PARITY_ERROR (1<<UPE)
#define DATA_OVERRUN (1<<DOR)
#define DATA_REGISTER_EMPTY (1<<UDRE)
#define RX_COMPLETE (1<<RXC)

// USART Receiver buffer
#define RX_BUFFER_SIZE 32
char rx_buffer[RX_BUFFER_SIZE];

#if RX_BUFFER_SIZE <= 256
unsigned char rx_wr_index,rx_rd_index,rx_counter;
#else
unsigned int rx_wr_index,rx_rd_index,rx_counter;
#endif

// This flag is set on USART Receiver buffer overflow
bit rx_buffer_overflow;

// USART Receiver interrupt service routine
interrupt [USART_RXC] void usart_rx_isr(void)
{
char status,data;
status=UCSRA;
data=UDR;
if ((status & (FRAMING_ERROR | PARITY_ERROR | DATA_OVERRUN))==0)
   {
   rx_buffer[rx_wr_index++]=data;
#if RX_BUFFER_SIZE == 256
   // special case for receiver buffer size=256
   if (++rx_counter == 0)
      {
#else
   if (rx_wr_index == RX_BUFFER_SIZE) rx_wr_index=0;
   if (++rx_counter == RX_BUFFER_SIZE)
      {
      rx_counter=0;
#endif
      rx_buffer_overflow=1;
      }
   }
}

#ifndef _DEBUG_TERMINAL_IO_
// Get a character from the USART Receiver buffer
#define _ALTERNATE_GETCHAR_
#pragma used+
char getchar(void)
{
char data;
while (rx_counter==0);
data=rx_buffer[rx_rd_index++];
#if RX_BUFFER_SIZE != 256
if (rx_rd_index == RX_BUFFER_SIZE) rx_rd_index=0;
#endif
#asm("cli")
--rx_counter;
#asm("sei")
return data;
}
#pragma used-
#endif

// USART Transmitter buffer
#define TX_BUFFER_SIZE 32
char tx_buffer[TX_BUFFER_SIZE];

#if TX_BUFFER_SIZE <= 256
unsigned char tx_wr_index,tx_rd_index,tx_counter;
#else
unsigned int tx_wr_index,tx_rd_index,tx_counter;
#endif

// USART Transmitter interrupt service routine
interrupt [USART_TXC] void usart_tx_isr(void)
{
if (tx_counter)
   {
   --tx_counter;
   UDR=tx_buffer[tx_rd_index++];
#if TX_BUFFER_SIZE != 256
   if (tx_rd_index == TX_BUFFER_SIZE) tx_rd_index=0;
#endif
   }
}

#ifndef _DEBUG_TERMINAL_IO_
// Write a character to the USART Transmitter buffer
#define _ALTERNATE_PUTCHAR_
#pragma used+
void putchar(char c)
{
while (tx_counter == TX_BUFFER_SIZE);
#asm("cli")
if (tx_counter || ((UCSRA & DATA_REGISTER_EMPTY)==0))
   {
   tx_buffer[tx_wr_index++]=c;
#if TX_BUFFER_SIZE != 256
   if (tx_wr_index == TX_BUFFER_SIZE) tx_wr_index=0;
#endif
   ++tx_counter;
   }
else
   UDR=c;
#asm("sei")
}
#pragma used-
#endif

// Standard Input/Output functions
#include <stdio.h>

/////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////

#define FIRST_ADC_INPUT 0
#define LAST_ADC_INPUT 3
#define ADC_VREF_TYPE 0x40
#define ZERO 10

#define COUNT_CONTROL 75
#define HYSTIREZIS 15

#define AP PORTC.2
#define AN PORTC.3
#define BP PORTC.4
#define BN PORTC.5
#define CP PORTC.6
#define CN PORTC.7

#define LED1 PORTD.4  //green
#define LED2 PORTD.6  //red

#define MIN_OUT_VOLTAGE (230*COUNT_CONTROL)
#define MAX_OUT_VOLTAGE (255*COUNT_CONTROL)

#define MIN_TIMEREG 47    //180 grad
#define MAX_TIMEREG 180   //30 grad


char adc_wr_input=0, adc_rd_input=0;
char isRising[4], isFalling[4]; 
signed int adcValue[LAST_ADC_INPUT-FIRST_ADC_INPUT+1], tempValue;
long OutVoltage = 0;
char flag, isEnable = 1;
unsigned char timeReg = MIN_TIMEREG, lastFalling = 0;
char regCounter = 0;
char phaseCounter = 0;
char old_test = 0;

inline void SetOut(char numb)
{
  if(isEnable && isRising[numb] && timeReg > MIN_TIMEREG)
  {
      switch(numb) 
      {
          case 0: AP = 1; if(isFalling[1]) BN = 1; if(isFalling[2]) CN = 1;
          break; 
          case 1: BP = 1; if(isFalling[0]) AN = 1; if(isFalling[2]) CN = 1;
          break;
          case 2: CP = 1; if(isFalling[0]) AN = 1; if(isFalling[1]) BN = 1;
          break;
      } 
      
      delay_us(50); 
      
      switch(numb) 
      {
          case 0: AP = 0; BN = 0; CN = 0;
          break; 
          case 1: BP = 0; AN = 0; CN = 0;
          break;
          case 2: CP = 0; AN = 0; BN = 0;
          break;
      }
  } 
}

// Timer 0 overflow interrupt service routine
interrupt [TIM0_OVF] void timer0_ovf_isr(void)
{
// Reinitialize Timer 0 value
TCCR0=0x00;
TCNT0=0x4A;
// Place your code here
SetOut(0);
}

// Timer 0 output compare interrupt service routine
interrupt [TIM0_COMP] void timer0_comp_isr(void)
{
// Place your code here
SetOut(0);
}

// Timer1 overflow interrupt service routine
interrupt [TIM1_OVF] void timer1_ovf_isr(void)
{
// Reinitialize Timer1 value
TCCR1B=0x00;
TCNT1H=0xFF;
TCNT1L=0x4A;
// Place your code here
SetOut(1);
}

// Timer1 output compare A interrupt service routine
interrupt [TIM1_COMPA] void timer1_compa_isr(void)
{
// Place your code here
SetOut(1);
}

// Timer2 overflow interrupt service routine
interrupt [TIM2_OVF] void timer2_ovf_isr(void)
{
// Reinitialize Timer2 value
TCCR2=0x00;
TCNT2=0x4A;
// Place your code here
SetOut(2);
}

// Timer2 output compare interrupt service routine
interrupt [TIM2_COMP] void timer2_comp_isr(void)
{
// Place your code here
SetOut(2);
}



// ADC interrupt service routine
// with auto input scanning
interrupt [ADC_INT] void adc_isr(void)
{
// Read the AD conversion result

tempValue = ADCW;

// Select next ADC input
    adc_rd_input = adc_wr_input + 1;
    if(adc_rd_input > 3) adc_rd_input -= 4;
    ADMUX=(ADC_VREF_TYPE & 0xff) | adc_rd_input;


if(adc_wr_input<3) //Фазы
{ 
tempValue -= 0x01FF;
adcValue[adc_wr_input] = tempValue;

if(tempValue > (ZERO+HYSTIREZIS) && isRising[adc_wr_input] == 0)
{
    isRising[adc_wr_input] = 1;
    phaseCounter++;
    
    if(isEnable)
    { 
    switch(adc_wr_input)
    {
        case 0:
            if((TCCR0&7) == 0) 
            {
              TCNT0=timeReg; //Время включения 1
              TCCR0=0x05;  //putchar(0xB1);
            }
        break;
        case 1:
            if((TCCR1B&7) == 0) 
            {
              TCNT1H=0xFF;
              TCNT1L=timeReg; //Время включения 2
              TCCR1B=0x05;  //putchar(0xB2);
            }   
        break;
        case 2:
            if((TCCR2&7) == 0)
            {
              TCNT2=timeReg; //Время включения 3
              TCCR2=0x07;   //putchar(0xB3);
            }
        break;
    }
    }
}

if(tempValue < ((signed int)ZERO-HYSTIREZIS))
{
    isRising[adc_wr_input] = 0;
}

if(tempValue < ((signed int)ZERO-HYSTIREZIS) && isFalling[adc_wr_input] == 0)
{
    isFalling[adc_wr_input] = 1;
    lastFalling = adc_wr_input; 
    phaseCounter++;
}

if(tempValue > (ZERO+HYSTIREZIS))
{
    isFalling[adc_wr_input] = 0;
}
}
else //Выход
{
    OutVoltage += tempValue - 255;

    if(++regCounter >= COUNT_CONTROL)
    {
        isEnable = (phaseCounter > 4) && (phaseCounter < 11); //Защита от частоты сети
        if(OutVoltage < 40 && timeReg > (MIN_TIMEREG + 26)) isEnable = 0; //Защита от мин тока удержания
        
        if(isEnable){LED1 = 0; LED2 = 0;} else {LED1 = 1; LED2 = 1; timeReg = MIN_TIMEREG; }
        
        if(OutVoltage < MIN_OUT_VOLTAGE){ if(timeReg < MAX_TIMEREG) timeReg++; LED1 = 1;}  //LED2 on Volt+
        if(OutVoltage > MAX_OUT_VOLTAGE){ if(timeReg > MIN_TIMEREG) timeReg--; LED2 = 1;}  //Для 50 герц
        if(OutVoltage > (MAX_OUT_VOLTAGE+30) && timeReg > (MIN_TIMEREG+3)) timeReg-=3;
         if(timeReg != old_test) putchar(timeReg); 
         old_test = timeReg;
         if(phaseCounter>7) putchar(phaseCounter);
        regCounter = 0;
        OutVoltage = 0;
        phaseCounter = 0;
    }
    adcValue[adc_wr_input] = tempValue - 255;
}

flag = 1;

// Select next ADC input
if (++adc_wr_input > 3) 
{
    adc_wr_input = 0;
}
// Delay needed for the stabilization of the ADC input voltage
delay_us(10);
// Start the AD conversion
ADCSRA|=0x40;
}

// Declare your global variables here

void main(void)
{
// Declare your local variables here
char i;
// Input/Output Ports initialization
// Port A initialization
// Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In 
// State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T 
PORTA=0x00;
DDRA=0x00;

// Port B initialization
// Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=Out 
// State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=0 
PORTB=0x00;
DDRB=0x01;

// Port C initialization
// Func7=Out Func6=Out Func5=Out Func4=Out Func3=Out Func2=Out Func1=In Func0=In 
// State7=0 State6=0 State5=0 State4=0 State3=0 State2=0 State1=T State0=T 
PORTC=0x00;
DDRC=0xFC;

// Port D initialization
// Func7=In Func6=Out Func5=In Func4=Out Func3=In Func2=In Func1=In Func0=In 
// State7=T State6=0 State5=T State4=0 State3=T State2=T State1=T State0=T 
PORTD=0x00;
DDRD=0x50;


// Timer/Counter 0 initialization
// Clock source: System Clock
// Clock value: 15,625 kHz
// Mode: Normal top=0xFF
// OC0 output: Disconnected
//TCCR0=0x05;
TCNT0=0x4A;
OCR0=0xCC;

// Timer/Counter 1 initialization
// Clock source: System Clock
// Clock value: 15,625 kHz
// Mode: Normal top=0xFFFF
// OC1A output: Discon.
// OC1B output: Discon.
// Noise Canceler: Off
// Input Capture on Falling Edge
// Timer1 Overflow Interrupt: On
// Input Capture Interrupt: Off
// Compare A Match Interrupt: On
// Compare B Match Interrupt: Off
TCCR1A=0x00;
//TCCR1B=0x05;
TCNT1H=0xFF;
TCNT1L=0x4A;
ICR1H=0x00;
ICR1L=0x00;
OCR1AH=0xFF;
OCR1AL=0xCC;
OCR1BH=0x00;
OCR1BL=0x00;

// Timer/Counter 2 initialization
// Clock source: System Clock
// Clock value: 15,625 kHz
// Mode: Normal top=0xFF
// OC2 output: Disconnected
ASSR=0x00;
//TCCR2=0x07;
TCNT2=0x4A;
OCR2=0xCC;

// External Interrupt(s) initialization
// INT0: Off
// INT1: Off
// INT2: Off
MCUCR=0x00;
MCUCSR=0x00;

// Timer(s)/Counter(s) Interrupt(s) initialization
TIMSK=0xD7;


// USART initialization
// Communication Parameters: 8 Data, 1 Stop, No Parity
// USART Receiver: On
// USART Transmitter: On
// USART Mode: Asynchronous
// USART Baud Rate: 38400
UCSRA=0x00;
UCSRB=0xD8;
UCSRC=0x86;
UBRRH=0x00;
UBRRL=0x67; //UBRRL=0x19;

// Analog Comparator initialization
// Analog Comparator: Off
// Analog Comparator Input Capture by Timer/Counter 1: Off
ACSR=0x80;
SFIOR=0x00;

// ADC initialization
// ADC Clock frequency: 250,000 kHz
// ADC Voltage Reference: AVCC pin
// ADC Auto Trigger Source: ADC Stopped
ADMUX=FIRST_ADC_INPUT | (ADC_VREF_TYPE & 0xff);
ADCSRA=0xCE;

// SPI initialization
// SPI disabled
SPCR=0x00;

// TWI initialization
// TWI disabled
TWCR=0x00;

// Watchdog Timer initialization
// Watchdog Timer Prescaler: OSC/512k
#pragma optsize-
WDTCR=0x1D;
WDTCR=0x0D;
#ifdef _OPTIMIZE_SIZE_
#pragma optsize+
#endif

// Global enable interrupts
#asm("sei")

putchar(0xCC);
while (1)
      {
      #asm("wdr")
      if(flag && rx_counter)
      { 
        getchar();
        for(i=0; i<4; i++)
        {
          putchar(adcValue[i] & 0xFF); 
          putchar(adcValue[i] >> 8);
        }
        flag = 0;
      }

      }
}
