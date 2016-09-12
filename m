From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-rc 3/7] IB/mlx4: Use correct subnet-prefix in QP1 mads under SR-IOV
Date: Mon, 12 Sep 2016 19:16:20 +0300
Message-ID: <1473696984-6161-4-git-send-email-leon@kernel.org>
References: <1473696984-6161-1-git-send-email-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1473696984-6161-1-git-send-email-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>

When sending QP1 MAD packets which use a GRH, the source GID
(which consists of the 64-bit subnet prefix, and the 64 bit port GUID)
must be included in the packet GRH.

For SR-IOV, a GID cache is used, since the source GID needs to be the
slave's source GID, and not the Hypervisor's GID. This cache also
included a subnet_prefix. Unfortunately, the subnet_prefix field in
the cache was never initialized (to the default subnet prefix 0xfe80::0).
As a result, this field remained all zeroes.  Therefore, when SR-IOV
was active, all QP1 packets which included a GRH had a source GID
subnet prefix of all-zeroes.

However, the subnet-prefix should initially be 0xfe80::0 (the default
subnet prefix). In addition, if OpenSM modifies a port's subnet prefix,
the new subnet prefix must be used in the GRH when sending QP1 packets.
To fix this we now initialize the subnet prefix in the SR-IOV GID cache
to the default subnet prefix. We update the cached value if/when OpenSM
modifies the port's subnet prefix. We take this cached value when sending
QP1 packets when SR-IOV is active.

Note that the value is stored as an atomic64. This eliminates any need
for locking when the subnet prefix is being updated.

Note also that we depend on the FW generating the "port management change"
event for tracking subnet-prefix changes performed by OpenSM. If running
early FW (before 2.9.4630), subnet prefix changes will not be tracked (but
the default subnet prefix still will be stored in the cache; therefore
users who do not modify the subnet prefix will not have a problem).
IF there is a need for such tracking also for early FW, we will add that
capability in a subsequent patch.

Fixes: 1ffeb2eb8be9 ("IB/mlx4: SR-IOV IB context objects and proxy/tunnel SQP support")
Signed-off-by: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/hw/mlx4/mad.c     | 23 +++++++++++++++++++++++
 drivers/infiniband/hw/mlx4/mlx4_ib.h |  2 +-
 drivers/infiniband/hw/mlx4/qp.c      |  5 +++--
 3 files changed, 27 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/hw/mlx4/mad.c b/drivers/infiniband/hw/mlx4/mad.c
index 9c2e53d..0f21c3a 100644
--- a/drivers/infiniband/hw/mlx4/mad.c
+++ b/drivers/infiniband/hw/mlx4/mad.c
@@ -1128,6 +1128,27 @@ void handle_port_mgmt_change_event(struct work_struct *work)

 		/* Generate GUID changed event */
 		if (changed_attr & MLX4_EQ_PORT_INFO_GID_PFX_CHANGE_MASK) {
+			if (mlx4_is_master(dev->dev)) {
+				union ib_gid gid;
+				int err = 0;
+
+				if (!eqe->event.port_mgmt_change.params.port_info.gid_prefix)
+					err = __mlx4_ib_query_gid(&dev->ib_dev, port, 0, &gid, 1);
+				else
+					gid.global.subnet_prefix =
+						eqe->event.port_mgmt_change.params.port_info.gid_prefix;
+				if (err) {
+					pr_warn("Could not change QP1 subnet prefix for port %d: query_gid error (%d)\n",
+						port, err);
+				} else {
+					pr_debug("Changing QP1 subnet prefix for port %d. old=0x%llx. new=0x%llx\n",
+						 port,
+						 (u64)atomic64_read(&dev->sriov.demux[port - 1].subnet_prefix),
+						 be64_to_cpu(gid.global.subnet_prefix));
+					atomic64_set(&dev->sriov.demux[port - 1].subnet_prefix,
+						     be64_to_cpu(gid.global.subnet_prefix));
+				}
+			}
 			mlx4_ib_dispatch_event(dev, port, IB_EVENT_GID_CHANGE);
 			/*if master, notify all slaves*/
 			if (mlx4_is_master(dev->dev))
@@ -2202,6 +2223,8 @@ int mlx4_ib_init_sriov(struct mlx4_ib_dev *dev)
 		if (err)
 			goto demux_err;
 		dev->sriov.demux[i].guid_cache[0] = gid.global.interface_id;
+		atomic64_set(&dev->sriov.demux[i].subnet_prefix,
+			     be64_to_cpu(gid.global.subnet_prefix));
 		err = alloc_pv_object(dev, mlx4_master_func_num(dev->dev), i + 1,
 				      &dev->sriov.sqps[i]);
 		if (err)
diff --git a/drivers/infiniband/hw/mlx4/mlx4_ib.h b/drivers/infiniband/hw/mlx4/mlx4_ib.h
index 7c5832e..686ab48 100644
--- a/drivers/infiniband/hw/mlx4/mlx4_ib.h
+++ b/drivers/infiniband/hw/mlx4/mlx4_ib.h
@@ -448,7 +448,7 @@ struct mlx4_ib_demux_ctx {
 	struct workqueue_struct *wq;
 	struct workqueue_struct *ud_wq;
 	spinlock_t ud_lock;
-	__be64 subnet_prefix;
+	atomic64_t subnet_prefix;
 	__be64 guid_cache[128];
 	struct mlx4_ib_dev *dev;
 	/* the following lock protects both mcg_table and mcg_mgid0_list */
diff --git a/drivers/infiniband/hw/mlx4/qp.c b/drivers/infiniband/hw/mlx4/qp.c
index e398c04..7fb9629 100644
--- a/drivers/infiniband/hw/mlx4/qp.c
+++ b/drivers/infiniband/hw/mlx4/qp.c
@@ -2502,8 +2502,9 @@ static int build_mlx_header(struct mlx4_ib_sqp *sqp, struct ib_ud_wr *wr,
 				 * we must use our own cache
 				 */
 				sqp->ud_header.grh.source_gid.global.subnet_prefix =
-					to_mdev(ib_dev)->sriov.demux[sqp->qp.port - 1].
-							       subnet_prefix;
+					cpu_to_be64(atomic64_read(&(to_mdev(ib_dev)->sriov.
+								    demux[sqp->qp.port - 1].
+								    subnet_prefix)));
 				sqp->ud_header.grh.source_gid.global.interface_id =
 					to_mdev(ib_dev)->sriov.demux[sqp->qp.port - 1].
 						       guid_cache[ah->av.ib.gid_index];
--
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
