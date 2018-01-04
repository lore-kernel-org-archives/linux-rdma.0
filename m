From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next v2 04/14] IB/mlx5: Reduce the use of num_port capability
Date: Thu,  4 Jan 2018 17:25:34 +0200
Message-ID: <20180104152544.28919-5-leon@kernel.org>
References: <20180104152544.28919-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180104152544.28919-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Remove use of the num_ports general capability throughout. The number of
ports will be variable in the future, and reported in a different way.

Signed-off-by: Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/hw/mlx5/mad.c  |  2 +-
 drivers/infiniband/hw/mlx5/main.c | 16 ++++++++--------
 drivers/infiniband/hw/mlx5/qp.c   |  5 ++---
 3 files changed, 11 insertions(+), 12 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/mad.c b/drivers/infiniband/hw/mlx5/mad.c
index 1003b0133a49..0559e0a9e398 100644
--- a/drivers/infiniband/hw/mlx5/mad.c
+++ b/drivers/infiniband/hw/mlx5/mad.c
@@ -519,7 +519,7 @@ int mlx5_query_mad_ifc_port(struct ib_device *ibdev, u8 port,
 	int ext_active_speed;
 	int err = -ENOMEM;
 
-	if (port < 1 || port > MLX5_CAP_GEN(mdev, num_ports)) {
+	if (port < 1 || port > dev->num_ports) {
 		mlx5_ib_warn(dev, "invalid port number %d\n", port);
 		return -EINVAL;
 	}
diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index 675144a20f95..0c24cd42b411 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -1512,7 +1512,7 @@ static struct ib_ucontext *mlx5_ib_alloc_ucontext(struct ib_device *ibdev,
 	mutex_init(&context->db_page_mutex);
 
 	resp.tot_bfregs = req.total_num_bfregs;
-	resp.num_ports = MLX5_CAP_GEN(dev->mdev, num_ports);
+	resp.num_ports = dev->num_ports;
 
 	if (field_avail(typeof(resp), cqe_version, udata->outlen))
 		resp.response_length += sizeof(resp.cqe_version);
@@ -2774,7 +2774,7 @@ static struct ib_flow *mlx5_ib_create_flow(struct ib_qp *qp,
 		return ERR_PTR(-ENOMEM);
 
 	if (domain != IB_FLOW_DOMAIN_USER ||
-	    flow_attr->port > MLX5_CAP_GEN(dev->mdev, num_ports) ||
+	    flow_attr->port > dev->num_ports ||
 	    (flow_attr->flags & ~IB_FLOW_ATTR_FLAGS_DONT_TRAP))
 		return ERR_PTR(-EINVAL);
 
@@ -3122,7 +3122,7 @@ static int set_has_smi_cap(struct mlx5_ib_dev *dev)
 	int err;
 	int port;
 
-	for (port = 1; port <= MLX5_CAP_GEN(dev->mdev, num_ports); port++) {
+	for (port = 1; port <= dev->num_ports; port++) {
 		dev->mdev->port_caps[port - 1].has_smi = false;
 		if (MLX5_CAP_GEN(dev->mdev, port_type) ==
 		    MLX5_CAP_PORT_TYPE_IB) {
@@ -3149,7 +3149,7 @@ static void get_ext_port_caps(struct mlx5_ib_dev *dev)
 {
 	int port;
 
-	for (port = 1; port <= MLX5_CAP_GEN(dev->mdev, num_ports); port++)
+	for (port = 1; port <= dev->num_ports; port++)
 		mlx5_query_ext_port_caps(dev, port);
 }
 
@@ -3179,7 +3179,7 @@ static int get_port_caps(struct mlx5_ib_dev *dev)
 		goto out;
 	}
 
-	for (port = 1; port <= MLX5_CAP_GEN(dev->mdev, num_ports); port++) {
+	for (port = 1; port <= dev->num_ports; port++) {
 		memset(pprops, 0, sizeof(*pprops));
 		err = mlx5_ib_query_port(&dev->ib_dev, port, pprops);
 		if (err) {
@@ -4061,7 +4061,7 @@ static int mlx5_ib_stage_init_init(struct mlx5_ib_dev *dev)
 	const char *name;
 	int err;
 
-	dev->port = kcalloc(MLX5_CAP_GEN(mdev, num_ports), sizeof(*dev->port),
+	dev->port = kcalloc(dev->num_ports, sizeof(*dev->port),
 			    GFP_KERNEL);
 	if (!dev->port)
 		return -ENOMEM;
@@ -4083,8 +4083,7 @@ static int mlx5_ib_stage_init_init(struct mlx5_ib_dev *dev)
 	dev->ib_dev.owner		= THIS_MODULE;
 	dev->ib_dev.node_type		= RDMA_NODE_IB_CA;
 	dev->ib_dev.local_dma_lkey	= 0 /* not supported for now */;
-	dev->num_ports		= MLX5_CAP_GEN(mdev, num_ports);
-	dev->ib_dev.phys_port_cnt     = dev->num_ports;
+	dev->ib_dev.phys_port_cnt	= dev->num_ports;
 	dev->ib_dev.num_comp_vectors    =
 		dev->mdev->priv.eq_table.num_comp_vectors;
 	dev->ib_dev.dev.parent		= &mdev->pdev->dev;
@@ -4443,6 +4442,7 @@ static void *__mlx5_ib_add(struct mlx5_core_dev *mdev,
 		return NULL;
 
 	dev->mdev = mdev;
+	dev->num_ports = MLX5_CAP_GEN(mdev, num_ports);
 
 	for (i = 0; i < MLX5_IB_STAGE_MAX; i++) {
 		if (profile->stage[i].init) {
diff --git a/drivers/infiniband/hw/mlx5/qp.c b/drivers/infiniband/hw/mlx5/qp.c
index f59de13b657e..4b08472cf0ba 100644
--- a/drivers/infiniband/hw/mlx5/qp.c
+++ b/drivers/infiniband/hw/mlx5/qp.c
@@ -3351,7 +3351,7 @@ int mlx5_ib_modify_qp(struct ib_qp *ibqp, struct ib_qp_attr *attr,
 
 	if ((attr_mask & IB_QP_PORT) &&
 	    (attr->port_num == 0 ||
-	     attr->port_num > MLX5_CAP_GEN(dev->mdev, num_ports))) {
+	     attr->port_num > dev->num_ports)) {
 		mlx5_ib_dbg(dev, "invalid port number %d. number of ports is %d\n",
 			    attr->port_num, dev->num_ports);
 		goto out;
@@ -4670,14 +4670,13 @@ static void to_rdma_ah_attr(struct mlx5_ib_dev *ibdev,
 			    struct rdma_ah_attr *ah_attr,
 			    struct mlx5_qp_path *path)
 {
-	struct mlx5_core_dev *dev = ibdev->mdev;
 
 	memset(ah_attr, 0, sizeof(*ah_attr));
 
 	ah_attr->type = rdma_ah_find_type(&ibdev->ib_dev, path->port);
 	rdma_ah_set_port_num(ah_attr, path->port);
 	if (rdma_ah_get_port_num(ah_attr) == 0 ||
-	    rdma_ah_get_port_num(ah_attr) > MLX5_CAP_GEN(dev, num_ports))
+	    rdma_ah_get_port_num(ah_attr) > ibdev->num_ports)
 		return;
 
 	rdma_ah_set_port_num(ah_attr, path->port);
-- 
2.15.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
