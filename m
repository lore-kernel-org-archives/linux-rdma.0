From: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH FIXES for-3.19 2/2] IB/iser: Release the iscsi endpoint if ep_disconnect wasn't called
Date: Sun, 18 Jan 2015 16:51:07 +0200
Message-ID: <1421592667-4099-3-git-send-email-sagig@mellanox.com>
References: <1421592667-4099-1-git-send-email-sagig@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1421592667-4099-1-git-send-email-sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Oren Duer <oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Roi Dayan <roid-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Ariel Nahum <arieln-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Ariel Nahum <arieln-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

In some cases, we might reach the iser connection termination
without ep_disconnect being invoked (for example if user-space
daemon doesn't exists). In this case, we need to free the iscsi
endpoint when we remove the iser connection.

Signed-off-by: Ariel Nahum <arieln-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/ulp/iser/iser_verbs.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/infiniband/ulp/iser/iser_verbs.c b/drivers/infiniband/ulp/iser/iser_verbs.c
index f3e21ab..4065abe 100644
--- a/drivers/infiniband/ulp/iser/iser_verbs.c
+++ b/drivers/infiniband/ulp/iser/iser_verbs.c
@@ -646,9 +646,11 @@ void iser_conn_release(struct iser_conn *iser_conn)
 	mutex_unlock(&ig.connlist_mutex);
 
 	mutex_lock(&iser_conn->state_mutex);
+	/* In case we endup here without ep_disconnect being invoked. */
 	if (iser_conn->state != ISER_CONN_DOWN) {
 		iser_warn("iser conn %p state %d, expected state down.\n",
 			  iser_conn, iser_conn->state);
+		iscsi_destroy_endpoint(iser_conn->ep);
 		iser_conn->state = ISER_CONN_DOWN;
 	}
 	/*
-- 
1.8.4.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
