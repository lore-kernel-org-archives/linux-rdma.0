From: "Arlin Davis" <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 1/5] uDAPL v2: Patch series for ucm, scm: fixes for issues discovered during scale-up, out testing
Date: Wed, 28 Oct 2009 16:19:03 -0700
Message-ID: <F9116972FE5D4B089161A6A55258309C@amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


Linux testing completed with Intel MPI/HPCC benchmarks on 128 nodes, 1024 cores.
ucm, scm: address handles need destroyed when freeing Endpoints with UD QP's.

Signed-off-by: Arlin Davis <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 dapl/openib_scm/cm.c           |    4 ++++
 dapl/openib_ucm/cm.c           |    6 ++++++
 dapl/openib_ucm/dapl_ib_util.h |    1 +
 dapl/openib_ucm/device.c       |   16 ++++++++++------
 4 files changed, 21 insertions(+), 6 deletions(-)

diff --git a/dapl/openib_scm/cm.c b/dapl/openib_scm/cm.c
index 453e32e..0d2d058 100644
--- a/dapl/openib_scm/cm.c
+++ b/dapl/openib_scm/cm.c
@@ -355,6 +355,10 @@ multi_cleanup:
 			dapl_os_lock(&cr->lock);
 			hca_ptr = cr->hca;
 			cr->ep = NULL;
+			if (cr->ah) {
+				ibv_destroy_ah(cr->ah);
+				cr->ah = NULL;
+			}
 			cr->state = DCM_DESTROY;
 			dapl_os_unlock(&cr->lock);
 		}
diff --git a/dapl/openib_ucm/cm.c b/dapl/openib_ucm/cm.c
index cc480c4..96ee382 100644
--- a/dapl/openib_ucm/cm.c
+++ b/dapl/openib_ucm/cm.c
@@ -679,6 +679,10 @@ static void ucm_ud_free(DAPL_EP *ep)
 			dapl_os_lock(&cm->lock);
 			hca = cm->hca;
 			cm->ep = NULL;
+			if (cm->ah) {
+				ibv_destroy_ah(cm->ah);
+				cm->ah = NULL;
+			}
 			cm->state = DCM_DESTROY;
 			dapl_os_unlock(&cm->lock);
 		}
@@ -1041,6 +1045,7 @@ ud_bail:
 			event = IB_CME_LOCAL_FAILURE;
 			goto bail;
 		}
+		cm->ah = xevent.remote_ah.ah; /* keep ref to destroy */
 
 		dapl_os_memcpy(&xevent.remote_ah.ia_addr,
 			       &cm->msg.daddr,
@@ -1218,6 +1223,7 @@ static void ucm_accept_rtu(dp_ib_cm_handle_t cm, ib_cm_msg_t *msg)
 		if (xevent.remote_ah.ah == NULL) 
 			goto bail;
 
+		cm->ah = xevent.remote_ah.ah; /* keep ref to destroy */
 		dapl_os_memcpy(&xevent.remote_ah.ia_addr,
 			       &cm->msg.daddr,
 			        sizeof(union dcm_addr));
diff --git a/dapl/openib_ucm/dapl_ib_util.h b/dapl/openib_ucm/dapl_ib_util.h
index 27ff8dd..6273459 100644
--- a/dapl/openib_ucm/dapl_ib_util.h
+++ b/dapl/openib_ucm/dapl_ib_util.h
@@ -43,6 +43,7 @@ struct ib_cm_handle
 	struct dapl_hca		*hca;
 	struct dapl_sp		*sp;	
 	struct dapl_ep 		*ep;
+	struct ibv_ah		*ah;
 	uint16_t		p_size; /* accept p_data, for retries */
 	uint8_t			p_data[DCM_MAX_PDATA_SIZE];
 	ib_cm_msg_t		msg;
diff --git a/dapl/openib_ucm/device.c b/dapl/openib_ucm/device.c
index 077446b..e890eef 100644
--- a/dapl/openib_ucm/device.c
+++ b/dapl/openib_ucm/device.c
@@ -434,14 +434,18 @@ static void ucm_service_destroy(IN DAPL_HCA *hca)
 	if (tp->rch)
 		ibv_destroy_comp_channel(tp->rch);
 
-        dapl_log(DAPL_DBG_TYPE_UTIL,
-                        " destroy_service: pd %p ctx %p handle 0x%x\n",
-                         tp->pd, tp->pd->context, tp->pd->handle);
-	if (tp->pd)
-		ibv_dealloc_pd(tp->pd);
+ 	if (tp->ah) {
+		int i;
 
-	if (tp->ah)
+		for (i = 0;i < 0xffff; i++) {
+			if (tp->ah[i])
+				ibv_destroy_ah(tp->ah[i]);
+		}
 		dapl_os_free(tp->ah, (sizeof(*tp->ah) * 0xffff));
+	}
+
+	if (tp->pd)
+		ibv_dealloc_pd(tp->pd);
 
 	if (tp->sid)
 		dapl_os_free(tp->sid, (sizeof(*tp->sid) * 0xffff));
-- 
1.5.2.5


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
