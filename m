From: Andrea Gozzelino <Andrea.Gozzelino-PK20h7lG/Rc1GQ1Ptb7lUw@public.gmane.org>
Subject: use rdma_post_sendv
Date: Tue, 23 Nov 2010 09:09:14 +0100 (CET)
Message-ID: <851749.1290499754034.SLOX.WebMail.wwwrun@imap.lnl.infn.it>
References: <24966_1290443966_oAMGdKar029662_4771797.1290443946539.SLOX.WebMail.wwwrun@imap.lnl.infn.it>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_Part_10358_3982480.1290499754032"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <24966_1290443966_oAMGdKar029662_4771797.1290443946539.SLOX.WebMail.wwwrun-XDIR3SKYeFbgKi2NxijLtw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

------=_Part_10358_3982480.1290499754032
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi,
 
I have some problem in using function rdma_post_sendv.
I find errno=22, so the client does not run.

I use the code attached.

Could you please explain how it is build a scatter gather list and how
an element could be added?
 
Thanks a lot,
Andrea

 
Andrea Gozzelino

INFN - Laboratori Nazionali di Legnaro	(LNL)
Viale dell'Universita' 2 -I-35020 - Legnaro (PD)- ITALIA
Office: E-101
Tel: +39 049 8068346
Fax: +39 049 641925
Mail: andrea.gozzelino-PK20h7lG/Rc1GQ1Ptb7lUw@public.gmane.org
Cell: +39 3488245552				
		

------=_Part_10358_3982480.1290499754032
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=proof_RDMA.cpp

/*
------------------------------------------------------------------
Program: RDMA Latency test 
Program detail: RDMA Latency test with buffer size <= 64 bytes
Use: REDIGO project --> RDMA performance test with vector list
Authors: Damiano Bortolato - Andrea Gozzelino
Structure: INFN LNL @ Legnaro (Italy)
Date: November - December 2010
Compile:  g++ -o 2DEV_RDMA_Latency 2DEV_latency_RDMA.cpp 2DEV_socket_RDMA.cpp 2DEV_test_RDMA.cpp -lrdmacm
Library: use librdmacm version 1.0.12 by Sean Hefty 
Note: help from Chien Tin Tung (Intel) and Sean Hefty (Intel)
------------------------------------------------------------------
*/

/*
IBV _SEND_INLINE
The flag IBV_SEND_INLINE describe to the low level driver how the data will be 
read from the memory buffer (the driver will read the data and give it to the 
HCA or the HCA will fetch the data from the memory using the gather list).
The data on the wire for inline messages looks the same like data which 
was fetched by the HCA.
The receive side don't have any feature which can work 
with memory buffer without any registration.

Unless the send request is using inline data, the message buffers must have been registered
before being posted, and the buffers must remain registered until the send completes.
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
	struct ibv_mr *mr,*mr1;
	char *send_msg=new char[BUF_SIZE];
	char *recv_msg=new char[BUF_SIZE];
	struct rdma_addrinfo hints, *res;
	struct ibv_qp_init_attr attr;
	struct ibv_wc wc;
	int ret;// function return value
	int i; // loop counter

	struct ibv_sge SGLr;
	struct ibv_sge SGLs;
	int SGE;

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
		printf("rdma_reg_msgs rec%d\n", errno);
		return ret;
		}
	else printf("OK rdma_reg_msgs function. Created rec mr %p \n", mr);

	mr1 = rdma_reg_msgs(id, send_msg, BUF_SIZE);
	if (!mr) {
		printf("rdma_reg_msgs send %d\n", errno);
		return ret;
		}
	else printf("OK rdma_reg_msgs function. Created send mr1 %p \n", mr1);

//NEW
	SGE = 3;
	SGLr.addr = (uintptr_t) recv_msg; 	          // Start address of the local memory buffer
	SGLr.length = BUF_SIZE*SGE;                       // Length of the buffer
	SGLr.lkey  = mr->lkey;                            // Key of the local Memory Region

	SGLs.addr = (uintptr_t) send_msg; 	          // Start address of the local memory buffer
	SGLs.length = BUF_SIZE*SGE;                       // Length of the buffer
	SGLs.lkey = mr1->lkey;                            // Key of the local Memory Region

	// Pre post receive vectored: RDMA_post_recvv
	ret = rdma_post_recvv(id, recv_msg, &SGLr, SGE);
	if (ret) {
		printf("rdma_post_recvv %d\n", errno);
		return ret;
		}
	else printf("OK PRE POST rdma_post_recvv. Created post receive vector. \n");
 
	// Pre post receive: RDMA_post_recv
	ret = rdma_post_recv(id, NULL, recv_msg, BUF_SIZE, mr);
	if (ret) {
		printf("rdma_post_recv %d\n", errno);
		return ret;
		}
	else printf("OK PRE POST rdma_post_recv. \n");

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
	
	for(i=0;i<SGE;i++){

	// ********** Server is receiving ***************
	ret = rdma_post_recvv(id, recv_msg, &SGLr, SGE);
	if (ret) {
		printf("rdma_post_recvv %d\n", errno);
		return ret;
	}
	else printf("OK rdma_post_recvv. \n");

	// RDMA_get_recv_comp
	ret = rdma_get_recv_comp(id, &wc);
	if (ret <= 0) {
		printf("rdma_get_recv_comp %d\n", ret);
		return ret;
	}
	else printf("OK rdma_get_recv_comp %d\n", ret);

	//while (!ibv_poll_cq(id->recv_cq, 1, &wc));
		
		
	// ************ Server is sending ****************
	//ret = rdma_post_send(id, NULL, send_msg, BUF_SIZE, NULL, IBV_SEND_INLINE);	
	ret = rdma_post_sendv(id, send_msg, &SGLs, SGE, IBV_SEND_INLINE);
	if (ret) {
		printf("rdma_post_sendv %d\n", errno);
		return ret;
	}
	else printf("OK rdma_post_sendv. \n", ret);

	// RDMA_get_send_comp
	ret = rdma_get_send_comp(id, &wc);
	if (ret <= 0) {
		printf("rdma_get_send_comp %d\n", ret);
		return ret;
	}
	else printf("OK rdma_get_send_comp %d\n", ret);

	//while (!ibv_poll_cq(id->send_cq, 1, &wc));

	}	
	
	printf("OK RDMA server closes. \n \n");
	
	rdma_disconnect(id);
	rdma_dereg_mr(mr);
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
	struct ibv_mr *mr,*mr1;
	char *send_msg=new char[BUF_SIZE];
	char *recv_msg=new char[BUF_SIZE];
	struct rdma_addrinfo hints, *res;
	struct ibv_qp_init_attr attr;
	struct ibv_wc wc;
	int ret; // function return value
	int i; // counter

	struct ibv_sge SGLr;
	struct ibv_sge SGLs;
	int SGE;

	time_t start,end;// clock values
        double dif;// delta time
        static clock_t st_time;
        static clock_t en_time;
        static struct tms st_cpu;
        static struct tms en_cpu;
	
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
		printf("rdma_reg_msgs %d\n", errno);
		return ret;
		}
	else printf("OK rdma_reg_msgs function. Created mr %p \n", mr);

	mr1 = rdma_reg_msgs(id, send_msg, BUF_SIZE);
	if (!mr) {
		printf("rdma_reg_msgs send%d\n", errno);
		return ret;
		}
	else printf("OK rdma_reg_msgs function. Created send mr1 %p \n", mr1);

//NEW 
	SGE = 3;
	SGLr.addr   = (uintptr_t) recv_msg; 	           // Start address of the local memory buffer
	SGLr.length = BUF_SIZE*SGE;                            // Length of the buffer
	SGLr.lkey   = mr->lkey;                            // Key of the local Memory Region

	SGLs.addr  = (uintptr_t) send_msg; 	           // Start address of the local memory buffer
	SGLs.length = BUF_SIZE*SGE;                            // Length of the buffer
	SGLs.lkey   = mr1->lkey;                            // Key of the local Memory Region

	
 
	// Pre post receive vectored: RDMA_post_recvv
	ret = rdma_post_recvv(id, recv_msg, &SGLr, SGE);
	if (ret) {
		printf("rdma_post_recvv %d\n", errno);
		return ret;
		}
	else printf("OK PRE POST rdma_post_recvv. Created post receive vector. \n");

	// Pre post receive: RDMA_post_recv
	ret = rdma_post_recv(id, NULL, recv_msg, BUF_SIZE, mr);
  	if (ret) {
  		printf("rdma_post_recv %d\n", errno);
  		return ret;
  		}
  	else printf("OK PRE POST rdma_post_recv. \n");

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
        st_time= times(&st_cpu);
        
        //----------------------------------------------------------
        //--------- CLIENT RDMA: data movement --------------------
        //----------------------------------------------------------
        for(i=0;i<SGE;i++){
  	//*************** Client is sending ***************************
  	//ret = rdma_post_send(id, NULL, send_msg, BUF_SIZE, NULL, IBV_SEND_INLINE);	
  	ret = rdma_post_sendv(id, send_msg, &SGLs, SGE, IBV_SEND_INLINE);
	if (ret) {
  		printf("rdma_post_sendv %d\n", errno);
  		return ret;
  	}
  	else printf("OK rdma_post_sendv. \n");

  	// RDMA_get_send_comp
  	ret = rdma_get_send_comp(id, &wc);
	if (ret <= 0) {
		printf("rdma_get_send_comp %d\n", ret);
		return ret;
	}
	else printf("OK rdma_get_send_comp %d\n", ret);

	//while (!ibv_poll_cq(id->send_cq, 1, &wc));	
		
  	//********************** Client is receiving *******************
	
	ret = rdma_post_recvv(id, recv_msg, &SGLr, SGE);
  	if (ret) {
  		printf("rdma_post_recvv %d\n", errno);
  		return ret;
  	}
  	else printf("OK rdma_post_recvv. \n");
  	
  	// RDMA_get_recv_comp
  	ret = rdma_get_recv_comp(id, &wc);
  	if (ret <= 0) {
  		printf("rdma_get_recv_comp %d\n", ret);
  		return ret;
  	}
	else printf("OK rdma_get_recv_comp %d \n", ret);

	//while (!ibv_poll_cq(id->recv_cq, 1, &wc));
  	}	
 	
  	//----------------------------------------------------------
	//--------- Clock stops -------------------------------------
	//----------------------------------------------------------
  	time(&end);
  	en_time= times(&en_cpu);
  	
	printf("OK RDMA client closes. \n \n");
  	
  	rdma_disconnect(id);
	rdma_dereg_mr(mr);
	rdma_destroy_ep(id);

	
	//------------------------------------------------------------------
	//------- Output txt file with data --------------------------------
	//------------------------------------------------------------------
	
	ofstream OutFile("Test_Latency.txt");
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
	float cpu = 100* (en_cpu.tms_utime+en_cpu.tms_stime)/(en_time-st_time+10);// ERRORE DI CALCOLO

	// Use setw(), setprecision(), scientific options if it is necessary
	cout.setf(ios::left);       // set option 'left justify output'

	// Outfile format
	OutFile << "#transfer|buffer_size(bytes)|total_time(s)|speed(bytes/s)|latency(s)|CPU(%)| \n";
	OutFile << setw(9) << NTX << "|";
	OutFile << setw(18) << BUF_SIZE << "|";
	OutFile << setw(13) << dif << "|";
	OutFile << setw(14) << speed << "|";
	OutFile << setw(10) << latency << "|";
	OutFile << setw(6) << cpu << "|";
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



------=_Part_10358_3982480.1290499754032--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
