From: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-next 05/10] IB/mlx5: Create GSI transmission QPs when P_Key table is changed
Date: Mon, 29 Feb 2016 15:45:07 +0200
Message-ID: <1456753512-17688-6-git-send-email-haggaie@mellanox.com>
References: <1456753512-17688-1-git-send-email-haggaie@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1456753512-17688-1-git-send-email-haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Whenever the P_Key table is changed, we create the required GSI
transmission QPs on-demand.

Reviewed-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/hw/mlx5/gsi.c     | 10 ++++++++++
 drivers/infiniband/hw/mlx5/main.c    | 28 ++++++++++++++++++++++++++++
 drivers/infiniband/hw/mlx5/mlx5_ib.h |  3 +++
 3 files changed, 41 insertions(+)

diff --git a/drivers/infiniband/hw/mlx5/gsi.c b/drivers/infiniband/hw/mlx5/gsi.c
index 91bd20eb59b7..1648f539c836 100644
--- a/drivers/infiniband/hw/mlx5/gsi.c
+++ b/drivers/infiniband/hw/mlx5/gsi.c
@@ -341,3 +341,13 @@ int mlx5_ib_gsi_post_recv(struct ib_qp *qp, struct ib_recv_wr *wr,
 
 	return ib_post_recv(gsi->rx_qp, wr, bad_wr);
 }
+
+void mlx5_ib_gsi_pkey_change(struct mlx5_ib_gsi_qp *gsi)
+{
+	if (!gsi)
+		return;
+
+	mutex_lock(&gsi->mutex);
+	setup_qps(gsi);
+	mutex_unlock(&gsi->mutex);
+}
diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index a2a16db62b5e..3fbc257ba5e2 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -1716,6 +1716,17 @@ static struct device_attribute *mlx5_class_attributes[] = {
 	&dev_attr_reg_pages,
 };
 
+static void pkey_change_handler(struct work_struct *work)
+{
+	struct mlx5_ib_port_resources *ports =
+		container_of(work, struct mlx5_ib_port_resources,
+			     pkey_change_work);
+
+	mutex_lock(&ports->devr->mutex);
+	mlx5_ib_gsi_pkey_change(ports->gsi);
+	mutex_unlock(&ports->devr->mutex);
+}
+
 static void mlx5_ib_event(struct mlx5_core_dev *dev, void *context,
 			  enum mlx5_dev_event event, unsigned long param)
 {
@@ -1752,6 +1763,8 @@ static void mlx5_ib_event(struct mlx5_core_dev *dev, void *context,
 	case MLX5_DEV_EVENT_PKEY_CHANGE:
 		ibev.event = IB_EVENT_PKEY_CHANGE;
 		port = (u8)param;
+
+		schedule_work(&ibdev->devr.ports[port - 1].pkey_change_work);
 		break;
 
 	case MLX5_DEV_EVENT_GUID_CHANGE:
@@ -1961,6 +1974,7 @@ static int create_dev_resources(struct mlx5_ib_resources *devr)
 	struct ib_srq_init_attr attr;
 	struct mlx5_ib_dev *dev;
 	struct ib_cq_init_attr cq_attr = {.cqe = 1};
+	int port;
 	int ret = 0;
 
 	dev = container_of(devr, struct mlx5_ib_dev, devr);
@@ -2054,6 +2068,12 @@ static int create_dev_resources(struct mlx5_ib_resources *devr)
 	atomic_inc(&devr->p0->usecnt);
 	atomic_set(&devr->s0->usecnt, 0);
 
+	for (port = 0; port < ARRAY_SIZE(devr->ports); ++port) {
+		INIT_WORK(&devr->ports[port].pkey_change_work,
+			  pkey_change_handler);
+		devr->ports[port].devr = devr;
+	}
+
 	return 0;
 
 error5:
@@ -2072,12 +2092,20 @@ error0:
 
 static void destroy_dev_resources(struct mlx5_ib_resources *devr)
 {
+	struct mlx5_ib_dev *dev =
+		container_of(devr, struct mlx5_ib_dev, devr);
+	int port;
+
 	mlx5_ib_destroy_srq(devr->s1);
 	mlx5_ib_destroy_srq(devr->s0);
 	mlx5_ib_dealloc_xrcd(devr->x0);
 	mlx5_ib_dealloc_xrcd(devr->x1);
 	mlx5_ib_destroy_cq(devr->c0);
 	mlx5_ib_dealloc_pd(devr->p0);
+
+	/* Make sure no change P_Key work items are still executing */
+	for (port = 0; port < dev->num_ports; ++port)
+		cancel_work_sync(&devr->ports[port].pkey_change_work);
 }
 
 static u32 get_core_cap_flags(struct ib_device *ibdev)
diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw/mlx5/mlx5_ib.h
index 81af9842ab29..640840dfc4f4 100644
--- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
+++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
@@ -509,7 +509,9 @@ struct mlx5_mr_cache {
 struct mlx5_ib_gsi_qp;
 
 struct mlx5_ib_port_resources {
+	struct mlx5_ib_resources *devr;
 	struct mlx5_ib_gsi_qp *gsi;
+	struct work_struct pkey_change_work;
 };
 
 struct mlx5_ib_resources {
@@ -780,6 +782,7 @@ int mlx5_ib_gsi_post_send(struct ib_qp *qp, struct ib_send_wr *wr,
 			  struct ib_send_wr **bad_wr);
 int mlx5_ib_gsi_post_recv(struct ib_qp *qp, struct ib_recv_wr *wr,
 			  struct ib_recv_wr **bad_wr);
+void mlx5_ib_gsi_pkey_change(struct mlx5_ib_gsi_qp *gsi);
 
 static inline void init_query_mad(struct ib_smp *mad)
 {
-- 
1.7.11.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
