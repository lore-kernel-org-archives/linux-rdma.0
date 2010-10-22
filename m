From: "Davis, Arlin R" <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] DAPL v2.0: ucm: allow configuration of CM burst (signal)
 threshold on posting
Date: Fri, 22 Oct 2010 13:15:04 -0700
Message-ID: <E3280858FA94444CA49D2BA02341C983011BA209E5@orsmsx506.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org" <ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Add new DAPL_UCM_TX_BURST environment variable, default=50.
Every 50 posted send messages will signal event which
is 10 percent bursting of default 500 message limit.

Signed-off-by: Arlin Davis <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 dapl/openib_common/dapl_ib_common.h |    1 +
 dapl/openib_ucm/cm.c                |   27 ++++++++++++++++++---------
 dapl/openib_ucm/dapl_ib_util.h      |    1 +
 dapl/openib_ucm/device.c            |    2 ++
 4 files changed, 22 insertions(+), 9 deletions(-)

diff --git a/dapl/openib_common/dapl_ib_common.h b/dapl/openib_common/dapl_ib_common.h
index d3cf2e0..10b5d22 100644
--- a/dapl/openib_common/dapl_ib_common.h
+++ b/dapl/openib_common/dapl_ib_common.h
@@ -171,6 +171,7 @@ typedef uint16_t		ib_hca_port_t;
 #define DCM_RTU_TIME    400	/* rtu timeout in m_secs */
 #define DCM_QP_SIZE     500     /* uCM tx, rx qp size */
 #define DCM_CQ_SIZE     500     /* uCM cq size */
+#define DCM_TX_BURST	50	/* uCM signal, every TX burst msgs posted */
 
 /* DTO OPs, ordered for DAPL ENUM definitions */
 #define OP_RDMA_WRITE           IBV_WR_RDMA_WRITE
diff --git a/dapl/openib_ucm/cm.c b/dapl/openib_ucm/cm.c
index be15c0f..3a518c3 100644
--- a/dapl/openib_ucm/cm.c
+++ b/dapl/openib_ucm/cm.c
@@ -116,8 +116,6 @@ static void ucm_disconnect_final(dp_ib_cm_handle_t cm);
 DAT_RETURN dapli_cm_disconnect(dp_ib_cm_handle_t cm);
 DAT_RETURN dapli_cm_connect(DAPL_EP *ep, dp_ib_cm_handle_t cm);
 
-#define UCM_SND_BURST	50	
-
 /* Service ids - port space */
 static uint16_t ucm_get_port(ib_hca_transport_t *tp, uint16_t port)
 {
@@ -242,10 +240,10 @@ static ib_cm_msg_t *ucm_get_smsg(ib_hca_transport_t *tp)
 	int ret, polled = 0, hd = tp->s_hd;
 
 	hd++;
-retry:
+
 	if (hd == tp->qpe)
 		hd = 0;
-
+retry:
 	if (hd == tp->s_tl)
 		msg = NULL;
 	else {
@@ -257,7 +255,7 @@ retry:
 	if ((msg == NULL) && (!polled)) {
 		struct ibv_wc wc;
 
-		/* process completions, based on UCM_SND_BURST */
+		/* process completions, based on UCM_TX_BURST */
 		ret = ibv_poll_cq(tp->scq, 1, &wc);
 		if (ret < 0) {
 			dapl_log(DAPL_DBG_TYPE_WARN,
@@ -583,8 +581,12 @@ static int ucm_send(ib_hca_transport_t *tp, ib_cm_msg_t *msg, DAT_PVOID p_data,
 
 	/* Get message from send queue, copy data, and send */
 	dapl_os_lock(&tp->slock);
-	if ((smsg = ucm_get_smsg(tp)) == NULL)
+	if ((smsg = ucm_get_smsg(tp)) == NULL) {
+		dapl_log(DAPL_DBG_TYPE_ERR,
+			" ucm_send ERR: get_smsg(hd=%d,tl=%d) \n",
+			tp->s_hd, tp->s_tl);
 		goto bail;
+	}
 
 	len = (sizeof(*msg) - DCM_MAX_PDATA_SIZE);
 	dapl_os_memcpy(smsg, msg, len);
@@ -598,7 +600,7 @@ static int ucm_send(ib_hca_transport_t *tp, ib_cm_msg_t *msg, DAT_PVOID p_data,
         wr.num_sge = 1;
         wr.opcode = IBV_WR_SEND;
         wr.wr_id = (unsigned long)tp->s_hd;
-	wr.send_flags = (wr.wr_id % UCM_SND_BURST) ? 0 : IBV_SEND_SIGNALED;
+	wr.send_flags = (wr.wr_id % tp->burst) ? 0 : IBV_SEND_SIGNALED;
 	if (len <= tp->max_inline_send)
 		wr.send_flags |= IBV_SEND_INLINE; 
 
@@ -626,6 +628,12 @@ static int ucm_send(ib_hca_transport_t *tp, ib_cm_msg_t *msg, DAT_PVOID p_data,
 	wr.wr.ud.remote_qkey = DAT_UD_QKEY;
 
 	ret = ibv_post_send(tp->qp, &wr, &bad_wr);
+	if (ret) {
+		dapl_log(DAPL_DBG_TYPE_ERR,
+			 " ucm_send ERR: post_send() %s\n",
+			 strerror(errno) );
+	}
+
 bail:
 	dapl_os_unlock(&tp->slock);	
 	return ret;
@@ -1413,9 +1421,10 @@ static int ucm_reply(dp_ib_cm_handle_t cm)
 	}
 	dapl_os_get_time(&cm->timer); /* RTU expected */
 	dapl_os_unlock(&cm->lock);
-	if (ucm_send(&cm->hca->ib_trans, &cm->msg, cm->p_data, cm->p_size)) 		
+	if (ucm_send(&cm->hca->ib_trans, &cm->msg, cm->p_data, cm->p_size)) {
+		dapl_log(DAPL_DBG_TYPE_ERR," accept ERR: ucm reply send()\n");
 		return -1;
-
+	}
 	return 0;
 }
 
diff --git a/dapl/openib_ucm/dapl_ib_util.h b/dapl/openib_ucm/dapl_ib_util.h
index 9fd573e..7769307 100644
--- a/dapl/openib_ucm/dapl_ib_util.h
+++ b/dapl/openib_ucm/dapl_ib_util.h
@@ -95,6 +95,7 @@ typedef struct _ib_hca_transport
 	struct dapl_thread_signal signal;
 	int			cqe;
 	int			qpe;
+	int			burst;
 	int			retries;
 	int			cm_timer;
 	int			rep_time;
diff --git a/dapl/openib_ucm/device.c b/dapl/openib_ucm/device.c
index 7457fb7..6882c58 100644
--- a/dapl/openib_ucm/device.c
+++ b/dapl/openib_ucm/device.c
@@ -485,6 +485,7 @@ static int ucm_service_create(IN DAPL_HCA *hca)
 	tp->cm_timer = DAPL_MIN(tp->rep_time,tp->rtu_time);
 	tp->qpe = dapl_os_get_env_val("DAPL_UCM_QP_SIZE", DCM_QP_SIZE);
 	tp->cqe = dapl_os_get_env_val("DAPL_UCM_CQ_SIZE", DCM_CQ_SIZE);
+	tp->burst = dapl_os_get_env_val("DAPL_UCM_TX_BURST", DCM_TX_BURST);
 	tp->pd = ibv_alloc_pd(hca->ib_hca_handle);
         if (!tp->pd) 
                 goto bail;
@@ -525,6 +526,7 @@ static int ucm_service_create(IN DAPL_HCA *hca)
 	tp->sid = (uint8_t*) dapl_os_alloc(sizeof(uint8_t) * 0xffff);
 	tp->rbuf = (void*) dapl_os_alloc((mlen + hlen) * tp->qpe);
 	tp->sbuf = (void*) dapl_os_alloc(mlen * tp->qpe);
+	tp->s_hd = tp->s_tl = 0;
 
 	if (!tp->ah || !tp->rbuf || !tp->sbuf || !tp->sid)
 		goto bail;
-- 
1.7.3



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
