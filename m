From: "Davis, Arlin R" <arlin.r.davis@intel.com>
Subject: [PATCH] dapl-1.2: common,
 cma: disconnect and cleanup CR linkings after DTO error on EP
Date: Wed, 4 Aug 2010 11:24:38 -0700
Message-ID: <E3280858FA94444CA49D2BA02341C983010FFA7A30@orsmsx506.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <ofw-bounces@lists.openfabrics.org>
Content-Language: en-US
List-Unsubscribe: <http://lists.openfabrics.org/cgi-bin/mailman/listinfo/ofw>,
	<mailto:ofw-request@lists.openfabrics.org?subject=unsubscribe>
List-Archive: <http://lists.openfabrics.org/pipermail/ofw>
List-Post: <mailto:ofw@lists.openfabrics.org>
List-Help: <mailto:ofw-request@lists.openfabrics.org?subject=help>
List-Subscribe: <http://lists.openfabrics.org/cgi-bin/mailman/listinfo/ofw>,
	<mailto:ofw-request@lists.openfabrics.org?subject=subscribe>
Sender: ofw-bounces@lists.openfabrics.org
Errors-To: ofw-bounces@lists.openfabrics.org
To: linux-rdma <linux-rdma@vger.kernel.org>, "ofw@lists.openfabrics.org" <ofw@lists.openfabrics.org>
List-Id: linux-rdma@vger.kernel.org


Add a cleanup to remove CR from SP and EP
during DTO errors in dapli_evd_cqe_to_event.
Initiate a provider disconnect request since
the QP error is independent of CM processing.

dapl_sp_remove_ep needs to remove cr_ptr
reference from EP before freeing cr object.

Provider disconnect should not wait on disconnect
event. Let consumer choose decide to wait on
event or go ahead and destroy if taking too long.

Signed-off-by: Arlin Davis <arlin.r.davis@intel.com>
---
 dapl/common/dapl_evd_util.c  |   34 ++++++++++++++++++++++++++++++++--
 dapl/common/dapl_sp_util.c   |    2 ++
 dapl/openib_cma/dapl_ib_cm.c |   17 ++++-------------
 3 files changed, 38 insertions(+), 15 deletions(-)

diff --git a/dapl/common/dapl_evd_util.c b/dapl/common/dapl_evd_util.c
index 8ea2ce8..e3655fb 100644
--- a/dapl/common/dapl_evd_util.c
+++ b/dapl/common/dapl_evd_util.c
@@ -1169,11 +1169,41 @@ dapli_evd_cqe_to_event (
      * Most error DTO ops result in disconnecting the EP. See
      * IBTA Vol 1.1, Chapter 10,Table 68, for expected effect on
      * state. The QP going to error state will trigger disconnect
-     * at provider level. No need to force disconnect here. Just
-     * print error log.
+     * at provider level. QP errors and CM events are independent,
+     * issue CM disconnect and cleanup any pending CR's 
      */
     if ((dto_status != DAT_DTO_SUCCESS) && (dto_status != DAT_DTO_ERR_FLUSHED))
     {
+	dapl_os_lock ( &ep_ptr->header.lock );
+	if (ep_ptr->param.ep_state == DAT_EP_STATE_CONNECTED ||
+	    ep_ptr->param.ep_state == DAT_EP_STATE_ACTIVE_CONNECTION_PENDING ||
+	    ep_ptr->param.ep_state == DAT_EP_STATE_PASSIVE_CONNECTION_PENDING||
+	    ep_ptr->param.ep_state == DAT_EP_STATE_COMPLETION_PENDING )
+	{
+	    ep_ptr->param.ep_state = DAT_EP_STATE_DISCONNECTED;
+	    dapl_os_unlock ( &ep_ptr->header.lock );
+	    dapls_io_trc_dump (ep_ptr, cqe_ptr, dto_status);
+
+	    /* Let the other side know we have disconnected */
+	    (void) dapls_ib_disconnect (ep_ptr, DAT_CLOSE_ABRUPT_FLAG);
+
+	    /* ... and clean up the local side */
+	    evd_ptr = (DAPL_EVD *) ep_ptr->param.connect_evd_handle;
+	    dapl_sp_remove_ep(ep_ptr);
+	    if (evd_ptr != NULL)
+	    {
+		dapls_evd_post_connection_event (evd_ptr,
+						DAT_CONNECTION_EVENT_BROKEN,
+						(DAT_HANDLE) ep_ptr,
+						0,
+						0);
+	    }
+	}
+	else
+	{
+	    dapl_os_unlock ( &ep_ptr->header.lock );
+	}
+
 	dapl_log(DAPL_DBG_TYPE_ERR,
 		 "DTO completion ERR: status %d, op %s, vendor_err 0x%x - %s\n",
 		 DAPL_GET_CQE_STATUS(cqe_ptr),
diff --git a/dapl/common/dapl_sp_util.c b/dapl/common/dapl_sp_util.c
index 1ca1204..310e601 100644
--- a/dapl/common/dapl_sp_util.c
+++ b/dapl/common/dapl_sp_util.c
@@ -290,6 +290,8 @@ dapl_sp_remove_ep (
 
 	dapl_os_unlock (&sp_ptr->header.lock);
 
+	ep_ptr->cr_ptr = NULL;
+
 	/* free memory outside of the lock */
 	dapls_cr_free (cr_ptr);
 
diff --git a/dapl/openib_cma/dapl_ib_cm.c b/dapl/openib_cma/dapl_ib_cm.c
index 576e19e..8332d46 100755
--- a/dapl/openib_cma/dapl_ib_cm.c
+++ b/dapl/openib_cma/dapl_ib_cm.c
@@ -610,21 +610,12 @@ dapls_ib_disconnect(IN DAPL_EP *ep_ptr,
 		dapl_dbg_log(DAPL_DBG_TYPE_ERR,
 			     " disconnect: ID %p ret %d\n", 
 			     ep_ptr->cm_handle, ret);
-
-	/* ABRUPT close, wait for callback and !DISCONNECT_PENDING state */
-	if (close_flags == DAT_CLOSE_ABRUPT_FLAG) {
-		dapl_os_lock(&ep_ptr->header.lock);
-		while (ep_ptr->param.ep_state == DAT_EP_STATE_DISCONNECT_PENDING) {
-			dapl_os_unlock(&ep_ptr->header.lock);
-			dapl_os_sleep_usec(10000);
-			dapl_os_lock(&ep_ptr->header.lock);
-		}
-		dapl_os_unlock(&ep_ptr->header.lock);
-	}
-
 	/* 
 	 * DAT event notification occurs from the callback
-	 * Note: will fire even if DREQ goes unanswered on timeout 
+	 * Don't wait for event, allow consumer option to
+	 * to give up and destroy cm_id if event is delayed. 
+	 * EP DISCONNECTED state protects against duplicate 
+	 * events being queued.
 	 */
 	return DAT_SUCCESS;
 }
-- 
1.5.2.5
