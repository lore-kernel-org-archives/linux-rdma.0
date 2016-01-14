From: Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH v1 07/13] IB/mlx5: Allocate a Transport Domain for each ucontext
Date: Thu, 14 Jan 2016 19:13:02 +0200
Message-ID: <1452791588-19895-8-git-send-email-majd@mellanox.com>
References: <1452791588-19895-1-git-send-email-majd@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1452791588-19895-1-git-send-email-majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, achiad-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, leon-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Transport Domain groups several TIS and TIR object. By grouping
these object, it defines wheather local loopback packets that
are sent from the TIS objects in the group are received by the
TIR objects in the same group.

Allocate a Transport Domain(TD) for each user context to be used
in the future by Raw Packet QP for Self-Loopback Control.

Signed-off-by: Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/hw/mlx5/main.c    | 16 +++++++++++++++-
 drivers/infiniband/hw/mlx5/mlx5_ib.h |  3 +++
 2 files changed, 18 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index c874c09..588ac99 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -941,6 +941,13 @@ static struct ib_ucontext *mlx5_ib_alloc_ucontext(struct ib_device *ibdev,
 	context->ibucontext.invalidate_range = &mlx5_ib_invalidate_range;
 #endif
 
+	if (MLX5_CAP_GEN(dev->mdev, log_max_transport_domain)) {
+		err = mlx5_core_alloc_transport_domain(dev->mdev,
+						       &context->tdn);
+		if (err)
+			goto out_uars;
+	}
+
 	INIT_LIST_HEAD(&context->db_page_list);
 	mutex_init(&context->db_page_mutex);
 
@@ -963,7 +970,7 @@ static struct ib_ucontext *mlx5_ib_alloc_ucontext(struct ib_device *ibdev,
 
 	err = ib_copy_to_udata(udata, &resp, resp.response_length);
 	if (err)
-		goto out_uars;
+		goto out_td;
 
 	uuari->ver = ver;
 	uuari->num_low_latency_uuars = req.num_low_latency_uuars;
@@ -973,6 +980,10 @@ static struct ib_ucontext *mlx5_ib_alloc_ucontext(struct ib_device *ibdev,
 
 	return &context->ibucontext;
 
+out_td:
+	if (MLX5_CAP_GEN(dev->mdev, log_max_transport_domain))
+		mlx5_core_dealloc_transport_domain(dev->mdev, context->tdn);
+
 out_uars:
 	for (i--; i >= 0; i--)
 		mlx5_cmd_free_uar(dev->mdev, uars[i].index);
@@ -997,6 +1008,9 @@ static int mlx5_ib_dealloc_ucontext(struct ib_ucontext *ibcontext)
 	struct mlx5_uuar_info *uuari = &context->uuari;
 	int i;
 
+	if (MLX5_CAP_GEN(dev->mdev, log_max_transport_domain))
+		mlx5_core_dealloc_transport_domain(dev->mdev, context->tdn);
+
 	for (i = 0; i < uuari->num_uars; i++) {
 		if (mlx5_cmd_free_uar(dev->mdev, uuari->uars[i].index))
 			mlx5_ib_warn(dev, "failed to free UAR 0x%x\n", uuari->uars[i].index);
diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw/mlx5/mlx5_ib.h
index a6a57de..2ccc3d9 100644
--- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
+++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
@@ -42,6 +42,7 @@
 #include <linux/mlx5/qp.h>
 #include <linux/mlx5/srq.h>
 #include <linux/types.h>
+#include <linux/mlx5/transobj.h>
 
 #define mlx5_ib_dbg(dev, format, arg...)				\
 pr_debug("%s:%s:%d:(pid %d): " format, (dev)->ib_dev.name, __func__,	\
@@ -110,6 +111,8 @@ struct mlx5_ib_ucontext {
 	struct mutex		db_page_mutex;
 	struct mlx5_uuar_info	uuari;
 	u8			cqe_version;
+	/* Transport Domain number */
+	u32			tdn;
 };
 
 static inline struct mlx5_ib_ucontext *to_mucontext(struct ib_ucontext *ibucontext)
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
