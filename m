From: Leon Romanovsky <leon@kernel.org>
Subject: [PATCH rdma-next v2 4/8] IB: Consider ib_flow creation by the KABI infrastructure
Date: Mon, 23 Jul 2018 15:25:08 +0300
Message-ID: <20180723122512.20967-5-leon@kernel.org>
References: <20180723122512.20967-1-leon@kernel.org>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180723122512.20967-1-leon@kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>
Cc: Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Yishai Hadas <yishaih@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

From: Yishai Hadas <yishaih@mellanox.com>

This patch considers the case that ib_flow is created by some device
driver with its specific parameters using the KABI infrastructure.

In that case both QP and ib_uflow_resources might not be applicable.
Downstream patches from this series use the above functionality.

Signed-off-by: Yishai Hadas <yishaih@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/infiniband/core/uverbs_cmd.c       | 4 ++++
 drivers/infiniband/core/uverbs_std_types.c | 5 +++--
 include/rdma/ib_verbs.h                    | 1 +
 3 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
index e4c298ac5946..312f9dbec09f 100644
--- a/drivers/infiniband/core/uverbs_cmd.c
+++ b/drivers/infiniband/core/uverbs_cmd.c
@@ -2771,6 +2771,9 @@ void ib_uverbs_flow_resources_free(struct ib_uflow_resources *uflow_res)
 {
 	unsigned int i;
 
+	if (!uflow_res)
+		return;
+
 	for (i = 0; i < uflow_res->collection_num; i++)
 		atomic_dec(&uflow_res->collection[i]->usecnt);
 
@@ -3590,6 +3593,7 @@ int ib_uverbs_ex_create_flow(struct ib_uverbs_file *file,
 	}
 	atomic_inc(&qp->usecnt);
 	flow_id->qp = qp;
+	flow_id->device = qp->device;
 	flow_id->uobject = uobj;
 	uobj->object = flow_id;
 	uflow = container_of(uobj, typeof(*uflow), uobject);
diff --git a/drivers/infiniband/core/uverbs_std_types.c b/drivers/infiniband/core/uverbs_std_types.c
index 718c8430d364..c1e0492cc78a 100644
--- a/drivers/infiniband/core/uverbs_std_types.c
+++ b/drivers/infiniband/core/uverbs_std_types.c
@@ -54,9 +54,10 @@ static int uverbs_free_flow(struct ib_uobject *uobject,
 	struct ib_qp *qp = flow->qp;
 	int ret;
 
-	ret = qp->device->destroy_flow(flow);
+	ret = flow->device->destroy_flow(flow);
 	if (!ret) {
-		atomic_dec(&qp->usecnt);
+		if (qp)
+			atomic_dec(&qp->usecnt);
 		ib_uverbs_flow_resources_free(uflow->resources);
 	}
 
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 2696f1d730a1..d02bbbafbd3c 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -2079,6 +2079,7 @@ struct ib_flow_attr {
 
 struct ib_flow {
 	struct ib_qp		*qp;
+	struct ib_device	*device;
 	struct ib_uobject	*uobject;
 };
 
-- 
2.14.4
