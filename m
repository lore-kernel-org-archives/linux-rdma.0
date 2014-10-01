From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-next 06/21] IB/iser: Don't bound release_work completions timeouts
Date: Wed,  1 Oct 2014 14:02:02 +0300
Message-ID: <1412161337-25285-7-git-send-email-ogerlitz@mellanox.com>
References: <1412161337-25285-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1412161337-25285-1-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Roi Dayan <roid-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Ariel Nahum <arieln-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

We no longer rely on iscsi connection teardown sequence,
so no need to give a grace period and continue cleanup if
it expired. Have iser_conn_release wait for full completion
before freeing iser_conn.

ib_completion:
	Guaranteed to come when:
	    - Got DISCONNECTED/ADDR_CHANGE event or
	    - iSCSI called ep_disconnect/conn_stop
	Guaranteed to finish when:
	    - Got TIMEWAIT_EXIT/DEVICE_REMOVAL event
	    - All Flush errors are consumed
	    - IB related resources are destroyed

stop_completion:
	Guaranteed to come when:
	    - iSCSI calls conn_stop
	Guaranteed to finish when:
	    - All inflight tasks were cleaned up

Signed-off-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Ariel Nahum <arieln-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/ulp/iser/iser_verbs.c |   13 ++++---------
 1 files changed, 4 insertions(+), 9 deletions(-)

diff --git a/drivers/infiniband/ulp/iser/iser_verbs.c b/drivers/infiniband/ulp/iser/iser_verbs.c
index 6170d06..6ce20fd 100644
--- a/drivers/infiniband/ulp/iser/iser_verbs.c
+++ b/drivers/infiniband/ulp/iser/iser_verbs.c
@@ -566,18 +566,13 @@ static int iser_conn_state_comp_exch(struct iser_conn *iser_conn,
 void iser_release_work(struct work_struct *work)
 {
 	struct iser_conn *iser_conn;
-	int rc;
 
 	iser_conn = container_of(work, struct iser_conn, release_work);
 
-	/* wait for .conn_stop callback */
-	rc = wait_for_completion_timeout(&iser_conn->stop_completion, 30 * HZ);
-	WARN_ON(rc == 0);
-
-	rc = wait_for_completion_timeout(&iser_conn->ib_completion, 30 * HZ);
-	if (rc == 0)
-		iser_warn("conn %p, IB cleanup didn't complete in 30 "
-			  "seconds, continue with release\n", iser_conn);
+	/* Wait for conn_stop to complete */
+	wait_for_completion(&iser_conn->stop_completion);
+	/* Wait for IB resouces cleanup to complete */
+	wait_for_completion(&iser_conn->ib_completion);
 
 	mutex_lock(&iser_conn->state_mutex);
 	iser_conn->state = ISER_CONN_DOWN;
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
