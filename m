From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next V1 04/17] IB/mlx4: Remove debug prints after allocation failure
Date: Thu,  3 Nov 2016 16:44:12 +0200
Message-ID: <1478184265-9620-5-git-send-email-leon@kernel.org>
References: <1478184265-9620-1-git-send-email-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1478184265-9620-1-git-send-email-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

The prints after [k|v][m|z|c]alloc() functions are not needed,
because in case of failure, allocator will print their internal
error prints anyway.

Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/hw/mlx4/alias_GUID.c |  4 +---
 drivers/infiniband/hw/mlx4/cm.c         |  4 +---
 drivers/infiniband/hw/mlx4/mad.c        |  9 ++-------
 drivers/infiniband/hw/mlx4/main.c       | 16 +++-------------
 drivers/infiniband/hw/mlx4/mcg.c        |  5 +----
 5 files changed, 8 insertions(+), 30 deletions(-)

diff --git a/drivers/infiniband/hw/mlx4/alias_GUID.c b/drivers/infiniband/hw/mlx4/alias_GUID.c
index 5e99390..06020c5 100644
--- a/drivers/infiniband/hw/mlx4/alias_GUID.c
+++ b/drivers/infiniband/hw/mlx4/alias_GUID.c
@@ -755,10 +755,8 @@ static void alias_guid_work(struct work_struct *work)
 	struct mlx4_ib_dev *dev = container_of(ib_sriov, struct mlx4_ib_dev, sriov);
 
 	rec = kzalloc(sizeof *rec, GFP_KERNEL);
-	if (!rec) {
-		pr_err("alias_guid_work: No Memory\n");
+	if (!rec)
 		return;
-	}
 
 	pr_debug("starting [port: %d]...\n", sriov_alias_port->port + 1);
 	ret = get_next_record_to_update(dev, sriov_alias_port->port, rec);
diff --git a/drivers/infiniband/hw/mlx4/cm.c b/drivers/infiniband/hw/mlx4/cm.c
index 39a4888..d648453 100644
--- a/drivers/infiniband/hw/mlx4/cm.c
+++ b/drivers/infiniband/hw/mlx4/cm.c
@@ -247,10 +247,8 @@ id_map_alloc(struct ib_device *ibdev, int slave_id, u32 sl_cm_id)
 	struct mlx4_ib_sriov *sriov = &to_mdev(ibdev)->sriov;
 
 	ent = kmalloc(sizeof (struct id_map_entry), GFP_KERNEL);
-	if (!ent) {
-		mlx4_ib_warn(ibdev, "Couldn't allocate id cache entry - out of memory\n");
+	if (!ent)
 		return ERR_PTR(-ENOMEM);
-	}
 
 	ent->sl_cm_id = sl_cm_id;
 	ent->slave_id = slave_id;
diff --git a/drivers/infiniband/hw/mlx4/mad.c b/drivers/infiniband/hw/mlx4/mad.c
index 1672907..b0cd663 100644
--- a/drivers/infiniband/hw/mlx4/mad.c
+++ b/drivers/infiniband/hw/mlx4/mad.c
@@ -1102,10 +1102,8 @@ static void handle_slaves_guid_change(struct mlx4_ib_dev *dev, u8 port_num,
 
 	in_mad  = kmalloc(sizeof *in_mad, GFP_KERNEL);
 	out_mad = kmalloc(sizeof *out_mad, GFP_KERNEL);
-	if (!in_mad || !out_mad) {
-		mlx4_ib_warn(&dev->ib_dev, "failed to allocate memory for guid info mads\n");
+	if (!in_mad || !out_mad)
 		goto out;
-	}
 
 	guid_tbl_blk_num  *= 4;
 
@@ -1916,11 +1914,8 @@ static int alloc_pv_object(struct mlx4_ib_dev *dev, int slave, int port,
 
 	*ret_ctx = NULL;
 	ctx = kzalloc(sizeof (struct mlx4_ib_demux_pv_ctx), GFP_KERNEL);
-	if (!ctx) {
-		pr_err("failed allocating pv resource context "
-		       "for port %d, slave %d\n", port, slave);
+	if (!ctx)
 		return -ENOMEM;
-	}
 
 	ctx->ib_dev = &dev->ib_dev;
 	ctx->port = port;
diff --git a/drivers/infiniband/hw/mlx4/main.c b/drivers/infiniband/hw/mlx4/main.c
index b597e82..1b54786 100644
--- a/drivers/infiniband/hw/mlx4/main.c
+++ b/drivers/infiniband/hw/mlx4/main.c
@@ -2814,11 +2814,8 @@ static void *mlx4_ib_add(struct mlx4_dev *dev)
 			kmalloc(BITS_TO_LONGS(ibdev->steer_qpn_count) *
 				sizeof(long),
 				GFP_KERNEL);
-		if (!ibdev->ib_uc_qpns_bitmap) {
-			dev_err(&dev->persist->pdev->dev,
-				"bit map alloc failed\n");
+		if (!ibdev->ib_uc_qpns_bitmap)
 			goto err_steer_qp_release;
-		}
 
 		bitmap_zero(ibdev->ib_uc_qpns_bitmap, ibdev->steer_qpn_count);
 
@@ -3055,15 +3052,12 @@ static void do_slave_init(struct mlx4_ib_dev *ibdev, int slave, int do_init)
 	first_port = find_first_bit(actv_ports.ports, dev->caps.num_ports);
 
 	dm = kcalloc(ports, sizeof(*dm), GFP_ATOMIC);
-	if (!dm) {
-		pr_err("failed to allocate memory for tunneling qp update\n");
+	if (!dm)
 		return;
-	}
 
 	for (i = 0; i < ports; i++) {
 		dm[i] = kmalloc(sizeof (struct mlx4_ib_demux_work), GFP_ATOMIC);
 		if (!dm[i]) {
-			pr_err("failed to allocate memory for tunneling qp update work struct\n");
 			while (--i >= 0)
 				kfree(dm[i]);
 			goto out;
@@ -3223,8 +3217,6 @@ void mlx4_sched_ib_sl2vl_update_work(struct mlx4_ib_dev *ibdev,
 		ew->port = port;
 		ew->ib_dev = ibdev;
 		queue_work(wq, &ew->work);
-	} else {
-		pr_err("failed to allocate memory for sl2vl update work\n");
 	}
 }
 
@@ -3284,10 +3276,8 @@ static void mlx4_ib_event(struct mlx4_dev *dev, void *ibdev_ptr,
 
 	case MLX4_DEV_EVENT_PORT_MGMT_CHANGE:
 		ew = kmalloc(sizeof *ew, GFP_ATOMIC);
-		if (!ew) {
-			pr_err("failed to allocate memory for events work\n");
+		if (!ew)
 			break;
-		}
 
 		INIT_WORK(&ew->work, handle_port_mgmt_change_event);
 		memcpy(&ew->ib_eqe, eqe, sizeof *eqe);
diff --git a/drivers/infiniband/hw/mlx4/mcg.c b/drivers/infiniband/hw/mlx4/mcg.c
index a21d37f..e010fe4 100644
--- a/drivers/infiniband/hw/mlx4/mcg.c
+++ b/drivers/infiniband/hw/mlx4/mcg.c
@@ -1142,7 +1142,6 @@ void mlx4_ib_mcg_port_cleanup(struct mlx4_ib_demux_ctx *ctx, int destroy_wq)
 	work = kmalloc(sizeof *work, GFP_KERNEL);
 	if (!work) {
 		ctx->flushing = 0;
-		mcg_warn("failed allocating work for cleanup\n");
 		return;
 	}
 
@@ -1202,10 +1201,8 @@ static int push_deleteing_req(struct mcast_group *group, int slave)
 		return 0;
 
 	req = kzalloc(sizeof *req, GFP_KERNEL);
-	if (!req) {
-		mcg_warn_group(group, "failed allocation - may leave stall groups\n");
+	if (!req)
 		return -ENOMEM;
-	}
 
 	if (!list_empty(&group->func[slave].pending)) {
 		pend_req = list_entry(group->func[slave].pending.prev, struct mcast_req, group_list);
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
