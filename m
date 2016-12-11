From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [RFC ABI V6 12/14] IB/{core,mlx5}: Support uhw definition per driver
Date: Sun, 11 Dec 2016 14:58:06 +0200
Message-ID: <1481461088-56355-13-git-send-email-matanb@mellanox.com>
References: <1481461088-56355-1-git-send-email-matanb@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1481461088-56355-1-git-send-email-matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Instead of supporting a generic unknown size of the uhw (driver
specific uhw_in and uhw_out) parameters via the common attributes,
declare the sizes specific to each driver in a driver specific tree.

When we initialize the parsing tree, this tree is merged with the
common parsing tree, creating this driver specific tree.
This tree could add driver specific types, actions and other
attributes as well.
We propose creating way of passing the merged parsing tree to the
user-space. By that, a user-space could query which features are
supported by the driver.

Signed-off-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/core/uverbs_ioctl_cmd.c | 21 +++------
 drivers/infiniband/hw/mlx5/Makefile        |  2 +-
 drivers/infiniband/hw/mlx5/main.c          |  2 +
 drivers/infiniband/hw/mlx5/mlx5_ib.h       |  2 +
 drivers/infiniband/hw/mlx5/uverbs_tree.c   | 68 ++++++++++++++++++++++++++++++
 5 files changed, 80 insertions(+), 15 deletions(-)
 create mode 100644 drivers/infiniband/hw/mlx5/uverbs_tree.c

diff --git a/drivers/infiniband/core/uverbs_ioctl_cmd.c b/drivers/infiniband/core/uverbs_ioctl_cmd.c
index 5ab6189..ef620b4 100644
--- a/drivers/infiniband/core/uverbs_ioctl_cmd.c
+++ b/drivers/infiniband/core/uverbs_ioctl_cmd.c
@@ -978,8 +978,7 @@ DECLARE_UVERBS_TYPE(uverbs_type_cq,
 		    &UVERBS_ACTIONS(
 			ADD_UVERBS_ACTION(UVERBS_CQ_CREATE,
 					  uverbs_create_cq_handler,
-					  &uverbs_create_cq_spec,
-					  &uverbs_uhw_compat_spec)));
+					  &uverbs_create_cq_spec)));
 
 DECLARE_UVERBS_TYPE(uverbs_type_qp,
 		    /* 1 is used in order to free the MR after all the MWs */
@@ -988,15 +987,13 @@ DECLARE_UVERBS_TYPE(uverbs_type_qp,
 		    &UVERBS_ACTIONS(
 			ADD_UVERBS_ACTION(UVERBS_QP_CREATE,
 					  uverbs_create_qp_handler,
-					  &uverbs_create_qp_spec,
-					  &uverbs_uhw_compat_spec),
+					  &uverbs_create_qp_spec),
 			ADD_UVERBS_ACTION(UVERBS_QP_CREATE_XRC_TGT,
 					  uverbs_create_qp_xrc_tgt_handler,
 					  &uverbs_create_qp_xrc_tgt_spec),
 			ADD_UVERBS_ACTION(UVERBS_QP_MODIFY,
 					  uverbs_modify_qp_handler,
-					  &uverbs_modify_qp_spec,
-					  &uverbs_uhw_compat_spec)),
+					  &uverbs_modify_qp_spec)),
 );
 
 DECLARE_UVERBS_TYPE(uverbs_type_mw,
@@ -1009,8 +1006,7 @@ DECLARE_UVERBS_TYPE(uverbs_type_mr,
 		    &UVERBS_TYPE_ALLOC_IDR(1, uverbs_free_mr),
 		    &UVERBS_ACTIONS(
 			ADD_UVERBS_ACTION(UVERBS_MR_REG, uverbs_reg_mr_handler,
-					  &uverbs_reg_mr_spec,
-					  &uverbs_uhw_compat_spec),
+					  &uverbs_reg_mr_spec),
 			ADD_UVERBS_ACTION(UVERBS_MR_DEREG,
 					  uverbs_dereg_mr_handler,
 					  &uverbs_dereg_mr_spec)));
@@ -1054,19 +1050,16 @@ DECLARE_UVERBS_TYPE(uverbs_type_pd,
 		    &UVERBS_ACTIONS(
 			ADD_UVERBS_ACTION(UVERBS_PD_ALLOC,
 					  uverbs_alloc_pd_handler,
-					  &uverbs_alloc_pd_spec,
-					  &uverbs_uhw_compat_spec)));
+					  &uverbs_alloc_pd_spec)));
 
 DECLARE_UVERBS_TYPE(uverbs_type_device, NULL,
 		    &UVERBS_ACTIONS(
 			ADD_UVERBS_CTX_ACTION(UVERBS_DEVICE_ALLOC_CONTEXT,
 					      uverbs_get_context,
-					      &uverbs_get_context_spec,
-					      &uverbs_uhw_compat_spec),
+					      &uverbs_get_context_spec),
 			ADD_UVERBS_ACTION(UVERBS_DEVICE_QUERY,
 					  &uverbs_query_device_handler,
-					  &uverbs_query_device_spec,
-					  &uverbs_uhw_compat_spec)));
+					  &uverbs_query_device_spec)));
 
 DECLARE_UVERBS_TYPES(uverbs_common_types,
 		     ADD_UVERBS_TYPE(UVERBS_TYPE_DEVICE, uverbs_type_device),
diff --git a/drivers/infiniband/hw/mlx5/Makefile b/drivers/infiniband/hw/mlx5/Makefile
index 7493a83..aa035bb 100644
--- a/drivers/infiniband/hw/mlx5/Makefile
+++ b/drivers/infiniband/hw/mlx5/Makefile
@@ -1,4 +1,4 @@
 obj-$(CONFIG_MLX5_INFINIBAND)	+= mlx5_ib.o
 
-mlx5_ib-y :=	main.o cq.o doorbell.o qp.o mem.o srq.o mr.o ah.o mad.o gsi.o ib_virt.o
+mlx5_ib-y :=	main.o cq.o doorbell.o qp.o mem.o srq.o mr.o ah.o mad.o gsi.o ib_virt.o uverbs_tree.o
 mlx5_ib-$(CONFIG_INFINIBAND_ON_DEMAND_PAGING) += odp.o
diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index 4e739e7..26beb6f 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -2931,6 +2931,8 @@ static void *mlx5_ib_add(struct mlx5_core_dev *mdev)
 	static const struct uverbs_root_spec root_spec[] = {
 		[0] = {.types = &uverbs_common_types,
 			.group_id = 0},
+		[1] = {.types = &mlx5_common_types,
+			.group_id = 0},
 	};
 
 	port_type_cap = MLX5_CAP_GEN(mdev, port_type);
diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw/mlx5/mlx5_ib.h
index 1df8a67..bb12c66 100644
--- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
+++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
@@ -45,6 +45,7 @@
 #include <linux/mlx5/transobj.h>
 #include <rdma/ib_user_verbs.h>
 #include <rdma/mlx5-abi.h>
+#include <rdma/uverbs_ioctl.h>
 
 #define mlx5_ib_dbg(dev, format, arg...)				\
 pr_debug("%s:%s:%d:(pid %d): " format, (dev)->ib_dev.name, __func__,	\
@@ -906,6 +907,7 @@ int mlx5_ib_gsi_post_recv(struct ib_qp *qp, struct ib_recv_wr *wr,
 void mlx5_ib_gsi_pkey_change(struct mlx5_ib_gsi_qp *gsi);
 
 int mlx5_ib_generate_wc(struct ib_cq *ibcq, struct ib_wc *wc);
+extern const struct uverbs_type_group mlx5_common_types;
 
 static inline void init_query_mad(struct ib_smp *mad)
 {
diff --git a/drivers/infiniband/hw/mlx5/uverbs_tree.c b/drivers/infiniband/hw/mlx5/uverbs_tree.c
new file mode 100644
index 0000000..704b177
--- /dev/null
+++ b/drivers/infiniband/hw/mlx5/uverbs_tree.c
@@ -0,0 +1,68 @@
+#include <rdma/uverbs_ioctl.h>
+#include <rdma/uverbs_ioctl_cmd.h>
+#include <rdma/mlx5-abi.h>
+#include "mlx5_ib.h"
+
+DECLARE_UVERBS_ATTR_SPEC(
+	mlx5_spec_create_qp,
+	UVERBS_ATTR_PTR_IN_SZ(UVERBS_UHW_IN, 0,
+			      UA_FLAGS(UVERBS_ATTR_SPEC_F_MIN_SZ)),
+	UVERBS_ATTR_PTR_OUT_SZ(UVERBS_UHW_OUT, 0,
+			       UA_FLAGS(UVERBS_ATTR_SPEC_F_MIN_SZ)));
+
+DECLARE_UVERBS_ATTR_SPEC(
+	mlx5_spec_create_cq,
+	UVERBS_ATTR_PTR_IN_SZ(UVERBS_UHW_IN,
+			      offsetof(struct mlx5_ib_create_cq, reserved),
+			      UA_FLAGS(UVERBS_ATTR_SPEC_F_MANDATORY |
+				       UVERBS_ATTR_SPEC_F_MIN_SZ)),
+	UVERBS_ATTR_PTR_OUT(UVERBS_UHW_OUT, __u32,
+			    UA_FLAGS(UVERBS_ATTR_SPEC_F_MANDATORY)));
+
+DECLARE_UVERBS_ATTR_SPEC(
+	mlx5_spec_alloc_pd,
+	UVERBS_ATTR_PTR_OUT(UVERBS_UHW_OUT, struct mlx5_ib_alloc_pd_resp,
+			    UA_FLAGS(UVERBS_ATTR_SPEC_F_MANDATORY)));
+
+DECLARE_UVERBS_ATTR_SPEC(
+	mlx5_spec_device_query,
+	UVERBS_ATTR_PTR_OUT_SZ(UVERBS_UHW_OUT, 0,
+			       UA_FLAGS(UVERBS_ATTR_SPEC_F_MIN_SZ)));
+/* TODO: fix sizes */
+DECLARE_UVERBS_ATTR_SPEC(
+	mlx5_spec_alloc_context,
+	UVERBS_ATTR_PTR_IN(UVERBS_UHW_IN, struct mlx5_ib_alloc_ucontext_req,
+			   UA_FLAGS(UVERBS_ATTR_SPEC_F_MIN_SZ |
+				    UVERBS_ATTR_SPEC_F_MANDATORY)),
+	UVERBS_ATTR_PTR_OUT_SZ(UVERBS_UHW_OUT, 0,
+			       UA_FLAGS(UVERBS_ATTR_SPEC_F_MIN_SZ)));
+
+DECLARE_UVERBS_TYPE(mlx5_type_qp, NULL,
+		    &UVERBS_ACTIONS(
+			ADD_UVERBS_ACTION(UVERBS_QP_CREATE, NULL, NULL,
+					  &mlx5_spec_create_qp)));
+
+DECLARE_UVERBS_TYPE(mlx5_type_cq, NULL,
+		    &UVERBS_ACTIONS(
+			ADD_UVERBS_ACTION(UVERBS_CQ_CREATE, NULL, NULL,
+					  &mlx5_spec_create_cq)));
+
+DECLARE_UVERBS_TYPE(mlx5_type_pd, NULL,
+		    &UVERBS_ACTIONS(
+			ADD_UVERBS_ACTION(UVERBS_PD_ALLOC, NULL, NULL,
+					  &mlx5_spec_alloc_pd)));
+
+DECLARE_UVERBS_TYPE(mlx5_type_device, NULL,
+		    &UVERBS_ACTIONS(
+			ADD_UVERBS_CTX_ACTION(UVERBS_DEVICE_ALLOC_CONTEXT,
+					      NULL, NULL,
+					      &mlx5_spec_alloc_context),
+			ADD_UVERBS_ACTION(UVERBS_DEVICE_QUERY,
+					  NULL, NULL,
+					  &mlx5_spec_device_query)));
+
+DECLARE_UVERBS_TYPES(mlx5_common_types,
+		     ADD_UVERBS_TYPE(UVERBS_TYPE_DEVICE, mlx5_type_device),
+		     ADD_UVERBS_TYPE(UVERBS_TYPE_PD, mlx5_type_pd),
+		     ADD_UVERBS_TYPE(UVERBS_TYPE_CQ, mlx5_type_cq),
+		     ADD_UVERBS_TYPE(UVERBS_TYPE_QP, mlx5_type_qp));
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
