From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-next 10/21] IB/iser: Use iser_warn instead of BUG_ON in iser_conn_release
Date: Wed,  1 Oct 2014 14:02:06 +0300
Message-ID: <1412161337-25285-11-git-send-email-ogerlitz@mellanox.com>
References: <1412161337-25285-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1412161337-25285-1-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Roi Dayan <roid-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Ariel Nahum <arieln-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Ariel Nahum <arieln-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

In case iscsid was violently killed (SIGKILL) during its error recovery
stage, we may never get a connection teardown sequence for some of
the old connections. No harm done, but when we try to unload the module
we will need to cleanup all these connections. So we actually may end-up
here - So it's not a BUG_ON(), just give a relaxed warning that this
happened and continue with normal unload. BUG_ON will cause segfault
on module_exit and we don't want that.

Signed-off-by: Ariel Nahum <arieln-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Roi Dayan <roid-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/ulp/iser/iser_verbs.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/infiniband/ulp/iser/iser_verbs.c b/drivers/infiniband/ulp/iser/iser_verbs.c
index 35f53a3..57b20c6 100644
--- a/drivers/infiniband/ulp/iser/iser_verbs.c
+++ b/drivers/infiniband/ulp/iser/iser_verbs.c
@@ -627,7 +627,9 @@ void iser_conn_release(struct iser_conn *iser_conn)
 	mutex_unlock(&ig.connlist_mutex);
 
 	mutex_lock(&iser_conn->state_mutex);
-	BUG_ON(iser_conn->state != ISER_CONN_DOWN);
+	if (iser_conn->state != ISER_CONN_DOWN)
+		iser_warn("iser conn %p state %d, expected state down.\n",
+			  iser_conn, iser_conn->state);
 	/*
 	 * In case we never got to bind stage, we still need to
 	 * release IB resources (which is safe to call more than once).
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
