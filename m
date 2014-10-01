From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-next 08/21] IB/iser: Protect tasks cleanup in case IB device was already released
Date: Wed,  1 Oct 2014 14:02:04 +0300
Message-ID: <1412161337-25285-9-git-send-email-ogerlitz@mellanox.com>
References: <1412161337-25285-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1412161337-25285-1-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Roi Dayan <roid-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Ariel Nahum <arieln-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Bailout in case a task cleanup (iscsi_iser_cleanup_task) is
called after the IB device was removed (DEVICE_REMOVAL CM event).
We also call iscsi_conn_stop with a lock taken to prevent
DEVICE_REMOVAL and tasks cleanup from racing.

Signed-off-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Ariel Nahum <arieln-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/ulp/iser/iscsi_iser.c |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/drivers/infiniband/ulp/iser/iscsi_iser.c b/drivers/infiniband/ulp/iser/iscsi_iser.c
index 7298e69..81d69a3 100644
--- a/drivers/infiniband/ulp/iser/iscsi_iser.c
+++ b/drivers/infiniband/ulp/iser/iscsi_iser.c
@@ -293,6 +293,10 @@ static void iscsi_iser_cleanup_task(struct iscsi_task *task)
 	struct iser_conn       *iser_conn	  = task->conn->dd_data;
 	struct iser_device *device = iser_conn->ib_conn.device;
 
+	/* DEVICE_REMOVAL event might have already released the device */
+	if (!device)
+		return;
+
 	ib_dma_unmap_single(device->ib_device,
 		tx_desc->dma_addr, ISER_HEADERS_LEN, DMA_TO_DEVICE);
 
@@ -407,7 +411,6 @@ iscsi_iser_conn_stop(struct iscsi_cls_conn *cls_conn, int flag)
 	struct iser_conn *iser_conn = conn->dd_data;
 
 	iser_dbg("stopping iscsi_conn: %p, iser_conn: %p\n", conn, iser_conn);
-	iscsi_conn_stop(cls_conn, flag);
 
 	/*
 	 * Userspace may have goofed up and not bound the connection or
@@ -415,6 +418,7 @@ iscsi_iser_conn_stop(struct iscsi_cls_conn *cls_conn, int flag)
 	 */
 	if (iser_conn) {
 		mutex_lock(&iser_conn->state_mutex);
+		iscsi_conn_stop(cls_conn, flag);
 		iser_conn_terminate(iser_conn);
 
 		/* unbind */
@@ -423,6 +427,8 @@ iscsi_iser_conn_stop(struct iscsi_cls_conn *cls_conn, int flag)
 
 		complete(&iser_conn->stop_completion);
 		mutex_unlock(&iser_conn->state_mutex);
+	} else {
+		iscsi_conn_stop(cls_conn, flag);
 	}
 }
 
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
