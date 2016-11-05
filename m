From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH rdma-rc 4/9] IB/{core, mlx4}: Handle IPv4 header when demultiplexing MAD
Date: Sat,  5 Nov 2016 21:57:17 +0200
Message-ID: <1478375842-21513-5-git-send-email-leonro@mellanox.com>
References: <1478375842-21513-1-git-send-email-leonro@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1478375842-21513-1-git-send-email-leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

When MAD arrives to the hypervisor, we need to identify which slave it
should be sent by destination GID. When L3 protocol is IPv4 the
GRH is replaced by an IPv4 header.

This patch detects when IPv4 header needs to be parsed instead of GRH.

Fixes: b6ffaeffaea4 ('mlx4: In RoCE allow guests to have multiple GIDS')
Signed-off-by: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Signed-off-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/core/verbs.c  | 16 +++++++++-------
 drivers/infiniband/hw/mlx4/mad.c | 33 ++++++++++++++++++++++++++++++---
 include/rdma/ib_verbs.h          | 19 +++++++++++++++++++
 3 files changed, 58 insertions(+), 10 deletions(-)

diff --git a/drivers/infiniband/core/verbs.c b/drivers/infiniband/core/verbs.c
index 8368764..b3a915f 100644
--- a/drivers/infiniband/core/verbs.c
+++ b/drivers/infiniband/core/verbs.c
@@ -328,7 +328,7 @@ struct ib_ah *ib_create_ah(struct ib_pd *pd, struct ib_ah_attr *ah_attr)
 }
 EXPORT_SYMBOL(ib_create_ah);
 
-static int ib_get_header_version(const union rdma_network_hdr *hdr)
+int ib_get_rdma_header_version(const union rdma_network_hdr *hdr)
 {
 	const struct iphdr *ip4h = (struct iphdr *)&hdr->roce4grh;
 	struct iphdr ip4h_checked;
@@ -359,6 +359,7 @@ static int ib_get_header_version(const union rdma_network_hdr *hdr)
 		return 4;
 	return 6;
 }
+EXPORT_SYMBOL(ib_get_rdma_header_version);
 
 static enum rdma_network_type ib_get_net_type_by_grh(struct ib_device *device,
 						     u8 port_num,
@@ -369,7 +370,7 @@ static enum rdma_network_type ib_get_net_type_by_grh(struct ib_device *device,
 	if (rdma_protocol_ib(device, port_num))
 		return RDMA_NETWORK_IB;
 
-	grh_version = ib_get_header_version((union rdma_network_hdr *)grh);
+	grh_version = ib_get_rdma_header_version((union rdma_network_hdr *)grh);
 
 	if (grh_version == 4)
 		return RDMA_NETWORK_IPV4;
@@ -415,9 +416,9 @@ static int get_sgid_index_from_eth(struct ib_device *device, u8 port_num,
 				     &context, gid_index);
 }
 
-static int get_gids_from_rdma_hdr(union rdma_network_hdr *hdr,
-				  enum rdma_network_type net_type,
-				  union ib_gid *sgid, union ib_gid *dgid)
+int ib_get_gids_from_rdma_hdr(const union rdma_network_hdr *hdr,
+			      enum rdma_network_type net_type,
+			      union ib_gid *sgid, union ib_gid *dgid)
 {
 	struct sockaddr_in  src_in;
 	struct sockaddr_in  dst_in;
@@ -447,6 +448,7 @@ static int get_gids_from_rdma_hdr(union rdma_network_hdr *hdr,
 		return -EINVAL;
 	}
 }
+EXPORT_SYMBOL(ib_get_gids_from_rdma_hdr);
 
 int ib_init_ah_from_wc(struct ib_device *device, u8 port_num,
 		       const struct ib_wc *wc, const struct ib_grh *grh,
@@ -469,8 +471,8 @@ int ib_init_ah_from_wc(struct ib_device *device, u8 port_num,
 			net_type = ib_get_net_type_by_grh(device, port_num, grh);
 		gid_type = ib_network_to_gid_type(net_type);
 	}
-	ret = get_gids_from_rdma_hdr((union rdma_network_hdr *)grh, net_type,
-				     &sgid, &dgid);
+	ret = ib_get_gids_from_rdma_hdr((union rdma_network_hdr *)grh, net_type,
+					&sgid, &dgid);
 	if (ret)
 		return ret;
 
diff --git a/drivers/infiniband/hw/mlx4/mad.c b/drivers/infiniband/hw/mlx4/mad.c
index 1672907..b8e9013 100644
--- a/drivers/infiniband/hw/mlx4/mad.c
+++ b/drivers/infiniband/hw/mlx4/mad.c
@@ -39,6 +39,8 @@
 #include <linux/mlx4/cmd.h>
 #include <linux/gfp.h>
 #include <rdma/ib_pma.h>
+#include <linux/ip.h>
+#include <net/ipv6.h>
 
 #include <linux/mlx4/driver.h>
 #include "mlx4_ib.h"
@@ -480,6 +482,23 @@ static int find_slave_port_pkey_ix(struct mlx4_ib_dev *dev, int slave,
 	return -EINVAL;
 }
 
+static int get_gids_from_l3_hdr(struct ib_grh *grh, union ib_gid *sgid,
+				union ib_gid *dgid)
+{
+	int version = ib_get_rdma_header_version((const union rdma_network_hdr *)grh);
+	enum rdma_network_type net_type;
+
+	if (version == 4)
+		net_type = RDMA_NETWORK_IPV4;
+	else if (version == 6)
+		net_type = RDMA_NETWORK_IPV6;
+	else
+		return -EINVAL;
+
+	return ib_get_gids_from_rdma_hdr((union rdma_network_hdr *)grh, net_type,
+					 sgid, dgid);
+}
+
 int mlx4_ib_send_to_slave(struct mlx4_ib_dev *dev, int slave, u8 port,
 			  enum ib_qp_type dest_qpt, struct ib_wc *wc,
 			  struct ib_grh *grh, struct ib_mad *mad)
@@ -538,7 +557,10 @@ int mlx4_ib_send_to_slave(struct mlx4_ib_dev *dev, int slave, u8 port,
 	memset(&attr, 0, sizeof attr);
 	attr.port_num = port;
 	if (is_eth) {
-		memcpy(&attr.grh.dgid.raw[0], &grh->dgid.raw[0], 16);
+		union ib_gid sgid;
+
+		if (get_gids_from_l3_hdr(grh, &sgid, &attr.grh.dgid))
+			return -EINVAL;
 		attr.ah_flags = IB_AH_GRH;
 	}
 	ah = ib_create_ah(tun_ctx->pd, &attr);
@@ -651,6 +673,11 @@ static int mlx4_ib_demux_mad(struct ib_device *ibdev, u8 port,
 		is_eth = 1;
 
 	if (is_eth) {
+		union ib_gid dgid;
+		union ib_gid sgid;
+
+		if (get_gids_from_l3_hdr(grh, &sgid, &dgid))
+			return -EINVAL;
 		if (!(wc->wc_flags & IB_WC_GRH)) {
 			mlx4_ib_warn(ibdev, "RoCE grh not present.\n");
 			return -EINVAL;
@@ -659,10 +686,10 @@ static int mlx4_ib_demux_mad(struct ib_device *ibdev, u8 port,
 			mlx4_ib_warn(ibdev, "RoCE mgmt class is not CM\n");
 			return -EINVAL;
 		}
-		err = mlx4_get_slave_from_roce_gid(dev->dev, port, grh->dgid.raw, &slave);
+		err = mlx4_get_slave_from_roce_gid(dev->dev, port, dgid.raw, &slave);
 		if (err && mlx4_is_mf_bonded(dev->dev)) {
 			other_port = (port == 1) ? 2 : 1;
-			err = mlx4_get_slave_from_roce_gid(dev->dev, other_port, grh->dgid.raw, &slave);
+			err = mlx4_get_slave_from_roce_gid(dev->dev, other_port, dgid.raw, &slave);
 			if (!err) {
 				port = other_port;
 				pr_debug("resolved slave %d from gid %pI6 wire port %d other %d\n",
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 5ad43a4..467a4b4 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -2581,6 +2581,24 @@ void ib_dealloc_pd(struct ib_pd *pd);
 struct ib_ah *ib_create_ah(struct ib_pd *pd, struct ib_ah_attr *ah_attr);
 
 /**
+ * ib_get_gids_from_rdma_hdr - Get sgid and dgid from GRH or IPv4 header
+ *   work completion.
+ * @hdr: the L3 header to parse
+ * @net_type: type of header to parse
+ * @sgid: place to store source gid
+ * @dgid: place to store destination gid
+ */
+int ib_get_gids_from_rdma_hdr(const union rdma_network_hdr *hdr,
+			      enum rdma_network_type net_type,
+			      union ib_gid *sgid, union ib_gid *dgid);
+
+/**
+ * ib_get_rdma_header_version - Get the header version
+ * @hdr: the L3 header to parse
+ */
+int ib_get_rdma_header_version(const union rdma_network_hdr *hdr);
+
+/**
  * ib_init_ah_from_wc - Initializes address handle attributes from a
  *   work completion.
  * @device: Device on which the received message arrived.
@@ -3357,4 +3375,5 @@ int ib_sg_to_pages(struct ib_mr *mr, struct scatterlist *sgl, int sg_nents,
 void ib_drain_rq(struct ib_qp *qp);
 void ib_drain_sq(struct ib_qp *qp);
 void ib_drain_qp(struct ib_qp *qp);
+
 #endif /* IB_VERBS_H */
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
