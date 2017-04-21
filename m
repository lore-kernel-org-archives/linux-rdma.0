From: Dasaratharaman Chandramouli
        <dasaratharaman.chandramouli-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v3 rdma-next 12/18] IB/mlx5: Rename to_ib_ah_attr to to_rdma_ah_attr
Date: Fri, 21 Apr 2017 01:44:57 -0400
Message-ID: <1492753503-64790-13-git-send-email-dasaratharaman.chandramouli@intel.com>
References: <1492753503-64790-1-git-send-email-dasaratharaman.chandramouli@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1492753503-64790-1-git-send-email-dasaratharaman.chandramouli-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

local function  to_ib_ah_attr is renamed so it in
sync with the rename of the ib_ah_attr structure

Reviewed-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Don Hiatt <don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dasaratharaman Chandramouli <dasaratharaman.chandramouli-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/mlx5/qp.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/qp.c b/drivers/infiniband/hw/mlx5/qp.c
index 26803aa..22d8f71 100644
--- a/drivers/infiniband/hw/mlx5/qp.c
+++ b/drivers/infiniband/hw/mlx5/qp.c
@@ -4248,9 +4248,9 @@ static int to_ib_qp_access_flags(int mlx5_flags)
 	return ib_flags;
 }
 
-static void to_ib_ah_attr(struct mlx5_ib_dev *ibdev,
-			  struct rdma_ah_attr *ib_ah_attr,
-			  struct mlx5_qp_path *path)
+static void to_rdma_ah_attr(struct mlx5_ib_dev *ibdev,
+			    struct rdma_ah_attr *ib_ah_attr,
+			    struct mlx5_qp_path *path)
 {
 	struct mlx5_core_dev *dev = ibdev->mdev;
 
@@ -4440,8 +4440,8 @@ static int query_qp_attr(struct mlx5_ib_dev *dev, struct mlx5_ib_qp *qp,
 		to_ib_qp_access_flags(be32_to_cpu(context->params2));
 
 	if (qp->ibqp.qp_type == IB_QPT_RC || qp->ibqp.qp_type == IB_QPT_UC) {
-		to_ib_ah_attr(dev, &qp_attr->ah_attr, &context->pri_path);
-		to_ib_ah_attr(dev, &qp_attr->alt_ah_attr, &context->alt_path);
+		to_rdma_ah_attr(dev, &qp_attr->ah_attr, &context->pri_path);
+		to_rdma_ah_attr(dev, &qp_attr->alt_ah_attr, &context->alt_path);
 		qp_attr->alt_pkey_index =
 			be16_to_cpu(context->alt_path.pkey_index);
 		qp_attr->alt_port_num	= qp_attr->alt_ah_attr.port_num;
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
