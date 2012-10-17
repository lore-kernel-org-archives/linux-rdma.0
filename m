From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-3.7 1/3] IB/mlx4: Fix QP1 pkey processing in the Primary Physical Function (PPF)
Date: Wed, 17 Oct 2012 18:42:58 +0200
Message-ID: <1350492181-13471-2-git-send-email-ogerlitz@mellanox.com>
References: <1350492181-13471-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1350492181-13471-1-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>

In the MAD paravirtualization code, one of the checks performed when forwarding
QP1 (GSI) packets from wire to slave was a pkey check: The pkey received in the
MAD must be present in the guest's paravirtualized pkey table, and at least one
of the (packet pkey, guest pkey) must be a full-membership pkey.

However, if both Dom0 and the VFs have only limited membership in the default
pkey, then packets sent by full-member remote hosts arrive at Dom0, but are not
passed on to the VFs with the current pkey1 check.

Fix is as follows:

1. Don't care if pkey received over wire is full or not. If it successfully passed
   HW checks on the real QP1, then simply pass it to guest regardless of whether
   the guest has full or limited membership in its pkey table.

2. If the guest (including paravirtualized Dom0) has both full and limited pkey
   forms in its table, preferentially pass the paravirtualized pkey index of
   the full pkey form in the tunnel header.

3. In the multicast join flow (mlx4/mcg.c), use the index for the default pkey
   (wherever it is located) in replies generated from within the mcg module
   (previously, pkey index 0 was used in all cases).

Signed-off-by: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
---
 drivers/infiniband/hw/mlx4/mad.c |   89 ++++++++++++++++++--------------------
 drivers/infiniband/hw/mlx4/mcg.c |    3 +-
 2 files changed, 44 insertions(+), 48 deletions(-)

diff --git a/drivers/infiniband/hw/mlx4/mad.c b/drivers/infiniband/hw/mlx4/mad.c
index 21a7941..3afb563 100644
--- a/drivers/infiniband/hw/mlx4/mad.c
+++ b/drivers/infiniband/hw/mlx4/mad.c
@@ -409,38 +409,45 @@ int mlx4_ib_find_real_gid(struct ib_device *ibdev, u8 port, __be64 guid)
 }
 
 
-static int get_pkey_phys_indices(struct mlx4_ib_dev *ibdev, u8 port, u8 ph_pkey_ix,
-				 u8 *full_pk_ix, u8 *partial_pk_ix,
-				 int *is_full_member)
+static int find_slave_port_pkey_ix(struct mlx4_ib_dev *dev, int slave,
+				   u8 port, u16 pkey, u16 *ix)
 {
-	u16 search_pkey;
-	int fm;
-	int err = 0;
-	u16 pk;
+	int i, ret;
+	u8 unassigned_pkey_ix, pkey_ix, partial_ix = 0xFF;
+	u16 slot_pkey;
 
-	err = ib_get_cached_pkey(&ibdev->ib_dev, port, ph_pkey_ix, &search_pkey);
-	if (err)
-		return err;
+	if (slave == mlx4_master_func_num(dev->dev))
+		return ib_find_cached_pkey(&dev->ib_dev, port, pkey, ix);
 
-	fm = (search_pkey & 0x8000) ? 1 : 0;
-	if (fm) {
-		*full_pk_ix = ph_pkey_ix;
-		search_pkey &= 0x7FFF;
-	} else {
-		*partial_pk_ix = ph_pkey_ix;
-		search_pkey |= 0x8000;
-	}
+	unassigned_pkey_ix = dev->dev->phys_caps.pkey_phys_table_len[port] - 1;
 
-	if (ib_find_exact_cached_pkey(&ibdev->ib_dev, port, search_pkey, &pk))
-		pk = 0xFFFF;
+	for (i = 0; i < dev->dev->caps.pkey_table_len[port]; i++) {
+		if (dev->pkeys.virt2phys_pkey[slave][port - 1][i] == unassigned_pkey_ix)
+			continue;
 
-	if (fm)
-		*partial_pk_ix = (pk & 0xFF);
-	else
-		*full_pk_ix = (pk & 0xFF);
+		pkey_ix = dev->pkeys.virt2phys_pkey[slave][port - 1][i];
 
-	*is_full_member = fm;
-	return err;
+		ret = ib_get_cached_pkey(&dev->ib_dev, port, pkey_ix, &slot_pkey);
+		if (ret)
+			continue;
+		if ((slot_pkey & 0x7FFF) == (pkey & 0x7FFF)) {
+			if (slot_pkey & 0x8000) {
+				*ix = (u16) pkey_ix;
+				return 0;
+			} else {
+				/* take first partial pkey index found */
+				if (partial_ix == 0xFF)
+					partial_ix = pkey_ix;
+			}
+		}
+	}
+
+	if (partial_ix < 0xFF) {
+		*ix = (u16) partial_ix;
+		return 0;
+	}
+
+	return -EINVAL;
 }
 
 int mlx4_ib_send_to_slave(struct mlx4_ib_dev *dev, int slave, u8 port,
@@ -458,10 +465,8 @@ int mlx4_ib_send_to_slave(struct mlx4_ib_dev *dev, int slave, u8 port,
 	unsigned tun_tx_ix = 0;
 	int dqpn;
 	int ret = 0;
-	int i;
-	int is_full_member = 0;
 	u16 tun_pkey_ix;
-	u8 ph_pkey_ix, full_pk_ix = 0, partial_pk_ix = 0;
+	u16 cached_pkey;
 
 	if (dest_qpt > IB_QPT_GSI)
 		return -EINVAL;
@@ -481,27 +486,17 @@ int mlx4_ib_send_to_slave(struct mlx4_ib_dev *dev, int slave, u8 port,
 	else
 		tun_qp = &tun_ctx->qp[1];
 
-	/* compute pkey index for slave */
-	/* get physical pkey -- virtualized Dom0 pkey to phys*/
+	/* compute pkey index to put in tunnel header for slave */
 	if (dest_qpt) {
-		ph_pkey_ix =
-			dev->pkeys.virt2phys_pkey[mlx4_master_func_num(dev->dev)][port - 1][wc->pkey_index];
-
-		/* now, translate this to the slave pkey index */
-		ret = get_pkey_phys_indices(dev, port, ph_pkey_ix, &full_pk_ix,
-					    &partial_pk_ix, &is_full_member);
+		u16 pkey_ix;
+		ret = ib_get_cached_pkey(&dev->ib_dev, port, wc->pkey_index, &cached_pkey);
 		if (ret)
 			return -EINVAL;
 
-		for (i = 0; i < dev->dev->caps.pkey_table_len[port]; i++) {
-			if ((dev->pkeys.virt2phys_pkey[slave][port - 1][i] == full_pk_ix) ||
-			    (is_full_member &&
-			     (dev->pkeys.virt2phys_pkey[slave][port - 1][i] == partial_pk_ix)))
-				break;
-		}
-		if (i == dev->dev->caps.pkey_table_len[port])
+		ret = find_slave_port_pkey_ix(dev, slave, port, cached_pkey, &pkey_ix);
+		if (ret)
 			return -EINVAL;
-		tun_pkey_ix = i;
+		tun_pkey_ix = pkey_ix;
 	} else
 		tun_pkey_ix = dev->pkeys.virt2phys_pkey[slave][port - 1][0];
 
diff --git a/drivers/infiniband/hw/mlx4/mcg.c b/drivers/infiniband/hw/mlx4/mcg.c
index 3c3b54c..44ff480 100644
--- a/drivers/infiniband/hw/mlx4/mcg.c
+++ b/drivers/infiniband/hw/mlx4/mcg.c
@@ -233,7 +233,8 @@ static int send_mad_to_slave(int slave, struct mlx4_ib_demux_ctx *ctx,
 
 	ib_query_ah(dev->sm_ah[ctx->port - 1], &ah_attr);
 
-	wc.pkey_index = 0;
+	if (ib_find_cached_pkey(&dev->ib_dev, ctx->port, IB_DEFAULT_PKEY_FULL, &wc.pkey_index))
+		return -EINVAL;
 	wc.sl = 0;
 	wc.dlid_path_bits = 0;
 	wc.port_num = ctx->port;
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
