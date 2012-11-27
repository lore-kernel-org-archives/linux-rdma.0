From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH FIXES 2/2] NET/mlx4_core: Fix potential deadlock in mlx4_eq_int
Date: Tue, 27 Nov 2012 18:24:30 +0200
Message-ID: <1354033470-12724-3-git-send-email-ogerlitz@mellanox.com>
References: <1354033470-12724-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1354033470-12724-1-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>

The slave_state_lock spinlock is used both in the interrupt context and
in a process context, hence irq locking must be used. Found by lockdep.

Signed-off-by: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/net/ethernet/mellanox/mlx4/cmd.c |    9 +++++----
 drivers/net/ethernet/mellanox/mlx4/eq.c  |   10 ++++++----
 2 files changed, 11 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx4/cmd.c b/drivers/net/ethernet/mellanox/mlx4/cmd.c
index e791e70..fdc5f23 100644
--- a/drivers/net/ethernet/mellanox/mlx4/cmd.c
+++ b/drivers/net/ethernet/mellanox/mlx4/cmd.c
@@ -1498,6 +1498,7 @@ static void mlx4_master_do_cmd(struct mlx4_dev *dev, int slave, u8 cmd,
 	u32 reply;
 	u8 is_going_down = 0;
 	int i;
+	unsigned long flags;
 
 	slave_state[slave].comm_toggle ^= 1;
 	reply = (u32) slave_state[slave].comm_toggle << 31;
@@ -1576,12 +1577,12 @@ static void mlx4_master_do_cmd(struct mlx4_dev *dev, int slave, u8 cmd,
 		mlx4_warn(dev, "Bad comm cmd:%d from slave:%d\n", cmd, slave);
 		goto reset_slave;
 	}
-	spin_lock(&priv->mfunc.master.slave_state_lock);
+	spin_lock_irqsave(&priv->mfunc.master.slave_state_lock, flags);
 	if (!slave_state[slave].is_slave_going_down)
 		slave_state[slave].last_cmd = cmd;
 	else
 		is_going_down = 1;
-	spin_unlock(&priv->mfunc.master.slave_state_lock);
+	spin_unlock_irqrestore(&priv->mfunc.master.slave_state_lock, flags);
 	if (is_going_down) {
 		mlx4_warn(dev, "Slave is going down aborting command(%d)"
 			  " executing from slave:%d\n",
@@ -1597,10 +1598,10 @@ static void mlx4_master_do_cmd(struct mlx4_dev *dev, int slave, u8 cmd,
 reset_slave:
 	/* cleanup any slave resources */
 	mlx4_delete_all_resources_for_slave(dev, slave);
-	spin_lock(&priv->mfunc.master.slave_state_lock);
+	spin_lock_irqsave(&priv->mfunc.master.slave_state_lock, flags);
 	if (!slave_state[slave].is_slave_going_down)
 		slave_state[slave].last_cmd = MLX4_COMM_CMD_RESET;
-	spin_unlock(&priv->mfunc.master.slave_state_lock);
+	spin_unlock_irqrestore(&priv->mfunc.master.slave_state_lock, flags);
 	/*with slave in the middle of flr, no need to clean resources again.*/
 inform_slave_state:
 	memset(&slave_state[slave].event_eq, 0,
diff --git a/drivers/net/ethernet/mellanox/mlx4/eq.c b/drivers/net/ethernet/mellanox/mlx4/eq.c
index c509a86..3cb7727 100644
--- a/drivers/net/ethernet/mellanox/mlx4/eq.c
+++ b/drivers/net/ethernet/mellanox/mlx4/eq.c
@@ -407,6 +407,7 @@ void mlx4_master_handle_slave_flr(struct work_struct *work)
 	struct mlx4_slave_state *slave_state = priv->mfunc.master.slave_state;
 	int i;
 	int err;
+	unsigned long flags;
 
 	mlx4_dbg(dev, "mlx4_handle_slave_flr\n");
 
@@ -418,10 +419,10 @@ void mlx4_master_handle_slave_flr(struct work_struct *work)
 
 			mlx4_delete_all_resources_for_slave(dev, i);
 			/*return the slave to running mode*/
-			spin_lock(&priv->mfunc.master.slave_state_lock);
+			spin_lock_irqsave(&priv->mfunc.master.slave_state_lock, flags);
 			slave_state[i].last_cmd = MLX4_COMM_CMD_RESET;
 			slave_state[i].is_slave_going_down = 0;
-			spin_unlock(&priv->mfunc.master.slave_state_lock);
+			spin_unlock_irqrestore(&priv->mfunc.master.slave_state_lock, flags);
 			/*notify the FW:*/
 			err = mlx4_cmd(dev, 0, i, 0, MLX4_CMD_INFORM_FLR_DONE,
 				       MLX4_CMD_TIME_CLASS_A, MLX4_CMD_WRAPPED);
@@ -446,6 +447,7 @@ static int mlx4_eq_int(struct mlx4_dev *dev, struct mlx4_eq *eq)
 	u8 update_slave_state;
 	int i;
 	enum slave_port_gen_event gen_event;
+	unsigned long flags;
 
 	while ((eqe = next_eqe_sw(eq, dev->caps.eqe_factor))) {
 		/*
@@ -653,13 +655,13 @@ static int mlx4_eq_int(struct mlx4_dev *dev, struct mlx4_eq *eq)
 			} else
 				update_slave_state = 1;
 
-			spin_lock(&priv->mfunc.master.slave_state_lock);
+			spin_lock_irqsave(&priv->mfunc.master.slave_state_lock, flags);
 			if (update_slave_state) {
 				priv->mfunc.master.slave_state[flr_slave].active = false;
 				priv->mfunc.master.slave_state[flr_slave].last_cmd = MLX4_COMM_CMD_FLR;
 				priv->mfunc.master.slave_state[flr_slave].is_slave_going_down = 1;
 			}
-			spin_unlock(&priv->mfunc.master.slave_state_lock);
+			spin_unlock_irqrestore(&priv->mfunc.master.slave_state_lock, flags);
 			queue_work(priv->mfunc.master.comm_wq,
 				   &priv->mfunc.master.slave_flr_event_work);
 			break;
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
