From: "Coulter, Susan K" <skc-YOWKrPYUwWM@public.gmane.org>
Subject: partitions / ib_read_bw
Date: Fri, 21 Jun 2013 21:48:31 +0000
Message-ID: <AB9234BD-66C3-4D8E-93CA-5AF8D26818AB@lanl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Content-ID: <910178C59F69F84083C65395A57D339D-r1tBtT6b1V2fRvmTrFJqzg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


One of my test clusters is running with multiple partitions.
The partitions look correct (using "smpquery pkey") and the path records look correct (using "saquery pr").

I'd like a simple user-level test to validate who is allowed to talk to who; and hoped to use ib_read_bw.
Alas, ib_read_bw does not honor partitions.

Below is a patch I wrote to try and add pkey support to ib_read_bw.  No joy.

The server shows it is populating ibv_qp_attr with the pkey(s) of any full partition it is a member of, 
but the client does not get that same pkey in ibv_wc.

What am I missing?


--- read_bw.c.orig	2013-01-29 12:27:20.000000000 -0700
+++ read_bw.c	2013-06-07 17:15:33.931392279 -0600
@@ -37,11 +37,13 @@
 #  include <config.h>
 #endif /* HAVE_CONFIG_H */
 
+#include <errno.h>
+#include <inttypes.h>
+#include <malloc.h>
 #include <stdio.h>
 #include <stdlib.h>
-#include <unistd.h>
 #include <string.h>
-#include <malloc.h>
+#include <unistd.h>
 
 #include "get_clock.h"
 #include "perftest_resources.h"
@@ -53,14 +55,42 @@
 cycles_t	*tposted;
 cycles_t	*tcompleted;
 
+struct full_pkey_entry {
+	int	idx;
+	struct	full_pkey_entry *next;
+};
+static struct full_pkey_entry *fpk_head;
+
 /****************************************************************************** 
  *
  ******************************************************************************/
 static int pp_connect_ctx(struct pingpong_context *ctx,int my_psn,int my_out_reads,
 						  struct pingpong_dest *dest,struct perftest_parameters *user_parm)
 {
+	struct full_pkey_entry *p;
 	struct ibv_qp_attr attr;
 	memset(&attr, 0, sizeof attr);
+	
+	attr.pkey_index = 0;
+	attr.alt_pkey_index = 0;
+	p = fpk_head;
+	while (p != NULL) {
+		if (attr.pkey_index == 0) 
+			attr.pkey_index = p->idx;		
+		else if (attr.alt_pkey_index == 0)
+			attr.alt_pkey_index = p->idx;
+		p=p->next;
+        }
+	fprintf(stdout,"skc: pkey_index is %i\n", attr.pkey_index);
+	fprintf(stdout,"skc: alt_pkey_index is %i\n", attr.alt_pkey_index);
+
+/*  check pkey value    */
+
+        ret = ibv_query_pkey(ctx, user_parm->ib_port, attr.pkey_index, pkey_n);
+        if (!ret) {
+        	pkey = ntohs(*pkey_n);
+		fprintf(stdout,"skc: pkey_index value is %u\n", pkey);
+        }        
 
 	attr.qp_state 		= IBV_QPS_RTR;
 	attr.path_mtu       = user_parm->curr_mtu;
@@ -166,6 +196,8 @@
 
 	ALLOCATE(wc , struct ibv_wc , DEF_WC_SIZE);
 
+	fprintf(stdout,"skc: ibv_wc allocated\n");
+
 	list.addr   = (uintptr_t)ctx->buf;
 	list.length = user_param->size;
 	list.lkey   = ctx->mr->lkey;
@@ -219,6 +251,8 @@
 				if (ne > 0) {
 					for (i = 0; i < ne; i++) {
 
+						fprintf(stdout,"skc: completion queue %i polled, pkey is %i\n", i, wc[i].pkey_index);
+
 						if (wc[i].status != IBV_WC_SUCCESS) 
 							NOTIFY_COMP_ERROR_SEND(wc[i],scnt,ccnt);
 
@@ -243,12 +277,48 @@
 	return 0;
 }
 
+int check_pkey(struct ibv_context *context, struct perftest_parameters *parms) {
+
+	int idx,ret;
+	uint16_t *pkey_n,pkey;
+	struct ibv_port_attr pattr;
+	struct full_pkey_entry *fpk, *p;
+	
+	ret = ibv_query_port(context, parms->ib_port, &pattr);
+	
+	if(!ret) {
+                pkey_n = malloc(sizeof *pkey_n); 
+		for (idx=0; idx < pattr.pkey_tbl_len; idx++) {
+			ret = ibv_query_pkey(context, parms->ib_port, idx, pkey_n);
+			if (!ret) {
+				pkey = ntohs(*pkey_n);
+				if (pkey > 32767) {
+					fprintf(stdout,"skc: full member pkey is %u at index %i\n", pkey, idx);
+                                	fpk = (struct full_pkey_entry *) malloc(sizeof(struct full_pkey_entry));
+					fpk->idx = idx;
+					fpk->next = NULL;
+   					if (fpk_head == NULL) {
+						fpk_head = fpk;
+					} else {
+						for (p=fpk_head; p->next != NULL; p=p->next);
+						p->next = fpk;
+					}
+				}
+			} else {
+				ret = EPERM;
+			}	
+		}
+	}
+	return ret;
+}
+
 /****************************************************************************** 
  *
  ******************************************************************************/
 int main(int argc, char *argv[]) {
 
 	int                        i = 0;
+	int                        ret = 0;
 	struct ibv_device		   *ib_dev = NULL;
 	struct pingpong_context    ctx;
 	struct pingpong_dest       my_dest,rem_dest;
@@ -280,6 +350,12 @@
 		return 1;
 	}
 
+	ret = check_pkey(ctx.context, &user_param);
+        if (ret) {
+		fprintf(stderr, "PKey stuff borked\n");
+		return FAILURE;
+	}
+
 	// See if MTU and link type are valid and supported.
 	if (check_link_and_mtu(ctx.context,&user_param)) {
 		fprintf(stderr, " Couldn't get context for the device\n");
@@ -362,7 +438,7 @@
 	if (ctx_hand_shake(&user_comm,&my_dest,&rem_dest)) {
         fprintf(stderr,"Failed to exchange date between server and clients\n");
         return 1;    
-    }
+    	}
      
 	// For half duplex tests, server just waits for client to exit 
 	if (user_param.machine == SERVER && !user_param.duplex) {
@@ -390,6 +466,8 @@
 	ALLOCATE(tposted , cycles_t , user_param.iters);
 	ALLOCATE(tcompleted , cycles_t , user_param.iters);
 
+	fprintf(stdout,"skc: ready to run iterations\n");
+
 	if (user_param.all == ON) {
 
 		for (i = 1; i < 24 ; ++i) {
====================================

Susan Coulter
HPC-3 Network/Infrastructure
505-667-8425
Increase the Peace...
An eye for an eye leaves the whole world blind
====================================

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
