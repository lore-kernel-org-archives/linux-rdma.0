From: Leon Romanovsky <leon@kernel.org>
Subject: [PATCH rdma-next 11/12] RDMA/mlx5: Move to single device multiport ports in switchdev mode
Date: Thu, 28 Mar 2019 15:27:41 +0200
Message-ID: <20190328132742.12070-12-leon@kernel.org>
References: <20190328132742.12070-1-leon@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20190328132742.12070-1-leon@kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>
Cc: Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Maor Gottlieb <maorg@mellanox.com>, Mark Bloch <markb@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

From: Mark Bloch <markb@mellanox.com>

Move from IB device (representor) per virtual function to single IB device
with port per virtual function (port 1 represents the uplink). As number
of ports is a static property of an IB device, declare the IB device with
as many port as the possible according to the PCI bus.

Signed-off-by: Mark Bloch <markb@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/infiniband/hw/mlx5/ib_rep.c  | 31 +++++++++++++++++++++++-----
 drivers/infiniband/hw/mlx5/main.c    | 26 +++++++++++++++++++----
 drivers/infiniband/hw/mlx5/mlx5_ib.h |  1 +
 3 files changed, 49 insertions(+), 9 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/ib_rep.c b/drivers/infiniband/hw/mlx5/ib_rep.c
index 7946cf26421b..224ef6c88d17 100644
--- a/drivers/infiniband/hw/mlx5/ib_rep.c
+++ b/drivers/infiniband/hw/mlx5/ib_rep.c
@@ -46,17 +46,36 @@ static const struct mlx5_ib_profile vf_rep_profile = {
 		     NULL),
 };
 
+static int
+mlx5_ib_set_vport_rep(struct mlx5_core_dev *dev, struct mlx5_eswitch_rep *rep)
+{
+	struct mlx5_ib_dev *ibdev;
+	int vport_index;
+
+	ibdev = mlx5_ib_get_uplink_ibdev(dev->priv.eswitch);
+	vport_index = ibdev->free_port++;
+
+	ibdev->port[vport_index].rep = rep;
+	write_lock(&ibdev->port[vport_index].roce.netdev_lock);
+	ibdev->port[vport_index].roce.netdev =
+		mlx5_ib_get_rep_netdev(dev->priv.eswitch, rep->vport);
+	write_unlock(&ibdev->port[vport_index].roce.netdev_lock);
+
+	return 0;
+}
+
 static int
 mlx5_ib_vport_rep_load(struct mlx5_core_dev *dev, struct mlx5_eswitch_rep *rep)
 {
+	int num_ports = MLX5_TOTAL_VPORTS(dev);
 	const struct mlx5_ib_profile *profile;
 	struct mlx5_ib_dev *ibdev;
-	int num_ports = 1;
+	int vport_index;
 
 	if (rep->vport == MLX5_VPORT_UPLINK)
 		profile = &uplink_rep_profile;
 	else
-		profile = &vf_rep_profile;
+		return mlx5_ib_set_vport_rep(dev, rep);
 
 	ibdev = ib_alloc_device(mlx5_ib_dev, ib_dev);
 	if (!ibdev)
@@ -70,8 +89,9 @@ mlx5_ib_vport_rep_load(struct mlx5_core_dev *dev, struct mlx5_eswitch_rep *rep)
 	}
 
 	ibdev->is_rep = true;
-	ibdev->port[0].rep = rep;
-	ibdev->port[0].roce.netdev =
+	vport_index = ibdev->free_port++;
+	ibdev->port[vport_index].rep = rep;
+	ibdev->port[vport_index].roce.netdev =
 		mlx5_ib_get_rep_netdev(dev->priv.eswitch, rep->vport);
 	ibdev->mdev = dev;
 	ibdev->num_ports = num_ports;
@@ -89,7 +109,8 @@ mlx5_ib_vport_rep_unload(struct mlx5_eswitch_rep *rep)
 {
 	struct mlx5_ib_dev *dev;
 
-	if (!rep->rep_if[REP_IB].priv)
+	if (!rep->rep_if[REP_IB].priv ||
+	    rep->vport != MLX5_VPORT_UPLINK)
 		return;
 
 	dev = mlx5_ib_rep_to_dev(rep);
diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index 7eca3978c50c..57d269c1b874 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -506,9 +506,14 @@ static int mlx5_query_port_roce(struct ib_device *device, u8 port_num,
 
 	/* Possible bad flows are checked before filling out props so in case
 	 * of an error it will still be zeroed out.
+	 * Use native port in case of reps
 	 */
-	err = mlx5_query_port_ptys(mdev, out, sizeof(out), MLX5_PTYS_EN,
-				   mdev_port_num);
+	if (dev->is_rep)
+		err = mlx5_query_port_ptys(mdev, out, sizeof(out), MLX5_PTYS_EN,
+					   1);
+	else
+		err = mlx5_query_port_ptys(mdev, out, sizeof(out), MLX5_PTYS_EN,
+					   mdev_port_num);
 	if (err)
 		goto out;
 	ext = MLX5_CAP_PCAM_FEATURE(dev->mdev, ptys_extended_ethernet);
@@ -1432,7 +1437,9 @@ static int mlx5_ib_rep_query_port(struct ib_device *ibdev, u8 port,
 {
 	int ret;
 
-	/* Only link layer == ethernet is valid for representors */
+	/* Only link layer == ethernet is valid for representors
+	 * and we always use port 1
+	 */
 	ret = mlx5_query_port_roce(ibdev, port, props);
 	if (ret || !props)
 		return ret;
@@ -4565,7 +4572,7 @@ static void get_ext_port_caps(struct mlx5_ib_dev *dev)
 		mlx5_query_ext_port_caps(dev, port);
 }
 
-static int get_port_caps(struct mlx5_ib_dev *dev, u8 port)
+static int __get_port_caps(struct mlx5_ib_dev *dev, u8 port)
 {
 	struct ib_device_attr *dprops = NULL;
 	struct ib_port_attr *pprops = NULL;
@@ -4608,6 +4615,16 @@ static int get_port_caps(struct mlx5_ib_dev *dev, u8 port)
 	return err;
 }
 
+static int get_port_caps(struct mlx5_ib_dev *dev, u8 port)
+{
+	/* For representors use port 1, is this is the only native
+	 * port
+	 */
+	if (dev->is_rep)
+		return __get_port_caps(dev, 1);
+	return __get_port_caps(dev, port);
+}
+
 static void destroy_umrc_res(struct mlx5_ib_dev *dev)
 {
 	int err;
@@ -6268,6 +6285,7 @@ static int mlx5_ib_stage_common_roce_init(struct mlx5_ib_dev *dev)
 
 	port_num = mlx5_core_native_port_num(dev->mdev) - 1;
 
+	/* Register only for native ports */
 	return mlx5_add_netdev_notifier(dev, port_num);
 }
 
diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw/mlx5/mlx5_ib.h
index 885f87d0a3f9..7daa20102b1d 100644
--- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
+++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
@@ -956,6 +956,7 @@ struct mlx5_ib_dev {
 	u16			devx_whitelist_uid;
 	struct mlx5_srq_table   srq_table;
 	struct mlx5_async_ctx   async_ctx;
+	int			free_port;
 };
 
 static inline struct mlx5_ib_cq *to_mibcq(struct mlx5_core_cq *mcq)
-- 
2.20.1
