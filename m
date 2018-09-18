From: Jan Dakinevich <jan.dakinevich@virtuozzo.com>
Subject: [PATCH 2/4] IB/mlx4: move iboe field aside from mlx4_ib_dev
Date: Tue, 18 Sep 2018 16:03:44 +0300
Message-ID: <1537275826-27247-3-git-send-email-jan.dakinevich@virtuozzo.com>
References: <1537275826-27247-1-git-send-email-jan.dakinevich@virtuozzo.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1537275826-27247-1-git-send-email-jan.dakinevich@virtuozzo.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>, Yishai Hadas <yishaih@mellanox.com>, Leon Romanovsky <leon@kernel.org>, Parav Pandit <parav@mellanox.com>, Mark Bloch <markb@mellanox.com>, Daniel Jurgens <danielj@mellanox.com>, Kees Cook <keescook@chromium.org>, Kamal Heib <kamalheib1@gmail.com>, Bart Van Assche <bvanassche@acm.org>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Denis Lunev <den@virtuozzo.com>, Konstantin Khorenko <khorenko@virtuozzo.com>, Jan Dakinevich <jan.dakinevich@virtuozzo.com>
List-Id: linux-rdma@vger.kernel.org

This is the 1st patch of 3 of the work for decreasing size
of mlx4_ib_dev.

The field takes about 8K and could be safely allocated with kvzalloc.

Signed-off-by: Jan Dakinevich <jan.dakinevich@virtuozzo.com>
---
 drivers/infiniband/hw/mlx4/main.c    | 65 ++++++++++++++++++++++--------------
 drivers/infiniband/hw/mlx4/mlx4_ib.h |  3 +-
 drivers/infiniband/hw/mlx4/qp.c      |  4 +--
 3 files changed, 44 insertions(+), 28 deletions(-)

diff --git a/drivers/infiniband/hw/mlx4/main.c b/drivers/infiniband/hw/mlx4/main.c
index 0bbeaaa..1e3bb67 100644
--- a/drivers/infiniband/hw/mlx4/main.c
+++ b/drivers/infiniband/hw/mlx4/main.c
@@ -249,7 +249,7 @@ static int mlx4_ib_update_gids(struct gid_entry *gids,
 static int mlx4_ib_add_gid(const struct ib_gid_attr *attr, void **context)
 {
 	struct mlx4_ib_dev *ibdev = to_mdev(attr->device);
-	struct mlx4_ib_iboe *iboe = &ibdev->iboe;
+	struct mlx4_ib_iboe *iboe = ibdev->iboe;
 	struct mlx4_port_gid_table   *port_gid_table;
 	int free = -1, found = -1;
 	int ret = 0;
@@ -327,7 +327,7 @@ static int mlx4_ib_del_gid(const struct ib_gid_attr *attr, void **context)
 {
 	struct gid_cache_context *ctx = *context;
 	struct mlx4_ib_dev *ibdev = to_mdev(attr->device);
-	struct mlx4_ib_iboe *iboe = &ibdev->iboe;
+	struct mlx4_ib_iboe *iboe = ibdev->iboe;
 	struct mlx4_port_gid_table   *port_gid_table;
 	int ret = 0;
 	int hw_update = 0;
@@ -382,7 +382,7 @@ static int mlx4_ib_del_gid(const struct ib_gid_attr *attr, void **context)
 int mlx4_ib_gid_index_to_real_index(struct mlx4_ib_dev *ibdev,
 				    const struct ib_gid_attr *attr)
 {
-	struct mlx4_ib_iboe *iboe = &ibdev->iboe;
+	struct mlx4_ib_iboe *iboe = ibdev->iboe;
 	struct gid_cache_context *ctx = NULL;
 	struct mlx4_port_gid_table   *port_gid_table;
 	int real_index = -EINVAL;
@@ -742,7 +742,7 @@ static int eth_link_query_port(struct ib_device *ibdev, u8 port,
 {
 
 	struct mlx4_ib_dev *mdev = to_mdev(ibdev);
-	struct mlx4_ib_iboe *iboe = &mdev->iboe;
+	struct mlx4_ib_iboe *iboe = mdev->iboe;
 	struct net_device *ndev;
 	enum ib_mtu tmp;
 	struct mlx4_cmd_mailbox *mailbox;
@@ -1415,11 +1415,11 @@ int mlx4_ib_add_mc(struct mlx4_ib_dev *mdev, struct mlx4_ib_qp *mqp,
 	if (!mqp->port)
 		return 0;
 
-	spin_lock_bh(&mdev->iboe.lock);
-	ndev = mdev->iboe.netdevs[mqp->port - 1];
+	spin_lock_bh(&mdev->iboe->lock);
+	ndev = mdev->iboe->netdevs[mqp->port - 1];
 	if (ndev)
 		dev_hold(ndev);
-	spin_unlock_bh(&mdev->iboe.lock);
+	spin_unlock_bh(&mdev->iboe->lock);
 
 	if (ndev) {
 		ret = 1;
@@ -2078,11 +2078,11 @@ static int mlx4_ib_mcg_detach(struct ib_qp *ibqp, union ib_gid *gid, u16 lid)
 	mutex_lock(&mqp->mutex);
 	ge = find_gid_entry(mqp, gid->raw);
 	if (ge) {
-		spin_lock_bh(&mdev->iboe.lock);
-		ndev = ge->added ? mdev->iboe.netdevs[ge->port - 1] : NULL;
+		spin_lock_bh(&mdev->iboe->lock);
+		ndev = ge->added ? mdev->iboe->netdevs[ge->port - 1] : NULL;
 		if (ndev)
 			dev_hold(ndev);
-		spin_unlock_bh(&mdev->iboe.lock);
+		spin_unlock_bh(&mdev->iboe->lock);
 		if (ndev)
 			dev_put(ndev);
 		list_del(&ge->list);
@@ -2373,7 +2373,7 @@ static void mlx4_ib_update_qps(struct mlx4_ib_dev *ibdev,
 	new_smac = mlx4_mac_to_u64(dev->dev_addr);
 	read_unlock(&dev_base_lock);
 
-	atomic64_set(&ibdev->iboe.mac[port - 1], new_smac);
+	atomic64_set(&ibdev->iboe->mac[port - 1], new_smac);
 
 	/* no need for update QP1 and mac registration in non-SRIOV */
 	if (!mlx4_is_mfunc(ibdev->dev))
@@ -2429,7 +2429,7 @@ static void mlx4_ib_scan_netdevs(struct mlx4_ib_dev *ibdev,
 
 	ASSERT_RTNL();
 
-	iboe = &ibdev->iboe;
+	iboe = ibdev->iboe;
 
 	spin_lock_bh(&iboe->lock);
 	mlx4_foreach_ib_transport_port(port, ibdev->dev) {
@@ -2453,13 +2453,13 @@ static int mlx4_ib_netdev_event(struct notifier_block *this,
 				unsigned long event, void *ptr)
 {
 	struct net_device *dev = netdev_notifier_info_to_dev(ptr);
-	struct mlx4_ib_dev *ibdev;
+	struct mlx4_ib_iboe *iboe;
 
 	if (!net_eq(dev_net(dev), &init_net))
 		return NOTIFY_DONE;
 
-	ibdev = container_of(this, struct mlx4_ib_dev, iboe.nb);
-	mlx4_ib_scan_netdevs(ibdev, dev, event);
+	iboe = container_of(this, struct mlx4_ib_iboe, nb);
+	mlx4_ib_scan_netdevs(iboe->parent, dev, event);
 
 	return NOTIFY_DONE;
 }
@@ -2589,6 +2589,14 @@ static void get_fw_ver_str(struct ib_device *device, char *str)
 		 (int) dev->dev->caps.fw_ver & 0xffff);
 }
 
+static void mlx4_ib_release(struct ib_device *device)
+{
+	struct mlx4_ib_dev *ibdev = container_of(device, struct mlx4_ib_dev,
+						 ib_dev);
+
+	kvfree(ibdev->iboe);
+}
+
 static void *mlx4_ib_add(struct mlx4_dev *dev)
 {
 	struct mlx4_ib_dev *ibdev;
@@ -2619,7 +2627,14 @@ static void *mlx4_ib_add(struct mlx4_dev *dev)
 		return NULL;
 	}
 
-	iboe = &ibdev->iboe;
+	ibdev->ib_dev.release		= mlx4_ib_release;
+
+	ibdev->iboe = kvzalloc(sizeof(struct mlx4_ib_iboe), GFP_KERNEL);
+	if (!ibdev->iboe)
+		goto err_dealloc;
+
+	ibdev->iboe->parent = ibdev;
+	iboe = ibdev->iboe;
 
 	if (mlx4_pd_alloc(dev, &ibdev->priv_pdn))
 		goto err_dealloc;
@@ -2948,10 +2963,10 @@ static void *mlx4_ib_add(struct mlx4_dev *dev)
 	return ibdev;
 
 err_notif:
-	if (ibdev->iboe.nb.notifier_call) {
-		if (unregister_netdevice_notifier(&ibdev->iboe.nb))
+	if (ibdev->iboe->nb.notifier_call) {
+		if (unregister_netdevice_notifier(&ibdev->iboe->nb))
 			pr_warn("failure unregistering notifier\n");
-		ibdev->iboe.nb.notifier_call = NULL;
+		ibdev->iboe->nb.notifier_call = NULL;
 	}
 	flush_workqueue(wq);
 
@@ -3073,10 +3088,10 @@ static void mlx4_ib_remove(struct mlx4_dev *dev, void *ibdev_ptr)
 	mlx4_ib_mad_cleanup(ibdev);
 	ib_unregister_device(&ibdev->ib_dev);
 	mlx4_ib_diag_cleanup(ibdev);
-	if (ibdev->iboe.nb.notifier_call) {
-		if (unregister_netdevice_notifier(&ibdev->iboe.nb))
+	if (ibdev->iboe->nb.notifier_call) {
+		if (unregister_netdevice_notifier(&ibdev->iboe->nb))
 			pr_warn("failure unregistering notifier\n");
-		ibdev->iboe.nb.notifier_call = NULL;
+		ibdev->iboe->nb.notifier_call = NULL;
 	}
 
 	mlx4_qp_release_range(dev, ibdev->steer_qpn_base,
@@ -3218,9 +3233,9 @@ static void handle_bonded_port_state_event(struct work_struct *work)
 	struct ib_event ibev;
 
 	kfree(ew);
-	spin_lock_bh(&ibdev->iboe.lock);
+	spin_lock_bh(&ibdev->iboe->lock);
 	for (i = 0; i < MLX4_MAX_PORTS; ++i) {
-		struct net_device *curr_netdev = ibdev->iboe.netdevs[i];
+		struct net_device *curr_netdev = ibdev->iboe->netdevs[i];
 		enum ib_port_state curr_port_state;
 
 		if (!curr_netdev)
@@ -3234,7 +3249,7 @@ static void handle_bonded_port_state_event(struct work_struct *work)
 		bonded_port_state = (bonded_port_state != IB_PORT_ACTIVE) ?
 			curr_port_state : IB_PORT_ACTIVE;
 	}
-	spin_unlock_bh(&ibdev->iboe.lock);
+	spin_unlock_bh(&ibdev->iboe->lock);
 
 	ibev.device = &ibdev->ib_dev;
 	ibev.element.port_num = 1;
diff --git a/drivers/infiniband/hw/mlx4/mlx4_ib.h b/drivers/infiniband/hw/mlx4/mlx4_ib.h
index e10dccc..2996c61 100644
--- a/drivers/infiniband/hw/mlx4/mlx4_ib.h
+++ b/drivers/infiniband/hw/mlx4/mlx4_ib.h
@@ -524,6 +524,7 @@ struct mlx4_ib_iboe {
 	atomic64_t		mac[MLX4_MAX_PORTS];
 	struct notifier_block 	nb;
 	struct mlx4_port_gid_table gids[MLX4_MAX_PORTS];
+	struct mlx4_ib_dev     *parent;
 };
 
 struct pkey_mgt {
@@ -600,7 +601,7 @@ struct mlx4_ib_dev {
 
 	struct mutex		cap_mask_mutex;
 	bool			ib_active;
-	struct mlx4_ib_iboe	iboe;
+	struct mlx4_ib_iboe    *iboe;
 	struct mlx4_ib_counters counters_table[MLX4_MAX_PORTS];
 	int		       *eq_table;
 	struct kobject	       *iov_parent;
diff --git a/drivers/infiniband/hw/mlx4/qp.c b/drivers/infiniband/hw/mlx4/qp.c
index 6dd3cd2..853ef6f 100644
--- a/drivers/infiniband/hw/mlx4/qp.c
+++ b/drivers/infiniband/hw/mlx4/qp.c
@@ -1868,7 +1868,7 @@ static int handle_eth_ud_smac_index(struct mlx4_ib_dev *dev,
 	u64 u64_mac;
 	int smac_index;
 
-	u64_mac = atomic64_read(&dev->iboe.mac[qp->port - 1]);
+	u64_mac = atomic64_read(&dev->iboe->mac[qp->port - 1]);
 
 	context->pri_path.sched_queue = MLX4_IB_DEFAULT_SCHED_QUEUE | ((qp->port - 1) << 6);
 	if (!qp->pri.smac && !qp->pri.smac_port) {
@@ -2926,7 +2926,7 @@ static int fill_gid_by_hw_index(struct mlx4_ib_dev *ibdev, u8 port_num,
 				int index, union ib_gid *gid,
 				enum ib_gid_type *gid_type)
 {
-	struct mlx4_ib_iboe *iboe = &ibdev->iboe;
+	struct mlx4_ib_iboe *iboe = ibdev->iboe;
 	struct mlx4_port_gid_table *port_gid_table;
 	unsigned long flags;
 
-- 
2.1.4
