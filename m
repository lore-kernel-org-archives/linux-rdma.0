From: arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH 4/4] ucm: add time wait override capability for CM services
Date: Mon, 15 Dec 2014 11:58:55 -0800
Message-ID: <1418673535-1464-5-git-send-email-arlin.r.davis@intel.com>
References: <1418673535-1464-1-git-send-email-arlin.r.davis@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1418673535-1464-1-git-send-email-arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Arlin Davis <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Arlin Davis <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

New environment variable DAPL_UCM_WAIT_TIME (ms) to
override the default wait_time for CM services.
Default setting is 60 seconds.

Signed-off-by: Arlin Davis <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 dapl/openib_common/dapl_ib_common.h |    1 +
 dapl/openib_ucm/cm.c                |   52 +++++++++++++---------------------
 dapl/openib_ucm/dapl_ib_util.h      |    1 +
 dapl/openib_ucm/device.c            |    9 +++---
 4 files changed, 27 insertions(+), 36 deletions(-)

diff --git a/dapl/openib_common/dapl_ib_common.h b/dapl/openib_common/dapl_ib_common.h
index c1b9267..d5b26ec 100644
--- a/dapl/openib_common/dapl_ib_common.h
+++ b/dapl/openib_common/dapl_ib_common.h
@@ -225,6 +225,7 @@ typedef uint16_t		ib_hca_port_t;
 #define DCM_RETRY_CNT   10
 #define DCM_REP_TIME    800	/* reply timeout in m_secs */
 #define DCM_RTU_TIME    800	/* rtu timeout in m_secs */
+#define DCM_WAIT_TIME   60000	/* wait timeout in m_secs */
 #define DCM_QP_SIZE     500     /* uCM tx, rx qp size */
 #define DCM_CQ_SIZE     500     /* uCM cq size */
 #define DCM_TX_BURST	50	/* uCM signal, every TX burst msgs posted */
diff --git a/dapl/openib_ucm/cm.c b/dapl/openib_ucm/cm.c
index 141086d..04d5eac 100644
--- a/dapl/openib_ucm/cm.c
+++ b/dapl/openib_ucm/cm.c
@@ -231,38 +231,26 @@ static void ucm_check_timers(dp_ib_cm_handle_t cm, int *timer)
 		*timer = cm->hca->ib_trans.cm_timer;
 		if ((time - cm->timer)/1000 >
 		     (cm->hca->ib_trans.rtu_time << cm->retries)) {
-			dapl_log(DAPL_DBG_TYPE_CM,
-				 " CM_TIMEWAIT %d %p [lid, port, cqp, iqp]:"
-				 " %x %x %x %x -> %x %x %x %x r_pid %x"
-				 " Time(ms) %d > %d\n",
-				 cm->retries+1, cm,
-				 ntohs(cm->msg.saddr.ib.lid), ntohs(cm->msg.sport),
-				 ntohl(cm->msg.sqpn), ntohl(cm->msg.saddr.ib.qpn),
-				 ntohs(cm->msg.daddr.ib.lid), ntohs(cm->msg.dport),
-				 ntohl(cm->msg.dqpn), ntohl(cm->msg.daddr.ib.qpn),
-				 ntohl(cm->msg.d_id),
-				 (time - cm->timer)/1000,
-				 cm->hca->ib_trans.rtu_time << cm->retries);
 			cm->retries++;
-		}
-		if (cm->retries > 2) {
-			dapl_log(DAPL_DBG_TYPE_CM_WARN,
-				 " CM_TIMEWAIT EXPIRED %d %p [lid, port, cqp, iqp]:"
-				 " %x %x %x %x -> %x %x %x %x r_pid %x"
-				 " Time(ms) %d > %d\n",
-				 cm->retries+1, cm,
-				 ntohs(cm->msg.saddr.ib.lid), ntohs(cm->msg.sport),
-				 ntohl(cm->msg.sqpn), ntohl(cm->msg.saddr.ib.qpn),
-				 ntohs(cm->msg.daddr.ib.lid), ntohs(cm->msg.dport),
-				 ntohl(cm->msg.dqpn), ntohl(cm->msg.daddr.ib.qpn),
-				 ntohl(cm->msg.d_id),
-				 (time - cm->timer)/1000,
-				 cm->hca->ib_trans.rtu_time << cm->retries);
-			cm->ah = NULL;  /* consumer will free AH */
-			cm->state = DCM_FREE;
-			dapl_os_unlock(&cm->lock);
-			dapl_ep_unlink_cm(cm->ep, cm);  /* last CM ref */
-			return;
+			if ((time - cm->timer)/1000 > cm->hca->ib_trans.wait_time) {
+				dapl_log(DAPL_DBG_TYPE_CM_WARN,
+					 " CM_TIMEWAIT EXPIRED %d %p [lid, port, cqp, iqp]:"
+					 " %x %x %x %x -> %x %x %x %x r_pid %x"
+					 " Time(ms) %d > %d\n",
+					 cm->retries+1, cm,
+					 ntohs(cm->msg.saddr.ib.lid), ntohs(cm->msg.sport),
+					 ntohl(cm->msg.sqpn), ntohl(cm->msg.saddr.ib.qpn),
+					 ntohs(cm->msg.daddr.ib.lid), ntohs(cm->msg.dport),
+					 ntohl(cm->msg.dqpn), ntohl(cm->msg.daddr.ib.qpn),
+					 ntohl(cm->msg.d_id),
+					 (time - cm->timer)/1000,
+					 cm->hca->ib_trans.wait_time);
+				cm->ah = NULL;  /* consumer will free AH */
+				cm->state = DCM_FREE;
+				dapl_os_unlock(&cm->lock);
+				dapl_ep_unlink_cm(cm->ep, cm);  /* last CM ref */
+				return;
+			}
 		}
 		break;
 
@@ -737,7 +725,7 @@ void dapls_cm_release(dp_ib_cm_handle_t cm)
 	dapl_os_lock(&cm->lock);
 	cm->ref_count--;
 	if (cm->ref_count) {
-		if (cm->ref_count == 1)
+		if ((cm->ref_count == 1) && (cm->list_entry.list_head))
 			dapl_os_wait_object_wakeup(&cm->f_event);
                 dapl_os_unlock(&cm->lock);
 		return;
diff --git a/dapl/openib_ucm/dapl_ib_util.h b/dapl/openib_ucm/dapl_ib_util.h
index 69d61a4..a5b9c52 100644
--- a/dapl/openib_ucm/dapl_ib_util.h
+++ b/dapl/openib_ucm/dapl_ib_util.h
@@ -101,6 +101,7 @@ typedef struct _ib_hca_transport
 	int			cm_timer;
 	int			rep_time;
 	int			rtu_time;
+	int			wait_time;
 	DAPL_OS_LOCK		slock;	
 	int			s_hd;
 	int			s_tl;
diff --git a/dapl/openib_ucm/device.c b/dapl/openib_ucm/device.c
index 75d7306..79796cc 100644
--- a/dapl/openib_ucm/device.c
+++ b/dapl/openib_ucm/device.c
@@ -504,12 +504,11 @@ static int ucm_service_create(IN DAPL_HCA *hca)
 	int hlen = sizeof(struct ibv_grh); /* hdr included with UD recv */
 	char *rbuf;
 
-	dapl_dbg_log(DAPL_DBG_TYPE_UTIL, " ucm_create: \n");
-
 	/* setup CM timers and queue sizes */
 	tp->retries = dapl_os_get_env_val("DAPL_UCM_RETRY", DCM_RETRY_CNT);
 	tp->rep_time = dapl_os_get_env_val("DAPL_UCM_REP_TIME", DCM_REP_TIME);
 	tp->rtu_time = dapl_os_get_env_val("DAPL_UCM_RTU_TIME", DCM_RTU_TIME);
+	tp->wait_time = dapl_os_get_env_val("DAPL_UCM_WAIT_TIME", DCM_WAIT_TIME);
 	tp->cm_timer = DAPL_MIN(tp->rep_time,tp->rtu_time);
 	tp->qpe = dapl_os_get_env_val("DAPL_UCM_QP_SIZE", DCM_QP_SIZE);
 	tp->cqe = dapl_os_get_env_val("DAPL_UCM_CQ_SIZE", DCM_CQ_SIZE);
@@ -519,8 +518,10 @@ static int ucm_service_create(IN DAPL_HCA *hca)
                 goto bail;
         
         dapl_log(DAPL_DBG_TYPE_UTIL,
-                        " create_service: pd %p ctx %p handle 0x%x\n",
-                         tp->pd, tp->pd->context, tp->pd->handle);
+                 " UCM: CM service - pd %p ctx %p "
+        	 " Timers(ms): req %d rtu %d wait %d\n",
+                 tp->pd, tp->pd->context, tp->rep_time,
+                 tp->rtu_time, tp->wait_time);
 
     	tp->rch = ibv_create_comp_channel(hca->ib_hca_handle);
 	if (!tp->rch) 
-- 
1.7.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
