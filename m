From: Jan Dakinevich <jan.dakinevich@virtuozzo.com>
Subject: [PATCH 3/4] IB/mlx4: move pkeys field aside from mlx4_ib_dev
Date: Tue, 18 Sep 2018 16:03:45 +0300
Message-ID: <1537275826-27247-4-git-send-email-jan.dakinevich@virtuozzo.com>
References: <1537275826-27247-1-git-send-email-jan.dakinevich@virtuozzo.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1537275826-27247-1-git-send-email-jan.dakinevich@virtuozzo.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>, Yishai Hadas <yishaih@mellanox.com>, Leon Romanovsky <leon@kernel.org>, Parav Pandit <parav@mellanox.com>, Mark Bloch <markb@mellanox.com>, Daniel Jurgens <danielj@mellanox.com>, Kees Cook <keescook@chromium.org>, Kamal Heib <kamalheib1@gmail.com>, Bart Van Assche <bvanassche@acm.org>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Denis Lunev <den@virtuozzo.com>, Konstantin Khorenko <khorenko@virtuozzo.com>, Jan Dakinevich <jan.dakinevich@virtuozzo.com>
List-Id: linux-rdma@vger.kernel.org

This is the 2nd patch of 3 of the work for decreasing size
of mlx4_ib_dev.

The field takes about 36K and could be safely allocated with kvzalloc.

Signed-off-by: Jan Dakinevich <jan.dakinevich@virtuozzo.com>
---
 drivers/infiniband/hw/mlx4/mad.c     | 18 +++++++++---------
 drivers/infiniband/hw/mlx4/main.c    | 11 ++++++++---
 drivers/infiniband/hw/mlx4/mlx4_ib.h |  2 +-
 drivers/infiniband/hw/mlx4/sysfs.c   | 30 +++++++++++++++---------------
 4 files changed, 33 insertions(+), 28 deletions(-)

diff --git a/drivers/infiniband/hw/mlx4/mad.c b/drivers/infiniband/hw/mlx4/mad.c
index e5466d7..3eceb46 100644
--- a/drivers/infiniband/hw/mlx4/mad.c
+++ b/drivers/infiniband/hw/mlx4/mad.c
@@ -268,9 +268,9 @@ static void smp_snoop(struct ib_device *ibdev, u8 port_num, const struct ib_mad
 				pr_debug("PKEY[%d] = x%x\n",
 					 i + bn*32, be16_to_cpu(base[i]));
 				if (be16_to_cpu(base[i]) !=
-				    dev->pkeys.phys_pkey_cache[port_num - 1][i + bn*32]) {
+				    dev->pkeys->phys_pkey_cache[port_num - 1][i + bn*32]) {
 					pkey_change_bitmap |= (1 << i);
-					dev->pkeys.phys_pkey_cache[port_num - 1][i + bn*32] =
+					dev->pkeys->phys_pkey_cache[port_num - 1][i + bn*32] =
 						be16_to_cpu(base[i]);
 				}
 			}
@@ -348,7 +348,7 @@ static void __propagate_pkey_ev(struct mlx4_ib_dev *dev, int port_num,
 				continue;
 			for (ix = 0;
 			     ix < dev->dev->caps.pkey_table_len[port_num]; ix++) {
-				if (dev->pkeys.virt2phys_pkey[slave][port_num - 1]
+				if (dev->pkeys->virt2phys_pkey[slave][port_num - 1]
 				    [ix] == i + 32 * block) {
 					err = mlx4_gen_pkey_eqe(dev->dev, slave, port_num);
 					pr_debug("propagate_pkey_ev: slave %d,"
@@ -455,10 +455,10 @@ static int find_slave_port_pkey_ix(struct mlx4_ib_dev *dev, int slave,
 	unassigned_pkey_ix = dev->dev->phys_caps.pkey_phys_table_len[port] - 1;
 
 	for (i = 0; i < dev->dev->caps.pkey_table_len[port]; i++) {
-		if (dev->pkeys.virt2phys_pkey[slave][port - 1][i] == unassigned_pkey_ix)
+		if (dev->pkeys->virt2phys_pkey[slave][port - 1][i] == unassigned_pkey_ix)
 			continue;
 
-		pkey_ix = dev->pkeys.virt2phys_pkey[slave][port - 1][i];
+		pkey_ix = dev->pkeys->virt2phys_pkey[slave][port - 1][i];
 
 		ret = ib_get_cached_pkey(&dev->ib_dev, port, pkey_ix, &slot_pkey);
 		if (ret)
@@ -546,7 +546,7 @@ int mlx4_ib_send_to_slave(struct mlx4_ib_dev *dev, int slave, u8 port,
 			return -EINVAL;
 		tun_pkey_ix = pkey_ix;
 	} else
-		tun_pkey_ix = dev->pkeys.virt2phys_pkey[slave][port - 1][0];
+		tun_pkey_ix = dev->pkeys->virt2phys_pkey[slave][port - 1][0];
 
 	dqpn = dev->dev->phys_caps.base_proxy_sqpn + 8 * slave + port + (dest_qpt * 2) - 1;
 
@@ -1382,11 +1382,11 @@ int mlx4_ib_send_to_wire(struct mlx4_ib_dev *dev, int slave, u8 port,
 	if (dest_qpt == IB_QPT_SMI) {
 		src_qpnum = 0;
 		sqp = &sqp_ctx->qp[0];
-		wire_pkey_ix = dev->pkeys.virt2phys_pkey[slave][port - 1][0];
+		wire_pkey_ix = dev->pkeys->virt2phys_pkey[slave][port - 1][0];
 	} else {
 		src_qpnum = 1;
 		sqp = &sqp_ctx->qp[1];
-		wire_pkey_ix = dev->pkeys.virt2phys_pkey[slave][port - 1][pkey_index];
+		wire_pkey_ix = dev->pkeys->virt2phys_pkey[slave][port - 1][pkey_index];
 	}
 
 	send_qp = sqp->qp;
@@ -1840,7 +1840,7 @@ static int create_pv_sqp(struct mlx4_ib_demux_pv_ctx *ctx,
 					      &attr.pkey_index);
 	if (ret || !create_tun)
 		attr.pkey_index =
-			to_mdev(ctx->ib_dev)->pkeys.virt2phys_pkey[ctx->slave][ctx->port - 1][0];
+			to_mdev(ctx->ib_dev)->pkeys->virt2phys_pkey[ctx->slave][ctx->port - 1][0];
 	attr.qkey = IB_QP1_QKEY;
 	attr.port_num = ctx->port;
 	ret = ib_modify_qp(tun_qp->qp, &attr, qp_attr_mask_INIT);
diff --git a/drivers/infiniband/hw/mlx4/main.c b/drivers/infiniband/hw/mlx4/main.c
index 1e3bb67..8ba0103 100644
--- a/drivers/infiniband/hw/mlx4/main.c
+++ b/drivers/infiniband/hw/mlx4/main.c
@@ -2477,12 +2477,12 @@ static void init_pkeys(struct mlx4_ib_dev *ibdev)
 				for (i = 0;
 				     i < ibdev->dev->phys_caps.pkey_phys_table_len[port];
 				     ++i) {
-					ibdev->pkeys.virt2phys_pkey[slave][port - 1][i] =
+					ibdev->pkeys->virt2phys_pkey[slave][port - 1][i] =
 					/* master has the identity virt2phys pkey mapping */
 						(slave == mlx4_master_func_num(ibdev->dev) || !i) ? i :
 							ibdev->dev->phys_caps.pkey_phys_table_len[port] - 1;
 					mlx4_sync_pkey_table(ibdev->dev, slave, port, i,
-							     ibdev->pkeys.virt2phys_pkey[slave][port - 1][i]);
+							     ibdev->pkeys->virt2phys_pkey[slave][port - 1][i]);
 				}
 			}
 		}
@@ -2491,7 +2491,7 @@ static void init_pkeys(struct mlx4_ib_dev *ibdev)
 			for (i = 0;
 			     i < ibdev->dev->phys_caps.pkey_phys_table_len[port];
 			     ++i)
-				ibdev->pkeys.phys_pkey_cache[port-1][i] =
+				ibdev->pkeys->phys_pkey_cache[port-1][i] =
 					(i) ? 0 : 0xFFFF;
 		}
 	}
@@ -2595,6 +2595,7 @@ static void mlx4_ib_release(struct ib_device *device)
 						 ib_dev);
 
 	kvfree(ibdev->iboe);
+	kvfree(ibdev->pkeys);
 }
 
 static void *mlx4_ib_add(struct mlx4_dev *dev)
@@ -2636,6 +2637,10 @@ static void *mlx4_ib_add(struct mlx4_dev *dev)
 	ibdev->iboe->parent = ibdev;
 	iboe = ibdev->iboe;
 
+	ibdev->pkeys = kvzalloc(sizeof(struct pkey_mgt), GFP_KERNEL);
+	if (!ibdev->pkeys)
+		goto err_dealloc;
+
 	if (mlx4_pd_alloc(dev, &ibdev->priv_pdn))
 		goto err_dealloc;
 
diff --git a/drivers/infiniband/hw/mlx4/mlx4_ib.h b/drivers/infiniband/hw/mlx4/mlx4_ib.h
index 2996c61..2b5a9b2 100644
--- a/drivers/infiniband/hw/mlx4/mlx4_ib.h
+++ b/drivers/infiniband/hw/mlx4/mlx4_ib.h
@@ -608,7 +608,7 @@ struct mlx4_ib_dev {
 	struct kobject	       *ports_parent;
 	struct kobject	       *dev_ports_parent[MLX4_MFUNC_MAX];
 	struct mlx4_ib_iov_port	iov_ports[MLX4_MAX_PORTS];
-	struct pkey_mgt		pkeys;
+	struct pkey_mgt	       *pkeys;
 	unsigned long *ib_uc_qpns_bitmap;
 	int steer_qpn_count;
 	int steer_qpn_base;
diff --git a/drivers/infiniband/hw/mlx4/sysfs.c b/drivers/infiniband/hw/mlx4/sysfs.c
index e219093..a5b4592a 100644
--- a/drivers/infiniband/hw/mlx4/sysfs.c
+++ b/drivers/infiniband/hw/mlx4/sysfs.c
@@ -447,12 +447,12 @@ static ssize_t show_port_pkey(struct mlx4_port *p, struct port_attribute *attr,
 		container_of(attr, struct port_table_attribute, attr);
 	ssize_t ret = -ENODEV;
 
-	if (p->dev->pkeys.virt2phys_pkey[p->slave][p->port_num - 1][tab_attr->index] >=
+	if (p->dev->pkeys->virt2phys_pkey[p->slave][p->port_num - 1][tab_attr->index] >=
 	    (p->dev->dev->caps.pkey_table_len[p->port_num]))
 		ret = sprintf(buf, "none\n");
 	else
 		ret = sprintf(buf, "%d\n",
-			      p->dev->pkeys.virt2phys_pkey[p->slave]
+			      p->dev->pkeys->virt2phys_pkey[p->slave]
 			      [p->port_num - 1][tab_attr->index]);
 	return ret;
 }
@@ -476,8 +476,8 @@ static ssize_t store_port_pkey(struct mlx4_port *p, struct port_attribute *attr,
 		 idx < 0)
 		return -EINVAL;
 
-	p->dev->pkeys.virt2phys_pkey[p->slave][p->port_num - 1]
-				    [tab_attr->index] = idx;
+	p->dev->pkeys->virt2phys_pkey[p->slave][p->port_num - 1]
+				     [tab_attr->index] = idx;
 	mlx4_sync_pkey_table(p->dev->dev, p->slave, p->port_num,
 			     tab_attr->index, idx);
 	err = mlx4_gen_pkey_eqe(p->dev->dev, p->slave, p->port_num);
@@ -687,7 +687,7 @@ static int add_port(struct mlx4_ib_dev *dev, int port_num, int slave)
 	if (ret)
 		goto err_free_gid;
 
-	list_add_tail(&p->kobj.entry, &dev->pkeys.pkey_port_list[slave]);
+	list_add_tail(&p->kobj.entry, &dev->pkeys->pkey_port_list[slave]);
 	return 0;
 
 err_free_gid:
@@ -716,19 +716,19 @@ static int register_one_pkey_tree(struct mlx4_ib_dev *dev, int slave)
 
 	get_name(dev, name, slave, sizeof name);
 
-	dev->pkeys.device_parent[slave] =
+	dev->pkeys->device_parent[slave] =
 		kobject_create_and_add(name, kobject_get(dev->iov_parent));
 
-	if (!dev->pkeys.device_parent[slave]) {
+	if (!dev->pkeys->device_parent[slave]) {
 		err = -ENOMEM;
 		goto fail_dev;
 	}
 
-	INIT_LIST_HEAD(&dev->pkeys.pkey_port_list[slave]);
+	INIT_LIST_HEAD(&dev->pkeys->pkey_port_list[slave]);
 
 	dev->dev_ports_parent[slave] =
 		kobject_create_and_add("ports",
-				       kobject_get(dev->pkeys.device_parent[slave]));
+				       kobject_get(dev->pkeys->device_parent[slave]));
 
 	if (!dev->dev_ports_parent[slave]) {
 		err = -ENOMEM;
@@ -748,7 +748,7 @@ static int register_one_pkey_tree(struct mlx4_ib_dev *dev, int slave)
 
 err_add:
 	list_for_each_entry_safe(p, t,
-				 &dev->pkeys.pkey_port_list[slave],
+				 &dev->pkeys->pkey_port_list[slave],
 				 entry) {
 		list_del(&p->entry);
 		mport = container_of(p, struct mlx4_port, kobj);
@@ -760,9 +760,9 @@ static int register_one_pkey_tree(struct mlx4_ib_dev *dev, int slave)
 	kobject_put(dev->dev_ports_parent[slave]);
 
 err_ports:
-	kobject_put(dev->pkeys.device_parent[slave]);
+	kobject_put(dev->pkeys->device_parent[slave]);
 	/* extra put for the device_parent create_and_add */
-	kobject_put(dev->pkeys.device_parent[slave]);
+	kobject_put(dev->pkeys->device_parent[slave]);
 
 fail_dev:
 	kobject_put(dev->iov_parent);
@@ -793,7 +793,7 @@ static void unregister_pkey_tree(struct mlx4_ib_dev *device)
 
 	for (slave = device->dev->persist->num_vfs; slave >= 0; --slave) {
 		list_for_each_entry_safe(p, t,
-					 &device->pkeys.pkey_port_list[slave],
+					 &device->pkeys->pkey_port_list[slave],
 					 entry) {
 			list_del(&p->entry);
 			port = container_of(p, struct mlx4_port, kobj);
@@ -804,8 +804,8 @@ static void unregister_pkey_tree(struct mlx4_ib_dev *device)
 			kobject_put(device->dev_ports_parent[slave]);
 		}
 		kobject_put(device->dev_ports_parent[slave]);
-		kobject_put(device->pkeys.device_parent[slave]);
-		kobject_put(device->pkeys.device_parent[slave]);
+		kobject_put(device->pkeys->device_parent[slave]);
+		kobject_put(device->pkeys->device_parent[slave]);
 		kobject_put(device->iov_parent);
 	}
 }
-- 
2.1.4
