From: Alex Margolin <alexma-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: RE: [RFC] Vendor-specific QPs
Date: Wed, 22 Nov 2017 20:09:56 +0000
Message-ID: <VI1PR05MB12788EFB06D82A0A41FA129FB9200@VI1PR05MB1278.eurprd05.prod.outlook.com>
References: <VI1PR05MB12784029D1DE2689A8194A58B9590@VI1PR05MB1278.eurprd05.prod.outlook.com>
 <20171102200158.GU18874@ziepe.ca>
 <VI1PR05MB1278EA7700D1BEB63383FC52B9200@VI1PR05MB1278.eurprd05.prod.outlook.com>
 <20171122180731.GS18272@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171122180731.GS18272-uk2M96/98Pc@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Cc: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

My bad, I apologize. Patches inline.

>From 506d56ee1f7a63e690b345f34f190dd5e5c05025 Mon Sep 17 00:00:00 2001
From: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Date: Mon, 13 Nov 2017 17:08:44 +0200
Subject: [PATCH 1/2] IB/core: [RFC] Introduce vendor QP type

Vendors can implement type of QPs that are not described in the
Infiniband specification. To still be able to use the IB/core layer
services (e.g. user object management) without tainting this layer with
vendor proprietary logic a new QP type is added - IB_QPT_VENDOR. This
will be a general QP type that core layer doesn't know about its true natur=
e.
When a command like create_qp() is passed to vendor driver the extra data
that is required is taken from the vendor channel.
Although IB/core layer doesn't know the details of the vendor QP it can
assume that all vendor QP has some things in common that seperate them
from standard QPs and therefore code is allowed to make decisions based
on this QP type.

issue: 1126938
Change-Id: I6660be1b3cc2e38963aedb81e805f3b06b536182
Signed-off-by: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/core/uverbs_cmd.c | 9 ++++++---
 drivers/infiniband/core/verbs.c      | 3 +++
 include/rdma/ib_verbs.h              | 2 ++
 3 files changed, 11 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core=
/uverbs_cmd.c
index 52a2cf2..21d8f55 100644
--- a/drivers/infiniband/core/uverbs_cmd.c
+++ b/drivers/infiniband/core/uverbs_cmd.c
@@ -1374,6 +1374,7 @@ static int create_qp(struct ib_uverbs_file *file,
 	int				ret;
 	struct ib_rwq_ind_table *ind_tbl =3D NULL;
 	bool has_sq =3D true;
+	bool has_rq =3D true;
=20
 	if (cmd->qp_type =3D=3D IB_QPT_RAW_PACKET && !capable(CAP_NET_RAW))
 		return -EPERM;
@@ -1412,8 +1413,10 @@ static int create_qp(struct ib_uverbs_file *file,
 		goto err_put;
 	}
=20
-	if (ind_tbl && !cmd->max_send_wr)
+	if ((ind_tbl || cmd->qp_type =3D=3D IB_QPT_VENDOR) && !cmd->max_send_wr)
 		has_sq =3D false;
+	if (cmd->qp_type =3D=3D IB_QPT_VENDOR && !cmd->max_recv_wr)
+		has_rq =3D false;
=20
 	if (cmd->qp_type =3D=3D IB_QPT_XRC_TGT) {
 		xrcd_uobj =3D uobj_get_read(uobj_get_type(xrcd), cmd->pd_handle,
@@ -1445,7 +1448,7 @@ static int create_qp(struct ib_uverbs_file *file,
 			}
=20
 			if (!ind_tbl) {
-				if (cmd->recv_cq_handle !=3D cmd->send_cq_handle) {
+				if (cmd->recv_cq_handle !=3D cmd->send_cq_handle && has_rq) {
 					rcq =3D uobj_get_obj_read(cq, cmd->recv_cq_handle,
 								file->ucontext);
 					if (!rcq) {
@@ -1459,7 +1462,7 @@ static int create_qp(struct ib_uverbs_file *file,
 		if (has_sq)
 			scq =3D uobj_get_obj_read(cq, cmd->send_cq_handle,
 						file->ucontext);
-		if (!ind_tbl)
+		if (!ind_tbl && has_rq)
 			rcq =3D rcq ?: scq;
 		pd  =3D uobj_get_obj_read(pd, cmd->pd_handle, file->ucontext);
 		if (!pd || (!scq && has_sq)) {
diff --git a/drivers/infiniband/core/verbs.c b/drivers/infiniband/core/verb=
s.c
index de57d6c..9b5afeb5 100644
--- a/drivers/infiniband/core/verbs.c
+++ b/drivers/infiniband/core/verbs.c
@@ -1196,6 +1196,9 @@ int ib_modify_qp_is_ok(enum ib_qp_state cur_state, en=
um ib_qp_state next_state,
 {
 	enum ib_qp_attr_mask req_param, opt_param;
=20
+	if (type >=3D IB_QPT_MAX)
+		return 0;
+
 	if (cur_state  < 0 || cur_state  > IB_QPS_ERR ||
 	    next_state < 0 || next_state > IB_QPS_ERR)
 		return 0;
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index e8608b2..93a305b 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -1069,7 +1069,9 @@ enum ib_qp_type {
 	IB_QPT_RAW_PACKET =3D 8,
 	IB_QPT_XRC_INI =3D 9,
 	IB_QPT_XRC_TGT,
+	/* IB_QPT_MAX is the higher value for QP types that the InfiniBand spec d=
escribes */
 	IB_QPT_MAX,
+	IB_QPT_VENDOR =3D0xFFF,
 	/* Reserve a range for qp types internal to the low level driver.
 	 * These qp types will not be visible at the IB core layer, so the
 	 * IB_QPT_MAX usages should not be affected in the core layer
--=20
1.8.3.1

>From 4483d80880c0cea41c3ce2257539ee0d89361925 Mon Sep 17 00:00:00 2001
From: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Date: Wed, 15 Nov 2017 13:22:50 +0200
Subject: [PATCH 1/4] verbs: [RFC] Intorduce QP type IBV_QPT_VENDOR

The new QP type for vendor QP is added to the reflect the change in the
kernel.

issue: 1126938
Change-Id: I1c2cb6d04f28ef46451ee9c4b3e13f75b0dcd3c7
Signed-off-by: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 libibverbs/verbs.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/libibverbs/verbs.h b/libibverbs/verbs.h
index b39dc30..95594dc 100644
--- a/libibverbs/verbs.h
+++ b/libibverbs/verbs.h
@@ -813,7 +813,8 @@ enum ibv_qp_type {
 	IBV_QPT_UD,
 	IBV_QPT_RAW_PACKET =3D 8,
 	IBV_QPT_XRC_SEND =3D 9,
-	IBV_QPT_XRC_RECV
+	IBV_QPT_XRC_RECV,
+	IBV_QPT_VENDOR =3D 0xfff,
 };
=20
 struct ibv_qp_cap {
--=20
1.8.3.1

>From 298e1f0431ba1b3b238a65e241102d062f7c8528 Mon Sep 17 00:00:00 2001
From: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Date: Wed, 15 Nov 2017 09:29:42 +0200
Subject: [PATCH 2/2] IB/mlx5: [RFC] Example use of vendor QP

An example that shows how to use the IB_QPT_VENDOR QP type
to create a DCI QP - specific only to mlx5 driver.
More specifically, validating state transition cannot be with
ib_modify_qp_is_ok() which knows only what are the  state
transition rules for InfiniBand spec QPs.

issue: 1126938
Change-Id: I71f6ea7e5686a5ac41f339c5ff3644cc3bf99bae
Signed-off-by: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/hw/mlx5/mlx5_ib.h |  6 ++++++
 drivers/infiniband/hw/mlx5/qp.c      | 24 +++++++++++++++++++++++-
 include/uapi/rdma/mlx5-abi.h         |  2 ++
 3 files changed, 31 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw/m=
lx5/mlx5_ib.h
index 189e80c..b8a3a63 100644
--- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
+++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
@@ -209,6 +209,11 @@ struct mlx5_ib_flow_db {
 #define MLX5_IB_UPD_XLT_ACCESS	      BIT(5)
 #define MLX5_IB_UPD_XLT_INDIRECT      BIT(6)
=20
+enum {
+	MLX5_VENDOR_QPT_DCT	=3D 1,
+	MLX5_VENDOR_QPT_DCI,
+};
+
 /* Private QP creation flags to be passed in ib_qp_init_attr.create_flags.
  *
  * These flags are intended for internal use by the mlx5_ib driver, and th=
ey
@@ -389,6 +394,7 @@ struct mlx5_ib_qp {
 	struct list_head	cq_send_list;
 	u32			rate_limit;
 	u32                     underlay_qpn;
+	u32			vendor_qp_type;
 };
=20
 struct mlx5_ib_cq_buf {
diff --git a/drivers/infiniband/hw/mlx5/qp.c b/drivers/infiniband/hw/mlx5/q=
p.c
index acb79d3..5c2bd14 100644
--- a/drivers/infiniband/hw/mlx5/qp.c
+++ b/drivers/infiniband/hw/mlx5/qp.c
@@ -1527,6 +1527,11 @@ static int create_qp_common(struct mlx5_ib_dev *dev,=
 struct ib_pd *pd,
 	spin_lock_init(&qp->sq.lock);
 	spin_lock_init(&qp->rq.lock);
=20
+	if (init_attr->qp_type =3D=3D IB_QPT_VENDOR) {
+		if (!udata)
+			return -ENOSYS;
+	}
+
 	if (init_attr->rwq_ind_tbl) {
 		if (!udata)
 			return -ENOSYS;
@@ -1596,6 +1601,7 @@ static int create_qp_common(struct mlx5_ib_dev *dev, =
struct ib_pd *pd,
 			mlx5_ib_dbg(dev, "copy failed\n");
 			return -EFAULT;
 		}
+		qp->vendor_qp_type =3D ucmd.vendor_qp_type;
=20
 		err =3D get_qp_user_index(to_mucontext(pd->uobject->context),
 					&ucmd, udata->inlen, &uidx);
@@ -2086,6 +2092,7 @@ struct ib_qp *mlx5_ib_create_qp(struct ib_pd *pd,
 	case IB_QPT_RC:
 	case IB_QPT_UC:
 	case IB_QPT_UD:
+	case IB_QPT_VENDOR:
 	case IB_QPT_SMI:
 	case MLX5_IB_QPT_HW_GSI:
 	case MLX5_IB_QPT_REG_UMR:
@@ -2934,6 +2941,15 @@ static int __mlx5_ib_modify_qp(struct ib_qp *ibqp,
 	return err;
 }
=20
+int mlx5_ib_modify_qp_is_ok(struct ib_qp *ibqp, struct ib_qp_attr *attr,
+			    int attr_mask, struct ib_udata *udata)
+{
+	struct mlx5_ib_qp *qp =3D to_mqp(ibqp);
+
+	/* put some real logic here based on value of qp->vendor_qp_type */
+	return 1;
+}
+
 int mlx5_ib_modify_qp(struct ib_qp *ibqp, struct ib_qp_attr *attr,
 		      int attr_mask, struct ib_udata *udata)
 {
@@ -2971,10 +2987,16 @@ int mlx5_ib_modify_qp(struct ib_qp *ibqp, struct ib=
_qp_attr *attr,
 			goto out;
 		}
 	} else if (qp_type !=3D MLX5_IB_QPT_REG_UMR &&
-	    !ib_modify_qp_is_ok(cur_state, new_state, qp_type, attr_mask, ll)) {
+		   qp_type !=3D IB_QPT_VENDOR &&
+		   !ib_modify_qp_is_ok(cur_state, new_state, qp_type, attr_mask, ll)) {
 		mlx5_ib_dbg(dev, "invalid QP state transition from %d to %d, qp_type %d,=
 attr_mask 0x%x\n",
 			    cur_state, new_state, ibqp->qp_type, attr_mask);
 		goto out;
+	} else if ((qp_type =3D=3D IB_QPT_VENDOR) &&
+		    !mlx5_ib_modify_qp_is_ok(ibqp, attr, attr_mask, udata)) {
+			mlx5_ib_dbg(dev, "invalid QP state transition from %d to %d, qp_type %d=
, attr_mask 0x%x\n",
+			    cur_state, new_state, ibqp->qp_type, attr_mask);
+			goto out;
 	}
=20
 	if ((attr_mask & IB_QP_PORT) &&
diff --git a/include/uapi/rdma/mlx5-abi.h b/include/uapi/rdma/mlx5-abi.h
index 23dba2d..6701102 100644
--- a/include/uapi/rdma/mlx5-abi.h
+++ b/include/uapi/rdma/mlx5-abi.h
@@ -248,6 +248,8 @@ struct mlx5_ib_create_qp {
 	__u32	uidx;
 	__u32	reserved0;
 	__u64	sq_buf_addr;
+	__u32	vendor_qp_type;
+	__u32	reserved1;
 };
=20
 /* RX Hash function flags */
--=20
1.8.3.1

>From ef7b6ef3c7318653812d3dafdebd0efd752a8ddc Mon Sep 17 00:00:00 2001
From: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Date: Wed, 15 Nov 2017 13:23:28 +0200
Subject: [PATCH 2/4] mlx5: [RFC] Introduce mlx5dv_create_qp()

A vendor QP has a generic type that doesn't add any additional info
about this QP, not even to the vendor itself. It is required to add more
info about the specific type of the QP and extra initialization data
without tainting the verbs interface command layout. For this purpose
the application calls mlx5dv_create_qp() instead of ibv_create_qp() and
passes the vendor specific data along with the generic QP
initialization data. This function still calls the ibv_cmd_create_qp()
but extra data is now piggybacking on the standard command structure.
Since this function returns an object of type (ibv_qp *) any function
that take (ibv_qp *) as an argument will work with this object. For
instance, ibv_modify_qp() will be used to modify the state of a QP that
was created with mlx5dv_creae_qp().

issue: 1126938
Change-Id: I65c4cde6b85a06dfb912706a3b03b50b12d66af4
Signed-off-by: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 providers/mlx5/mlx5-abi.h |  5 +++++
 providers/mlx5/mlx5dv.h   | 39 +++++++++++++++++++++++++++++++++++++++
 providers/mlx5/verbs.c    | 19 +++++++++++++++----
 3 files changed, 59 insertions(+), 4 deletions(-)

diff --git a/providers/mlx5/mlx5-abi.h b/providers/mlx5/mlx5-abi.h
index d1e8b9d..71e2424 100644
--- a/providers/mlx5/mlx5-abi.h
+++ b/providers/mlx5/mlx5-abi.h
@@ -163,6 +163,9 @@ struct mlx5_create_qp_drv_ex {
 	__u32			reserved;
 	/* SQ buffer address - used for Raw Packet QP */
 	__u64			sq_buf_addr;
+	__u32			vendor_qp_type;
+	__u32			reserved1;
+
 };
=20
 struct mlx5_create_qp_ex {
@@ -199,6 +202,8 @@ struct mlx5_create_qp {
 	__u32                           reserved;
 	/* SQ buffer address - used for Raw Packet QP */
 	__u64                           sq_buf_addr;
+	__u32				vendor_qp_type;
+	__u32                           reserved1;
 };
=20
 struct mlx5_create_qp_resp {
diff --git a/providers/mlx5/mlx5dv.h b/providers/mlx5/mlx5dv.h
index 600f6e1..0fc4021 100644
--- a/providers/mlx5/mlx5dv.h
+++ b/providers/mlx5/mlx5dv.h
@@ -107,6 +107,45 @@ struct mlx5dv_cq_init_attr {
 struct ibv_cq_ex *mlx5dv_create_cq(struct ibv_context *context,
 				   struct ibv_cq_init_attr_ex *cq_attr,
 				   struct mlx5dv_cq_init_attr *mlx5_cq_attr);
+
+enum mlx5dv_dc_type{
+	MLX5_VENDOR_QPT_DCT     =3D 1,
+	MLX5_VENDOR_QPT_DCI,
+};
+
+enum mlx5dv_dc_handshake_mode {
+	MLX5DV_QP_HANDSHAKE_MODE_FULL =3D 0,
+	MLX5DV_QP_HANDSHAKE_MODE_HALF
+};
+
+enum mlx5dv_qp_init_attr_mask {
+	MLX5DV_QP_INIT_ATTR_MASK_DC	=3D 1 << 0,
+};
+
+struct mlx5dv_dc_attr {
+	enum mlx5dv_dc_type vendor_qp_type;
+	union {
+		struct {
+			enum mlx5dv_dc_handshake_mode	mode;
+			uint8_t	reverse_cnak_sl;
+		} dc_ini;
+		struct {
+			uint64_t access_key;
+			uint32_t min_responders;
+			uint32_t max_responders;
+		} dc_tgt;
+	};
+};
+
+struct mlx5dv_qp_init_attr {
+	uint64_t comp_mask;
+	struct mlx5dv_dc_attr dc_attr;
+};
+
+struct ibv_qp *mlx5dv_create_qp(struct ibv_context *context,
+				struct ibv_qp_init_attr_ex *qp_init_attr_ex,
+				struct mlx5dv_qp_init_attr *mlx5_qp_init_attr);
+
 /*
  * Most device capabilities are exported by ibv_query_device(...),
  * but there is HW device-specific information which is important
diff --git a/providers/mlx5/verbs.c b/providers/mlx5/verbs.c
index c2e8c64..835a226 100644
--- a/providers/mlx5/verbs.c
+++ b/providers/mlx5/verbs.c
@@ -1244,7 +1244,8 @@ enum {
 };
=20
 static struct ibv_qp *create_qp(struct ibv_context *context,
-			 struct ibv_qp_init_attr_ex *attr)
+				struct ibv_qp_init_attr_ex *attr,
+				struct mlx5dv_qp_init_attr *mlx5_qp_init_attr)
 {
 	struct mlx5_create_qp		cmd;
 	struct mlx5_create_qp_resp	resp;
@@ -1374,6 +1375,9 @@ static struct ibv_qp *create_qp(struct ibv_context *c=
ontext,
 		cmd.uidx =3D usr_idx;
 	}
=20
+	if (mlx5_qp_init_attr) {
+		cmd.vendor_qp_type =3D mlx5_qp_init_attr->vendor_qp_type;
+	}
 	if (attr->comp_mask & MLX5_CREATE_QP_EX2_COMP_MASK)
 		ret =3D mlx5_cmd_create_qp_ex(context, attr, &cmd, qp, &resp_ex);
 	else
@@ -1448,7 +1452,7 @@ struct ibv_qp *mlx5_create_qp(struct ibv_pd *pd,
 	memcpy(&attrx, attr, sizeof(*attr));
 	attrx.comp_mask =3D IBV_QP_INIT_ATTR_PD;
 	attrx.pd =3D pd;
-	qp =3D create_qp(pd->context, &attrx);
+	qp =3D create_qp(pd->context, &attrx, NULL);
 	if (qp)
 		memcpy(attr, &attrx, sizeof(*attr));
=20
@@ -1785,7 +1789,14 @@ int mlx5_detach_mcast(struct ibv_qp *qp, const union=
 ibv_gid *gid, uint16_t lid)
 struct ibv_qp *mlx5_create_qp_ex(struct ibv_context *context,
 				 struct ibv_qp_init_attr_ex *attr)
 {
-	return create_qp(context, attr);
+	return create_qp(context, attr, NULL);
+}
+
+struct ibv_qp *mlx5dv_create_qp(struct ibv_context *context,
+				struct ibv_qp_init_attr_ex *qp_init_attr_ex,
+				struct mlx5dv_qp_init_attr *mlx5_qp_init_attr)
+{
+	return create_qp(context, qp_init_attr_ex, mlx5_qp_init_attr);
 }
=20
 int mlx5_get_srq_num(struct ibv_srq *srq, uint32_t *srq_num)
@@ -1870,7 +1881,7 @@ create_cmd_qp(struct ibv_context *context,
 	init_attr.send_cq =3D srq_attr->cq;
 	init_attr.recv_cq =3D srq_attr->cq;
=20
-	qp =3D create_qp(context, &init_attr);
+	qp =3D create_qp(context, &init_attr, NULL);
 	if (!qp)
 		return NULL;
=20
--=20
1.8.3.1

>From 2e5ef2979fd198880ce0e4896c9b3ab09ea4bc8b Mon Sep 17 00:00:00 2001
From: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Date: Thu, 16 Nov 2017 11:13:11 +0200
Subject: [PATCH 3/4] mlx5/examples: Create a DCI QP

This program creates a DCI QP by using the mlx5dv_create_qp() interface.

issue: 1126938
Change-Id: I01db5da904b93faaba3491073816c29a415209a9
Signed-off-by: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 providers/mlx5/examples/dc_send.c | 146 ++++++++++++++++++++++++++++++++++=
++++
 1 file changed, 146 insertions(+)
 create mode 100644 providers/mlx5/examples/dc_send.c

diff --git a/providers/mlx5/examples/dc_send.c b/providers/mlx5/examples/dc=
_send.c
new file mode 100644
index 0000000..af2a5b4
--- /dev/null
+++ b/providers/mlx5/examples/dc_send.c
@@ -0,0 +1,146 @@
+#define _GNU_SOURCE
+
+#include <stdio.h>
+#include <stdlib.h>
+#include <unistd.h>
+#include <string.h>
+#include <sys/types.h>
+#include <sys/socket.h>
+#include <sys/time.h>
+#include <netdb.h>
+#include <malloc.h>
+#include <getopt.h>
+#include <arpa/inet.h>
+#include <time.h>
+#include <verbs.h>
+#include  "mlx5dv.h"
+
+
+static void usage(const char *argv0)
+{
+	printf("Usage:\n");
+	printf("  %s <host>     connect to server at <host>\n", argv0);
+	printf("\n");
+	printf("Options:\n");
+	printf("  -p, --port=3D<port>      listen on/connect to port <port> (defa=
ult 18515)\n");
+	printf("  -d, --ib-dev=3D<dev>     use IB device <dev> (default first dev=
ice found)\n");
+	printf("  -i, --ib-port=3D<port>   use port <port> of IB device (default =
1)\n");
+}
+
+int main(int argc, char *argv[])
+{
+	char                    *servername =3D NULL;
+	struct ibv_device      **dev_list;
+	struct ibv_device	*ib_dev;
+	int                      ib_port =3D 1;
+	char                    *ib_devname =3D NULL;
+
+	while (1) {
+		int c;
+
+		static struct option long_options[] =3D {
+			{ .name =3D "ib-dev",   .has_arg =3D 1, .val =3D 'd' },
+			{ .name =3D "ib-port",  .has_arg =3D 1, .val =3D 'i' },
+			{}
+		};
+
+		c =3D getopt_long(argc, argv, "d:i:", long_options, NULL);
+		if (c =3D=3D -1)
+			break;
+
+		switch (c) {
+		case 'd':
+			ib_devname =3D strdupa(optarg);
+			break;
+
+		case 'i':
+			ib_port =3D strtol(optarg, NULL, 0);
+			if (ib_port < 1) {
+				usage(argv[0]);
+				return 1;
+			}
+			break;
+		default:
+			usage(argv[0]);
+			return 1;
+		}
+	}
+
+	if (optind =3D=3D argc - 1)
+		servername =3D strdupa(argv[optind]);
+	else if (optind < argc) {
+		usage(argv[0]);
+		return 1;
+	}
+
+	dev_list =3D ibv_get_device_list(NULL);
+	if (!dev_list) {
+		perror("Failed to get IB devices list");
+		return 1;
+	}
+
+	if (!ib_devname) {
+		ib_dev =3D *dev_list;
+		if (!ib_dev) {
+			fprintf(stderr, "No IB devices found\n");
+			return 1;
+		}
+	} else {
+		int i;
+		for (i =3D 0; dev_list[i]; ++i)
+			if (!strcmp(ibv_get_device_name(dev_list[i]), ib_devname))
+				break;
+		ib_dev =3D dev_list[i];
+		if (!ib_dev) {
+			fprintf(stderr, "IB device %s not found\n", ib_devname);
+			return 1;
+		}
+	}
+	{
+		struct ibv_context	*context;
+		struct ibv_pd		*pd;
+		struct ibv_cq		*cq;
+		struct ibv_qp		*qp;
+		int			qp_depth =3D 128;
+		struct ibv_qp_attr	attr;
+		struct ibv_qp_init_attr_ex 	init_attr;
+		struct mlx5dv_qp_init_attr	dv_init_attr;
+
+		context =3D ibv_open_device(ib_dev);
+		if (!context) {
+			fprintf(stderr, "Couldn't get context for %s\n",
+					ibv_get_device_name(ib_dev));
+			return -1;
+		}
+		pd =3D ibv_alloc_pd(context);
+		if (!pd) {
+			fprintf(stderr, "Couldn't allocate PD\n");
+			return -1;
+		}
+		cq =3D ibv_create_cq(context, qp_depth + 1, NULL, NULL, 0);
+		if (cq) {
+			fprintf(stderr, "Couldn't create CQ\n");
+			return -1;
+		}
+
+		init_attr.send_cq =3D cq;
+		init_attr.recv_cq =3D cq;
+		init_attr.cap.max_send_wr  =3D 100;=20
+		init_attr.cap.max_send_sge  =3D 1;
+		init_attr.qp_type =3D IBV_QPT_VENDOR;
+		init_attr.pd =3D pd;
+
+		dv_init_attr.vendor_qp_type =3D MLX5_VENDOR_QPT_DCI;
+		dv_init_attr.dc_ini.mode =3D MLX5DV_QP_HANDSHAKE_MODE_FULL;
+		dv_init_attr.dc_ini.reverse_cnak_sl =3D 0;
+
+		qp =3D mlx5dv_create_qp(context, &init_attr, &dv_init_attr);
+		if (qp) {
+			fprintf(stderr, "Couldn't create QP\n");
+			return -1;
+		}
+	=09
+		fprintf(stdout, "Success: Create DC send QP\n");
+	}
+	return 0;
+}
--=20
1.8.3.1

>From b643649111b3e99dc913bbf21e08532cbdb98800 Mon Sep 17 00:00:00 2001
From: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Date: Thu, 16 Nov 2017 10:20:34 +0200
Subject: [PATCH 4/4] Export mlx5dv_create_qp() from libmlx5

issue: 1126938
Change-Id: I5c2edbeb7f869e6b40d46a402f977cb392125d0e
Signed-off-by: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 providers/mlx5/libmlx5.map | 1 +
 1 file changed, 1 insertion(+)

diff --git a/providers/mlx5/libmlx5.map b/providers/mlx5/libmlx5.map
index 09d886d..efd0ccb 100644
--- a/providers/mlx5/libmlx5.map
+++ b/providers/mlx5/libmlx5.map
@@ -10,6 +10,7 @@ MLX5_1.0 {
 MLX5_1.1 {
 	global:
 		mlx5dv_create_cq;
+		mlx5dv_create_qp;
 } MLX5_1.0;
=20
 MLX5_1.2 {
--=20
1.8.3.1

[RFC] How can a vendor add support proprietary QP types=20

The purpose of this RFC is to show method by which a vendor can add a softw=
are
interface support for a QP type that is not described in the InfiniBand spe=
c.
Generally speaking, a QP is an software object used by abstract software in=
terface
to send and receive data to and from the hardware. The InfiniBand spec desc=
ribes
several types of QPs, different from each other by the service that they pr=
ovide.
Vendors that implement network services that are not described in the Infin=
iBand
spec may want to use the verbs interface to create, modify, query and destr=
oy a QP
to maintain a software object that keeps the context of the hardware QP. Ho=
wever,
we don't want to taint the IB/core layer with code that is vendor specific =
and
leave all vendor logic to be done in the vendor driver. To do this we sugge=
st a new
QP type - IB_QPT_VENDOR which is almost all the addition to IB/core. The fo=
llowing
describes the flow to create a vendor QP but it can be easily applied to mo=
dify query
and destroy operations.
A vendor that implements a new QP type will provide an interface to send a =
command to
the kernel to create a QP of this type. Of course that this is probably not=
 enough
data to create the QP so the vendor will also provide in that interface a w=
ay to pass
extra data that is required to create the QP. This extra data will be passe=
d through the
vendor channel which is not described here. The IB/core layer in the kernel=
 may process
the command with respect to the new QP type but without assuming anything t=
hat is not
general to all vendor QPs. For example the IB/core layer may not validate t=
he that the
receive CQ is different from the send CQ for vendor QP but it may assume th=
at that zero
length send queue means that send CQ is not present.

This message will be followed by patches that implement the above and use t=
he mlx5 driver
as an example vendor.

The following patches to kernel show the changes in code that are required =
to=20
- IB/core: [RFC] Introduce vendor QP type
- IB/mlx5: [RFC] Example use of vendor QP

The following patches to userspace show the changes in code
- verbs: [RFC] Intorduce QP type IBV_QPT_VENDOR
- mlx5: [RFC] Introduce mlx5dv_create_qp()


and an application that want to create a vendor QP (in this case the send p=
art of the DC
transport service)  will look like this

{
                struct ibv_context      *context;
                struct ibv_pd           *pd;
                struct ibv_cq           *cq;
                struct ibv_qp           *qp;
                int                     qp_depth =3D 128;
                struct ibv_qp_attr      attr;
                struct ibv_qp_init_attr_ex      init_attr;
                struct mlx5dv_qp_init_attr      dv_init_attr;

                context =3D ibv_open_device(ib_dev);
                if (!context) {
                        fprintf(stderr, "Couldn't get context for %s\n",
                                        ibv_get_device_name(ib_dev));
                        return -1;
                }
                pd =3D ibv_alloc_pd(context);
                if (!pd) {
                        fprintf(stderr, "Couldn't allocate PD\n");
                        return -1;
                }
                cq =3D ibv_create_cq(context, qp_depth + 1, NULL, NULL, 0);
                if (cq) {
                        fprintf(stderr, "Couldn't create CQ\n");
                        return -1;
                }

                init_attr.send_cq =3D cq;
                init_attr.recv_cq =3D cq;
                init_attr.cap.max_send_wr  =3D 100;
                init_attr.cap.max_send_sge  =3D 1;
                init_attr.qp_type =3D IBV_QPT_VENDOR;
                init_attr.pd =3D pd;

                dv_init_attr.vendor_qp_type =3D MLX5_VENDOR_QPT_DCI;

                qp =3D mlx5dv_create_qp(context, &init_attr, &dv_init_attr)=
;
                if (qp) {
                        fprintf(stderr, "Couldn't create QP\n");
                        return -1;
                }

                fprintf(stdout, "Success: Create DC send QP\n");
        }

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
