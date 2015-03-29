From: Sagi Grimberg <sagig@mellanox.com>
Subject: [PATCH 08/18] iser-target: Split isert_setup_qp
Date: Sun, 29 Mar 2015 15:52:10 +0300
Message-ID: <1427633540-30352-9-git-send-email-sagig@mellanox.com>
References: <1427633540-30352-1-git-send-email-sagig@mellanox.com>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1427633540-30352-1-git-send-email-sagig@mellanox.com>
Sender: target-devel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: target-devel@vger.kernel.org, linux-rdma@vger.kernel.org, Or Gerlitz <ogerlitz@mellanox.com>, Oren Duer <oren@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

Simplify iser QP creation by splitting some unrelated
logic bulks to routines.

Signed-off-by: Sagi Grimberg <sagig@mellanox.com>
---
 drivers/infiniband/ulp/isert/ib_isert.c |   56 +++++++++++++++++++++++--------
 1 files changed, 42 insertions(+), 14 deletions(-)

diff --git a/drivers/infiniband/ulp/isert/ib_isert.c b/drivers/infiniband/ulp/isert/ib_isert.c
index 1b13337..2a4a435 100644
--- a/drivers/infiniband/ulp/isert/ib_isert.c
+++ b/drivers/infiniband/ulp/isert/ib_isert.c
@@ -107,13 +107,12 @@ isert_query_device(struct ib_device *ib_dev, struct ib_device_attr *devattr)
 	return 0;
 }
 
-static int
-isert_conn_setup_qp(struct isert_conn *isert_conn, struct rdma_cm_id *cma_id)
+static struct isert_comp *
+isert_comp_get(struct isert_conn *isert_conn)
 {
 	struct isert_device *device = isert_conn->conn_device;
-	struct ib_qp_init_attr attr;
 	struct isert_comp *comp;
-	int ret, i, min = 0;
+	int i, min = 0;
 
 	mutex_lock(&device_list_mutex);
 	for (i = 0; i < device->comps_used; i++)
@@ -122,9 +121,30 @@ isert_conn_setup_qp(struct isert_conn *isert_conn, struct rdma_cm_id *cma_id)
 			min = i;
 	comp = &device->comps[min];
 	comp->active_qps++;
+	mutex_unlock(&device_list_mutex);
+
 	isert_info("conn %p, using comp %p min_index: %d\n",
 		   isert_conn, comp, min);
+
+	return comp;
+}
+
+static void
+isert_comp_put(struct isert_comp *comp)
+{
+	mutex_lock(&device_list_mutex);
+	comp->active_qps--;
 	mutex_unlock(&device_list_mutex);
+}
+
+static struct ib_qp *
+isert_create_qp(struct isert_conn *isert_conn,
+		struct isert_comp *comp,
+		struct rdma_cm_id *cma_id)
+{
+	struct isert_device *device = isert_conn->conn_device;
+	struct ib_qp_init_attr attr;
+	int ret;
 
 	memset(&attr, 0, sizeof(struct ib_qp_init_attr));
 	attr.event_handler = isert_qp_event_callback;
@@ -152,16 +172,28 @@ isert_conn_setup_qp(struct isert_conn *isert_conn, struct rdma_cm_id *cma_id)
 	ret = rdma_create_qp(cma_id, device->pd, &attr);
 	if (ret) {
 		isert_err("rdma_create_qp failed for cma_id %d\n", ret);
+		return ERR_PTR(ret);
+	}
+
+	return cma_id->qp;
+}
+
+static int
+isert_conn_setup_qp(struct isert_conn *isert_conn, struct rdma_cm_id *cma_id)
+{
+	struct isert_comp *comp;
+	int ret;
+
+	comp = isert_comp_get(isert_conn);
+	isert_conn->conn_qp = isert_create_qp(isert_conn, comp, cma_id);
+	if (IS_ERR(isert_conn->conn_qp)) {
+		ret = PTR_ERR(isert_conn->conn_qp);
 		goto err;
 	}
-	isert_conn->conn_qp = cma_id->qp;
 
 	return 0;
 err:
-	mutex_lock(&device_list_mutex);
-	comp->active_qps--;
-	mutex_unlock(&device_list_mutex);
-
+	isert_comp_put(comp);
 	return ret;
 }
 
@@ -736,11 +768,7 @@ isert_connect_release(struct isert_conn *isert_conn)
 	if (isert_conn->conn_qp) {
 		struct isert_comp *comp = isert_conn->conn_qp->recv_cq->cq_context;
 
-		isert_dbg("dec completion context %p active_qps\n", comp);
-		mutex_lock(&device_list_mutex);
-		comp->active_qps--;
-		mutex_unlock(&device_list_mutex);
-
+		isert_comp_put(comp);
 		ib_destroy_qp(isert_conn->conn_qp);
 	}
 
-- 
1.7.1
