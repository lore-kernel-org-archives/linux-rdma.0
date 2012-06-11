From: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH for-next 26/29] IB/mlx4: Initialize guid-cache index 0 (default guid)
Date: Mon, 11 Jun 2012 13:46:07 +0300
Message-ID: <1339411570-4689-27-git-send-email-jackm@dev.mellanox.co.il>
References: <1339411570-4689-1-git-send-email-jackm@dev.mellanox.co.il>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1339411570-4689-1-git-send-email-jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, yevgenyp-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

The guid cache introduced by the alias guid feature contains the all the
GUIDs for each port.  GUIDs 1..127 are obtained from the subnet manager.
GUID 0, however, is obtained from the FW and cannot be modified by the
subnet manager. It must be introduced separately into the guid cache.

Initialize the value of GUID 0 in the guid cache (since this cannot be
obtained via the GUID CHANGE event flow, since it does not change).

To accomplish this easily, add capability to __mlx4_ib_query_gid()
to obtain the network view (i.e., physical view) gid at index X,
not just the host (paravirtualized) view.

Signed-off-by: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
---
 drivers/infiniband/hw/mlx4/mad.c     |    5 +++++
 drivers/infiniband/hw/mlx4/main.c    |   28 ++++++++++++++++++++++------
 drivers/infiniband/hw/mlx4/mlx4_ib.h |    3 +++
 3 files changed, 30 insertions(+), 6 deletions(-)

diff --git a/drivers/infiniband/hw/mlx4/mad.c b/drivers/infiniband/hw/mlx4/mad.c
index 6aff431..6f74335 100644
--- a/drivers/infiniband/hw/mlx4/mad.c
+++ b/drivers/infiniband/hw/mlx4/mad.c
@@ -2020,6 +2020,11 @@ int mlx4_ib_init_sriov(struct mlx4_ib_dev *dev)
 		mlx4_ib_warn(&dev->ib_dev, "initializing demux service for %d qp1 clients\n",
 			     dev->dev->caps.sqp_demux);
 		for (i = 0; i < dev->num_ports; i++) {
+			union ib_gid gid;
+			err = __mlx4_ib_query_gid(&dev->ib_dev, i + 1, 0, &gid, 1);
+			if (err)
+				goto demux_err;
+			dev->sriov.demux[i].guid_cache[0] = gid.global.interface_id;
 			err = alloc_pv_object(dev, slave_num(dev), i + 1,
 					      &dev->sriov.sqps[i]);
 			if (err)
diff --git a/drivers/infiniband/hw/mlx4/main.c b/drivers/infiniband/hw/mlx4/main.c
index 074b475..14bb028 100644
--- a/drivers/infiniband/hw/mlx4/main.c
+++ b/drivers/infiniband/hw/mlx4/main.c
@@ -361,12 +361,15 @@ static int mlx4_ib_query_port(struct ib_device *ibdev, u8 port,
 	return __mlx4_ib_query_port(ibdev, port, props, 0);
 }
 
-static int __mlx4_ib_query_gid(struct ib_device *ibdev, u8 port, int index,
-			       union ib_gid *gid)
+int __mlx4_ib_query_gid(struct ib_device *ibdev, u8 port, int index,
+			union ib_gid *gid, int netw_view)
 {
 	struct ib_smp *in_mad  = NULL;
 	struct ib_smp *out_mad = NULL;
 	int err = -ENOMEM;
+	struct mlx4_ib_dev *dev = to_mdev(ibdev);
+	int clear = 0;
+	int mad_ifc_flags = MLX4_MAD_IFC_IGNORE_KEYS;
 
 	in_mad  = kzalloc(sizeof *in_mad, GFP_KERNEL);
 	out_mad = kmalloc(sizeof *out_mad, GFP_KERNEL);
@@ -377,18 +380,29 @@ static int __mlx4_ib_query_gid(struct ib_device *ibdev, u8 port, int index,
 	in_mad->attr_id  = IB_SMP_ATTR_PORT_INFO;
 	in_mad->attr_mod = cpu_to_be32(port);
 
-	err = mlx4_MAD_IFC(to_mdev(ibdev), MLX4_MAD_IFC_IGNORE_KEYS, port,
-			   NULL, NULL, in_mad, out_mad);
+	if (mlx4_is_mfunc(dev->dev) && netw_view)
+		mad_ifc_flags |= MLX4_MAD_IFC_NET_VIEW;
+
+	err = mlx4_MAD_IFC(dev, mad_ifc_flags, port, NULL, NULL, in_mad, out_mad);
 	if (err)
 		goto out;
 
 	memcpy(gid->raw, out_mad->data + 8, 8);
 
+	if (mlx4_is_mfunc(dev->dev) && !netw_view) {
+		if (index) {
+			/* For any index > 0, return the null guid */
+			err = 0;
+			clear = 1;
+			goto out;
+		}
+	}
+
 	init_query_mad(in_mad);
 	in_mad->attr_id  = IB_SMP_ATTR_GUID_INFO;
 	in_mad->attr_mod = cpu_to_be32(index / 8);
 
-	err = mlx4_MAD_IFC(to_mdev(ibdev), MLX4_MAD_IFC_IGNORE_KEYS, port,
+	err = mlx4_MAD_IFC(dev, mad_ifc_flags, port,
 			   NULL, NULL, in_mad, out_mad);
 	if (err)
 		goto out;
@@ -396,6 +410,8 @@ static int __mlx4_ib_query_gid(struct ib_device *ibdev, u8 port, int index,
 	memcpy(gid->raw + 8, out_mad->data + (index % 8) * 8, 8);
 
 out:
+	if (clear)
+		memset(gid->raw + 8, 0, 8);
 	kfree(in_mad);
 	kfree(out_mad);
 	return err;
@@ -415,7 +431,7 @@ static int mlx4_ib_query_gid(struct ib_device *ibdev, u8 port, int index,
 			     union ib_gid *gid)
 {
 	if (rdma_port_get_link_layer(ibdev, port) == IB_LINK_LAYER_INFINIBAND)
-		return __mlx4_ib_query_gid(ibdev, port, index, gid);
+		return __mlx4_ib_query_gid(ibdev, port, index, gid, 0);
 	else
 		return iboe_query_gid(ibdev, port, index, gid);
 }
diff --git a/drivers/infiniband/hw/mlx4/mlx4_ib.h b/drivers/infiniband/hw/mlx4/mlx4_ib.h
index 66d821b..e48e90e 100644
--- a/drivers/infiniband/hw/mlx4/mlx4_ib.h
+++ b/drivers/infiniband/hw/mlx4/mlx4_ib.h
@@ -650,6 +650,9 @@ int __mlx4_ib_query_port(struct ib_device *ibdev, u8 port,
 int __mlx4_ib_query_pkey(struct ib_device *ibdev, u8 port, u16 index,
 			 u16 *pkey, int netw_view);
 
+int __mlx4_ib_query_gid(struct ib_device *ibdev, u8 port, int index,
+			union ib_gid *gid, int netw_view);
+
 int mlx4_ib_resolve_grh(struct mlx4_ib_dev *dev, const struct ib_ah_attr *ah_attr,
 			u8 *mac, int *is_mcast, u8 port);
 
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
