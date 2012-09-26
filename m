From: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH] mlx4_core: Fix crash on uninitialized priv->cmd.slave_sem
Date: Tue, 25 Sep 2012 21:42:32 -0700
Message-ID: <1348634552-21047-1-git-send-email-roland@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>

On an SR-IOV master device, __mlx4_init_one() calls mlx4_init_hca()
before mlx4_multi_func_init().  However, for unlucky configurations,
mlx4_init_hca() might call mlx4_SENSE_PORT() (via mlx4_dev_cap()), and
that calls mlx4_cmd_imm() with MLX4_CMD_WRAPPED set.

However, on a multifunction device with MLX4_CMD_WRAPPED, __mlx4_cmd()
calls into mlx4_slave_cmd(), and that immediately tries to do

	down(&priv->cmd.slave_sem);

but priv->cmd.slave_sem isn't initialized until mlx4_multi_func_init()
(which we haven't called yet).  The next thing it tries to do is access
priv->mfunc.vhcr, but that hasn't been allocated yet.

Fix this by moving the initialization of slave_sem and vhcr up into
mlx4_cmd_init(). Also, since slave_sem is really just being used as a
mutex, convert it into a slave_cmd_mutex.

Signed-off-by: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
---
Jack, I needed this to get my (CX3 w/ FW 2.11.500) adapter to work in
SR-IOV mode.  Is it possible you never tested SR-IOV on an adapter
with ports in autosensing mode?

 drivers/net/ethernet/mellanox/mlx4/cmd.c  |   51 ++++++++++++++++++-----------
 drivers/net/ethernet/mellanox/mlx4/main.c |   11 ++++---
 drivers/net/ethernet/mellanox/mlx4/mlx4.h |    2 +-
 3 files changed, 38 insertions(+), 26 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx4/cmd.c b/drivers/net/ethernet/mellanox/mlx4/cmd.c
index 90774b7..3d1899f 100644
--- a/drivers/net/ethernet/mellanox/mlx4/cmd.c
+++ b/drivers/net/ethernet/mellanox/mlx4/cmd.c
@@ -395,7 +395,8 @@ static int mlx4_slave_cmd(struct mlx4_dev *dev, u64 in_param, u64 *out_param,
 	struct mlx4_vhcr_cmd *vhcr = priv->mfunc.vhcr;
 	int ret;
 
-	down(&priv->cmd.slave_sem);
+	mutex_lock(&priv->cmd.slave_cmd_mutex);
+
 	vhcr->in_param = cpu_to_be64(in_param);
 	vhcr->out_param = out_param ? cpu_to_be64(*out_param) : 0;
 	vhcr->in_modifier = cpu_to_be32(in_modifier);
@@ -403,6 +404,7 @@ static int mlx4_slave_cmd(struct mlx4_dev *dev, u64 in_param, u64 *out_param,
 	vhcr->token = cpu_to_be16(CMD_POLL_TOKEN);
 	vhcr->status = 0;
 	vhcr->flags = !!(priv->cmd.use_events) << 6;
+
 	if (mlx4_is_master(dev)) {
 		ret = mlx4_master_process_vhcr(dev, dev->caps.function, vhcr);
 		if (!ret) {
@@ -439,7 +441,8 @@ static int mlx4_slave_cmd(struct mlx4_dev *dev, u64 in_param, u64 *out_param,
 			mlx4_err(dev, "failed execution of VHCR_POST command"
 				 "opcode 0x%x\n", op);
 	}
-	up(&priv->cmd.slave_sem);
+
+	mutex_unlock(&priv->cmd.slave_cmd_mutex);
 	return ret;
 }
 
@@ -1559,14 +1562,15 @@ static void mlx4_master_do_cmd(struct mlx4_dev *dev, int slave, u8 cmd,
 		if ((slave_state[slave].last_cmd != MLX4_COMM_CMD_VHCR_EN) &&
 		    (slave_state[slave].last_cmd != MLX4_COMM_CMD_VHCR_POST))
 			goto reset_slave;
-		down(&priv->cmd.slave_sem);
+
+		mutex_lock(&priv->cmd.slave_cmd_mutex);
 		if (mlx4_master_process_vhcr(dev, slave, NULL)) {
 			mlx4_err(dev, "Failed processing vhcr for slave:%d,"
 				 " resetting slave.\n", slave);
-			up(&priv->cmd.slave_sem);
+			mutex_unlock(&priv->cmd.slave_cmd_mutex);
 			goto reset_slave;
 		}
-		up(&priv->cmd.slave_sem);
+		mutex_unlock(&priv->cmd.slave_cmd_mutex);
 		break;
 	default:
 		mlx4_warn(dev, "Bad comm cmd:%d from slave:%d\n", cmd, slave);
@@ -1707,14 +1711,6 @@ int mlx4_multi_func_init(struct mlx4_dev *dev)
 	struct mlx4_slave_state *s_state;
 	int i, j, err, port;
 
-	priv->mfunc.vhcr = dma_alloc_coherent(&(dev->pdev->dev), PAGE_SIZE,
-					    &priv->mfunc.vhcr_dma,
-					    GFP_KERNEL);
-	if (!priv->mfunc.vhcr) {
-		mlx4_err(dev, "Couldn't allocate vhcr.\n");
-		return -ENOMEM;
-	}
-
 	if (mlx4_is_master(dev))
 		priv->mfunc.comm =
 		ioremap(pci_resource_start(dev->pdev, priv->fw.comm_bar) +
@@ -1777,7 +1773,6 @@ int mlx4_multi_func_init(struct mlx4_dev *dev)
 		if (mlx4_init_resource_tracker(dev))
 			goto err_thread;
 
-		sema_init(&priv->cmd.slave_sem, 1);
 		err = mlx4_ARM_COMM_CHANNEL(dev);
 		if (err) {
 			mlx4_err(dev, " Failed to arm comm channel eq: %x\n",
@@ -1791,8 +1786,6 @@ int mlx4_multi_func_init(struct mlx4_dev *dev)
 			mlx4_err(dev, "Couldn't sync toggles\n");
 			goto err_comm;
 		}
-
-		sema_init(&priv->cmd.slave_sem, 1);
 	}
 	return 0;
 
@@ -1822,6 +1815,7 @@ int mlx4_cmd_init(struct mlx4_dev *dev)
 	struct mlx4_priv *priv = mlx4_priv(dev);
 
 	mutex_init(&priv->cmd.hcr_mutex);
+	mutex_init(&priv->cmd.slave_cmd_mutex);
 	sema_init(&priv->cmd.poll_sem, 1);
 	priv->cmd.use_events = 0;
 	priv->cmd.toggle     = 1;
@@ -1838,14 +1832,30 @@ int mlx4_cmd_init(struct mlx4_dev *dev)
 		}
 	}
 
+	if (mlx4_is_mfunc(dev)) {
+		priv->mfunc.vhcr = dma_alloc_coherent(&(dev->pdev->dev), PAGE_SIZE,
+						      &priv->mfunc.vhcr_dma,
+						      GFP_KERNEL);
+		if (!priv->mfunc.vhcr) {
+			mlx4_err(dev, "Couldn't allocate VHCR.\n");
+			goto err_hcr;
+		}
+	}
+
 	priv->cmd.pool = pci_pool_create("mlx4_cmd", dev->pdev,
 					 MLX4_MAILBOX_SIZE,
 					 MLX4_MAILBOX_SIZE, 0);
 	if (!priv->cmd.pool)
-		goto err_hcr;
+		goto err_vhcr;
 
 	return 0;
 
+err_vhcr:
+	if (mlx4_is_mfunc(dev))
+		dma_free_coherent(&(dev->pdev->dev), PAGE_SIZE,
+				  priv->mfunc.vhcr, priv->mfunc.vhcr_dma);
+	priv->mfunc.vhcr = NULL;
+
 err_hcr:
 	if (!mlx4_is_slave(dev))
 		iounmap(priv->cmd.hcr);
@@ -1868,9 +1878,6 @@ void mlx4_multi_func_cleanup(struct mlx4_dev *dev)
 	}
 
 	iounmap(priv->mfunc.comm);
-	dma_free_coherent(&(dev->pdev->dev), PAGE_SIZE,
-		     priv->mfunc.vhcr, priv->mfunc.vhcr_dma);
-	priv->mfunc.vhcr = NULL;
 }
 
 void mlx4_cmd_cleanup(struct mlx4_dev *dev)
@@ -1881,6 +1888,10 @@ void mlx4_cmd_cleanup(struct mlx4_dev *dev)
 
 	if (!mlx4_is_slave(dev))
 		iounmap(priv->cmd.hcr);
+	if (mlx4_is_mfunc(dev))
+		dma_free_coherent(&(dev->pdev->dev), PAGE_SIZE,
+				  priv->mfunc.vhcr, priv->mfunc.vhcr_dma);
+	priv->mfunc.vhcr = NULL;
 }
 
 /*
diff --git a/drivers/net/ethernet/mellanox/mlx4/main.c b/drivers/net/ethernet/mellanox/mlx4/main.c
index 8d3b475..9f06e04 100644
--- a/drivers/net/ethernet/mellanox/mlx4/main.c
+++ b/drivers/net/ethernet/mellanox/mlx4/main.c
@@ -1159,10 +1159,10 @@ static void mlx4_slave_exit(struct mlx4_dev *dev)
 {
 	struct mlx4_priv *priv = mlx4_priv(dev);
 
-	down(&priv->cmd.slave_sem);
+	mutex_lock(&priv->cmd.slave_cmd_mutex);
 	if (mlx4_comm_cmd(dev, MLX4_COMM_CMD_RESET, 0, MLX4_COMM_TIME))
 		mlx4_warn(dev, "Failed to close slave function.\n");
-	up(&priv->cmd.slave_sem);
+	mutex_unlock(&priv->cmd.slave_cmd_mutex);
 }
 
 static int map_bf_area(struct mlx4_dev *dev)
@@ -1214,7 +1214,7 @@ static int mlx4_init_slave(struct mlx4_dev *dev)
 	u32 slave_read;
 	u32 cmd_channel_ver;
 
-	down(&priv->cmd.slave_sem);
+	mutex_lock(&priv->cmd.slave_cmd_mutex);
 	priv->cmd.max_cmds = 1;
 	mlx4_warn(dev, "Sending reset\n");
 	ret_from_reset = mlx4_comm_cmd(dev, MLX4_COMM_CMD_RESET, 0,
@@ -1263,12 +1263,13 @@ static int mlx4_init_slave(struct mlx4_dev *dev)
 		goto err;
 	if (mlx4_comm_cmd(dev, MLX4_COMM_CMD_VHCR_EN, dma, MLX4_COMM_TIME))
 		goto err;
-	up(&priv->cmd.slave_sem);
+
+	mutex_unlock(&priv->cmd.slave_cmd_mutex);
 	return 0;
 
 err:
 	mlx4_comm_cmd(dev, MLX4_COMM_CMD_RESET, 0, 0);
-	up(&priv->cmd.slave_sem);
+	mutex_unlock(&priv->cmd.slave_cmd_mutex);
 	return -EIO;
 }
 
diff --git a/drivers/net/ethernet/mellanox/mlx4/mlx4.h b/drivers/net/ethernet/mellanox/mlx4/mlx4.h
index e5eee31..1bb3e5e 100644
--- a/drivers/net/ethernet/mellanox/mlx4/mlx4.h
+++ b/drivers/net/ethernet/mellanox/mlx4/mlx4.h
@@ -513,9 +513,9 @@ struct mlx4_cmd {
 	struct pci_pool	       *pool;
 	void __iomem	       *hcr;
 	struct mutex		hcr_mutex;
+	struct mutex		slave_cmd_mutex;
 	struct semaphore	poll_sem;
 	struct semaphore	event_sem;
-	struct semaphore	slave_sem;
 	int			max_cmds;
 	spinlock_t		context_lock;
 	int			free_head;
-- 
1.7.10.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
