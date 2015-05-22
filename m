From: "Davis, Arlin R" <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 4/5] dapl ucm: add device support for new port space hash
 table
Date: Fri, 22 May 2015 21:45:51 +0000
Message-ID: <54347E5A035A054EAE9D05927FB467F977D76BB9@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Arlin Davis <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Allocate port space hash table during device open when creating CM services. 
Default settings are set to 4K entry chunks and 256K total port slots.
Add environment variables for adjustments

DAPL_UCM_ENTRY_BITS 11
DAPL_UCM_ARRAY_BITS 18

Add debug output for create CM service errors

Signed-off-by: Arlin Davis <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 dapl/openib_ucm/device.c |  153 +++++++++++++++++++++++++++++++++++-----------
 1 files changed, 117 insertions(+), 36 deletions(-)

diff --git a/dapl/openib_ucm/device.c b/dapl/openib_ucm/device.c index b9abbf0..94ce812 100644
--- a/dapl/openib_ucm/device.c
+++ b/dapl/openib_ucm/device.c
@@ -311,6 +311,9 @@ DAT_RETURN dapls_ib_open_hca(IN IB_HCA_NAME hca_name,
 	if ((dapl_os_lock_init(&hca_ptr->ib_trans.plock)) != DAT_SUCCESS)
 		goto bail;
 
+	if ((dapl_os_lock_init(&hca_ptr->ib_trans.ilock)) != DAT_SUCCESS)
+		goto bail;
+
 	/* EVD events without direct CQ channels, CNO support */
 	hca_ptr->ib_trans.ib_cq =
 	    ibv_create_comp_channel(hca_ptr->ib_hca_handle);
@@ -367,11 +370,11 @@ done:
 	       &hca_ptr->ib_trans.addr,
 	       sizeof(union dcm_addr));
 
-	dapl_dbg_log(DAPL_DBG_TYPE_UTIL,
+	dapl_log(DAPL_DBG_TYPE_UTIL,
 		 "%s open: dev %s port %d, GID %s, LID %x qpn %x sl %d\n",
 		 PROVIDER_NAME, hca_name, hca_ptr->port_num,
 		 inet_ntop(AF_INET6, &hca_ptr->ib_trans.addr.ib.gid,
-			   gid_str, sizeof(gid_str)),
+			  gid_str, sizeof(gid_str)),
 		 ntohs(ucm_ia->ib.lid), ntohl(ucm_ia->ib.qpn),
 		 ucm_ia->ib.sl, ucm_ia->ib.qp_type);
 
@@ -428,6 +431,7 @@ DAT_RETURN dapls_ib_close_hca(IN DAPL_HCA * hca_ptr)
 
 	dapl_os_lock_destroy(&hca_ptr->ib_trans.lock);
 	dapl_os_lock_destroy(&hca_ptr->ib_trans.llock);
+	dapl_os_lock_destroy(&hca_ptr->ib_trans.ilock);
 	destroy_os_signal(hca_ptr);
 	ucm_service_destroy(hca_ptr);
 done:
@@ -454,7 +458,7 @@ done:
 static void ucm_service_destroy(IN DAPL_HCA *hca)  {
 	ib_hca_transport_t *tp = &hca->ib_trans;
-	int msg_size = sizeof(ib_cm_msg_t);
+	int i, msg_size = sizeof(ib_cm_msg_t);
 
 	if (tp->mr_sbuf)
 		ibv_dereg_mr(tp->mr_sbuf);
@@ -475,26 +479,32 @@ static void ucm_service_destroy(IN DAPL_HCA *hca)
 		ibv_destroy_comp_channel(tp->rch);
 
  	if (tp->ah) {
-		int i;
-
-		for (i = 0;i < 0xffff; i++) {
+		for (i=0; i<DCM_AH_SPACE; i++) {
 			if (tp->ah[i])
 				ibv_destroy_ah(tp->ah[i]);
 		}
-		dapl_os_free(tp->ah, (sizeof(*tp->ah) * 0xffff));
+		dapl_os_free(tp->ah, (sizeof(*tp->ah) * DCM_AH_SPACE));
 	}
 
 	if (tp->pd)
 		ibv_dealloc_pd(tp->pd);
 
 	if (tp->sid)
-		dapl_os_free(tp->sid, (sizeof(*tp->sid) * 0xffff));
+		dapl_os_free(tp->sid, UCM_SID_SPACE/UCM_SID_ENTRY);
 
 	if (tp->rbuf)
 		dapl_os_free(tp->rbuf, (msg_size * tp->qpe));
 
 	if (tp->sbuf)
 		dapl_os_free(tp->sbuf, (msg_size * tp->qpe));
+
+	if (tp->cm_idxr) {
+		for (i=0; i<=tp->cm_idxr_cur; i++) {
+			dapl_os_free(tp->cm_idxr[i],
+				     UCM_ENTRY_SIZE(tp->cm_entry_bits));
+			tp->cm_idxr[i] = 0;
+		}
+	}
 }
 
 static int ucm_service_create(IN DAPL_HCA *hca) @@ -503,7 +513,7 @@ static int ucm_service_create(IN DAPL_HCA *hca)
 	ib_hca_transport_t *tp = &hca->ib_trans;
 	struct ibv_recv_wr recv_wr, *recv_err;
         struct ibv_sge sge;
-	int i, mlen = sizeof(ib_cm_msg_t);
+	int i, array_sz, entry_sz, mlen = sizeof(ib_cm_msg_t);
 	int hlen = sizeof(struct ibv_grh); /* hdr included with UD recv */
 	char *rbuf;
 
@@ -518,31 +528,78 @@ static int ucm_service_create(IN DAPL_HCA *hca)
 	tp->dreq_cnt = dapl_os_get_env_val("DAPL_UCM_DREQ_RETRY", DCM_DREQ_CNT);
 	tp->drep_time = dapl_os_get_env_val("DAPL_UCM_DREP_TIME", DCM_DREP_TIME);
 	tp->cm_timer = dapl_os_get_env_val("DAPL_UCM_TIMER", DCM_CM_TIMER);
+	/* default = 11-bit, 2KB entries; 18 bit, 256KB total */
+	tp->cm_entry_bits = dapl_os_get_env_val("DAPL_UCM_ENTRY_BITS", UCM_ENTRY_BITS);
+	tp->cm_array_bits = DAPL_MAX(dapl_os_get_env_val("DAPL_UCM_ARRAY_BITS", UCM_ARRAY_BITS), tp->cm_entry_bits);
+	array_sz = UCM_ARRAY_SIZE(tp->cm_array_bits, tp->cm_entry_bits);
+	entry_sz = UCM_ENTRY_SIZE(tp->cm_entry_bits);
+
 	tp->pd = ibv_alloc_pd(hca->ib_hca_handle);
-        if (!tp->pd) 
-                goto bail;
+        if (!tp->pd) {
+		dapl_log(DAPL_DBG_TYPE_ERR,
+			 "UCM: CM service: ERR ibv_pd (%s)\n",
+			 strerror(errno));
+		goto bail;
+        }
         
-        dapl_log(DAPL_DBG_TYPE_UTIL,
-                 " UCM: CM service - pd %p ctx %p "
-        	 " Timers(ms): req %d rtu %d wait %d\n",
-                 tp->pd, tp->pd->context, tp->rep_time,
-                 tp->rtu_time, tp->wait_time);
-
-    	tp->rch = ibv_create_comp_channel(hca->ib_hca_handle);
-	if (!tp->rch) 
+        dapl_log(DAPL_DBG_TYPE_CM,
+                 "CM (%d+%d)- pd %p Timers(s): req %d rtu %d wait %d -"
+        	 " idx(%d,%d): Array %d Entry %d = %d\n",
+                 hlen, mlen, tp->pd, tp->rep_time/1000, tp->rtu_time/1000,
+                 tp->wait_time/1000, tp->cm_array_bits,
+                 tp->cm_entry_bits, array_sz, entry_sz,
+                 array_sz * entry_sz);
+
+        /* default == 2K idx size, grow to 256K total CM slots  */
+        tp->cm_idxr = dapl_os_alloc(sizeof(void*) * array_sz);
+        if (!tp->cm_idxr) {
+        	dapl_log(DAPL_DBG_TYPE_ERR,
+        		 "UCM: CM service: ERR (%s) idx_array alloc %d\n",
+        		 strerror(errno), sizeof(void*) * array_sz);
+        	goto bail;
+        }
+        (void)dapl_os_memzero(tp->cm_idxr, sizeof(void*) * array_sz);
+
+        /* allocate first index array for cm entries, 2K by default */
+        tp->cm_idxr[0] = dapl_os_alloc(sizeof(void*) * entry_sz);
+        if (!tp->cm_idxr[0]) {
+        	dapl_log(DAPL_DBG_TYPE_ERR,
+        		 "UCM: CM service: ERR (%s) idx_entry alloc %d\n",
+        		 strerror(errno), sizeof(void*) * entry_sz);
+        	goto bail;
+        }
+        (void)dapl_os_memzero(tp->cm_idxr[0], sizeof(void*) * 
+ entry_sz);
+
+        tp->rch = ibv_create_comp_channel(hca->ib_hca_handle);
+	if (!tp->rch) {
+		dapl_log(DAPL_DBG_TYPE_ERR,
+			 "UCM: CM service: ERR ibv_comp_channel (%s)\n",
+			 strerror(errno));
 		goto bail;
+	}
 	dapls_config_comp_channel(tp->rch);
 
 	tp->scq = ibv_create_cq(hca->ib_hca_handle, tp->cqe, hca, NULL, 0);
-	if (!tp->scq) 
+	if (!tp->scq) {
+		dapl_log(DAPL_DBG_TYPE_ERR,
+			 "UCM: CM service: ERR ibv_cq_s (%s)\n",
+			 strerror(errno));
 		goto bail;
-        
+	}
 	tp->rcq = ibv_create_cq(hca->ib_hca_handle, tp->cqe, hca, tp->rch, 0);
-	if (!tp->rcq) 
+	if (!tp->rcq) {
+		dapl_log(DAPL_DBG_TYPE_ERR,
+			 "UCM: CM service: ERR ibv_cq_r (%s)\n",
+			 strerror(errno));
 		goto bail;
+	}
 
-	if(ibv_req_notify_cq(tp->rcq, 0))
-		goto bail; 
+	if(ibv_req_notify_cq(tp->rcq, 0)) {
+		dapl_log(DAPL_DBG_TYPE_ERR,
+			 "UCM: CM service: ERR ibv_notify (%s)\n",
+			 strerror(errno));
+		goto bail;
+	}
  
 	dapl_os_memzero((void *)&qp_create, sizeof(qp_create));
 	qp_create.qp_type = IBV_QPT_UD;
@@ -554,39 +611,59 @@ static int ucm_service_create(IN DAPL_HCA *hca)
 	qp_create.qp_context = (void *)hca;
 
 	tp->qp = ibv_create_qp(tp->pd, &qp_create);
-	if (!tp->qp) 
-                goto bail;
+	if (!tp->qp) {
+		dapl_log(DAPL_DBG_TYPE_ERR,
+			 "UCM: CM service: ERR ibv_qp (%s)\n",
+			 strerror(errno));
+		goto bail;
+	}
 
-	tp->ah = (ib_ah_handle_t*) dapl_os_alloc(sizeof(ib_ah_handle_t) * 0xffff);
-	tp->sid = (uint8_t*) dapl_os_alloc(sizeof(uint8_t) * 0xffff);
+	tp->ah = (ib_ah_handle_t*) dapl_os_alloc(sizeof(ib_ah_handle_t) * DCM_AH_SPACE);
+	tp->sid = (uint8_t*) dapl_os_alloc(UCM_SID_SPACE/UCM_SID_ENTRY);
 	tp->rbuf = (void*) dapl_os_alloc((mlen + hlen) * tp->qpe);
 	tp->sbuf = (void*) dapl_os_alloc(mlen * tp->qpe);
 	tp->s_hd = tp->s_tl = 0;
 
-	if (!tp->ah || !tp->rbuf || !tp->sbuf || !tp->sid)
+	if (!tp->ah || !tp->rbuf || !tp->sbuf) {
+		dapl_log(DAPL_DBG_TYPE_ERR,
+			 "UCM: CM service: ERR malloc ah,bufs(%s)\n",
+			 strerror(errno));
 		goto bail;
+	}
 
-	(void)dapl_os_memzero(tp->ah, (sizeof(ib_ah_handle_t) * 0xffff));
-	(void)dapl_os_memzero(tp->sid, (sizeof(uint8_t) * 0xffff));
-	tp->sid[0] = 1; /* resv slot 0, 0 == no ports available */
+	(void)dapl_os_memzero(tp->ah, (sizeof(ib_ah_handle_t) * DCM_AH_SPACE));
+	(void)dapl_os_memzero(tp->sid, UCM_SID_SPACE/UCM_SID_ENTRY);
+	tp->sid[0] = 0x1; /* resv slot 0 */
 	(void)dapl_os_memzero(tp->rbuf, ((mlen + hlen) * tp->qpe));
 	(void)dapl_os_memzero(tp->sbuf, (mlen * tp->qpe));
 
 	tp->mr_sbuf = ibv_reg_mr(tp->pd, tp->sbuf, 
 				 (mlen * tp->qpe),
 				 IBV_ACCESS_LOCAL_WRITE);
-	if (!tp->mr_sbuf)
+	if (!tp->mr_sbuf) {
+		dapl_log(DAPL_DBG_TYPE_ERR,
+			 "UCM: CM service: ERR ibv_mr sbuf (%s)\n",
+			 strerror(errno));
 		goto bail;
+	}
 
 	tp->mr_rbuf = ibv_reg_mr(tp->pd, tp->rbuf, 
 				 ((mlen + hlen) * tp->qpe),
 				 IBV_ACCESS_LOCAL_WRITE);
-	if (!tp->mr_rbuf)
+	if (!tp->mr_rbuf) {
+		dapl_log(DAPL_DBG_TYPE_ERR,
+			 "UCM: CM service: ERR ibv_mr rbuf (%s)\n",
+			 strerror(errno));
 		goto bail;
+	}
 	
 	/* modify UD QP: init, rtr, rts */
-	if ((dapls_modify_qp_ud(hca, tp->qp)) != DAT_SUCCESS)
+	if ((dapls_modify_qp_ud(hca, tp->qp)) != DAT_SUCCESS) {
+		dapl_log(DAPL_DBG_TYPE_ERR,
+			 "UCM: CM service: ERR modify_qp_ud (%s)\n",
+			 strerror(errno));
 		goto bail;
+	}
 
 	/* post receive buffers, setup head, tail pointers */
 	recv_wr.next = NULL;
@@ -599,8 +676,12 @@ static int ucm_service_create(IN DAPL_HCA *hca)
 	for (i = 0; i < tp->qpe; i++) {
 		recv_wr.wr_id = (uintptr_t) (rbuf + hlen);
 		sge.addr = (uintptr_t) rbuf;
-		if (ibv_post_recv(tp->qp, &recv_wr, &recv_err))
+		if (ibv_post_recv(tp->qp, &recv_wr, &recv_err)) {
+			dapl_log(DAPL_DBG_TYPE_ERR,
+				 "UCM: CM service: ERR ibv_post_rcv (%s)\n",
+				 strerror(errno));
 			goto bail;
+		}
 		rbuf += sge.length;
 	}
 
--
1.7.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
