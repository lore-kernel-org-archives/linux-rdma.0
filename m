From: Leon Romanovsky <leon@kernel.org>
Subject: [PATCH rdma-next 03/12] RDMA/verbs: Drop kernel variant of create_flow
Date: Sun, 24 Jun 2018 11:23:44 +0300
Message-ID: <20180624082353.16138-4-leon@kernel.org>
References: <20180624082353.16138-1-leon@kernel.org>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180624082353.16138-1-leon@kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>
Cc: Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Hadar Hen Zion <hadarh@mellanox.com>, Matan Barak <matanb@mellanox.com>, Michael J Ruhl <michael.j.ruhl@intel.com>, Noa Osherovich <noaos@mellanox.com>, Raed Salem <raeds@mellanox.com>, Yishai Hadas <yishaih@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro@mellanox.com>

There are no kernel users of this interface so let's drop it.

Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/infiniband/core/verbs.c | 17 -----------------
 include/rdma/ib_verbs.h         |  2 --
 2 files changed, 19 deletions(-)

diff --git a/drivers/infiniband/core/verbs.c b/drivers/infiniband/core/verbs.c
index 9a72b88fea80..5ada09f708f5 100644
--- a/drivers/infiniband/core/verbs.c
+++ b/drivers/infiniband/core/verbs.c
@@ -2275,23 +2275,6 @@ int ib_destroy_rwq_ind_table(struct ib_rwq_ind_table *rwq_ind_table)
 }
 EXPORT_SYMBOL(ib_destroy_rwq_ind_table);
 
-struct ib_flow *ib_create_flow(struct ib_qp *qp,
-			       struct ib_flow_attr *flow_attr,
-			       int domain)
-{
-	struct ib_flow *flow_id;
-	if (!qp->device->create_flow)
-		return ERR_PTR(-EOPNOTSUPP);
-
-	flow_id = qp->device->create_flow(qp, flow_attr, domain, NULL);
-	if (!IS_ERR(flow_id)) {
-		atomic_inc(&qp->usecnt);
-		flow_id->qp = qp;
-	}
-	return flow_id;
-}
-EXPORT_SYMBOL(ib_create_flow);
-
 int ib_destroy_flow(struct ib_flow *flow_id)
 {
 	int err;
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index d1e2f2d91766..a55e1aa808a7 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -3832,8 +3832,6 @@ struct ib_xrcd *__ib_alloc_xrcd(struct ib_device *device, const char *caller);
  */
 int ib_dealloc_xrcd(struct ib_xrcd *xrcd);
 
-struct ib_flow *ib_create_flow(struct ib_qp *qp,
-			       struct ib_flow_attr *flow_attr, int domain);
 int ib_destroy_flow(struct ib_flow *flow_id);
 
 static inline int ib_check_mr_access(int flags)
-- 
2.14.4
