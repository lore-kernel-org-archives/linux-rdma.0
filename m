From: "Davis, Arlin R" <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 1/3]  DAPL v2.0:  ucm, scm: remove use of usec_sleep delays
 and use events for disc and destroy
Date: Sat, 12 Feb 2011 11:33:30 -0800
Message-ID: <E3280858FA94444CA49D2BA02341C98301272F405A@orsmsx506.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org" <ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Some optimizations and fixes for ucm/scm provider after issues discovered during MPI
testing with UD QP's on larger clusters.

PATCH [1/3]

use pthread mutex when processing and waiting for disconnect completions
and for CM object destruction. Add f_event, d_event to cm object.

Signed-off-by: Arlin Davis <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 dapl/openib_scm/cm.c           |   11 ++++++++---
 dapl/openib_ucm/cm.c           |   38 ++++++++++++++++++++++++++------------
 dapl/openib_ucm/dapl_ib_util.h |    3 ++-
 3 files changed, 36 insertions(+), 16 deletions(-)

diff --git a/dapl/openib_scm/cm.c b/dapl/openib_scm/cm.c
index b0fbadf..1145f17 100644
--- a/dapl/openib_scm/cm.c
+++ b/dapl/openib_scm/cm.c
@@ -362,6 +362,8 @@ void dapls_cm_release(dp_ib_cm_handle_t cm_ptr)
 	dapl_os_lock(&cm_ptr->lock);
 	cm_ptr->ref_count--;
 	if (cm_ptr->ref_count) {
+                if (cm_ptr->ref_count == 1)
+                        dapl_os_wait_object_wakeup(&cm_ptr->event);
                 dapl_os_unlock(&cm_ptr->lock);
 		return;
 	}
@@ -437,10 +439,13 @@ void dapls_cm_free(dp_ib_cm_handle_t cm_ptr)
 	/* free from internal workq, wait until EP is last ref */
 	dapl_os_lock(&cm_ptr->lock);
 	cm_ptr->state = DCM_FREE;
-	while (cm_ptr->ref_count != 1) {
-		dapli_cm_thread_signal(cm_ptr);
+	dapl_os_unlock(&cm_ptr->lock);
+
+	dapli_cm_thread_signal(cm_ptr);
+	dapl_os_lock(&cm_ptr->lock);
+	if (cm_ptr->ref_count != 1) {
 		dapl_os_unlock(&cm_ptr->lock);
-		dapl_os_sleep_usec(10000);
+		dapl_os_wait_object_wait(&cm_ptr->event, DAT_TIMEOUT_INFINITE);
 		dapl_os_lock(&cm_ptr->lock);
 	}
 	dapl_os_unlock(&cm_ptr->lock);
diff --git a/dapl/openib_ucm/cm.c b/dapl/openib_ucm/cm.c
index c5ddf04..69f7610 100644
--- a/dapl/openib_ucm/cm.c
+++ b/dapl/openib_ucm/cm.c
@@ -649,7 +649,8 @@ static void dapli_cm_dealloc(dp_ib_cm_handle_t cm) {
 
 	dapl_os_assert(!cm->ref_count);
 	dapl_os_lock_destroy(&cm->lock);
-	dapl_os_wait_object_destroy(&cm->event);
+	dapl_os_wait_object_destroy(&cm->d_event);
+	dapl_os_wait_object_destroy(&cm->f_event);
 	dapl_os_free(cm, sizeof(*cm));
 }
 
@@ -665,6 +666,8 @@ void dapls_cm_release(dp_ib_cm_handle_t cm)
 	dapl_os_lock(&cm->lock);
 	cm->ref_count--;
 	if (cm->ref_count) {
+		if (cm->ref_count == 1)
+			dapl_os_wait_object_wakeup(&cm->f_event);
                 dapl_os_unlock(&cm->lock);
 		return;
 	}
@@ -693,10 +696,15 @@ dp_ib_cm_handle_t dapls_ib_cm_create(DAPL_EP *ep)
 	if (dapl_os_lock_init(&cm->lock))
 		goto bail;
 	
-	if (dapl_os_wait_object_init(&cm->event)) {
+	if (dapl_os_wait_object_init(&cm->f_event)) {
 		dapl_os_lock_destroy(&cm->lock);
 		goto bail;
 	}
+	if (dapl_os_wait_object_init(&cm->d_event)) {
+		dapl_os_lock_destroy(&cm->lock);
+		dapl_os_wait_object_destroy(&cm->f_event);
+		goto bail;
+	}
 	dapls_cm_acquire(cm);
 
 	cm->msg.ver = htons(DCM_VER);
@@ -708,7 +716,8 @@ dp_ib_cm_handle_t dapls_ib_cm_create(DAPL_EP *ep)
 
 		cm->msg.sport = htons(ucm_get_port(&hca->ib_trans, 0));
 		if (!cm->msg.sport) {
-			dapl_os_wait_object_destroy(&cm->event);
+			dapl_os_wait_object_destroy(&cm->f_event);
+			dapl_os_wait_object_destroy(&cm->d_event);
 			dapl_os_lock_destroy(&cm->lock);
 			goto bail;
 		}
@@ -758,10 +767,13 @@ void dapls_cm_free(dp_ib_cm_handle_t cm)
 	if (cm->state != DCM_FREE) 
 		cm->state = DCM_FREE;
 	
-	while (cm->ref_count != 1) {
+	dapl_os_unlock(&cm->lock);
+	dapls_thread_signal(&cm->hca->ib_trans.signal);
+
+	dapl_os_lock(&cm->lock);
+	if (cm->ref_count != 1) {
 		dapl_os_unlock(&cm->lock);
-		dapls_thread_signal(&cm->hca->ib_trans.signal);
-		dapl_os_sleep_usec(10000);
+		dapl_os_wait_object_wait(&cm->f_event, DAT_TIMEOUT_INFINITE);
 		dapl_os_lock(&cm->lock);
 	}
 	dapl_os_unlock(&cm->lock);
@@ -836,6 +848,8 @@ static void ucm_disconnect_final(dp_ib_cm_handle_t cm)
 	else
 		dapl_evd_connection_callback(cm, IB_CME_DISCONNECTED, NULL, 0, cm->ep);
 
+	dapl_os_wait_object_wakeup(&cm->d_event);
+
 }
 
 /*
@@ -888,7 +902,7 @@ DAT_RETURN dapli_cm_disconnect(dp_ib_cm_handle_t cm)
 		dapl_os_unlock(&cm->lock);
 		return DAT_SUCCESS;
 	default:
-		dapl_log(DAPL_DBG_TYPE_WARN, 
+		dapl_log(DAPL_DBG_TYPE_EP, 
 			"  disconnect UNKNOWN state: ep %p cm %p %s %s"
 			"  %x %x %x %s %x %x %x r_id %x l_id %x\n",
 			cm->ep, cm,
@@ -1684,13 +1698,13 @@ dapls_ib_disconnect(IN DAPL_EP *ep_ptr, IN DAT_CLOSE_FLAGS close_flags)
         /* ABRUPT close, wait for callback and DISCONNECTED state */
         if (close_flags == DAT_CLOSE_ABRUPT_FLAG) {
                 dapl_os_lock(&ep_ptr->header.lock);
-                while (ep_ptr->param.ep_state != DAT_EP_STATE_DISCONNECTED) {
-                        dapl_os_unlock(&ep_ptr->header.lock);
-                        dapl_os_sleep_usec(10000);
-                        dapl_os_lock(&ep_ptr->header.lock);
+                if (ep_ptr->param.ep_state != DAT_EP_STATE_DISCONNECTED) {
+                	dapl_os_unlock(&ep_ptr->header.lock);
+                	dapl_os_wait_object_wait(&cm_ptr->d_event, DAT_TIMEOUT_INFINITE);
+                	dapl_os_lock(&ep_ptr->header.lock);
                 }
                 dapl_os_unlock(&ep_ptr->header.lock);
-        }
+	}
 
 	return DAT_SUCCESS;
 }
diff --git a/dapl/openib_ucm/dapl_ib_util.h b/dapl/openib_ucm/dapl_ib_util.h
index 7769307..efeec4d 100644
--- a/dapl/openib_ucm/dapl_ib_util.h
+++ b/dapl/openib_ucm/dapl_ib_util.h
@@ -38,7 +38,8 @@ struct ib_cm_handle
 { 
 	struct dapl_llist_entry	list_entry;
 	struct dapl_llist_entry	local_entry;
-	DAPL_OS_WAIT_OBJECT	event;
+	DAPL_OS_WAIT_OBJECT	d_event;
+	DAPL_OS_WAIT_OBJECT	f_event;
 	DAPL_OS_LOCK		lock;
 	DAPL_OS_TIMEVAL		timer;
         int			ref_count;
-- 
1.7.3



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
