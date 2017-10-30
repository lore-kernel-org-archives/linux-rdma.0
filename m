From: Alex Margolin <alexma-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [RFC] Vendor-specific QPs
Date: Mon, 30 Oct 2017 15:23:24 +0000
Message-ID: <VI1PR05MB12784029D1DE2689A8194A58B9590@VI1PR05MB1278.eurprd05.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

The Problem
-----------
There is a need for QPs different from the Infiniband specification, and Dy=
namically-Connected (DC) QP is one such example.
Since it is not in the spec, we need a way to extend the provider to suppor=
t such QPs without the restrictions of the IB core, such as the QP state-ma=
chine (DC does not adhere to the same state model) or the checking of flag =
parameter correctness (to allow for custom flags).

Proposed Solution
-----------------
We propose using the "reserved" range of QP types to serve the vendor-speci=
fic implementation, both within the Verbs API (API patch below) and the IB =
subsystem (ib_core). The solution requires minor changes to IB core, namely=
 removing some restrictions that apply to standard QPs at creation, but mos=
t of the flow (and the one for modify and destroy) remains identical.

The changes to support such QPs will remain in the vendor-specific area of =
the API, i.e. Mellanox "Direct Verbs" portion, and the change in ib_core is=
 to use specific IB_QPT_RESERVED* definitions to cut through some of the re=
quired checks (but still using most of the logic, where applicable). No cha=
nge to libibverbs is required.

The proposed flow allows the user to create custom QPs using the DV API, an=
d use the resulting objects (struct ibv_qp*) with other verb calls. This QP=
 creation call stack would include (in that order):
1. mlx5_dv_create_qp (Embed arguments in the uhw and use reserved QPT)
2. ibv_cmd_create_qp_ex
3. ib_uverbs_create_qp
4. mlx5_ib_create_qp

This patch demonstrates changes to QP creation only (not modification or de=
struction), but we expect changes will remain inside the provider, and most=
 likely the user could use standard control path (e.g. ibv_modify_qp and ib=
v_destroy_qp) and data path (e.g. ibv_post_send/recv) on DC QPs as well.


Below are patches proposed for IB core and rdma-core, demonstrating the pro=
posed change.


diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core=
/uverbs_cmd.c
index 08d3d22..d7c4293 100644
--- a/drivers/infiniband/core/uverbs_cmd.c
+++ b/drivers/infiniband/core/uverbs_cmd.c
@@ -1535,9 +1535,12 @@ static int create_qp(struct ib_uverbs_file *file,
        }

        if (cmd->qp_type !=3D IB_QPT_XRC_TGT) {
-               ret =3D ib_create_qp_security(qp, device);
-               if (ret)
-                       goto err_cb;
+               if (cmd->qp_type !=3D IB_QPT_RESERVED3 &&
+                   cmd->qp_type !=3D IB_QPT_RESERVED4) {
+                       ret =3D ib_create_qp_security(qp, device);
+                       if (ret)
+                               goto err_cb;
+               }

                qp->real_qp       =3D qp;
                qp->device        =3D device;
diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw/m=
lx5/mlx5_ib.h
index e1a3cb8..8d922e4 100644
--- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
+++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
@@ -193,6 +193,8 @@ struct mlx5_ib_flow_db {
#define MLX5_IB_SEND_UMR_UPDATE_PD_ACCESS       IB_SEND_RESERVED_END

#define MLX5_IB_QPT_REG_UMR    IB_QPT_RESERVED1
+#define MLX5_IB_QPT_DC_INI     IB_QPT_RESERVED3
+#define MLX5_IB_QPT_DC_TGT     IB_QPT_RESERVED4
/*
  * IB_QPT_GSI creates the software wrapper around GSI, and MLX5_IB_QPT_HW_=
GSI
  * creates the actual hardware QP.




diff --git a/providers/mlx5/mlx5dv.h b/providers/mlx5/mlx5dv.h index 1a2e25=
7..1084124 100644
--- a/providers/mlx5/mlx5dv.h
+++ b/providers/mlx5/mlx5dv.h
@@ -54,6 +54,16 @@ enum {
 	MLX5_SND_DBR	=3D 1,
 };
=20
+enum mlx5dv_qp_type {
+    MLX5DV_QPT_DC_SEND =3D IB_QPT_RESERVED3,
+    MLX5DV_QPT_DC_RECV =3D IB_QPT_RESERVED4
+};
+
+enum mlx5dv_qp_handshake_mode {
+    MLX5DV_QP_HANDSHAKE_MODE_FULL =3D 0,
+    MLX5DV_QP_HANDSHAKE_MODE_HALF
+};
+
 enum mlx5dv_context_comp_mask {
 	MLX5DV_CONTEXT_MASK_CQE_COMPRESION	=3D 1 << 0,
 	MLX5DV_CONTEXT_MASK_RESERVED		=3D 1 << 1,
@@ -64,6 +74,18 @@ struct mlx5dv_cqe_comp_caps {
 	uint32_t supported_format; /* enum mlx5dv_cqe_comp_res_format */  };
=20
+
+ #define MLX5DV_DC_CAP_FULL_HANDSHAKE  (1 << 0) #define=20
+ MLX5DV_DC_CAP_MAX_RESPONDERS  (1 << 1) #define=20
+ MLX5DV_DC_CAP_CNAK_REVERSE_SL (1 << 2)
+
+struct mlx5dv_dc_caps {
+    uint64_t cap_flags;
+    uint32_t dct_max_responders;
+    uint32_t dc_odp_caps;
+};
+
 /*
  * Direct verbs device-specific attributes
  */
@@ -72,6 +94,7 @@ struct mlx5dv_context {
 	uint64_t	flags;
 	uint64_t	comp_mask;
 	struct mlx5dv_cqe_comp_caps	cqe_comp_caps;
+	struct mlx5dv_dc_caps dc_caps;
 };
=20
 enum mlx5dv_context_flags {
@@ -95,6 +118,50 @@ struct mlx5dv_cq_init_attr {  struct ibv_cq_ex *mlx5dv_=
create_cq(struct ibv_context *context,
 				   struct ibv_cq_init_attr_ex *cq_attr,
 				   struct mlx5dv_cq_init_attr *mlx5_cq_attr);
+
+struct mlx5dv_qp_init_attr {
+    uint32_t comp_mask;
+    union {
+        struct {
+            enum mlx5dv_qp_handshake_mode mode;
+            uint8_t  reverse_cnak_sl;
+        } dc_send;
+        struct {
+            enum mlx5dv_qp_handshake_mode mode;
+            uint64_t dc_key;
+            uint32_t min_responders;
+            uint32_t max_responders;
+        } dc_recv;
+    };
+};
+
+struct ibv_qp *mlx5dv_create_qp(struct ibv_context *context,
+                                struct ibv_qp_init_attr_ex *qp_init_attr_e=
x,
+                                struct mlx5dv_qp_init_attr=20
+*mlx5_qp_init_attr);
+
+struct mlx5dv_send_wr {
+    uint32_t comp_mask;
+    union {
+        struct {
+            struct ibv_ah  *ah;
+            uint32_t    remote_qpn;
+            uint32_t    remote_qkey;
+            uint64_t    remote_dc_key;
+            uint8_t     reverse_data_sl;
+        } dc_send;
+    };
+};
+
+struct mlx5dv_send_wr {
+    struct mlx5dv_send_wr *next;
+    struct mlx5dv_vendor_send_wr *mlx_wr;
+    struct ibv_send_wr ibv_wr;
+};
+
+int mlx5dv_post_send(struct ibv_qp *qp,
+                     struct mlx5dv_send_wr *mlx5_wr,
+                     struct mlx5dv_send_wr **bad_wr);
+
 /*
  * Most device capabilities are exported by ibv_query_device(...),
  * but there is HW device-specific information which is important

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
