From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next V1 16/17] IB/isert: Remove and fix debug prints after allocation failure
Date: Thu,  3 Nov 2016 16:44:24 +0200
Message-ID: <1478184265-9620-17-git-send-email-leon@kernel.org>
References: <1478184265-9620-1-git-send-email-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1478184265-9620-1-git-send-email-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

The prints after [k|v][m|z|c]alloc() functions are not needed,
because in case of failure, allocator will print their internal
error prints anyway.

Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/ulp/isert/ib_isert.c | 23 ++++++-----------------
 1 file changed, 6 insertions(+), 17 deletions(-)

diff --git a/drivers/infiniband/ulp/isert/ib_isert.c b/drivers/infiniband/ulp/isert/ib_isert.c
index 6dd43f6..225cb82 100644
--- a/drivers/infiniband/ulp/isert/ib_isert.c
+++ b/drivers/infiniband/ulp/isert/ib_isert.c
@@ -184,7 +184,7 @@ isert_alloc_rx_descriptors(struct isert_conn *isert_conn)
 	isert_conn->rx_descs = kzalloc(ISERT_QP_MAX_RECV_DTOS *
 				sizeof(struct iser_rx_desc), GFP_KERNEL);
 	if (!isert_conn->rx_descs)
-		goto fail;
+		return -ENOMEM;
 
 	rx_desc = isert_conn->rx_descs;
 
@@ -213,9 +213,7 @@ isert_alloc_rx_descriptors(struct isert_conn *isert_conn)
 	}
 	kfree(isert_conn->rx_descs);
 	isert_conn->rx_descs = NULL;
-fail:
 	isert_err("conn %p failed to allocate rx descriptors\n", isert_conn);
-
 	return -ENOMEM;
 }
 
@@ -269,10 +267,8 @@ isert_alloc_comps(struct isert_device *device)
 
 	device->comps = kcalloc(device->comps_used, sizeof(struct isert_comp),
 				GFP_KERNEL);
-	if (!device->comps) {
-		isert_err("Unable to allocate completion contexts\n");
+	if (!device->comps)
 		return -ENOMEM;
-	}
 
 	max_cqe = min(ISER_MAX_CQ_LEN, device->ib_device->attrs.max_cqe);
 
@@ -432,10 +428,8 @@ isert_alloc_login_buf(struct isert_conn *isert_conn,
 
 	isert_conn->login_req_buf = kzalloc(sizeof(*isert_conn->login_req_buf),
 			GFP_KERNEL);
-	if (!isert_conn->login_req_buf) {
-		isert_err("Unable to allocate isert_conn->login_buf\n");
+	if (!isert_conn->login_req_buf)
 		return -ENOMEM;
-	}
 
 	isert_conn->login_req_dma = ib_dma_map_single(ib_dev,
 				isert_conn->login_req_buf,
@@ -1276,11 +1270,8 @@ isert_handle_text_cmd(struct isert_conn *isert_conn, struct isert_cmd *isert_cmd
 
 	if (payload_length) {
 		text_in = kzalloc(payload_length, GFP_KERNEL);
-		if (!text_in) {
-			isert_err("Unable to allocate text_in of payload_length: %u\n",
-				  payload_length);
+		if (!text_in)
 			return -ENOMEM;
-		}
 	}
 	cmd->text_in_ptr = text_in;
 
@@ -2307,10 +2298,9 @@ isert_setup_np(struct iscsi_np *np,
 	int ret;
 
 	isert_np = kzalloc(sizeof(struct isert_np), GFP_KERNEL);
-	if (!isert_np) {
-		isert_err("Unable to allocate struct isert_np\n");
+	if (!isert_np)
 		return -ENOMEM;
-	}
+
 	sema_init(&isert_np->sem, 0);
 	mutex_init(&isert_np->mutex);
 	INIT_LIST_HEAD(&isert_np->accepted);
@@ -2651,7 +2641,6 @@ static int __init isert_init(void)
 					WQ_UNBOUND | WQ_HIGHPRI, 0);
 	if (!isert_comp_wq) {
 		isert_err("Unable to allocate isert_comp_wq\n");
-		ret = -ENOMEM;
 		return -ENOMEM;
 	}
 
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
