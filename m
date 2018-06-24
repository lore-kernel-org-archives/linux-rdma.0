From: Leon Romanovsky <leon@kernel.org>
Subject: [PATCH rdma-next 04/12] RDMA/verbs: Drop kernel variant of destroy_flow
Date: Sun, 24 Jun 2018 11:23:45 +0300
Message-ID: <20180624082353.16138-5-leon@kernel.org>
References: <20180624082353.16138-1-leon@kernel.org>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180624082353.16138-1-leon@kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>
Cc: Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Hadar Hen Zion <hadarh@mellanox.com>, Matan Barak <matanb@mellanox.com>, Michael J Ruhl <michael.j.ruhl@intel.com>, Noa Osherovich <noaos@mellanox.com>, Raed Salem <raeds@mellanox.com>, Yishai Hadas <yishaih@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro@mellanox.com>

Following the removal of ib_create_flow(), adjust the code to get rid of
ib_destroy_flow() too.

Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/infiniband/core/uverbs_cmd.c       |  3 ++-
 drivers/infiniband/core/uverbs_std_types.c |  9 ++++++---
 drivers/infiniband/core/verbs.c            | 12 ------------
 include/rdma/ib_verbs.h                    |  2 --
 4 files changed, 8 insertions(+), 18 deletions(-)

diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
index 6251d80db732..3aba63aa1779 100644
--- a/drivers/infiniband/core/uverbs_cmd.c
+++ b/drivers/infiniband/core/uverbs_cmd.c
@@ -3642,7 +3642,8 @@ int ib_uverbs_ex_create_flow(struct ib_uverbs_file *file,
 		kfree(kern_flow_attr);
 	return 0;
 err_copy:
-	ib_destroy_flow(flow_id);
+	if (!qp->device->destroy_flow(flow_id))
+		atomic_dec(&qp->usecnt);
 err_free:
 	ib_uverbs_flow_resources_free(uflow_res);
 err_free_flow_attr:
diff --git a/drivers/infiniband/core/uverbs_std_types.c b/drivers/infiniband/core/uverbs_std_types.c
index 6497263d13c8..9b4e1e53cd9c 100644
--- a/drivers/infiniband/core/uverbs_std_types.c
+++ b/drivers/infiniband/core/uverbs_std_types.c
@@ -48,14 +48,17 @@ static int uverbs_free_ah(struct ib_uobject *uobject,
 static int uverbs_free_flow(struct ib_uobject *uobject,
 			    enum rdma_remove_reason why)
 {
-	int ret;
 	struct ib_flow *flow = (struct ib_flow *)uobject->object;
 	struct ib_uflow_object *uflow =
 		container_of(uobject, struct ib_uflow_object, uobject);
+	struct ib_qp *qp = flow->qp;
+	int ret;
 
-	ret = ib_destroy_flow(flow);
-	if (!ret)
+	ret = qp->device->destroy_flow(flow);
+	if (!ret) {
+		atomic_dec(&qp->usecnt);
 		ib_uverbs_flow_resources_free(uflow->resources);
+	}
 
 	return ret;
 }
diff --git a/drivers/infiniband/core/verbs.c b/drivers/infiniband/core/verbs.c
index 5ada09f708f5..128d94988dd8 100644
--- a/drivers/infiniband/core/verbs.c
+++ b/drivers/infiniband/core/verbs.c
@@ -2275,18 +2275,6 @@ int ib_destroy_rwq_ind_table(struct ib_rwq_ind_table *rwq_ind_table)
 }
 EXPORT_SYMBOL(ib_destroy_rwq_ind_table);
 
-int ib_destroy_flow(struct ib_flow *flow_id)
-{
-	int err;
-	struct ib_qp *qp = flow_id->qp;
-
-	err = qp->device->destroy_flow(flow_id);
-	if (!err)
-		atomic_dec(&qp->usecnt);
-	return err;
-}
-EXPORT_SYMBOL(ib_destroy_flow);
-
 int ib_check_mr_status(struct ib_mr *mr, u32 check_mask,
 		       struct ib_mr_status *mr_status)
 {
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index a55e1aa808a7..6c51190ae7a1 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -3832,8 +3832,6 @@ struct ib_xrcd *__ib_alloc_xrcd(struct ib_device *device, const char *caller);
  */
 int ib_dealloc_xrcd(struct ib_xrcd *xrcd);
 
-int ib_destroy_flow(struct ib_flow *flow_id);
-
 static inline int ib_check_mr_access(int flags)
 {
 	/*
-- 
2.14.4
