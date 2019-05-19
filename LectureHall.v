module LectureHall(trig1,trig2,R,G,out1,out2,out3,echo1,echo2,CLK,temp1,temp2);
output trig1,trig2,R,G,out1,out2,out3,temp1,temp2;
input echo1,echo2,CLK;
wire trig1,trig2;
reg R,G;
reg [6:0] out1,out2,out3;
reg [3:0] count1,count2,count3;
wire [20:0] distance1,distance2;
sonic X (distance1,CLK, trig1, echo1);
sonic Y (distance2,CLK, trig2, echo2);
reg [25:0] delay;
wire sec;
assign sec=(delay==25000000)?1:0;
reg [7:0] AC;
reg [6:0] temp1;
reg[6:0] temp2;


always@(AC)
begin
if(AC<=200 && AC>180)//17
	begin
		temp1=7'b1111000;;
		temp2=7'b1111001;
	end
else if(AC<=180 && AC>160) //18
	begin
		temp1=7'b0000000;
		temp2=7'b1111001;
	end
else if(AC<=160 && AC>140) //19
	begin
		temp1=7'b0010000;
		temp2=7'b1111001;
	end
else if(AC<=140 && AC>120) //20
	begin
		temp1=7'b1000000;
		temp2=7'b0100100;
	end
else if(AC<=120 && AC>100) //21
	begin
		temp1=7'b1111001;
		temp2=7'b0100100;
	end
else if(AC<=100 && AC>80) //22
	begin
		temp1=7'b0100100;
		temp2=7'b0100100;
	end
else if(AC<=80 && AC>60) //23
	begin
		temp1=7'b0110000;
		temp2=7'b0100100;
		
	end
else if(AC<=60 && AC>40	) //24
	begin
		temp1=7'b0011001;
		temp2=7'b0100100;
	end
else if(AC<=40 && AC>20) //25
	begin
		temp1=7'b0010010;
		temp2=7'b0100100;
	end
else if(AC<=20 && AC>10) //26
	begin
		temp1=7'b0000010;
		temp2=7'b0100100;
	end
else  //27
	begin
		temp1=7'b1111000;
		temp2=7'b0100100;
	end





end

always@(posedge CLK)
begin
delay<=delay+1;
if(delay==25000000)
	begin
	delay<=0;
	end
end

always@( posedge sec)
begin
	if(distance1<=10&& count3<2)
		begin
		
			if(count1==4'b1001)
				begin
					count1=4'b0000;
					if(count2==4'b1001)
						begin
							count2=4'b0000;
							count3=count3+1;				
						end
					else
						begin
							count2=count2+1;
						end
			
				end
			else
				begin
					count1=count1+1;
				end
		
		end
	if(distance2<=10 && {count1,count2,count3} != 12'b000000000000)
		begin
			if(count1==4'b0000)
		begin
			count1=4'b1001;
			if(count2==4'b0000)
				begin
					count2=4'b1001;
					count3=count3-1;				
				end
			else
				begin
					count2=count2-1;
				end
			
		end
	else
		begin
			count1=count1-1;
		end
		
		end
	AC=(count3*100)+(count2*10)+count1;
end

always@(count1 or count2 or count3)
begin

if(count3==2)
	begin
		G=1'b0;
		R=1'b1;
	end
else
	begin
		G=1'b1;
		R=1'b0;
	end




case(count1)
4'b0000:out1=7'b1000000;
4'b0001:out1=7'b1111001;
4'b0010:out1=7'b0100100;
4'b0011:out1=7'b0110000;
4'b0100:out1=7'b0011001;
4'b0101:out1=7'b0010010;
4'b0110:out1=7'b0000010;
4'b0111:out1=7'b1111000;
4'b1000:out1=7'b0000000;
4'b1001:out1=7'b0010000;
default:out1=7'b0111111;
endcase
case(count2)
4'b0000:out2=7'b1000000;
4'b0001:out2=7'b1111001;
4'b0010:out2=7'b0100100;
4'b0011:out2=7'b0110000;
4'b0100:out2=7'b0011001;
4'b0101:out2=7'b0010010;
4'b0110:out2=7'b0000010;
4'b0111:out2=7'b1111000;
4'b1000:out2=7'b0000000;
4'b1001:out2=7'b0010000;
default:out2=7'b0111111;
endcase
case(count3)
4'b0000:out3=7'b1000000;
4'b0001:out3=7'b1111001;
4'b0010:out3=7'b0100100;
4'b0011:out3=7'b0110000;
4'b0100:out3=7'b0011001;
4'b0101:out3=7'b0010010;
4'b0110:out3=7'b0000010;
4'b0111:out3=7'b1111000;
4'b1000:out3=7'b0000000;
4'b1001:out3=7'b0010000;
default:out3=7'b0111111;
endcase



end
endmodule


module sonic(distance,clock, trig, echo);
input clock,echo;
output trig,distance;
reg [20:0] distance;

reg [32:0] us_counter = 0;
reg _trig = 1'b0;

reg [9:0] one_us_cnt = 0;
wire one_us = (one_us_cnt == 0);

reg [9:0] ten_us_cnt = 0;
wire ten_us = (ten_us_cnt == 0);

reg [21:0] forty_ms_cnt = 0;
wire forty_ms = (forty_ms_cnt == 0);

assign trig = _trig;

always @(posedge clock) begin
	one_us_cnt <= (one_us ? 50 : one_us_cnt) - 1;
	ten_us_cnt <= (ten_us ? 500 : ten_us_cnt) - 1;
	forty_ms_cnt <= (forty_ms ? 2000000 : forty_ms_cnt) - 1;
	
	if (ten_us && _trig)
		_trig <= 1'b0;
	
	if (one_us) begin	
		if (echo)
			us_counter <= us_counter + 1;
		else if (us_counter) begin
			distance <= us_counter / 58;
			us_counter <= 0;
		end
	end
	
   if (forty_ms)
		_trig <= 1'b1;
end

endmodule