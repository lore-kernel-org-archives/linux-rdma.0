From: Andrea Gozzelino <Andrea.Gozzelino-PK20h7lG/Rc1GQ1Ptb7lUw@public.gmane.org>
Subject: RE: RDMA transfer speed performance test
Date: Mon, 12 Jul 2010 14:37:41 +0200 (CEST)
Message-ID: <4242568.1278938261321.SLOX.WebMail.wwwrun@imap.lnl.infn.it>
References: <8214320.1278667993311.SLOX.WebMail.wwwrun@imap.lnl.infn.it> <CF9C39F99A89134C9CF9C4CCB68B8DDF25A127CDC0@orsmsx501.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_Part_1540_5520452.1278938261320"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CF9C39F99A89134C9CF9C4CCB68B8DDF25A127CDC0-osO9UTpF0USkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "Tung, Chien Tin" <chien.tin.tung-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "dotanba-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <dotanba-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

------=_Part_1540_5520452.1278938261320
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On Jul 09, 2010 07:13 PM, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:

> > Is librdmacm version 1.0.12 stable?
> 
> Yes - but you are using APIs that are new to this release. But those
> calls are wrappers around existing libibverbs calls.
>  
> > The flag IBV_SEND_INLINE supports buffer size until 64 bytes (cards'
> > feature).
> > 
> > I know that RDMA is a protocol connected with 10 Gigabit/s Ethernet.
> > How can I see this trasfer speed? Can you suggest the "path"?
> > I attached the starting latency_RDMA.cpp code, which works with
> > librdmacm version 1.0.12 with BUF_SIZE < = 64 bytes (thanks to
> > Chien).
> > I would like to explore transfer speed in range 1 bytes < BUF_SIZE <
> > 4
> > Mbytes.
> 
> The use of INLINE allows you to post a send message without the buffer
> being registered. As soon as you try to post a send with a buffer
> larger than what can be supported as inline, the buffer must be
> registered, and the memory region should be passed into the send
> command. Add something like this to both the client and server:
> 
> struct ibv_mr *send_mr;
> 
> ...
> 
> send_mr = rdma_reg_msgs(id, send_msg, BUF_SIZE);
> // add matching rdma_dereg_mr(send_mr); at end
> 
> and change your rdma_post_send calls to:
> 
> ret = rdma_post_send(id, NULL, send_msg, BUF_SIZE, send_mr,
> IBV_SEND_INLINE);
> 
> - Sean

Hi Sean, Hi Chien

the code now works fine. Thank you very much, Sean.
In attachment you find:
-- code and script client;
-- txt file with data recap;
-- xls file with graph.

Note that in txt file the round trip time is wrongly called "latency".
So in the xls file I correct the formula. I measure the trip time.
latency = RTT/2;
speed in txt file is reduced by 2.

In xls file I put also the speed in Gbits/s.

In this week I will recap code, test data and information about RDMA
test on NE020 cards.

Thank you again for contribution.
Regards,
Andrea



Andrea Gozzelino

INFN - Laboratori Nazionali di Legnaro	(LNL)
Viale dell'Universita' 2 -I-35020 - Legnaro (PD)- ITALIA
Office: E-101
Tel: +39 049 8068346
Fax: +39 049 641925
Mail: andrea.gozzelino-PK20h7lG/Rc1GQ1Ptb7lUw@public.gmane.org
Cell: +39 3488245552				

------=_Part_1540_5520452.1278938261320
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=script_Speed_RDMA.sh

#! /bin/sh

# Program: Script bash to run REDIGO (RDMA) performance test
# Authors: Damiano Bortolato - Andrea Gozzelino (INFN - LNL)
# Date: July 2010

# Array buffer size

# Bandwidth test -- Latency measurement too
array_BUFFER_SIZE=( 1 4 16 32 64 128 256 512 1024 8192 65536 131072 200704 262144 393216 524288 1048576 16777216 )

# default number of transfer is 10^6

# Constant that sets date formatting for appending to filenames
# Date format is DDMMYYhhmmss or day,month,year,hour,minute,second.
Date=`date "+%d%m%y%H%M%S"`
	
for i in "${array_BUFFER_SIZE[@]}"
	do
	./RDMA_Speed -b $i -n 1000000 > Test_$i.log
	mv Test_Speed.txt Test_Speed_$i.txt
	done

# Ending operations	
mkdir REDIGO_Speed_"$Date"
mv *.txt ./REDIGO_Speed_"$Date"
mv *.log ./REDIGO_Speed_"$Date"
cd REDIGO_Speed_"$Date"
cat *.txt > REDIGO_Data.txt
cat *.log > REDIGO_Log.log
cd ..



------=_Part_1540_5520452.1278938261320
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=REDIGO_Data.txt

#transfer|buffer_size(bytes)|total_time(s)|speed(bytes/s)|latency(s)| 
  1000000|              1024|           31|   3.30323e+07|   3.1e-05|
#transfer|buffer_size(bytes)|total_time(s)|speed(bytes/s)|latency(s)| 
  1000000|           1048576|         2014|   5.20643e+08|  0.002014|
#transfer|buffer_size(bytes)|total_time(s)|speed(bytes/s)|latency(s)| 
  1000000|               128|           27|   4.74074e+06|   2.7e-05|
#transfer|buffer_size(bytes)|total_time(s)|speed(bytes/s)|latency(s)| 
  1000000|            131072|          253|   5.18071e+08|  0.000253|
#transfer|buffer_size(bytes)|total_time(s)|speed(bytes/s)|latency(s)| 
  1000000|                16|           23|        695652|   2.3e-05|
#transfer|buffer_size(bytes)|total_time(s)|speed(bytes/s)|latency(s)| 
  1000000|                 1|           22|       45454.5|   2.2e-05|
#transfer|buffer_size(bytes)|total_time(s)|speed(bytes/s)|latency(s)| 
  1000000|            200704|          409|   4.90719e+08|  0.000409|
#transfer|buffer_size(bytes)|total_time(s)|speed(bytes/s)|latency(s)| 
  1000000|               256|           27|   9.48148e+06|   2.7e-05|
#transfer|buffer_size(bytes)|total_time(s)|speed(bytes/s)|latency(s)| 
  1000000|            262144|          563|    4.6562e+08|  0.000563|
#transfer|buffer_size(bytes)|total_time(s)|speed(bytes/s)|latency(s)| 
  1000000|                32|           23|    1.3913e+06|   2.3e-05|
#transfer|buffer_size(bytes)|total_time(s)|speed(bytes/s)|latency(s)| 
  1000000|            393216|          701|   5.60936e+08|  0.000701|
#transfer|buffer_size(bytes)|total_time(s)|speed(bytes/s)|latency(s)| 
  1000000|                 4|           23|        173913|   2.3e-05|
#transfer|buffer_size(bytes)|total_time(s)|speed(bytes/s)|latency(s)| 
  1000000|               512|           28|   1.82857e+07|   2.8e-05|
#transfer|buffer_size(bytes)|total_time(s)|speed(bytes/s)|latency(s)| 
  1000000|            524288|          927|   5.65575e+08|  0.000927|
#transfer|buffer_size(bytes)|total_time(s)|speed(bytes/s)|latency(s)| 
  1000000|                64|           23|   2.78261e+06|   2.3e-05|
#transfer|buffer_size(bytes)|total_time(s)|speed(bytes/s)|latency(s)| 
  1000000|             65536|          140|   4.68114e+08|   0.00014|
#transfer|buffer_size(bytes)|total_time(s)|speed(bytes/s)|latency(s)| 
  1000000|              8192|           46|   1.78087e+08|   4.6e-05|

------=_Part_1540_5520452.1278938261320
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=speed_RDMA.cpp

/*
------------------------------------------------------------------
Program: RDMA latency test with buffer size < 64 bytes
Program: RDMA bandwidth test
Use: REDIGO project --> RDMA performance test
Authors: Damiano Bortolato - Andrea Gozzelino (INFN - LNL)
Structure: INFN LNL @ Legnaro (Italy)
Date: July 2010
Note: using librdmacm version 1.0.12 by Sean Hefty 
Note: help from Chien Tin Tung (Intel) and Sean Hefty (Intel)
------------------------------------------------------------------
*/

//Include
#include <rdma/rdma_cma.h>
#include <rdma/rdma_verbs.h>
#include <infiniband/arch.h>
#include <netdb.h>
#include <errno.h>
#include <string.h>
#include <stdio.h>
#include <stdlib.h>
#include <inttypes.h>
#include <unistd.h>
#include <time.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <sys/socket.h>
#include <sys/types.h>
#include <sys/times.h>
#include <iostream>
#include <fstream>
#include <assert.h>
#include <sys/param.h>
#include <iomanip> // format manipulation
#include <vector>

using namespace std;

// header file
#include "header_RDMA.h"

//******************************************************
//********************** RDMA SERVER *******************
//******************************************************

int asServer(TestMessage &TM){
	
	printf("\nRDMA server machine redigo-01 is starting. \n");
	
	// Information from TCP socket
	int BUF_SIZE = TM.data.message.tbuffer_size;
	printf("BUF_SIZE = %i \n", BUF_SIZE);
	
	int NTX=TM.data.message.loops;
	printf("NTX = %i \n", NTX);
  
	// Variables
	static char *port = "7471";
	static char *server = "100.168.0.56";
	struct rdma_cm_id *listen_id, *id;
	struct ibv_mr *mr;
	struct ibv_mr  *send_mr; 
	char *send_msg=new char[BUF_SIZE];
	char *recv_msg=new char[BUF_SIZE];
	struct rdma_addrinfo hints, *res;
	struct ibv_qp_init_attr attr;
	struct ibv_wc wc;
	int ret;// function return value
	int i; // loop counter

	// RDMA_getaddrinfo 
	memset(&hints, 0, sizeof hints);
	hints.ai_flags = RAI_PASSIVE;
	hints.ai_port_space = RDMA_PS_TCP;
	ret = rdma_getaddrinfo(NULL, port, &hints, &res);
	if (ret) {
		printf("rdma_getaddrinfo %d\n", errno);
		return ret;
		}
	else printf("OK rdma_getaddrinfo function. \n");
	
	// RDMA_create_ep
	memset(&attr, 0, sizeof attr);
	attr.cap.max_send_wr = attr.cap.max_recv_wr = 128;
	attr.cap.max_send_sge = attr.cap.max_recv_sge = 1;
	attr.cap.max_inline_data = BUF_SIZE;
	attr.sq_sig_all = 1;
	ret = rdma_create_ep(&listen_id, res, NULL, &attr);
	rdma_freeaddrinfo(res);
	if (ret) {
		printf("rdma_create_ep %d\n", errno);
		return ret;
		}
	else printf("OK rdma_create_ep funtion. \n");

	// RDMA_listen
	ret = rdma_listen(listen_id, 0);
	if (ret) {
		printf("rdma_listen %d\n", errno);
		return ret;
		}
	else printf("OK rdma_listen function. \n");

	// RDMA_get_request
	ret = rdma_get_request(listen_id, &id);
	if (ret) {
		printf("rdma_get_request %d\n", errno);
		return ret;
		}
	else printf("OK rdma_get_request function \n");

	// RDMA_reg_msgs
	mr = rdma_reg_msgs(id, recv_msg, BUF_SIZE);
	if (!mr) {
		printf("Recv rdma_reg_msgs %d\n", errno);
		return ret;
		}
	else printf("OK recv rdma_reg_msgs function. \n");

	send_mr = rdma_reg_msgs(id, send_msg, BUF_SIZE); 
	if (!send_mr) {
		printf("Send rdma_reg_msgs %d\n", errno);
		return ret;
		}
	else printf("OK send rdma_reg_msgs function. \n");

 
	// Pre post receive: RDMA_post_recv
	ret = rdma_post_recv(id, NULL, recv_msg, BUF_SIZE, mr);
	if (ret) {
		printf("rdma_post_recv %d\n", errno);
		return ret;
		}
	else printf("OK PRE POST rdma_post_recv. \n");

/*
	// Pre post send: RDMA_post_send
	ret = rdma_post_send(id, NULL, send_msg, BUF_SIZE, send_mr, IBV_SEND_INLINE); 
	if (ret) {
		printf("rdma_post_send %d\n", errno);
		return ret;
		}
	else printf("OK PRE POST rdma_post_send. \n");
*/


	// RDMA_accept on server side
	ret = rdma_accept(id, NULL);
	if (ret) {
		printf("rdma_connect %d\n", errno);
		return ret;
		}
	else printf("OK rdma_connect: server accepts connection. \n");

	//---------------------------------------------------------
	//--------- SERVER RDMA: data movement --------------------
	//---------------------------------------------------------
	
	// Loop 
	for (i=0; i < NTX; i++){
		
		// ********** Server is receiving ***************
		
		// RDMA_post_recv
		ret = rdma_post_recv(id, NULL, recv_msg, BUF_SIZE, mr);
		if (ret) {
			printf("rdma_post_recv %d\n", errno);
			return ret;
		}
		//else printf("OK rdma_post_recv. \n");
		
		// RDMA_get_recv_comp
/*
		ret = rdma_get_recv_comp(id, &wc);
		if (ret <= 0) {
			printf("rdma_get_recv_comp %d\n", ret);
			return ret;
		}
*/
	        while (!ibv_poll_cq(id->recv_cq, 1, &wc))
			;
		//else printf("OK rdma_get_recv_comp %d\n", ret);
		

		// ************ Server is sending ****************
		
		// RDMA_post_send
		//ret = rdma_post_send(id, NULL, send_msg, BUF_SIZE, NULL, IBV_SEND_INLINE);//latency code
		ret = rdma_post_send(id, NULL, send_msg, BUF_SIZE, send_mr, IBV_SEND_INLINE); 
		//ret = rdma_post_send(id, NULL, send_msg, BUF_SIZE, send_mr,0); 
		if (ret) {
			printf("rdma_post_send %d\n", errno);
			return ret;
		}
		//else printf("OK rdma_post_send \n");

		// RDMA_get_send_comp
/*
		ret = rdma_get_send_comp(id, &wc);
		if (ret <= 0) {
			printf("rdma_get_send_comp %d\n", ret);
			return ret;
		}
*/
	        while (!ibv_poll_cq(id->send_cq, 1, &wc))
			;
		//else printf("OK rdma_get_send_comp %d\n", ret);

	}// end loop
	
	printf("Loop number = %i \n", i);
	printf("RDMA server closes. \n \n");
	
	rdma_disconnect(id);
	rdma_dereg_mr(mr);
	rdma_dereg_mr(send_mr);
	rdma_destroy_ep(id);
	rdma_destroy_ep(listen_id);
	
}// end asServer

//******************************************************
//********************** CLIENT RDMA *******************
//******************************************************

int asClient(TestMessage &TM){
	
	printf("\nRDMA client machine redigo-02 is starting. \n");
	
	// Information from TCP socket
	int BUF_SIZE=TM.data.message.tbuffer_size;
	printf("BUF_SIZE = %i \n", BUF_SIZE);
	
	int NTX=TM.data.message.loops;
	printf("NTX = %i \n", NTX);
	
	// Variables
	static char *port = "7471";
	static char *server = "10.10.10.1";
	struct rdma_cm_id *listen_id, *id;
	struct ibv_mr *mr;
	struct ibv_mr  *send_mr; 
	char *send_msg=new char[BUF_SIZE];
	char *recv_msg=new char[BUF_SIZE];
	struct rdma_addrinfo hints, *res;
	struct ibv_qp_init_attr attr;
	struct ibv_wc wc;
	int ret; // function return value
	int i; // counter
	time_t start,end;// clock values
        double dif;// delta time
	
	// RDMA_getaddrinfo 
	memset(&hints, 0, sizeof hints);
	hints.ai_port_space = RDMA_PS_TCP;
	ret = rdma_getaddrinfo(server, port, &hints, &res);
	if (ret) {
		printf("rdma_getaddrinfo %d\n", errno);
		return ret;
		}
	else printf("OK rdma_getaddrinfo function. \n");
	
	// RDMA_create_ep
	memset(&attr, 0, sizeof attr);
	attr.cap.max_send_wr = attr.cap.max_recv_wr = 128;
	attr.cap.max_send_sge = attr.cap.max_recv_sge = 1;
	attr.cap.max_inline_data = BUF_SIZE;
	attr.qp_context = id;
	attr.sq_sig_all = 1;
	ret = rdma_create_ep(&id, res, NULL, &attr);
	rdma_freeaddrinfo(res);
	if (ret) {
		printf("rdma_create_ep %d\n", errno);
		return ret;
		}
	else printf("OK rdma_create_ep funtion. \n");

	// RDMA_reg_msgs 
	mr = rdma_reg_msgs(id, recv_msg, BUF_SIZE);
	if (!mr) {
		printf("recv rdma_reg_msgs %d\n", errno);
		return ret;
		}
	else printf("OK recv rdma_reg_msgs function. \n");

	send_mr = rdma_reg_msgs(id, send_msg, BUF_SIZE); 
	if (!send_mr) {
		printf("send rdma_reg_msgs %d\n", errno);
		return ret;
		}
	else printf("OK send rdma_reg_msgs function. \n");

 
	// Pre post receive: RDMA_post_recv
	ret = rdma_post_recv(id, NULL, recv_msg, BUF_SIZE, mr);
  	if (ret) {
  		printf("rdma_post_recv %d\n", errno);
  		return ret;
  		}
  	else printf("OK PRE POST rdma_post_recv. \n");

/*
	// Pre post send: RDMA_post_send
	ret = rdma_post_send(id, NULL, send_msg, BUF_SIZE, send_mr, IBV_SEND_INLINE); 
	if (ret) {
		printf("rdma_post_send %d\n", errno);
		return ret;
		}
	else printf("OK PRE POST rdma_post_send. \n");
*/

	// RDMA_connect on client side
  	ret = rdma_connect(id, NULL);
  	if (ret) {
  		printf("rdma_connect %d\n", errno);
  		return ret;
  		}
  	else printf("OK rdma_connect: client is connected. \n");
  	
  	//----------------------------------------------------------
	//--------- Clock starts -------------------------------------
	//----------------------------------------------------------
        time(&start);
        
        //----------------------------------------------------------
        //--------- CLIENT RDMA: data movement --------------------
        //----------------------------------------------------------
        // Loop
  	for(i = 0; i < NTX; i++){
  		// RDMA_post_recv
  		ret = rdma_post_recv(id, NULL, recv_msg, BUF_SIZE, mr);
  		if (ret) {
  			printf("rdma_post_recv %d\n", errno);
  			return ret;
  			}
  		
  		//*************** Client is sending ***************************
  		
  		// RDMA_post_send
  		//ret = rdma_post_send(id, NULL, send_msg, BUF_SIZE, NULL, IBV_SEND_INLINE);// latency code
		ret = rdma_post_send(id, NULL, send_msg, BUF_SIZE, send_mr, IBV_SEND_INLINE);
		//ret = rdma_post_send(id, NULL, send_msg, BUF_SIZE, send_mr,0);
  		if (ret) {
  			printf("rdma_post_send %d\n", errno);
  			return ret;
  			}
  		//else printf("OK rdma_post_send \n");

  		// RDMA_get_send_comp
/*
  		ret = rdma_get_send_comp(id, &wc);
		if (ret <= 0) {
			printf("rdma_get_send_comp %d\n", ret);
			return ret;
		}
*/
	        while (!ibv_poll_cq(id->send_cq, 1, &wc))
			;
		//else printf("OK rdma_get_send_comp %d\n", ret);
		
		
  		//********************** Client is receiving *******************
  		
  		//else printf("OK rdma_post_recv \n");
  		
  		// RDMA_get_recv_comp
/*
  		ret = rdma_get_recv_comp(id, &wc);
  		if (ret <= 0) {
  			printf("rdma_get_recv_comp %d\n", ret);
  			return ret;
  		}
*/
	        while (!ibv_poll_cq(id->recv_cq, 1, &wc))
			;
  		//else printf("OK rdma_get_recv_comp \n");
  		
  	}//end loop
 	
  	//----------------------------------------------------------
	//--------- Clock stops -------------------------------------
	//----------------------------------------------------------
  	time(&end);
  	
  	printf("Loop number = %i\n", i);
	printf("RDMA client closes. \n \n");
  	
  	rdma_disconnect(id);
	rdma_dereg_mr(mr);
	rdma_dereg_mr(send_mr); 
	rdma_destroy_ep(id);

	
	//------------------------------------------------------------------
	//------- Output txt file with data --------------------------------
	//------------------------------------------------------------------
	
	ofstream OutFile("Test_Speed.txt");
	// Open outfile test
	if (! OutFile){
		cout << "Error opening output txt file." << endl;
		return -1;
	}
		
	// Calculation and other variables
	dif = difftime(end,start); //delta time
	
	long double NTXld = (long double) NTX;
	long double BUF_SIZEld = (long double) BUF_SIZE;
	long double dif_ld = (long double) dif;
	long double speed = 2*(NTXld*BUF_SIZEld)/(dif_ld);
	long double latency = dif_ld/(2*NTXld);

	// Use setw(), setprecision(), scientific options if it is necessary
	cout.setf(ios::left);       // set option 'left justify output'

	// Outfile format
	OutFile << "#transfer|buffer_size(bytes)|total_time(s)|speed(bytes/s)|latency(s)| \n";
	OutFile << setw(9) << NTX << "|";
	OutFile << setw(18) << BUF_SIZE << "|";
	OutFile << setw(13) << dif << "|";
	OutFile << setw(14) << speed << "|";
	OutFile << setw(10) << latency << "|";
	OutFile << endl;
	
}// end asClient










//*******************************************************
//************* (fake) Main program *********************
//*******************************************************
// It does not work!
/*
int main(int narg, char **argv) {
  if (narg > 1)
    return asServer();
  else
    return asClient();
};
*/



------=_Part_1540_5520452.1278938261320--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
