From: Leon Romanovsky <leon@kernel.org>
Subject: [PATCH rdma-next v2 07/13] IB/core: Support passing uhw for create_flow
Date: Tue, 29 May 2018 16:09:11 +0300
Message-ID: <20180529130917.13592-8-leon@kernel.org>
References: <20180529130917.13592-1-leon@kernel.org>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180529130917.13592-1-leon@kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>
Cc: Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Boris Pismenny <borisp@mellanox.com>, Matan Barak <matanb@mellanox.com>, Raed Salem <raeds@mellanox.com>, Yishai Hadas <yishaih@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

From: Matan Barak <matanb@mellanox.com>

This is required when user-space drivers need to pass extra information
regarding how to handle this flow steering specification.

Tested-by: Michael Guralnik <michaelgur@mellanox.com>
Reviewed-by: Yishai Hadas <yishaih@mellanox.com>
Signed-off-by: Matan Barak <matanb@mellanox.com>
Signed-off-by: Boris Pismenny <borisp@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/infiniband/core/uverbs_cmd.c | 7 ++++++-
 drivers/infiniband/core/verbs.c      | 2 +-
 drivers/infiniband/hw/mlx4/main.c    | 6 +++++-
 drivers/infiniband/hw/mlx5/main.c    | 7 ++++++-
 include/rdma/ib_verbs.h              | 3 ++-
 5 files changed, 20 insertions(+), 5 deletions(-)

diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
index e74262ee104c..ddb9d79691be 100644
--- a/drivers/infiniband/core/uverbs_cmd.c
+++ b/drivers/infiniband/core/uverbs_cmd.c
@@ -3542,11 +3542,16 @@ int ib_uverbs_ex_create_flow(struct ib_uverbs_file *file,
 		err = -EINVAL;
 		goto err_free;
 	}
-	flow_id = ib_create_flow(qp, flow_attr, IB_FLOW_DOMAIN_USER);
+
+	flow_id = qp->device->create_flow(qp, flow_attr,
+					  IB_FLOW_DOMAIN_USER, uhw);
+
 	if (IS_ERR(flow_id)) {
 		err = PTR_ERR(flow_id);
 		goto err_free;
 	}
+	atomic_inc(&qp->usecnt);
+	flow_id->qp = qp;
 	flow_id->uobject = uobj;
 	uobj->object = flow_id;
 	uflow = container_of(uobj, typeof(*uflow), uobject);
diff --git a/drivers/infiniband/core/verbs.c b/drivers/infiniband/core/verbs.c
index 6ddfb1fade79..0b56828c1319 100644
--- a/drivers/infiniband/core/verbs.c
+++ b/drivers/infiniband/core/verbs.c
@@ -1983,7 +1983,7 @@ struct ib_flow *ib_create_flow(struct ib_qp *qp,
 	if (!qp->device->create_flow)
 		return ERR_PTR(-EOPNOTSUPP);

-	flow_id = qp->device->create_flow(qp, flow_attr, domain);
+	flow_id = qp->device->create_flow(qp, flow_attr, domain, NULL);
 	if (!IS_ERR(flow_id)) {
 		atomic_inc(&qp->usecnt);
 		flow_id->qp = qp;
diff --git a/drivers/infiniband/hw/mlx4/main.c b/drivers/infiniband/hw/mlx4/main.c
index bf12394c13c1..6fe5d5d1d1d9 100644
--- a/drivers/infiniband/hw/mlx4/main.c
+++ b/drivers/infiniband/hw/mlx4/main.c
@@ -1848,7 +1848,7 @@ static int mlx4_ib_add_dont_trap_rule(struct mlx4_dev *dev,

 static struct ib_flow *mlx4_ib_create_flow(struct ib_qp *qp,
 				    struct ib_flow_attr *flow_attr,
-				    int domain)
+				    int domain, struct ib_udata *udata)
 {
 	int err = 0, i = 0, j = 0;
 	struct mlx4_ib_flow *mflow;
@@ -1866,6 +1866,10 @@ static struct ib_flow *mlx4_ib_create_flow(struct ib_qp *qp,
 	    (flow_attr->type != IB_FLOW_ATTR_NORMAL))
 		return ERR_PTR(-EOPNOTSUPP);

+	if (udata &&
+	    udata->inlen && !ib_is_udata_cleared(udata, 0, udata->inlen))
+		return ERR_PTR(-EOPNOTSUPP);
+
 	memset(type, 0, sizeof(type));

 	mflow = kzalloc(sizeof(*mflow), GFP_KERNEL);
diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index 25a271ef8374..59f86198eb3b 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -3363,7 +3363,8 @@ static struct mlx5_ib_flow_handler *create_sniffer_rule(struct mlx5_ib_dev *dev,

 static struct ib_flow *mlx5_ib_create_flow(struct ib_qp *qp,
 					   struct ib_flow_attr *flow_attr,
-					   int domain)
+					   int domain,
+					   struct ib_udata *udata)
 {
 	struct mlx5_ib_dev *dev = to_mdev(qp->device);
 	struct mlx5_ib_qp *mqp = to_mqp(qp);
@@ -3375,6 +3376,10 @@ static struct ib_flow *mlx5_ib_create_flow(struct ib_qp *qp,
 	int err;
 	int underlay_qpn;

+	if (udata &&
+	    udata->inlen && !ib_is_udata_cleared(udata, 0, udata->inlen))
+		return ERR_PTR(-EOPNOTSUPP);
+
 	if (flow_attr->priority > MLX5_IB_FLOW_LAST_PRIO)
 		return ERR_PTR(-ENOMEM);

diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index f6bd3b97b971..80956b1c9f4d 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -2459,7 +2459,8 @@ struct ib_device {
 	struct ib_flow *	   (*create_flow)(struct ib_qp *qp,
 						  struct ib_flow_attr
 						  *flow_attr,
-						  int domain);
+						  int domain,
+						  struct ib_udata *udata);
 	int			   (*destroy_flow)(struct ib_flow *flow_id);
 	int			   (*check_mr_status)(struct ib_mr *mr, u32 check_mask,
 						      struct ib_mr_status *mr_status);
