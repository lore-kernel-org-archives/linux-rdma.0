From: Wei Yongjun <weiyj.lk-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH -next] iser-target: fix error return code in isert_connect_request()
Date: Fri, 19 Apr 2013 13:13:44 +0800
Message-ID: <CAPgLHd8xrcHNEYOYZ6y6in=oEmkDegKtf_yZa_sF93sHTwp-rQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org
Cc: yongjun_wei-zrsr2BFq86L20UzCJQGyNP8+0UxHXcjY@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Wei Yongjun <yongjun_wei-zrsr2BFq86L20UzCJQGyNP8+0UxHXcjY@public.gmane.org>

Fix to return a negative error code from the error handling
case instead of 0, as done elsewhere in this function.

Signed-off-by: Wei Yongjun <yongjun_wei-zrsr2BFq86L20UzCJQGyNP8+0UxHXcjY@public.gmane.org>
---
 drivers/infiniband/ulp/isert/ib_isert.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/ulp/isert/ib_isert.c b/drivers/infiniband/ulp/isert/ib_isert.c
index f6f4f58..803b949 100644
--- a/drivers/infiniband/ulp/isert/ib_isert.c
+++ b/drivers/infiniband/ulp/isert/ib_isert.c
@@ -329,6 +329,7 @@ static struct isert_device *
 isert_device_find_by_ib_dev(struct rdma_cm_id *cma_id)
 {
 	struct isert_device *device;
+	int ret;
 
 	mutex_lock(&device_list_mutex);
 	list_for_each_entry(device, &device_list, dev_node) {
@@ -342,16 +343,17 @@ isert_device_find_by_ib_dev(struct rdma_cm_id *cma_id)
 	device = kzalloc(sizeof(struct isert_device), GFP_KERNEL);
 	if (!device) {
 		mutex_unlock(&device_list_mutex);
-		return NULL;
+		return ERR_PTR(-ENOMEM);
 	}
 
 	INIT_LIST_HEAD(&device->dev_node);
 
 	device->ib_device = cma_id->device;
-	if (isert_create_device_ib_res(device)) {
+	ret = isert_create_device_ib_res(device);
+	if (ret) {
 		kfree(device);
 		mutex_unlock(&device_list_mutex);
-		return NULL;
+		return ERR_PTR(ret);
 	}
 
 	device->refcount++;
@@ -434,8 +436,10 @@ isert_connect_request(struct rdma_cm_id *cma_id, struct rdma_cm_event *event)
 	}
 
 	device = isert_device_find_by_ib_dev(cma_id);
-	if (!device)
+	if (IS_ERR(device)) {
+		ret = PTR_ERR(device);
 		goto out_rsp_dma_map;
+	}
 
 	isert_conn->conn_device = device;
 	isert_conn->conn_pd = device->dev_pd;

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
