From: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH rdma-rc v2 3/4] IB/mlx5: Remove support for IB_DEVICE_LOCAL_DMA_LKEY
Date: Thu, 24 Sep 2015 10:34:23 +0300
Message-ID: <1443080064-28760-4-git-send-email-sagig@mellanox.com>
References: <1443080064-28760-1-git-send-email-sagig@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1443080064-28760-1-git-send-email-sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Commit 96249d70dd70 ("IB/core: Guarantee that a local_dma_lkey
is available") allows ULPs that make use of the local dma key to keep
working as before by allocating a DMA MR with local permissions and
converted these consumers to use the MR associated with the PD
rather then device->local_dma_lkey.

ConnectIB has some known issues with memory registration
using the local_dma_lkey (SEND, RDMA, RECV seems to work ok).

Thus don't expose support for it (remove device->local_dma_lkey
setting), and take advantage of the above commit such that no regression
is introduced to working systems.

The local_dma_lkey support will be restored in CX4 depending on FW
capability query.

Signed-off-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/hw/mlx5/main.c            | 10 +---------
 drivers/net/ethernet/mellanox/mlx5/core/fw.c | 22 ----------------------
 include/linux/mlx5/device.h                  | 11 -----------
 include/linux/mlx5/driver.h                  |  1 -
 4 files changed, 1 insertion(+), 43 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index 41d6911e244e..0ab9625911a1 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -245,7 +245,6 @@ static int mlx5_ib_query_device(struct ib_device *ibdev,
 		props->device_cap_flags |= IB_DEVICE_BAD_QKEY_CNTR;
 	if (MLX5_CAP_GEN(mdev, apm))
 		props->device_cap_flags |= IB_DEVICE_AUTO_PATH_MIG;
-	props->device_cap_flags |= IB_DEVICE_LOCAL_DMA_LKEY;
 	if (MLX5_CAP_GEN(mdev, xrc))
 		props->device_cap_flags |= IB_DEVICE_XRC;
 	props->device_cap_flags |= IB_DEVICE_MEM_MGT_EXTENSIONS;
@@ -1245,18 +1244,10 @@ static int create_dev_resources(struct mlx5_ib_resources *devr)
 	struct ib_srq_init_attr attr;
 	struct mlx5_ib_dev *dev;
 	struct ib_cq_init_attr cq_attr = {.cqe = 1};
-	u32 rsvd_lkey;
 	int ret = 0;
 
 	dev = container_of(devr, struct mlx5_ib_dev, devr);
 
-	ret = mlx5_core_query_special_context(dev->mdev, &rsvd_lkey);
-	if (ret) {
-		pr_err("Failed to query special context %d\n", ret);
-		return ret;
-	}
-	dev->ib_dev.local_dma_lkey = rsvd_lkey;
-
 	devr->p0 = mlx5_ib_alloc_pd(&dev->ib_dev, NULL, NULL);
 	if (IS_ERR(devr->p0)) {
 		ret = PTR_ERR(devr->p0);
@@ -1418,6 +1409,7 @@ static void *mlx5_ib_add(struct mlx5_core_dev *mdev)
 	strlcpy(dev->ib_dev.name, "mlx5_%d", IB_DEVICE_NAME_MAX);
 	dev->ib_dev.owner		= THIS_MODULE;
 	dev->ib_dev.node_type		= RDMA_NODE_IB_CA;
+	dev->ib_dev.local_dma_lkey	= 0 /* not supported for now */;
 	dev->num_ports		= MLX5_CAP_GEN(mdev, num_ports);
 	dev->ib_dev.phys_port_cnt     = dev->num_ports;
 	dev->ib_dev.num_comp_vectors    =
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fw.c b/drivers/net/ethernet/mellanox/mlx5/core/fw.c
index aa0d5ffe92d8..9335e5ae18cc 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fw.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fw.c
@@ -200,25 +200,3 @@ int mlx5_cmd_teardown_hca(struct mlx5_core_dev *dev)
 
 	return err;
 }
-
-int mlx5_core_query_special_context(struct mlx5_core_dev *dev, u32 *rsvd_lkey)
-{
-	struct mlx5_cmd_query_special_contexts_mbox_in in;
-	struct mlx5_cmd_query_special_contexts_mbox_out out;
-	int err;
-
-	memset(&in, 0, sizeof(in));
-	memset(&out, 0, sizeof(out));
-	in.hdr.opcode = cpu_to_be16(MLX5_CMD_OP_QUERY_SPECIAL_CONTEXTS);
-	err = mlx5_cmd_exec(dev, &in, sizeof(in), &out, sizeof(out));
-	if (err)
-		return err;
-
-	if (out.hdr.status)
-		err = mlx5_cmd_status_to_err(&out.hdr);
-
-	*rsvd_lkey = be32_to_cpu(out.resd_lkey);
-
-	return err;
-}
-EXPORT_SYMBOL(mlx5_core_query_special_context);
diff --git a/include/linux/mlx5/device.h b/include/linux/mlx5/device.h
index 6e4169c5ad78..b943cd9e2097 100644
--- a/include/linux/mlx5/device.h
+++ b/include/linux/mlx5/device.h
@@ -402,17 +402,6 @@ struct mlx5_cmd_teardown_hca_mbox_out {
 	u8			rsvd[8];
 };
 
-struct mlx5_cmd_query_special_contexts_mbox_in {
-	struct mlx5_inbox_hdr	hdr;
-	u8			rsvd[8];
-};
-
-struct mlx5_cmd_query_special_contexts_mbox_out {
-	struct mlx5_outbox_hdr	hdr;
-	__be32                  dump_fill_mkey;
-	__be32                  resd_lkey;
-};
-
 struct mlx5_cmd_layout {
 	u8		type;
 	u8		rsvd0[3];
diff --git a/include/linux/mlx5/driver.h b/include/linux/mlx5/driver.h
index 1e2e48ccb3fd..5722d88c2429 100644
--- a/include/linux/mlx5/driver.h
+++ b/include/linux/mlx5/driver.h
@@ -828,7 +828,6 @@ void *mlx5_get_protocol_dev(struct mlx5_core_dev *mdev, int protocol);
 int mlx5_register_interface(struct mlx5_interface *intf);
 void mlx5_unregister_interface(struct mlx5_interface *intf);
 int mlx5_core_query_vendor_id(struct mlx5_core_dev *mdev, u32 *vendor_id);
-int mlx5_core_query_special_context(struct mlx5_core_dev *dev, u32 *rsvd_lkey);
 
 struct mlx5_profile {
 	u64	mask;
-- 
1.8.4.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
