From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-next 03/16] IB/iser: Collapse cleanup and disconnect handlers
Date: Sun,  7 Dec 2014 16:09:54 +0200
Message-ID: <1417961407-10139-4-git-send-email-ogerlitz@mellanox.com>
References: <1417961407-10139-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1417961407-10139-1-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Roi Dayan <roid-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Oren Duer <oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Ariel Nahum <arieln-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Ariel Nahum <arieln-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

No real need to wait for TIMEWAIT_EXIT before we destroy
the RDMA resources (also TIMEAWAIT_EXIT is not guarenteed
to always arrive). As for the cma_id, only destroy it
if the state is not DOWN where in this case, conn_release
is already running and we don't want to compete.

Signed-off-by: Ariel Nahum <arieln-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/ulp/iser/iser_verbs.c |   19 +++++++++++--------
 1 files changed, 11 insertions(+), 8 deletions(-)

diff --git a/drivers/infiniband/ulp/iser/iser_verbs.c b/drivers/infiniband/ulp/iser/iser_verbs.c
index cd4acc5..6a2a91c 100644
--- a/drivers/infiniband/ulp/iser/iser_verbs.c
+++ b/drivers/infiniband/ulp/iser/iser_verbs.c
@@ -629,9 +629,11 @@ void iser_conn_release(struct iser_conn *iser_conn)
 	mutex_unlock(&ig.connlist_mutex);
 
 	mutex_lock(&iser_conn->state_mutex);
-	if (iser_conn->state != ISER_CONN_DOWN)
+	if (iser_conn->state != ISER_CONN_DOWN) {
 		iser_warn("iser conn %p state %d, expected state down.\n",
 			  iser_conn, iser_conn->state);
+		iser_conn->state = ISER_CONN_DOWN;
+	}
 	/*
 	 * In case we never got to bind stage, we still need to
 	 * release IB resources (which is safe to call more than once).
@@ -867,20 +869,21 @@ static int iser_cma_handler(struct rdma_cm_id *cma_id, struct rdma_cm_event *eve
 		break;
 	case RDMA_CM_EVENT_DISCONNECTED:
 	case RDMA_CM_EVENT_ADDR_CHANGE:
-		iser_disconnected_handler(cma_id);
+	case RDMA_CM_EVENT_TIMEWAIT_EXIT:
+		iser_cleanup_handler(cma_id, false);
 		break;
 	case RDMA_CM_EVENT_DEVICE_REMOVAL:
 		/*
 		 * we *must* destroy the device as we cannot rely
 		 * on iscsid to be around to initiate error handling.
-		 * also implicitly destroy the cma_id.
+		 * also if we are not in state DOWN implicitly destroy
+		 * the cma_id.
 		 */
 		iser_cleanup_handler(cma_id, true);
-		iser_conn->ib_conn.cma_id = NULL;
-		ret = 1;
-		break;
-	case RDMA_CM_EVENT_TIMEWAIT_EXIT:
-		iser_cleanup_handler(cma_id, false);
+		if (iser_conn->state != ISER_CONN_DOWN) {
+			iser_conn->ib_conn.cma_id = NULL;
+			ret = 1;
+		}
 		break;
 	default:
 		iser_err("Unexpected RDMA CM event (%d)\n", event->event);
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
