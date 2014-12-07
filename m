From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-next 07/16] IB/iser: Fix possible NULL derefernce ib_conn->device in session_create
Date: Sun,  7 Dec 2014 16:09:58 +0200
Message-ID: <1417961407-10139-8-git-send-email-ogerlitz@mellanox.com>
References: <1417961407-10139-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1417961407-10139-1-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Roi Dayan <roid-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Oren Duer <oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Ariel Nahum <arieln-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Ariel Nahum <arieln-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

If rdma_cm error event comes after ep_poll but before conn_bind, we should
protect against dereferncing the device (which may have been terminated)
in session_create and conn_create (already protected) callbacks.

Signed-off-by: Ariel Nahum <arieln-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/ulp/iser/iscsi_iser.c |   22 ++++++++++++++++++----
 1 files changed, 18 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/ulp/iser/iscsi_iser.c b/drivers/infiniband/ulp/iser/iscsi_iser.c
index 47bd87a..0b453e5 100644
--- a/drivers/infiniband/ulp/iser/iscsi_iser.c
+++ b/drivers/infiniband/ulp/iser/iscsi_iser.c
@@ -588,6 +588,15 @@ iscsi_iser_session_create(struct iscsi_endpoint *ep,
 	if (ep) {
 		iser_conn = ep->dd_data;
 		max_cmds = iser_conn->max_cmds;
+
+		mutex_lock(&iser_conn->state_mutex);
+		if (iser_conn->state != ISER_CONN_UP) {
+			iser_err("iser conn %p already started teardown\n",
+				 iser_conn);
+			mutex_unlock(&iser_conn->state_mutex);
+			goto free_host;
+		}
+
 		ib_conn = &iser_conn->ib_conn;
 		if (ib_conn->pi_support) {
 			u32 sig_caps = ib_conn->device->dev_attr.sig_prot_cap;
@@ -598,14 +607,19 @@ iscsi_iser_session_create(struct iscsi_endpoint *ep,
 			else
 				scsi_host_set_guard(shost, SHOST_DIX_GUARD_CRC);
 		}
+
+		if (iscsi_host_add(shost,
+				   ib_conn->device->ib_device->dma_device)) {
+			mutex_unlock(&iser_conn->state_mutex);
+			goto free_host;
+		}
+		mutex_unlock(&iser_conn->state_mutex);
 	} else {
 		max_cmds = ISER_DEF_XMIT_CMDS_MAX;
+		if (iscsi_host_add(shost, NULL))
+			goto free_host;
 	}
 
-	if (iscsi_host_add(shost, ep ?
-			   ib_conn->device->ib_device->dma_device : NULL))
-		goto free_host;
-
 	if (cmds_max > max_cmds) {
 		iser_info("cmds_max changed from %u to %u\n",
 			  cmds_max, max_cmds);
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
