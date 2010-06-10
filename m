From: Yevgeny Petrilin <yevgenyp-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Subject: [PATCH 19/19 V4] mlx4: Communication channel interrupts
Date: Thu, 10 Jun 2010 22:10:31 +0300
Message-ID: <4C1138A7.6070804@mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

The master function receives am interrupt each time on eof the slaves writes
to the communication channel, and then handles the channel from a deffered task.
The slaves can now receive command completions an async events by interrupts.
The open an EQ and the master generates eqes and "pushes" them to the slave's
EQ using Firmware "GEN_EQE" command.

Signed-off-by: Yevgeny Petrilin <yevgenyp-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
---
 drivers/net/mlx4/cmd.c      |  258 +++++++++++++++++++++++++++++++-------
 drivers/net/mlx4/eq.c       |  296 +++++++++++++++++++------------------------
 drivers/net/mlx4/main.c     |   50 +++-----
 drivers/net/mlx4/mlx4.h     |   97 +++++++++++++--
 include/linux/mlx4/cmd.h    |    7 +-
 include/linux/mlx4/device.h |    1 +
 6 files changed, 459 insertions(+), 250 deletions(-)

diff --git a/drivers/net/mlx4/cmd.c b/drivers/net/mlx4/cmd.c
index 7efa85f..083ae0f 100644
--- a/drivers/net/mlx4/cmd.c
+++ b/drivers/net/mlx4/cmd.c
@@ -148,19 +148,11 @@ static int comm_pending(struct mlx4_dev *dev)
 	return (swab32(status) >> 30) != priv->cmd.comm_toggle;
 }
 
-int mlx4_comm_cmd(struct mlx4_dev *dev, u8 cmd, u16 param, unsigned long timeout)
+static void mlx4_comm_cmd_post(struct mlx4_dev *dev, u8 cmd, u16 param)
 {
 	struct mlx4_priv *priv = mlx4_priv(dev);
-	unsigned long end;
 	u32 val;
 
-	/* First, verify that the master reports correct status */
-	if (comm_pending(dev)) {
-		mlx4_warn(dev, "Communication channel is not idle\n");
-		return -EAGAIN;
-	}
-
-	/* Write command */
 	if (cmd == MLX4_COMM_CMD_RESET)
 		priv->cmd.comm_toggle = 0;
 	else if (++priv->cmd.comm_toggle > 2)
@@ -168,6 +160,23 @@ int mlx4_comm_cmd(struct mlx4_dev *dev, u8 cmd, u16 param, unsigned long timeout
 	val = param | (cmd << 16) | (priv->cmd.comm_toggle << 30);
 	__raw_writel((__force u32) cpu_to_be32(val), &priv->mfunc.comm->slave_write);
 	wmb();
+}
+
+int mlx4_comm_cmd_poll(struct mlx4_dev *dev, u8 cmd, u16 param, unsigned long timeout)
+{
+	struct mlx4_priv *priv = mlx4_priv(dev);
+	unsigned long end;
+	int err = 0;
+
+	/* First, verify that the master reports correct status */
+	if (comm_pending(dev)) {
+		mlx4_warn(dev, "Communication channel is not idle\n");
+		return -EAGAIN;
+	}
+
+	/* Write command */
+	down(&priv->cmd.poll_sem);
+	mlx4_comm_cmd_post(dev, cmd, param);
 
 	end = msecs_to_jiffies(timeout) + jiffies;
 	while (comm_pending(dev) && time_before(jiffies, end))
@@ -175,11 +184,57 @@ int mlx4_comm_cmd(struct mlx4_dev *dev, u8 cmd, u16 param, unsigned long timeout
 
 	if (comm_pending(dev)) {
 		mlx4_warn(dev, "Communication channel timed out\n");
-		return -ETIMEDOUT;
+		err = -ETIMEDOUT;
 	}
+
+	up(&priv->cmd.poll_sem);
 	return 0;
 }
 
+static int mlx4_comm_cmd_wait(struct mlx4_dev *dev, u8 op,
+			      u16 param, unsigned long timeout)
+{
+	struct mlx4_cmd *cmd = &mlx4_priv(dev)->cmd;
+	struct mlx4_cmd_context *context;
+	int err = 0;
+
+	down(&cmd->event_sem);
+
+	spin_lock(&cmd->context_lock);
+	BUG_ON(cmd->free_head < 0);
+	context = &cmd->context[cmd->free_head];
+	context->token += cmd->token_mask + 1;
+	cmd->free_head = context->next;
+	spin_unlock(&cmd->context_lock);
+
+	init_completion(&context->done);
+
+	mlx4_comm_cmd_post(dev, op, param);
+
+	if (!wait_for_completion_timeout(&context->done, msecs_to_jiffies(timeout))) {
+		err = -EBUSY;
+		goto out;
+	}
+
+	err = context->result;
+
+out:
+	spin_lock(&cmd->context_lock);
+	context->next = cmd->free_head;
+	cmd->free_head = context - cmd->context;
+	spin_unlock(&cmd->context_lock);
+
+	up(&cmd->event_sem);
+	return err;
+}
+
+int mlx4_comm_cmd(struct mlx4_dev *dev, u8 cmd, u16 param, unsigned long timeout)
+{
+	if (mlx4_priv(dev)->cmd.use_events)
+		return mlx4_comm_cmd_wait(dev, cmd, param, timeout);
+	return mlx4_comm_cmd_poll(dev, cmd, param, timeout);
+}
+
 static int cmd_pending(struct mlx4_dev *dev)
 {
 	u32 status = readl(mlx4_priv(dev)->cmd.hcr + HCR_STATUS_OFFSET);
@@ -247,15 +302,15 @@ out:
 	return ret;
 }
 
-static int mlx4_slave_cmd_poll(struct mlx4_dev *dev, u64 in_param, u64 *out_param,
-			 int out_is_imm, u32 in_modifier, u8 op_modifier,
-			 u16 op, unsigned long timeout)
+static int mlx4_slave_cmd(struct mlx4_dev *dev, u64 in_param, u64 *out_param,
+			  int out_is_imm, u32 in_modifier, u8 op_modifier,
+			  u16 op, unsigned long timeout)
 {
 	struct mlx4_priv *priv = mlx4_priv(dev);
 	struct mlx4_vhcr *vhcr = priv->mfunc.vhcr;
 	int ret;
 
-	down(&priv->cmd.poll_sem);
+	down(&priv->cmd.slave_sem);
 	vhcr->in_param = in_param;
 	vhcr->out_param = out_param ? *out_param : 0;
 	vhcr->in_modifier = in_modifier;
@@ -270,7 +325,7 @@ static int mlx4_slave_cmd_poll(struct mlx4_dev *dev, u64 in_param, u64 *out_para
 			*out_param = vhcr->out_param;
 		ret = vhcr->errno;
 	}
-	up(&priv->cmd.poll_sem);
+	up(&priv->cmd.slave_sem);
 	return ret;
 }
 
@@ -378,19 +433,61 @@ int __mlx4_cmd(struct mlx4_dev *dev, u64 in_param, u64 *out_param,
 	       int out_is_imm, u32 in_modifier, u8 op_modifier,
 	       u16 op, unsigned long timeout)
 {
+	if (mlx4_is_slave(dev))
+		return mlx4_slave_cmd(dev, in_param, out_param, out_is_imm,
+				      in_modifier, op_modifier, op, timeout);
+
 	if (mlx4_priv(dev)->cmd.use_events)
 		return mlx4_cmd_wait(dev, in_param, out_param, out_is_imm,
 				     in_modifier, op_modifier, op, timeout);
-
-	if (mlx4_is_slave(dev))
-		return mlx4_slave_cmd_poll(dev, in_param, out_param, out_is_imm,
-				     in_modifier, op_modifier, op, timeout);
 	else
 		return mlx4_cmd_poll(dev, in_param, out_param, out_is_imm,
 				     in_modifier, op_modifier, op, timeout);
 }
 EXPORT_SYMBOL_GPL(__mlx4_cmd);
 
+
+static int mlx4_ARM_COMM_CHANNEL(struct mlx4_dev *dev)
+{
+	return mlx4_cmd(dev, 0, 0, 0, MLX4_CMD_ARM_COMM_CHANNEL, MLX4_CMD_TIME_CLASS_B);
+}
+
+int mlx4_GEN_EQE(struct mlx4_dev *dev, int slave, struct mlx4_eqe *eqe)
+{
+	struct mlx4_priv *priv = mlx4_priv(dev);
+	struct mlx4_slave_event_eq_info *event_eq =
+		&priv->mfunc.master.slave_state[slave].event_eq;
+	struct mlx4_cmd_mailbox *mailbox;
+	u32 in_modifier = 0;
+	int err;
+
+	if (!event_eq->use_int)
+		return 0;
+
+	/* Create the event only if the slave is registered */
+	if ((event_eq->event_type & eqe->type) == 0)
+		return 0;
+
+	mailbox = mlx4_alloc_cmd_mailbox(dev);
+	if (IS_ERR(mailbox))
+		return PTR_ERR(mailbox);
+
+	if (eqe->type == MLX4_EVENT_TYPE_CMD) {
+		++event_eq->token;
+		eqe->event.cmd.token = cpu_to_be16(event_eq->token);
+	}
+
+	memcpy(mailbox->buf, (u8 *) eqe, 28);
+
+	in_modifier = (slave & 0xff) | ((event_eq->eqn & 0xff) << 16);
+
+	err = mlx4_cmd(dev, mailbox->dma, in_modifier, 0,
+		       MLX4_CMD_GEN_EQE, MLX4_CMD_TIME_CLASS_B);
+
+       mlx4_free_cmd_mailbox(dev, mailbox);
+       return err;
+}
+
 static int mlx4_ACCESS_MEM(struct mlx4_dev *dev, u64 master_addr,
 			   int slave, u64 slave_addr,
 			   int size, int is_read)
@@ -597,12 +694,21 @@ static struct mlx4_cmd_info {
 	},
 
 	{
+		.opcode = MLX4_CMD_COMM_INT,
+		.has_inbox = false,
+		.has_outbox = false,
+		.out_is_imm = false,
+		.verify = NULL,
+		.wrapper = mlx4_COMM_INT_wrapper
+	},
+	{
 		.opcode = MLX4_CMD_INIT_PORT,
 		.has_inbox = false,
 		.has_outbox = false,
 		.out_is_imm = false,
 		.verify = NULL,
-		.wrapper = mlx4_INIT_PORT_wrapper},
+		.wrapper = mlx4_INIT_PORT_wrapper
+	},
 	{
 		.opcode = MLX4_CMD_CLOSE_PORT,
 		.has_inbox = false,
@@ -629,6 +735,14 @@ static struct mlx4_cmd_info {
 	},
 
 	{
+		.opcode = MLX4_CMD_MAP_EQ,
+		.has_inbox = false,
+		.has_outbox = false,
+		.out_is_imm = false,
+		.verify = NULL,
+		.wrapper = mlx4_MAP_EQ_wrapper
+	},
+	{
 		.opcode = MLX4_CMD_SW2HW_EQ,
 		.has_inbox = true,
 		.has_outbox = false,
@@ -1108,6 +1222,7 @@ static void mlx4_master_do_cmd(struct mlx4_dev *dev, int slave, u8 cmd, u16 para
 
 	if (cmd == MLX4_COMM_CMD_RESET) {
 		mlx4_warn(dev, "Received reset from slave:%d\n", slave);
+		slave_state[slave].active = false;
 		goto reset_slave;
 	}
 
@@ -1146,6 +1261,7 @@ static void mlx4_master_do_cmd(struct mlx4_dev *dev, int slave, u8 cmd, u16 para
 				      "number for slave %d\n", slave);
 			goto reset_slave;
 		}
+		slave_state[slave].active = true;
 		break;
 	case MLX4_COMM_CMD_VHCR_POST:
 		if ((slave_state[slave].last_cmd != MLX4_COMM_CMD_VHCR_EN) &&
@@ -1167,45 +1283,59 @@ static void mlx4_master_do_cmd(struct mlx4_dev *dev, int slave, u8 cmd, u16 para
 	__raw_writel((__force u32) cpu_to_be32(reply),
 		     &priv->mfunc.comm[slave].slave_read);
 	wmb();
+	if (mlx4_GEN_EQE(dev, slave, &priv->mfunc.master.cmd_eqe))
+		mlx4_warn(dev, "Failed to generate command completion eqe "
+			       "for slave %d\n", slave);
+
 	return;
 
 reset_slave:
 	/* FIXME: cleanup any slave resources */
 	slave_state[slave].last_cmd = MLX4_COMM_CMD_RESET;
 	slave_state[slave].comm_toggle = 0;
+	memset(&slave_state[slave].event_eq, 0,
+	       sizeof(struct mlx4_slave_event_eq_info));
 	__raw_writel((__force u32) 0, &priv->mfunc.comm[slave].slave_write);
 	__raw_writel((__force u32) 0, &priv->mfunc.comm[slave].slave_read);
 	wmb();
 }
 
 /* master command processing */
-static void mlx4_master_poll_comm(struct work_struct *work)
+void mlx4_master_comm_channel(struct work_struct *work)
 {
-	struct delayed_work *delay = container_of(work, struct delayed_work, work);
-	struct mlx4_mfunc *mfunc = container_of(delay, struct mlx4_mfunc, comm_work);
+	struct mlx4_mfunc_master_ctx *master = container_of(work,
+							   struct mlx4_mfunc_master_ctx,
+							   comm_work);
+	struct mlx4_mfunc *mfunc = container_of(master, struct mlx4_mfunc, master);
 	struct mlx4_priv *priv = container_of(mfunc, struct mlx4_priv, mfunc);
 	struct mlx4_dev *dev = &priv->dev;
+	u32 *bit_vec;
 	u32 comm_cmd;
-	int polled = 0;
-	int i;
-
-	/* Give each slave a chance for one command */
-	for (i = 0; i < dev->num_slaves; i++) {
-		comm_cmd = swab32(readl(&priv->mfunc.comm[i].slave_write));
-		if (comm_cmd >> 30 != priv->mfunc.master.slave_state[i].comm_toggle) {
-			mlx4_master_do_cmd(dev, i, comm_cmd >> 16, comm_cmd, comm_cmd >> 30);
-			polled = 1;
+	u32 vec;
+	int i, j, slave;
+
+	bit_vec = master->comm_arm_bit_vector;
+	for (i = 0; i < COMM_CHANNEL_BIT_ARRAY_SIZE; i++) {
+		vec = be32_to_cpu(bit_vec[i]);
+		for (j = 0; j < 32; j++) {
+			if (!(vec & (1 << j)))
+				continue;
+			slave = (i * 32) + j;
+			comm_cmd = swab32(readl(&mfunc->comm[slave].slave_write));
+			if (comm_cmd >> 30 != master->slave_state[slave].comm_toggle)
+				mlx4_master_do_cmd(dev, slave, comm_cmd >> 16, comm_cmd, comm_cmd >> 30);
 		}
 	}
-	queue_delayed_work(priv->mfunc.comm_wq, &priv->mfunc.comm_work,
-						polled ? 0 : HZ / 10);
+
+	if (mlx4_ARM_COMM_CHANNEL(dev))
+		mlx4_warn(dev, "Failed to arm comm channel events");
 }
 
 int mlx4_multi_func_init(struct mlx4_dev *dev)
 {
 	struct mlx4_priv *priv = mlx4_priv(dev);
 	struct mlx4_slave_state *s_state;
-	int i, port;
+	int i, err, port;
 
 	priv->mfunc.vhcr = dma_alloc_coherent(&(dev->pdev->dev), PAGE_SIZE,
 					    &priv->mfunc.vhcr_dma,
@@ -1253,20 +1383,30 @@ int mlx4_multi_func_init(struct mlx4_dev *dev)
 			spin_lock_init(&s_state->lock);
 		}
 
-		INIT_DELAYED_WORK(&priv->mfunc.comm_work, mlx4_master_poll_comm);
-		priv->mfunc.comm_wq = create_singlethread_workqueue("mlx4_comm");
-		if (!priv->mfunc.comm_wq)
+		memset(&priv->mfunc.master.cmd_eqe, 0, sizeof(struct mlx4_eqe));
+		priv->mfunc.master.cmd_eqe.type = MLX4_EVENT_TYPE_CMD;
+		INIT_WORK(&priv->mfunc.master.comm_work, mlx4_master_comm_channel);
+		INIT_WORK(&priv->mfunc.master.slave_event_work, mlx4_gen_slave_eqe);
+		priv->mfunc.master.comm_wq = create_singlethread_workqueue("mlx4_comm");
+		if (!priv->mfunc.master.comm_wq)
 			goto err_slaves;
 
+		err = mlx4_ARM_COMM_CHANNEL(dev);
+		if (err) {
+			mlx4_err(dev, " Failed to arm comm channel eq: %x\n", err);
+			goto err_thread;
+		}
+
 	} else {
+		sema_init(&priv->cmd.slave_sem, 1);
 		priv->cmd.comm_toggle = 0;
-		INIT_DELAYED_WORK(&priv->mfunc.comm_work, mlx4_slave_async_eq_poll);
-		priv->mfunc.comm_wq = create_singlethread_workqueue("mlx4_event");
-		if (!priv->mfunc.comm_wq)
 			goto err_comm;
 	}
 	return 0;
 
+err_thread:
+	flush_workqueue(priv->mfunc.master.comm_wq);
+	destroy_workqueue(priv->mfunc.master.comm_wq);
 err_slaves:
 	while (--i) {
 		for (port = 1; port <= MLX4_MAX_PORTS; port++)
@@ -1323,8 +1463,9 @@ void mlx4_multi_func_cleanup(struct mlx4_dev *dev)
 	struct mlx4_priv *priv = mlx4_priv(dev);
 	int i, port;
 
-	if (priv->mfunc.vhcr) {
-		destroy_workqueue(priv->mfunc.comm_wq);
+	if (mlx4_is_master(dev)) {
+		flush_workqueue(priv->mfunc.master.comm_wq);
+		destroy_workqueue(priv->mfunc.master.comm_wq);
 		for (i = 0; i < dev->num_slaves; i++) {
 			for (port = 1; port <= MLX4_MAX_PORTS; port++)
 				kfree(priv->mfunc.master.slave_state[i].vlan_filter[port]);
@@ -1356,6 +1497,7 @@ int mlx4_cmd_use_events(struct mlx4_dev *dev)
 {
 	struct mlx4_priv *priv = mlx4_priv(dev);
 	int i;
+	int err = 0;
 
 	priv->cmd.context = kmalloc(priv->cmd.max_cmds *
 				   sizeof (struct mlx4_cmd_context),
@@ -1382,9 +1524,17 @@ int mlx4_cmd_use_events(struct mlx4_dev *dev)
 
 	priv->cmd.use_events = 1;
 
+	if (mlx4_is_slave(dev)) {
+		err = mlx4_cmd(dev, 0, 1, 0, MLX4_CMD_COMM_INT, MLX4_CMD_TIME_CLASS_A);
+		if (err) {
+			mlx4_err(dev, "Failed to move to events for the slave\n");
+			priv->cmd.use_events = 0;
+		}
+	}
+
 	down(&priv->cmd.poll_sem);
 
-	return 0;
+	return err;
 }
 
 /*
@@ -1403,6 +1553,9 @@ void mlx4_cmd_use_polling(struct mlx4_dev *dev)
 	kfree(priv->cmd.context);
 
 	up(&priv->cmd.poll_sem);
+
+	if (mlx4_is_slave(dev))
+		mlx4_cmd(dev, 0, 0, 0, MLX4_CMD_COMM_INT, MLX4_CMD_TIME_CLASS_A);
 }
 
 struct mlx4_cmd_mailbox *mlx4_alloc_cmd_mailbox(struct mlx4_dev *dev)
@@ -1433,3 +1586,20 @@ void mlx4_free_cmd_mailbox(struct mlx4_dev *dev, struct mlx4_cmd_mailbox *mailbo
 	kfree(mailbox);
 }
 EXPORT_SYMBOL_GPL(mlx4_free_cmd_mailbox);
+
+int mlx4_COMM_INT_wrapper(struct mlx4_dev *dev, int slave, struct mlx4_vhcr *vhcr,
+			  struct mlx4_cmd_mailbox *inbox,
+			  struct mlx4_cmd_mailbox *outbox)
+{
+	struct mlx4_priv *priv = mlx4_priv(dev);
+	struct mlx4_slave_event_eq_info *event_eq =
+		&priv->mfunc.master.slave_state[slave].event_eq;
+
+	if (vhcr->in_modifier)
+		event_eq->use_int = true;
+	else
+		event_eq->use_int = false;
+
+	return 0;
+}
+
diff --git a/drivers/net/mlx4/eq.c b/drivers/net/mlx4/eq.c
index 9126c8e..e5adca2 100644
--- a/drivers/net/mlx4/eq.c
+++ b/drivers/net/mlx4/eq.c
@@ -99,46 +99,8 @@ struct mlx4_eq_context {
 			       (1ull << MLX4_EVENT_TYPE_SRQ_CATAS_ERROR)    | \
 			       (1ull << MLX4_EVENT_TYPE_SRQ_QP_LAST_WQE)    | \
 			       (1ull << MLX4_EVENT_TYPE_SRQ_LIMIT)	    | \
-			       (1ull << MLX4_EVENT_TYPE_CMD))
-
-struct mlx4_eqe {
-	u8			reserved1;
-	u8			type;
-	u8			reserved2;
-	u8			subtype;
-	union {
-		u32		raw[6];
-		struct {
-			__be32	cqn;
-		} __attribute__((packed)) comp;
-		struct {
-			u16	reserved1;
-			__be16	token;
-			u32	reserved2;
-			u8	reserved3[3];
-			u8	status;
-			__be64	out_param;
-		} __attribute__((packed)) cmd;
-		struct {
-			__be32	qpn;
-		} __attribute__((packed)) qp;
-		struct {
-			__be32	srqn;
-		} __attribute__((packed)) srq;
-		struct {
-			__be32	cqn;
-			u32	reserved1;
-			u8	reserved2[3];
-			u8	syndrome;
-		} __attribute__((packed)) cq_err;
-		struct {
-			u32	reserved1[2];
-			__be32	port;
-		} __attribute__((packed)) port_change;
-	}			event;
-	u8			reserved3[3];
-	u8			owner;
-} __attribute__((packed));
+			       (1ull << MLX4_EVENT_TYPE_CMD)		    | \
+			       (1ull << MLX4_EVENT_TYPE_COMM_CHANNEL))
 
 static void eq_set_ci(struct mlx4_eq *eq, int req_not)
 {
@@ -161,35 +123,87 @@ static struct mlx4_eqe *next_eqe_sw(struct mlx4_eq *eq)
 	return !!(eqe->owner & 0x80) ^ !!(eq->cons_index & eq->nent) ? NULL : eqe;
 }
 
-void mlx4_slave_event(struct mlx4_dev *dev, int slave, u8 type, u8 port, u32 param)
+static struct mlx4_eqe *next_slave_event_eqe(struct mlx4_slave_event_eq *slave_eq)
+{
+	struct mlx4_eqe *eqe =
+		&slave_eq->event_eqe[slave_eq->cons & (SLAVE_EVENT_EQ_SIZE - 1)];
+	return (!!(eqe->owner & 0x80) ^ !!(slave_eq->cons & SLAVE_EVENT_EQ_SIZE)) ?
+		eqe : NULL;
+}
+void mlx4_gen_slave_eqe(struct work_struct *work)
+{
+	struct mlx4_mfunc_master_ctx *master = container_of(work,
+							   struct mlx4_mfunc_master_ctx,
+							   slave_event_work);
+	struct mlx4_mfunc *mfunc = container_of(master, struct mlx4_mfunc, master);
+	struct mlx4_priv *priv = container_of(mfunc, struct mlx4_priv, mfunc);
+	struct mlx4_dev *dev = &priv->dev;
+	struct mlx4_slave_event_eq *slave_eq = &mfunc->master.slave_eq;
+	struct mlx4_eqe *eqe;
+	u8 slave;
+	int i;
+
+	for (eqe = next_slave_event_eqe(slave_eq); eqe;
+	      eqe = next_slave_event_eqe(slave_eq)) {
+		slave = eqe->slave_id;
+
+		/* All active slaves need to receive the event */
+		if (slave == ALL_SLAVES) {
+			for (i = 0; i < dev->num_slaves; i++) {
+				if (master->slave_state[i].active)
+					if (mlx4_GEN_EQE(dev, i, eqe))
+						mlx4_warn(dev, "Failed to generate event "
+							       "for slave %d\n", i);
+			}
+		} else {
+			if (mlx4_GEN_EQE(dev, slave, eqe))
+				mlx4_warn(dev, "Failed to generate event "
+					       "for slave %d\n", slave);
+		}
+		++slave_eq->cons;
+	}
+}
+
+
+static void slave_event(struct mlx4_dev *dev, u8 slave, struct mlx4_eqe *eqe)
 {
 	struct mlx4_priv *priv = mlx4_priv(dev);
-	struct mlx4_slave_state *ctx = &priv->mfunc.master.slave_state[slave];
-	unsigned long flags;
+	struct mlx4_slave_event_eq *slave_eq = &priv->mfunc.master.slave_eq;
+	struct mlx4_eqe *s_eqe =
+		&slave_eq->event_eqe[slave_eq->prod & (SLAVE_EVENT_EQ_SIZE - 1)];
 
-	if (ctx->last_cmd != MLX4_COMM_CMD_VHCR_POST) {
-		mlx4_warn(dev, "received event for inactive slave:%d\n", slave);
+	if ((!!(s_eqe->owner & 0x80)) ^ (!!(slave_eq->prod & SLAVE_EVENT_EQ_SIZE))) {
+		mlx4_warn(dev, "Master failed to generate an EQE for slave: %d. "
+			  "No free EQE on slave events queue\n", slave);
 		return;
 	}
 
-	/* Unconditionally add the new event - during overflows, we drop the
-	 * oldest events */
-	spin_lock_irqsave(&ctx->lock, flags);
-	ctx->eq[ctx->eq_pi & MLX4_MFUNC_EQE_MASK].type = type;
-	ctx->eq[ctx->eq_pi & MLX4_MFUNC_EQE_MASK].port = port;
-	ctx->eq[ctx->eq_pi & MLX4_MFUNC_EQE_MASK].param = param;
-	++ctx->eq_pi;
-	spin_unlock_irqrestore(&ctx->lock, flags);
+	memcpy(s_eqe, eqe, sizeof(struct mlx4_eqe) - 1);
+	s_eqe->slave_id = slave;
+	/* ensure all information is written before setting the ownersip bit */
+	wmb();
+	s_eqe->owner = !!(slave_eq->prod & SLAVE_EVENT_EQ_SIZE) ? 0x0 : 0x80;
+	++slave_eq->prod;
+
+	queue_work(priv->mfunc.master.comm_wq, &priv->mfunc.master.slave_event_work);
 }
 
-static void mlx4_slave_event_all(struct mlx4_dev *dev, u8 type, u8 port, u32 param)
+static void mlx4_slave_event(struct mlx4_dev *dev, int slave, struct mlx4_eqe* eqe)
 {
 	struct mlx4_priv *priv = mlx4_priv(dev);
-	int i;
+	struct mlx4_slave_state *s_slave = &priv->mfunc.master.slave_state[slave];
 
-	for (i = 0; i < dev->num_slaves; ++i)
-		if (priv->mfunc.master.slave_state[i].last_cmd == MLX4_COMM_CMD_VHCR_POST)
-			mlx4_slave_event(dev, i, type, port, param);
+	if (!s_slave->active) {
+		mlx4_warn(dev, "Trying to pass event to inactive slave\n");
+		return;
+	}
+
+	slave_event(dev, slave, eqe);
+}
+
+static void mlx4_slave_event_all(struct mlx4_dev *dev, struct mlx4_eqe* eqe)
+{
+	slave_event(dev, ALL_SLAVES, eqe);
 }
 
 int mlx4_GET_EVENT_wrapper(struct mlx4_dev *dev, int slave, struct mlx4_vhcr *vhcr,
@@ -216,24 +230,9 @@ int mlx4_GET_EVENT_wrapper(struct mlx4_dev *dev, int slave, struct mlx4_vhcr *vh
 	return 0;
 }
 
-static int mlx4_GET_EVENT(struct mlx4_dev *dev, struct mlx4_slave_eqe *eqe)
-{
-	int ret;
-	u64 out_param;
-
-	ret = mlx4_cmd_imm(dev, 0, &out_param, 0, 0, MLX4_CMD_GET_EVENT,
-						     MLX4_CMD_TIME_CLASS_A);
-	if (!ret) {
-		eqe->type = out_param & 0xff;
-		eqe->port = (out_param >> 8) & 0xff;
-		eqe->param = out_param >> 32;
-	} else
-		mlx4_err(dev, "Failed retrieving event\n");
-	return ret;
-}
-
 static int mlx4_eq_int(struct mlx4_dev *dev, struct mlx4_eq *eq)
 {
+	struct mlx4_priv *priv = mlx4_priv(dev);
 	struct mlx4_eqe *eqe;
 	int cqn;
 	int eqes_found = 0;
@@ -263,9 +262,7 @@ static int mlx4_eq_int(struct mlx4_dev *dev, struct mlx4_eq *eq)
 		case MLX4_EVENT_TYPE_WQ_ACCESS_ERROR:
 			if (mlx4_is_master(dev)) {
 				/* TODO: forward only to slave owning the QP */
-				mlx4_slave_event(dev, 0, eqe->type, 0,
-					      be32_to_cpu(eqe->event.qp.qpn) &
-					      0xffffff);
+				mlx4_slave_event(dev, 0, eqe);
 			} else
 				mlx4_qp_event(dev, be32_to_cpu(eqe->event.qp.qpn) &
 						   0xffffff, eqe->type);
@@ -275,9 +272,7 @@ static int mlx4_eq_int(struct mlx4_dev *dev, struct mlx4_eq *eq)
 		case MLX4_EVENT_TYPE_SRQ_CATAS_ERROR:
 			if (mlx4_is_master(dev)) {
 				/* TODO: forward only to slave owning the SRQ */
-				mlx4_slave_event(dev, 0, eqe->type, 0,
-					      be32_to_cpu(eqe->event.srq.srqn) &
-					      0xffffff);
+				mlx4_slave_event(dev, 0, eqe);
 			} else
 				mlx4_srq_event(dev, be32_to_cpu(eqe->event.srq.srqn) &
 						    0xffffff, eqe->type);
@@ -295,20 +290,14 @@ static int mlx4_eq_int(struct mlx4_dev *dev, struct mlx4_eq *eq)
 			if (eqe->subtype == MLX4_PORT_CHANGE_SUBTYPE_DOWN) {
 				mlx4_dispatch_event(dev, MLX4_DEV_EVENT_PORT_DOWN,
 						    port);
-				if (mlx4_is_master(dev)) {
-					mlx4_slave_event_all(dev, MLX4_EVENT_TYPE_PORT_CHANGE,
-							     port, MLX4_DEV_EVENT_PORT_DOWN);
-				}
 				mlx4_priv(dev)->sense.do_sense_port[port] = 1;
 			} else {
 				mlx4_dispatch_event(dev, MLX4_DEV_EVENT_PORT_UP,
 						    port);
-				if (mlx4_is_master(dev)) {
-					mlx4_slave_event_all(dev, MLX4_EVENT_TYPE_PORT_CHANGE,
-							     port, MLX4_DEV_EVENT_PORT_UP);
-				}
 				mlx4_priv(dev)->sense.do_sense_port[port] = 0;
 			}
+			if (mlx4_is_master(dev))
+				mlx4_slave_event_all(dev, eqe);
 			break;
 
 		case MLX4_EVENT_TYPE_CQ_ERROR:
@@ -318,8 +307,7 @@ static int mlx4_eq_int(struct mlx4_dev *dev, struct mlx4_eq *eq)
 				  be32_to_cpu(eqe->event.cq_err.cqn) & 0xffffff);
 			if (mlx4_is_master(dev)) {
 				/* TODO: forward only to slave owning the CQ */
-				mlx4_slave_event(dev, 0, eqe->type, 0,
-					      be32_to_cpu(eqe->event.cq_err.cqn));
+				mlx4_slave_event(dev, 0, eqe);
 			} else
 				mlx4_cq_event(dev, be32_to_cpu(eqe->event.cq_err.cqn),
 									   eqe->type);
@@ -329,6 +317,20 @@ static int mlx4_eq_int(struct mlx4_dev *dev, struct mlx4_eq *eq)
 			mlx4_warn(dev, "EQ overrun on EQN %d\n", eq->eqn);
 			break;
 
+		case MLX4_EVENT_TYPE_COMM_CHANNEL:
+			if (!mlx4_is_master(dev)) {
+				mlx4_warn(dev, "Received comm channel event "
+					       "for non master device\n");
+				break;
+			}
+			memcpy(&priv->mfunc.master.comm_arm_bit_vector,
+			       eqe->event.comm_channel_arm.bit_vec,
+			       sizeof(u32) * COMM_CHANNEL_BIT_ARRAY_SIZE);
+			queue_work(priv->mfunc.master.comm_wq,
+				   &priv->mfunc.master.comm_work);
+			break;
+
+
 		case MLX4_EVENT_TYPE_EEC_CATAS_ERROR:
 		case MLX4_EVENT_TYPE_ECC_DETECT:
 		default:
@@ -359,57 +361,6 @@ static int mlx4_eq_int(struct mlx4_dev *dev, struct mlx4_eq *eq)
 	return eqes_found;
 }
 
-void mlx4_slave_async_eq_poll(struct work_struct *work)
-{
-	struct delayed_work *delay = container_of(work, struct delayed_work, work);
-	struct mlx4_mfunc *mfunc = container_of(delay, struct mlx4_mfunc, comm_work);
-	struct mlx4_priv *priv = container_of(mfunc, struct mlx4_priv, mfunc);
-	struct mlx4_dev *dev = &priv->dev;
-	struct mlx4_slave_eqe eqe;
-	int ret;
-	int i;
-
-	for (i = 0; i < MLX4_MFUNC_MAX_EQES; i++) {
-		ret = mlx4_GET_EVENT(dev, &eqe);
-		if (ret || eqe.type == MLX4_EVENT_TYPE_NONE)
-			break;
-
-		switch (eqe.type) {
-		case MLX4_EVENT_TYPE_PATH_MIG:
-		case MLX4_EVENT_TYPE_COMM_EST:
-		case MLX4_EVENT_TYPE_SQ_DRAINED:
-		case MLX4_EVENT_TYPE_SRQ_QP_LAST_WQE:
-		case MLX4_EVENT_TYPE_WQ_CATAS_ERROR:
-		case MLX4_EVENT_TYPE_PATH_MIG_FAILED:
-		case MLX4_EVENT_TYPE_WQ_INVAL_REQ_ERROR:
-		case MLX4_EVENT_TYPE_WQ_ACCESS_ERROR:
-			mlx4_qp_event(dev, eqe.param, eqe.type);
-			break;
-
-		case MLX4_EVENT_TYPE_SRQ_LIMIT:
-		case MLX4_EVENT_TYPE_SRQ_CATAS_ERROR:
-			mlx4_srq_event(dev, eqe.param, eqe.type);
-			break;
-
-		case MLX4_EVENT_TYPE_PORT_CHANGE:
-			mlx4_dispatch_event(dev, eqe.param, eqe.port);
-			break;
-
-		case MLX4_EVENT_TYPE_CQ_ERROR:
-			mlx4_cq_event(dev, eqe.param, eqe.type);
-			break;
-
-		case MLX4_EVENT_TYPE_EQ_OVERFLOW:
-			mlx4_warn(dev, "slave async EQ overrun\n");
-			break;
-
-		default:
-			mlx4_warn(dev, "Unhandled event:%02x\n", eqe.type);
-		}
-	}
-	queue_delayed_work(priv->mfunc.comm_wq, &priv->mfunc.comm_work, HZ);
-}
-
 static irqreturn_t mlx4_interrupt(int irq, void *dev_ptr)
 {
 	struct mlx4_dev *dev = dev_ptr;
@@ -436,6 +387,30 @@ static irqreturn_t mlx4_msi_x_interrupt(int irq, void *eq_ptr)
 	return IRQ_HANDLED;
 }
 
+int mlx4_MAP_EQ_wrapper(struct mlx4_dev *dev, int slave,
+			struct mlx4_vhcr *vhcr,
+			struct mlx4_cmd_mailbox *inbox,
+			struct mlx4_cmd_mailbox *outbox)
+{
+	struct mlx4_priv *priv = mlx4_priv(dev);
+	struct mlx4_slave_event_eq_info *event_eq =
+		&priv->mfunc.master.slave_state[slave].event_eq;
+	u32 in_modifier = vhcr->in_modifier;
+	u32 eqn = in_modifier & 0x1FF;
+	u64 in_param =  vhcr->in_param;
+
+       if (in_modifier >> 31) {
+	       /* unmap */
+	       event_eq->event_type &= ~in_param;
+	       return 0;
+       }
+
+       event_eq->eqn = eqn;
+       event_eq->event_type = in_param;
+
+       return 0;
+}
+
 static int mlx4_MAP_EQ(struct mlx4_dev *dev, u64 event_mask, int unmap,
 			int eq_num)
 {
@@ -748,18 +723,16 @@ int mlx4_init_eq_table(struct mlx4_dev *dev)
 		}
 	}
 
-	if (!mlx4_is_slave(dev)) {
-		err = mlx4_create_eq(dev, MLX4_NUM_ASYNC_EQE + MLX4_NUM_SPARE_EQE,
-				     (dev->flags & MLX4_FLAG_MSI_X) ? dev->caps.num_comp_vectors : 0,
-				     &priv->eq_table.eq[dev->caps.num_comp_vectors]);
-		if (err)
-			goto err_out_comp;
-	}
+	err = mlx4_create_eq(dev, MLX4_NUM_ASYNC_EQE + MLX4_NUM_SPARE_EQE,
+			     (dev->flags & MLX4_FLAG_MSI_X) ? dev->caps.num_comp_vectors : 0,
+			     &priv->eq_table.eq[dev->caps.num_comp_vectors]);
+	if (err)
+		goto err_out_comp;
 
 	if (dev->flags & MLX4_FLAG_MSI_X) {
 		const char *eq_name;
 
-		for (i = 0; i < dev->caps.num_comp_vectors + !mlx4_is_slave(dev); ++i) {
+		for (i = 0; i < dev->caps.num_comp_vectors + 1; ++i) {
 			if (i < dev->caps.num_comp_vectors) {
 				snprintf(priv->eq_table.irq_names +
 					 i * MLX4_IRQNAME_SIZE,
@@ -797,22 +770,19 @@ int mlx4_init_eq_table(struct mlx4_dev *dev)
 		priv->eq_table.have_irq = 1;
 	}
 
-	if (!mlx4_is_slave(dev)) { /* hw async events cannot be shared */
-		err = mlx4_MAP_EQ(dev, MLX4_ASYNC_EVENT_MASK, 0,
-				  priv->eq_table.eq[dev->caps.num_comp_vectors].eqn);
-		if (err)
-			mlx4_warn(dev, "MAP_EQ for async EQ %d failed (%d)\n",
-				   priv->eq_table.eq[dev->caps.num_comp_vectors].eqn, err);
-	}
+	err = mlx4_MAP_EQ(dev, MLX4_ASYNC_EVENT_MASK, 0,
+			  priv->eq_table.eq[dev->caps.num_comp_vectors].eqn);
+	if (err)
+		mlx4_warn(dev, "MAP_EQ for async EQ %d failed (%d)\n",
+			  priv->eq_table.eq[dev->caps.num_comp_vectors].eqn, err);
 
-	for (i = 0; i < dev->caps.num_comp_vectors + !(mlx4_is_slave(dev)); ++i)
+	for (i = 0; i < dev->caps.num_comp_vectors + 1; ++i)
 		eq_set_ci(&priv->eq_table.eq[i], 1);
 
 	return 0;
 
 err_out_async:
-	if (!mlx4_is_slave(dev))
-		mlx4_free_eq(dev, &priv->eq_table.eq[dev->caps.num_comp_vectors]);
+	mlx4_free_eq(dev, &priv->eq_table.eq[dev->caps.num_comp_vectors]);
 
 err_out_comp:
 	i = dev->caps.num_comp_vectors;
@@ -840,14 +810,12 @@ void mlx4_cleanup_eq_table(struct mlx4_dev *dev)
 	struct mlx4_priv *priv = mlx4_priv(dev);
 	int i;
 
-	if (!mlx4_is_slave(dev)) {
-		mlx4_MAP_EQ(dev, MLX4_ASYNC_EVENT_MASK, 1,
-			    priv->eq_table.eq[dev->caps.num_comp_vectors].eqn);
-	}
+	mlx4_MAP_EQ(dev, MLX4_ASYNC_EVENT_MASK, 1,
+		    priv->eq_table.eq[dev->caps.num_comp_vectors].eqn);
 
 	mlx4_free_irqs(dev);
 
-	for (i = 0; i < dev->caps.num_comp_vectors + !mlx4_is_slave(dev); ++i)
+	for (i = 0; i < dev->caps.num_comp_vectors + 1; ++i)
 		mlx4_free_eq(dev, &priv->eq_table.eq[i]);
 
 	if (!mlx4_is_slave(dev))
diff --git a/drivers/net/mlx4/main.c b/drivers/net/mlx4/main.c
index f7fed9a..78a6255 100644
--- a/drivers/net/mlx4/main.c
+++ b/drivers/net/mlx4/main.c
@@ -807,10 +807,10 @@ static void mlx4_slave_exit(struct mlx4_dev *dev)
 {
 	struct mlx4_priv *priv = mlx4_priv(dev);
 
-	down(&priv->cmd.poll_sem);
+	down(&priv->cmd.slave_sem);
 	if (mlx4_comm_cmd(dev, MLX4_COMM_CMD_RESET, 0, MLX4_COMM_TIME))
 		mlx4_warn(dev, "Failed to close slave function.\n");
-	up(&priv->cmd.poll_sem);
+	up(&priv->cmd.slave_sem);
 }
 
 static void mlx4_close_hca(struct mlx4_dev *dev)
@@ -830,7 +830,8 @@ static int mlx4_init_slave(struct mlx4_dev *dev)
 	struct mlx4_priv *priv = mlx4_priv(dev);
 	u64 dma = (u64) priv->mfunc.vhcr_dma;
 
-	down(&priv->cmd.poll_sem);
+	down(&priv->cmd.slave_sem);
+	priv->cmd.max_cmds = 1;
 	mlx4_warn(dev, "Sending reset\n");
 	if (mlx4_comm_cmd(dev, MLX4_COMM_CMD_RESET, 0, MLX4_COMM_TIME))
 		goto err;
@@ -846,12 +847,12 @@ static int mlx4_init_slave(struct mlx4_dev *dev)
 		goto err;
 	if (mlx4_comm_cmd(dev, MLX4_COMM_CMD_VHCR_EN, dma, MLX4_COMM_TIME))
 		goto err;
-	up(&priv->cmd.poll_sem);
+	up(&priv->cmd.slave_sem);
 	return 0;
 
 err:
 	mlx4_comm_cmd(dev, MLX4_COMM_CMD_RESET, 0, 0);
-	up(&priv->cmd.poll_sem);
+	up(&priv->cmd.slave_sem);
 	return -EIO;
 }
 
@@ -1005,13 +1006,11 @@ static int mlx4_setup_hca(struct mlx4_dev *dev)
 		goto err_mr_table_free;
 	}
 
-	if (!mlx4_is_slave(dev)) {
-		err = mlx4_cmd_use_events(dev);
-		if (err) {
-			mlx4_err(dev, "Failed to switch to event-driven "
-				 "firmware commands, aborting.\n");
-			goto err_eq_table_free;
-		}
+	err = mlx4_cmd_use_events(dev);
+	if (err) {
+		mlx4_err(dev, "Failed to switch to event-driven "
+			      "firmware commands, aborting.\n");
+		goto err_eq_table_free;
 	}
 
 	err = mlx4_NOP(dev);
@@ -1094,8 +1093,7 @@ err_cq_table_free:
 	mlx4_cleanup_cq_table(dev);
 
 err_cmd_poll:
-	if (!mlx4_is_slave(dev))
-		mlx4_cmd_use_polling(dev);
+	mlx4_cmd_use_polling(dev);
 
 err_eq_table_free:
 	mlx4_cleanup_eq_table(dev);
@@ -1126,10 +1124,11 @@ static void mlx4_enable_msi_x(struct mlx4_dev *dev)
 	int i;
 
 	if (msi_x) {
-		/* The master only uses en event EQ,
-		 * Each one of the slaves have 1 completion eq */
+		/* In multifunction mode each function gets 2 msi-X vectors
+		 * one for data path completions anf the other for asynch events
+		 * or command completions */
 		if (mlx4_is_mfunc(dev))
-			nreq = 1 + !!mlx4_is_master(dev);
+			nreq = 4;
 		else
 			nreq = min_t(int, dev->caps.num_eqs - dev->caps.reserved_eqs,
 				     num_possible_cpus() + 1);
@@ -1155,7 +1154,7 @@ static void mlx4_enable_msi_x(struct mlx4_dev *dev)
 			goto no_msi;
 		}
 
-		dev->caps.num_comp_vectors = nreq - !mlx4_is_slave(dev);
+		dev->caps.num_comp_vectors = nreq - 1;
 		for (i = 0; i < nreq; ++i)
 			priv->eq_table.eq[i].irq = entries[i].vector;
 
@@ -1470,12 +1469,6 @@ slave_start:
 
 	pci_set_drvdata(pdev, dev);
 
-	/* Start serving comm channel:
-	 * - In master function: poll for commands
-	 * - in slave functions: poll for events
-	 * TODO - enable comm channel interrupts */
-	if (mlx4_is_mfunc(dev))
-		queue_delayed_work(priv->mfunc.comm_wq, &priv->mfunc.comm_work, 0);
 	return 0;
 
 err_port:
@@ -1486,8 +1479,7 @@ err_port:
 	mlx4_cleanup_qp_table(dev);
 	mlx4_cleanup_srq_table(dev);
 	mlx4_cleanup_cq_table(dev);
-	if (!mlx4_is_slave(dev))
-		mlx4_cmd_use_polling(dev);
+	mlx4_cmd_use_polling(dev);
 	mlx4_cleanup_eq_table(dev);
 	mlx4_cleanup_mr_table(dev);
 	mlx4_cleanup_pd_table(dev);
@@ -1549,9 +1541,6 @@ static void mlx4_remove_one(struct pci_dev *pdev)
 	int p;
 
 	if (dev) {
-		/* Stop serving commands and events over comm channel */
-		if (mlx4_is_mfunc(dev))
-			cancel_delayed_work_sync(&priv->mfunc.comm_work);
 		mlx4_stop_sense(dev);
 		mlx4_unregister_device(dev);
 
@@ -1564,8 +1553,7 @@ static void mlx4_remove_one(struct pci_dev *pdev)
 		mlx4_cleanup_qp_table(dev);
 		mlx4_cleanup_srq_table(dev);
 		mlx4_cleanup_cq_table(dev);
-		if (!mlx4_is_slave(dev))
-			mlx4_cmd_use_polling(dev);
+		mlx4_cmd_use_polling(dev);
 		mlx4_cleanup_eq_table(dev);
 		mlx4_cleanup_mr_table(dev);
 		mlx4_cleanup_pd_table(dev);
diff --git a/drivers/net/mlx4/mlx4.h b/drivers/net/mlx4/mlx4.h
index 7a7f787..91803aa 100644
--- a/drivers/net/mlx4/mlx4.h
+++ b/drivers/net/mlx4/mlx4.h
@@ -178,6 +178,53 @@ struct mlx4_icm_table {
 	struct mlx4_icm	      **icm;
 };
 
+
+struct mlx4_eqe {
+	u8			reserved1;
+	u8			type;
+	u8			reserved2;
+	u8			subtype;
+	union {
+		u32		raw[6];
+		struct {
+			__be32	cqn;
+		} __attribute__((packed)) comp;
+		struct {
+			u16	reserved1;
+			__be16	token;
+			u32	reserved2;
+			u8	reserved3[3];
+			u8	status;
+			__be64	out_param;
+		} __attribute__((packed)) cmd;
+		struct {
+			__be32	qpn;
+		} __attribute__((packed)) qp;
+		struct {
+			__be32	srqn;
+		} __attribute__((packed)) srq;
+		struct {
+			__be32	cqn;
+			u32	reserved1;
+			u8	reserved2[3];
+			u8	syndrome;
+		} __attribute__((packed)) cq_err;
+		struct {
+			u32	reserved1[2];
+			__be32	port;
+		} __attribute__((packed)) port_change;
+		struct {
+			#define COMM_CHANNEL_BIT_ARRAY_SIZE	4
+			u32 reserved;
+			u32 bit_vec[COMM_CHANNEL_BIT_ARRAY_SIZE];
+		} __attribute__((packed)) comm_channel_arm;
+	}			event;
+#define ALL_SLAVES 0xff
+	u8			slave_id;
+	u8			reserved3[2];
+	u8			owner;
+} __attribute__((packed));
+
 struct mlx4_eq {
 	struct mlx4_dev	       *dev;
 	void __iomem	       *doorbell;
@@ -190,6 +237,19 @@ struct mlx4_eq {
 	struct mlx4_mtt		mtt;
 };
 
+struct mlx4_slave_eqe {
+	u8 type;
+	u8 port;
+	u32 param;
+};
+
+struct mlx4_slave_event_eq_info {
+	u32 eqn;
+	bool  use_int;
+	u16 token;
+	u64 event_type;
+};
+
 struct mlx4_profile {
 	int			num_qp;
 	int			rdmarc_per_qp;
@@ -218,12 +278,6 @@ struct mlx4_comm {
 	u32			slave_read;
 };
 
-struct mlx4_slave_eqe {
-	u8 type;
-	u8 port;
-	u32 param;
-};
-
 struct mlx4_mcast_entry {
 	struct list_head list;
 	u64 addr;
@@ -250,6 +304,7 @@ struct mlx4_slave_state {
 	u8 last_cmd;
 	u8 init_port_mask;
 	u8 pf_num;
+	bool active;
 	u8 function;
 	dma_addr_t vhcr_dma;
 	u16 mtu[MLX4_MAX_PORTS + 1];
@@ -257,16 +312,31 @@ struct mlx4_slave_state {
 	struct mlx4_slave_eqe eq[MLX4_MFUNC_MAX_EQES];
 	struct list_head mcast_filters[MLX4_MAX_PORTS + 1];
 	struct mlx4_vlan_fltr *vlan_filter[MLX4_MAX_PORTS + 1];
+	struct mlx4_slave_event_eq_info event_eq;
 	u16 eq_pi;
 	u16 eq_ci;
 	spinlock_t lock;
 };
 
+#define SLAVE_EVENT_EQ_SIZE	128
+struct mlx4_slave_event_eq {
+	u32 eqn;
+	u32 cons;
+	u32 prod;
+	struct mlx4_eqe event_eqe[SLAVE_EVENT_EQ_SIZE];
+};
+
 struct mlx4_mfunc_master_ctx {
 	struct mlx4_slave_state *slave_state;
 	int			init_port_ref[MLX4_MAX_PORTS + 1];
 	u16			max_mtu[MLX4_MAX_PORTS + 1];
 	int			disable_mcast_ref[MLX4_MAX_PORTS + 1];
+	struct workqueue_struct *comm_wq;
+	struct work_struct	comm_work;
+	struct work_struct	slave_event_work;
+	u32			comm_arm_bit_vector[4];
+	struct mlx4_eqe		cmd_eqe;
+	struct mlx4_slave_event_eq slave_eq;
 };
 
 struct mlx4_vhcr {
@@ -282,8 +352,6 @@ struct mlx4_vhcr {
 
 struct mlx4_mfunc {
 	struct mlx4_comm __iomem       *comm;
-	struct workqueue_struct	       *comm_wq;
-	struct delayed_work	        comm_work;
 	struct mlx4_vhcr	       *vhcr;
 	dma_addr_t			vhcr_dma;
 
@@ -296,6 +364,7 @@ struct mlx4_cmd {
 	struct mutex		hcr_mutex;
 	struct semaphore	poll_sem;
 	struct semaphore	event_sem;
+	struct semaphore	slave_sem;
 	int			max_cmds;
 	spinlock_t		context_lock;
 	int			free_head;
@@ -522,7 +591,6 @@ void mlx4_free_ownership(struct mlx4_dev *dev);
 
 int mlx4_alloc_eq_table(struct mlx4_dev *dev);
 void mlx4_free_eq_table(struct mlx4_dev *dev);
-void mlx4_slave_event(struct mlx4_dev *dev, int slave, u8 type, u8 port, u32 param);
 int mlx4_GET_EVENT_wrapper(struct mlx4_dev *dev, int slave, struct mlx4_vhcr *vhcr,
 						 struct mlx4_cmd_mailbox *inbox,
 						 struct mlx4_cmd_mailbox *outbox);
@@ -576,7 +644,16 @@ u64 mlx4_make_profile(struct mlx4_dev *dev,
 		      struct mlx4_profile *request,
 		      struct mlx4_dev_cap *dev_cap,
 		      struct mlx4_init_hca_param *init_hca);
-void mlx4_slave_async_eq_poll(struct work_struct *work);
+void mlx4_master_comm_channel(struct work_struct *work);
+void mlx4_gen_slave_eqe(struct work_struct *work);
+
+int mlx4_MAP_EQ_wrapper(struct mlx4_dev *dev, int slave,
+			struct mlx4_vhcr *vhcr, struct mlx4_cmd_mailbox *inbox,
+			struct mlx4_cmd_mailbox *outbox);
+int mlx4_COMM_INT_wrapper(struct mlx4_dev *dev, int slave, struct mlx4_vhcr *vhcr,
+			  struct mlx4_cmd_mailbox *inbox,
+			  struct mlx4_cmd_mailbox *outbox);
+int mlx4_GEN_EQE(struct mlx4_dev *dev, int slave, struct mlx4_eqe *eqe);
 
 int mlx4_cmd_init(struct mlx4_dev *dev);
 void mlx4_cmd_cleanup(struct mlx4_dev *dev);
diff --git a/include/linux/mlx4/cmd.h b/include/linux/mlx4/cmd.h
index 9225791..a6901c3 100644
--- a/include/linux/mlx4/cmd.h
+++ b/include/linux/mlx4/cmd.h
@@ -125,6 +125,10 @@ enum {
 	MLX4_CMD_SET_MCAST_FLTR	 = 0x48,
 	MLX4_CMD_DUMP_ETH_STATS	 = 0x49,
 
+	/* Communication channel commands */
+	MLX4_CMD_ARM_COMM_CHANNEL = 0x57,
+	MLX4_CMD_GEN_EQE	 = 0x58,
+
 	/* virtual commands */
 	MLX4_CMD_ALLOC_RES	 = 0xf00,
 	MLX4_CMD_FREE_RES	 = 0xf01,
@@ -132,7 +136,8 @@ enum {
 	MLX4_CMD_GET_EVENT	 = 0xf03,
 	MLX4_CMD_QUERY_SLAVE_CAP = 0xf04,
 	MLX4_CMD_MCAST_ATTACH    = 0xf05,
-	MLX4_CMD_PROMISC         = 0xf07,
+	MLX4_CMD_COMM_INT        = 0xf07,
+	MLX4_CMD_PROMISC         = 0xf08,
 
 	/* debug commands */
 	MLX4_CMD_QUERY_DEBUG_MSG = 0x2a,
diff --git a/include/linux/mlx4/device.h b/include/linux/mlx4/device.h
index c03a176..1b553b0 100644
--- a/include/linux/mlx4/device.h
+++ b/include/linux/mlx4/device.h
@@ -101,6 +101,7 @@ enum mlx4_event {
 	MLX4_EVENT_TYPE_EQ_OVERFLOW	   = 0x0f,
 	MLX4_EVENT_TYPE_ECC_DETECT	   = 0x0e,
 	MLX4_EVENT_TYPE_CMD		   = 0x0a,
+	MLX4_EVENT_TYPE_COMM_CHANNEL       = 0x18,
 	MLX4_EVENT_TYPE_NONE		   = 0xff,
 };
 
-- 
1.6.0.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
