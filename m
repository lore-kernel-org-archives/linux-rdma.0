From: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH 12/18] iser-target: Rename device find/release routines
Date: Sun, 29 Mar 2015 15:52:14 +0300
Message-ID: <1427633540-30352-13-git-send-email-sagig@mellanox.com>
References: <1427633540-30352-1-git-send-email-sagig@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1427633540-30352-1-git-send-email-sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Nicholas A. Bellinger" <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>
Cc: target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Oren Duer <oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

isert_device_find_by_ib_dev and isert_device_try_release
can have a better, more common name like isert_device_[get|put].

Signed-off-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/ulp/isert/ib_isert.c |   13 ++++++-------
 1 files changed, 6 insertions(+), 7 deletions(-)

diff --git a/drivers/infiniband/ulp/isert/ib_isert.c b/drivers/infiniband/ulp/isert/ib_isert.c
index f015023..d19271b 100644
--- a/drivers/infiniband/ulp/isert/ib_isert.c
+++ b/drivers/infiniband/ulp/isert/ib_isert.c
@@ -410,7 +410,7 @@ isert_free_device_ib_res(struct isert_device *device)
 }
 
 static void
-isert_device_try_release(struct isert_device *device)
+isert_device_put(struct isert_device *device)
 {
 	mutex_lock(&device_list_mutex);
 	device->refcount--;
@@ -424,7 +424,7 @@ isert_device_try_release(struct isert_device *device)
 }
 
 static struct isert_device *
-isert_device_find_by_ib_dev(struct rdma_cm_id *cma_id)
+isert_device_get(struct rdma_cm_id *cma_id)
 {
 	struct isert_device *device;
 	int ret;
@@ -713,11 +713,12 @@ isert_connect_request(struct rdma_cm_id *cma_id, struct rdma_cm_event *event)
 		goto out_req_dma_map;
 	}
 
-	device = isert_device_find_by_ib_dev(cma_id);
+	device = isert_device_get(cma_id);
 	if (IS_ERR(device)) {
 		ret = PTR_ERR(device);
 		goto out_rsp_dma_map;
 	}
+	isert_conn->conn_device = device;
 
 	/* Set max inflight RDMA READ requests */
 	isert_conn->initiator_depth = min_t(u8,
@@ -725,8 +726,6 @@ isert_connect_request(struct rdma_cm_id *cma_id, struct rdma_cm_event *event)
 				device->dev_attr.max_qp_init_rd_atom);
 	isert_dbg("Using initiator_depth: %u\n", isert_conn->initiator_depth);
 
-	isert_conn->conn_device = device;
-
 	ret = isert_conn_setup_qp(isert_conn, cma_id);
 	if (ret)
 		goto out_conn_dev;
@@ -748,7 +747,7 @@ isert_connect_request(struct rdma_cm_id *cma_id, struct rdma_cm_event *event)
 	return 0;
 
 out_conn_dev:
-	isert_device_try_release(device);
+	isert_device_put(device);
 out_rsp_dma_map:
 	ib_dma_unmap_single(ib_dev, isert_conn->login_rsp_dma,
 			    ISER_RX_LOGIN_SIZE, DMA_TO_DEVICE);
@@ -796,7 +795,7 @@ isert_connect_release(struct isert_conn *isert_conn)
 	kfree(isert_conn);
 
 	if (device)
-		isert_device_try_release(device);
+		isert_device_put(device);
 }
 
 static void
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
