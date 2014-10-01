From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-next 07/21] IB/iser: Unbind at conn_stop stage
Date: Wed,  1 Oct 2014 14:02:03 +0300
Message-ID: <1412161337-25285-8-git-send-email-ogerlitz@mellanox.com>
References: <1412161337-25285-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1412161337-25285-1-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Roi Dayan <roid-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Ariel Nahum <arieln-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Ariel Nahum <arieln-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Previously we didn't need to unbind the iser_conn and
iscsi_conn since we always relied on iscsi daemon to teardown
the connection and never let it finish before we cleanup all that
is needed in iser. This is not the case anymore (for DEVICE_REMOVAL
event). So avoid any possible chance we cause iscsi_conn dereference
after iscsi_conn was freed.

We also call iser_conn_terminate (safe to call multiple times) just
for the corner case of iscsi daemon stopping an old connection before
invoking endpoint removal (might happen if it was violently killed).

Notice we are unbinding under a lock - which is required.

Signed-off-by: Ariel Nahum <arieln-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Roi Dayan <roid-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/ulp/iser/iscsi_iser.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/drivers/infiniband/ulp/iser/iscsi_iser.c b/drivers/infiniband/ulp/iser/iscsi_iser.c
index db83530..7298e69 100644
--- a/drivers/infiniband/ulp/iser/iscsi_iser.c
+++ b/drivers/infiniband/ulp/iser/iscsi_iser.c
@@ -414,8 +414,15 @@ iscsi_iser_conn_stop(struct iscsi_cls_conn *cls_conn, int flag)
 	 * might have only partially setup the connection.
 	 */
 	if (iser_conn) {
+		mutex_lock(&iser_conn->state_mutex);
+		iser_conn_terminate(iser_conn);
+
+		/* unbind */
+		iser_conn->iscsi_conn = NULL;
 		conn->dd_data = NULL;
+
 		complete(&iser_conn->stop_completion);
+		mutex_unlock(&iser_conn->state_mutex);
 	}
 }
 
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
