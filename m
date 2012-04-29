From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-next 6/7] IB/mlx4: replace KERN_yyy printk call with pr_yyy ones
Date: Sun, 29 Apr 2012 17:04:26 +0300
Message-ID: <1335708267-30284-7-git-send-email-ogerlitz@mellanox.com>
References: <1335708267-30284-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1335708267-30284-1-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Shlomo Pongratz <shlomop-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Shlomo Pongratz <shlomop-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Signed-off-by: Shlomo Pongratz <shlomop-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/hw/mlx4/cq.c   |   10 +++++-----
 drivers/infiniband/hw/mlx4/main.c |   12 ++++++------
 drivers/infiniband/hw/mlx4/mr.c   |    2 +-
 drivers/infiniband/hw/mlx4/qp.c   |   12 ++++++------
 drivers/infiniband/hw/mlx4/srq.c  |    2 +-
 5 files changed, 19 insertions(+), 19 deletions(-)

diff --git a/drivers/infiniband/hw/mlx4/cq.c b/drivers/infiniband/hw/mlx4/cq.c
index 77c8cb4..34ac0e2 100644
--- a/drivers/infiniband/hw/mlx4/cq.c
+++ b/drivers/infiniband/hw/mlx4/cq.c
@@ -50,7 +50,7 @@ static void mlx4_ib_cq_event(struct mlx4_cq *cq, enum mlx4_event type)
 	struct ib_cq *ibcq;
 
 	if (type != MLX4_EVENT_TYPE_CQ_ERROR) {
-		printk(KERN_WARNING "mlx4_ib: Unexpected event type %d "
+		pr_warn("Unexpected event type %d "
 		       "on CQ %06x\n", type, cq->cqn);
 		return;
 	}
@@ -463,7 +463,7 @@ static void dump_cqe(void *cqe)
 {
 	__be32 *buf = cqe;
 
-	printk(KERN_DEBUG "CQE contents %08x %08x %08x %08x %08x %08x %08x %08x\n",
+	pr_debug("CQE contents %08x %08x %08x %08x %08x %08x %08x %08x\n",
 	       be32_to_cpu(buf[0]), be32_to_cpu(buf[1]), be32_to_cpu(buf[2]),
 	       be32_to_cpu(buf[3]), be32_to_cpu(buf[4]), be32_to_cpu(buf[5]),
 	       be32_to_cpu(buf[6]), be32_to_cpu(buf[7]));
@@ -473,7 +473,7 @@ static void mlx4_ib_handle_error_cqe(struct mlx4_err_cqe *cqe,
 				     struct ib_wc *wc)
 {
 	if (cqe->syndrome == MLX4_CQE_SYNDROME_LOCAL_QP_OP_ERR) {
-		printk(KERN_DEBUG "local QP operation err "
+		pr_debug("local QP operation err "
 		       "(QPN %06x, WQE index %x, vendor syndrome %02x, "
 		       "opcode = %02x)\n",
 		       be32_to_cpu(cqe->my_qpn), be16_to_cpu(cqe->wqe_index),
@@ -576,7 +576,7 @@ repoll:
 
 	if (unlikely((cqe->owner_sr_opcode & MLX4_CQE_OPCODE_MASK) == MLX4_OPCODE_NOP &&
 		     is_send)) {
-		printk(KERN_WARNING "Completion for NOP opcode detected!\n");
+		pr_warn("Completion for NOP opcode detected!\n");
 		return -EINVAL;
 	}
 
@@ -606,7 +606,7 @@ repoll:
 		mqp = __mlx4_qp_lookup(to_mdev(cq->ibcq.device)->dev,
 				       be32_to_cpu(cqe->vlan_my_qpn));
 		if (unlikely(!mqp)) {
-			printk(KERN_WARNING "CQ %06x with entry for unknown QPN %06x\n",
+			pr_warn("CQ %06x with entry for unknown QPN %06x\n",
 			       cq->mcq.cqn, be32_to_cpu(cqe->vlan_my_qpn) & MLX4_CQE_QPN_MASK);
 			return -EINVAL;
 		}
diff --git a/drivers/infiniband/hw/mlx4/main.c b/drivers/infiniband/hw/mlx4/main.c
index 75d3056..1a11475 100644
--- a/drivers/infiniband/hw/mlx4/main.c
+++ b/drivers/infiniband/hw/mlx4/main.c
@@ -784,7 +784,7 @@ static int mlx4_ib_mcg_detach(struct ib_qp *ibqp, union ib_gid *gid, u16 lid)
 		list_del(&ge->list);
 		kfree(ge);
 	} else
-		printk(KERN_WARNING "could not find mgid entry\n");
+		pr_warn("could not find mgid entry\n");
 
 	mutex_unlock(&mqp->mutex);
 
@@ -897,7 +897,7 @@ static void update_gids_task(struct work_struct *work)
 
 	mailbox = mlx4_alloc_cmd_mailbox(dev);
 	if (IS_ERR(mailbox)) {
-		printk(KERN_WARNING "update gid table failed %ld\n", PTR_ERR(mailbox));
+		pr_warn("update gid table failed %ld\n", PTR_ERR(mailbox));
 		return;
 	}
 
@@ -908,7 +908,7 @@ static void update_gids_task(struct work_struct *work)
 		       1, MLX4_CMD_SET_PORT, MLX4_CMD_TIME_CLASS_B,
 		       MLX4_CMD_NATIVE);
 	if (err)
-		printk(KERN_WARNING "set port command failed\n");
+		pr_warn("set port command failed\n");
 	else {
 		memcpy(gw->dev->iboe.gid_table[gw->port - 1], gw->gids, sizeof gw->gids);
 		event.device = &gw->dev->ib_dev;
@@ -1082,7 +1082,7 @@ static void *mlx4_ib_add(struct mlx4_dev *dev)
 	printk_once(KERN_INFO "%s", mlx4_ib_version);
 
 	if (mlx4_is_mfunc(dev)) {
-		printk(KERN_WARNING "IB not yet supported in SRIOV\n");
+		pr_warn("IB not yet supported in SRIOV\n");
 		return NULL;
 	}
 
@@ -1248,7 +1248,7 @@ static void *mlx4_ib_add(struct mlx4_dev *dev)
 
 err_notif:
 	if (unregister_netdevice_notifier(&ibdev->iboe.nb))
-		printk(KERN_WARNING "failure unregistering notifier\n");
+		pr_warn("failure unregistering notifier\n");
 	flush_workqueue(wq);
 
 err_reg:
@@ -1283,7 +1283,7 @@ static void mlx4_ib_remove(struct mlx4_dev *dev, void *ibdev_ptr)
 	ib_unregister_device(&ibdev->ib_dev);
 	if (ibdev->iboe.nb.notifier_call) {
 		if (unregister_netdevice_notifier(&ibdev->iboe.nb))
-			printk(KERN_WARNING "failure unregistering notifier\n");
+			pr_warn("failure unregistering notifier\n");
 		ibdev->iboe.nb.notifier_call = NULL;
 	}
 	iounmap(ibdev->uar_map);
diff --git a/drivers/infiniband/hw/mlx4/mr.c b/drivers/infiniband/hw/mlx4/mr.c
index dca55b1..bbaf617 100644
--- a/drivers/infiniband/hw/mlx4/mr.c
+++ b/drivers/infiniband/hw/mlx4/mr.c
@@ -338,7 +338,7 @@ int mlx4_ib_unmap_fmr(struct list_head *fmr_list)
 
 	err = mlx4_SYNC_TPT(mdev);
 	if (err)
-		printk(KERN_WARNING "mlx4_ib: SYNC_TPT error %d when "
+		pr_warn("SYNC_TPT error %d when "
 		       "unmapping FMRs\n", err);
 
 	return 0;
diff --git a/drivers/infiniband/hw/mlx4/qp.c b/drivers/infiniband/hw/mlx4/qp.c
index 5e37090..da47bb1 100644
--- a/drivers/infiniband/hw/mlx4/qp.c
+++ b/drivers/infiniband/hw/mlx4/qp.c
@@ -261,7 +261,7 @@ static void mlx4_ib_qp_event(struct mlx4_qp *qp, enum mlx4_event type)
 			event.event = IB_EVENT_QP_ACCESS_ERR;
 			break;
 		default:
-			printk(KERN_WARNING "mlx4_ib: Unexpected event type %d "
+			pr_warn("Unexpected event type %d "
 			       "on QP %06x\n", type, qp->qpn);
 			return;
 		}
@@ -725,7 +725,7 @@ static void destroy_qp_common(struct mlx4_ib_dev *dev, struct mlx4_ib_qp *qp,
 	if (qp->state != IB_QPS_RESET)
 		if (mlx4_qp_modify(dev->dev, NULL, to_mlx4_state(qp->state),
 				   MLX4_QP_STATE_RST, NULL, 0, 0, &qp->mqp))
-			printk(KERN_WARNING "mlx4_ib: modify QP %06x to RESET failed.\n",
+			pr_warn("modify QP %06x to RESET failed.\n",
 			       qp->mqp.qpn);
 
 	get_cqs(qp, &send_cq, &recv_cq);
@@ -958,7 +958,7 @@ static int mlx4_set_path(struct mlx4_ib_dev *dev, const struct ib_ah_attr *ah,
 
 	if (ah->ah_flags & IB_AH_GRH) {
 		if (ah->grh.sgid_index >= dev->dev->caps.gid_table_len[port]) {
-			printk(KERN_ERR "sgid_index (%u) too large. max is %d\n",
+			pr_err("sgid_index (%u) too large. max is %d\n",
 			       ah->grh.sgid_index, dev->dev->caps.gid_table_len[port] - 1);
 			return -1;
 		}
@@ -1064,7 +1064,7 @@ static int __mlx4_ib_modify_qp(struct ib_qp *ibqp,
 			context->mtu_msgmax = (IB_MTU_4096 << 5) | 12;
 	} else if (attr_mask & IB_QP_PATH_MTU) {
 		if (attr->path_mtu < IB_MTU_256 || attr->path_mtu > IB_MTU_4096) {
-			printk(KERN_ERR "path MTU (%u) is invalid\n",
+			pr_err("path MTU (%u) is invalid\n",
 			       attr->path_mtu);
 			goto out;
 		}
@@ -1281,7 +1281,7 @@ static int __mlx4_ib_modify_qp(struct ib_qp *ibqp,
 	if (is_qp0(dev, qp)) {
 		if (cur_state != IB_QPS_RTR && new_state == IB_QPS_RTR)
 			if (mlx4_INIT_PORT(dev->dev, qp->port))
-				printk(KERN_WARNING "INIT_PORT failed for port %d\n",
+				pr_warn("INIT_PORT failed for port %d\n",
 				       qp->port);
 
 		if (cur_state != IB_QPS_RESET && cur_state != IB_QPS_ERR &&
@@ -1480,7 +1480,7 @@ static int build_mlx_header(struct mlx4_ib_sqp *sqp, struct ib_send_wr *wr,
 	header_size = ib_ud_header_pack(&sqp->ud_header, sqp->header_buf);
 
 	if (0) {
-		printk(KERN_ERR "built UD header of size %d:\n", header_size);
+		pr_err("built UD header of size %d:\n", header_size);
 		for (i = 0; i < header_size / 4; ++i) {
 			if (i % 8 == 0)
 				printk("  [%02x] ", i * 4);
diff --git a/drivers/infiniband/hw/mlx4/srq.c b/drivers/infiniband/hw/mlx4/srq.c
index 39542f3..60c5fb0 100644
--- a/drivers/infiniband/hw/mlx4/srq.c
+++ b/drivers/infiniband/hw/mlx4/srq.c
@@ -59,7 +59,7 @@ static void mlx4_ib_srq_event(struct mlx4_srq *srq, enum mlx4_event type)
 			event.event = IB_EVENT_SRQ_ERR;
 			break;
 		default:
-			printk(KERN_WARNING "mlx4_ib: Unexpected event type %d "
+			pr_warn("Unexpected event type %d "
 			       "on SRQ %06x\n", type, srq->srqn);
 			return;
 		}
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
