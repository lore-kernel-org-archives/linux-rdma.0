From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next v1 4/6] IB/mlx5: Handle type IB_QPT_DRIVER when creating a QP
Date: Wed, 27 Dec 2017 19:15:38 +0200
Message-ID: <20171227171540.1646-5-leon@kernel.org>
References: <20171227171540.1646-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171227171540.1646-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

The QP type IB_QPT_DRIVER doesn't describe the transport or the service that
the QP provides but those are known only to the hardware driver.
The extra data that tells more about the QP is in the driver
channel.
Take the real QP type from the driver channel and modify the QP initial
attributes before continuing with create_qp(). Also, define the layout
of the data structure that comes in the driver channel.
Downstream patches from this series will add support for both DCI and
DCT driver QPs.

Signed-off-by: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/hw/mlx5/mlx5_ib.h |  3 ++
 drivers/infiniband/hw/mlx5/qp.c      | 57 +++++++++++++++++++++++++++++++++++-
 include/uapi/rdma/mlx5-abi.h         |  7 ++++-
 3 files changed, 65 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw/mlx5/mlx5_ib.h
index 88b89ed15d1c..66e9c2190f2d 100644
--- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
+++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
@@ -202,6 +202,8 @@ struct mlx5_ib_flow_db {
  * creates the actual hardware QP.
  */
 #define MLX5_IB_QPT_HW_GSI	IB_QPT_RESERVED2
+#define MLX5_IB_QPT_DCI		IB_QPT_RESERVED3
+#define MLX5_IB_QPT_DCT		IB_QPT_RESERVED4
 #define MLX5_IB_WR_UMR		IB_WR_RESERVED1
 
 #define MLX5_IB_UMR_OCTOWORD	       16
@@ -406,6 +408,7 @@ struct mlx5_ib_qp {
 	u32			rate_limit;
 	u32                     underlay_qpn;
 	bool			tunnel_offload_en;
+	u32			driver_qp_type;
 };
 
 struct mlx5_ib_cq_buf {
diff --git a/drivers/infiniband/hw/mlx5/qp.c b/drivers/infiniband/hw/mlx5/qp.c
index 4b0420e67870..f1a2b1ade804 100644
--- a/drivers/infiniband/hw/mlx5/qp.c
+++ b/drivers/infiniband/hw/mlx5/qp.c
@@ -2115,20 +2115,62 @@ static const char *ib_qp_type_str(enum ib_qp_type type)
 		return "IB_QPT_RAW_PACKET";
 	case MLX5_IB_QPT_REG_UMR:
 		return "MLX5_IB_QPT_REG_UMR";
+	case IB_QPT_DRIVER:
+		return "IB_QPT_DRIVER";
 	case IB_QPT_MAX:
 	default:
 		return "Invalid QP type";
 	}
 }
 
+static int validate_driver_qp(struct mlx5_ib_dev *dev,
+			      struct ib_qp_init_attr *init_attr,
+			      struct mlx5_ib_create_qp *ucmd,
+			      struct ib_udata *udata)
+{
+	int err;
+	bool dc_supp = MLX5_CAP_GEN(dev->mdev, dct);
+
+	if (!udata)
+		return -EINVAL;
+
+	if (udata->inlen < sizeof(*ucmd)) {
+		mlx5_ib_dbg(dev, "create_qp user command is smaller than expected\n");
+		return -EINVAL;
+	}
+	err = ib_copy_from_udata(ucmd, udata, sizeof(*ucmd));
+	if (err)
+		return err;
+
+	if ((ucmd->flags & MLX5_QP_FLAG_TYPE_DCT) && (ucmd->flags & MLX5_QP_FLAG_TYPE_DCI)) {
+		mlx5_ib_dbg(dev, "Only one DC QP type should be specified\n");
+		return -EINVAL;
+	}
+	if (!((ucmd->flags & MLX5_QP_FLAG_TYPE_DCT) || (ucmd->flags & MLX5_QP_FLAG_TYPE_DCI))) {
+		mlx5_ib_dbg(dev, "DC QP type is not specified\n");
+		return -EINVAL;
+	}
+	if (!dc_supp) {
+		mlx5_ib_dbg(dev, "DC transport is not supported\n");
+		return -EOPNOTSUPP;
+	}
+	if (ucmd->flags & MLX5_QP_FLAG_TYPE_DCI)
+		init_attr->qp_type = MLX5_IB_QPT_DCI;
+	else
+		init_attr->qp_type = MLX5_IB_QPT_DCT;
+	return 0;
+}
+
 struct ib_qp *mlx5_ib_create_qp(struct ib_pd *pd,
-				struct ib_qp_init_attr *init_attr,
+				struct ib_qp_init_attr *verbs_init_attr,
 				struct ib_udata *udata)
 {
 	struct mlx5_ib_dev *dev;
 	struct mlx5_ib_qp *qp;
 	u16 xrcdn = 0;
 	int err;
+	struct ib_qp_init_attr mlx_init_attr;
+	struct ib_qp_init_attr *init_attr = verbs_init_attr;
 
 	if (pd) {
 		dev = to_mdev(pd->device);
@@ -2153,6 +2195,16 @@ struct ib_qp *mlx5_ib_create_qp(struct ib_pd *pd,
 		dev = to_mdev(to_mxrcd(init_attr->xrcd)->ibxrcd.device);
 	}
 
+	if (init_attr->qp_type == IB_QPT_DRIVER) {
+		struct mlx5_ib_create_qp ucmd;
+
+		init_attr = &mlx_init_attr;
+		memcpy(init_attr, verbs_init_attr, sizeof(*verbs_init_attr));
+		err = validate_driver_qp(dev, init_attr, &ucmd, udata);
+		if (err)
+			return ERR_PTR(err);
+	}
+
 	switch (init_attr->qp_type) {
 	case IB_QPT_XRC_TGT:
 	case IB_QPT_XRC_INI:
@@ -2214,6 +2266,9 @@ struct ib_qp *mlx5_ib_create_qp(struct ib_pd *pd,
 		return ERR_PTR(-EINVAL);
 	}
 
+	if (verbs_init_attr->qp_type == IB_QPT_DRIVER)
+		qp->driver_qp_type = init_attr->qp_type;
+
 	return &qp->ibqp;
 }
 
diff --git a/include/uapi/rdma/mlx5-abi.h b/include/uapi/rdma/mlx5-abi.h
index 0f7e45680ce5..83bde975d3f9 100644
--- a/include/uapi/rdma/mlx5-abi.h
+++ b/include/uapi/rdma/mlx5-abi.h
@@ -42,6 +42,8 @@ enum {
 	MLX5_QP_FLAG_SCATTER_CQE	= 1 << 1,
 	MLX5_QP_FLAG_TUNNEL_OFFLOADS	= 1 << 2,
 	MLX5_QP_FLAG_BFREG_INDEX	= 1 << 3,
+	MLX5_QP_FLAG_TYPE_DCT		= 1 << 4,
+	MLX5_QP_FLAG_TYPE_DCI		= 1 << 5,
 };
 
 enum {
@@ -284,7 +286,10 @@ struct mlx5_ib_create_qp {
 	__u32	flags;
 	__u32	uidx;
 	__u32	bfreg_index;
-	__u64	sq_buf_addr;
+	union {
+		__u64	sq_buf_addr;
+		__u64	access_key;
+	};
 };
 
 /* RX Hash function flags */
-- 
2.15.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
