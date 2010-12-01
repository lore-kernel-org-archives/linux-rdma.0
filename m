From: Aleksey Senin <alex-192fA4vuk7xBDLzU/O5InQ@public.gmane.org>
Subject: [PATCH V2] mlx4: Protocol distinction
Date: Wed, 1 Dec 2010 18:13:56 +0200
Message-ID: <4CF67444.4080001@senin.name>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Yevgeny Petrilin <yevgenyp-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>, Moni Shoua <monis-hKgKHo2Ms0F+cjeuK/JdrQ@public.gmane.org>, Alex Rosenbaum <Alexr-smomgflXvOZWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Differences from V1
Correct storing members count.
Added protocol type to multicast attach/detach calls.

Newest firmware does a IB/ETH protocol distiction.
There are two bits in members_count field of multicast group table
that store this info and its meaning : 0 - Infiniband, 1 - Ethernet.
While changing members count for particular multicast group it
important not to reset this information.
When calling multicast attach first time, protocol type should be
specified and currently it set to IB, but it will different in the
feature.
While looking for the QP, protocol type shoud be checked too.

Signed-off-by: Aleksey Senin <alekseys-smomgflXvOZWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/hw/mlx4/main.c |    8 +++++---
 drivers/net/mlx4/mcg.c            |   21 ++++++++++++---------
 include/linux/mlx4/device.h       |   10 ++++++++--
 include/linux/mlx4/driver.h       |    6 +-----
 4 files changed, 26 insertions(+), 19 deletions(-)

diff --git a/drivers/infiniband/hw/mlx4/main.c b/drivers/infiniband/hw/mlx4/main.c
index bf3e20c..bbe003f 100644
--- a/drivers/infiniband/hw/mlx4/main.c
+++ b/drivers/infiniband/hw/mlx4/main.c
@@ -624,7 +624,8 @@ static int mlx4_ib_mcg_attach(struct ib_qp *ibqp, union ib_gid *gid, u16 lid)
 	struct mlx4_ib_qp *mqp = to_mqp(ibqp);
 
 	err = mlx4_multicast_attach(mdev->dev, &mqp->mqp, gid->raw, !!(mqp->flags &
-				    MLX4_IB_QP_BLOCK_MULTICAST_LOOPBACK));
+				    MLX4_IB_QP_BLOCK_MULTICAST_LOOPBACK),
+				    MLX4_PROTOCOL_IB);
 	if (err)
 		return err;
 
@@ -635,7 +636,8 @@ static int mlx4_ib_mcg_attach(struct ib_qp *ibqp, union ib_gid *gid, u16 lid)
 	return 0;
 
 err_add:
-	mlx4_multicast_detach(mdev->dev, &mqp->mqp, gid->raw);
+	mlx4_multicast_detach(mdev->dev, &mqp->mqp, gid->raw,
+			MLX4_PROTOCOL_IB);
 	return err;
 }
 
@@ -665,7 +667,7 @@ static int mlx4_ib_mcg_detach(struct ib_qp *ibqp, union ib_gid *gid, u16 lid)
 	struct mlx4_ib_gid_entry *ge;
 
 	err = mlx4_multicast_detach(mdev->dev,
-				    &mqp->mqp, gid->raw);
+				    &mqp->mqp, gid->raw, MLX4_PROTOCOL_IB);
 	if (err)
 		return err;
 
diff --git a/drivers/net/mlx4/mcg.c b/drivers/net/mlx4/mcg.c
index c4f88b7..6d4d509 100644
--- a/drivers/net/mlx4/mcg.c
+++ b/drivers/net/mlx4/mcg.c
@@ -95,7 +95,8 @@ static int mlx4_MGID_HASH(struct mlx4_dev *dev, struct mlx4_cmd_mailbox *mailbox
  * entry in hash chain and *mgm holds end of hash chain.
  */
 static int find_mgm(struct mlx4_dev *dev,
-		    u8 *gid, struct mlx4_cmd_mailbox *mgm_mailbox,
+		    u8 *gid, enum mlx4_protocol prot,
+		    struct mlx4_cmd_mailbox *mgm_mailbox,
 		    u16 *hash, int *prev, int *index)
 {
 	struct mlx4_cmd_mailbox *mailbox;
@@ -134,7 +135,8 @@ static int find_mgm(struct mlx4_dev *dev,
 			return err;
 		}
 
-		if (!memcmp(mgm->gid, gid, 16))
+		if (!memcmp(mgm->gid, gid, 16) &&
+				(prot == be32_to_cpu(mgm->members_count) >> 30))
 			return err;
 
 		*prev = *index;
@@ -146,7 +148,7 @@ static int find_mgm(struct mlx4_dev *dev,
 }
 
 int mlx4_multicast_attach(struct mlx4_dev *dev, struct mlx4_qp *qp, u8 gid[16],
-			  int block_mcast_loopback)
+			  int block_mcast_loopback, enum mlx4_protocol prot)
 {
 	struct mlx4_priv *priv = mlx4_priv(dev);
 	struct mlx4_cmd_mailbox *mailbox;
@@ -165,7 +167,7 @@ int mlx4_multicast_attach(struct mlx4_dev *dev, struct mlx4_qp *qp, u8 gid[16],
 
 	mutex_lock(&priv->mcg_table.mutex);
 
-	err = find_mgm(dev, gid, mailbox, &hash, &prev, &index);
+	err = find_mgm(dev, gid, prot, mailbox, &hash, &prev, &index);
 	if (err)
 		goto out;
 
@@ -187,7 +189,7 @@ int mlx4_multicast_attach(struct mlx4_dev *dev, struct mlx4_qp *qp, u8 gid[16],
 		memcpy(mgm->gid, gid, 16);
 	}
 
-	members_count = be32_to_cpu(mgm->members_count);
+	members_count = be32_to_cpu(mgm->members_count) & 0xffffff;
 	if (members_count == MLX4_QP_PER_MGM) {
 		mlx4_err(dev, "MGM at index %x is full.\n", index);
 		err = -ENOMEM;
@@ -207,7 +209,7 @@ int mlx4_multicast_attach(struct mlx4_dev *dev, struct mlx4_qp *qp, u8 gid[16],
 	else
 		mgm->qp[members_count++] = cpu_to_be32(qp->qpn & MGM_QPN_MASK);
 
-	mgm->members_count       = cpu_to_be32(members_count);
+	mgm->members_count = cpu_to_be32(members_count | ((u32) prot << 30));
 
 	err = mlx4_WRITE_MCG(dev, index, mailbox);
 	if (err)
@@ -242,7 +244,8 @@ out:
 }
 EXPORT_SYMBOL_GPL(mlx4_multicast_attach);
 
-int mlx4_multicast_detach(struct mlx4_dev *dev, struct mlx4_qp *qp, u8 gid[16])
+int mlx4_multicast_detach(struct mlx4_dev *dev, struct mlx4_qp *qp, u8 gid[16],
+		enum mlx4_protocol prot)
 {
 	struct mlx4_priv *priv = mlx4_priv(dev);
 	struct mlx4_cmd_mailbox *mailbox;
@@ -270,7 +273,7 @@ int mlx4_multicast_detach(struct mlx4_dev *dev, struct mlx4_qp *qp, u8 gid[16])
 		goto out;
 	}
 
-	members_count = be32_to_cpu(mgm->members_count);
+	members_count = be32_to_cpu(mgm->members_count) & 0xffffff;
 	for (loc = -1, i = 0; i < members_count; ++i)
 		if ((be32_to_cpu(mgm->qp[i]) & MGM_QPN_MASK) == qp->qpn)
 			loc = i;
@@ -282,7 +285,7 @@ int mlx4_multicast_detach(struct mlx4_dev *dev, struct mlx4_qp *qp, u8 gid[16])
 	}
 
 
-	mgm->members_count = cpu_to_be32(--members_count);
+	mgm->members_count = cpu_to_be32(--members_count | ((u32) prot << 30));
 	mgm->qp[loc]       = mgm->qp[i - 1];
 	mgm->qp[i - 1]     = 0;
 
diff --git a/include/linux/mlx4/device.h b/include/linux/mlx4/device.h
index a7b15bc..a993268 100644
--- a/include/linux/mlx4/device.h
+++ b/include/linux/mlx4/device.h
@@ -144,6 +144,11 @@ enum {
 	MLX4_STAT_RATE_OFFSET	= 5
 };
 
+enum mlx4_protocol {
+	MLX4_PROTOCOL_IB,
+	MLX4_PROTOCOL_EN,
+};
+
 enum {
 	MLX4_MTT_FLAG_PRESENT		= 1
 };
@@ -500,8 +505,9 @@ int mlx4_INIT_PORT(struct mlx4_dev *dev, int port);
 int mlx4_CLOSE_PORT(struct mlx4_dev *dev, int port);
 
 int mlx4_multicast_attach(struct mlx4_dev *dev, struct mlx4_qp *qp, u8 gid[16],
-			  int block_mcast_loopback);
-int mlx4_multicast_detach(struct mlx4_dev *dev, struct mlx4_qp *qp, u8 gid[16]);
+			  int block_mcast_loopback,  enum mlx4_protocol);
+int mlx4_multicast_detach(struct mlx4_dev *dev, struct mlx4_qp *qp, u8 gid[16],
+				enum mlx4_protocol);
 
 int mlx4_register_mac(struct mlx4_dev *dev, u8 port, u64 mac, int *index);
 void mlx4_unregister_mac(struct mlx4_dev *dev, u8 port, int index);
diff --git a/include/linux/mlx4/driver.h b/include/linux/mlx4/driver.h
index f407cd4..e1eebf7 100644
--- a/include/linux/mlx4/driver.h
+++ b/include/linux/mlx4/driver.h
@@ -34,6 +34,7 @@
 #define MLX4_DRIVER_H
 
 #include <linux/device.h>
+#include <linux/mlx4/device.h>
 
 struct mlx4_dev;
 
@@ -44,11 +45,6 @@ enum mlx4_dev_event {
 	MLX4_DEV_EVENT_PORT_REINIT,
 };
 
-enum mlx4_protocol {
-	MLX4_PROTOCOL_IB,
-	MLX4_PROTOCOL_EN,
-};
-
 struct mlx4_interface {
 	void *			(*add)	 (struct mlx4_dev *dev);
 	void			(*remove)(struct mlx4_dev *dev, void *context);
-- 
1.6.4.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
