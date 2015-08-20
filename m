From: Achiad Shochat <achiad-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-next 09/10] IB/mlx5: Add RoCE fields to Address Vector
Date: Thu, 20 Aug 2015 19:46:28 +0300
Message-ID: <1440089189-3361-10-git-send-email-achiad@mellanox.com>
References: <1440089189-3361-1-git-send-email-achiad@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1440089189-3361-1-git-send-email-achiad-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Somnath Kotur <Somnath.Kotur-idTK6quXuVS1Z/+hSey0Gg@public.gmane.org>, Achiad Shochat <achiad-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Set the address handle and QP address path fields according to the
link layer type (IB/Eth).

Signed-off-by: Achiad Shochat <achiad-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/hw/mlx5/ah.c      | 32 +++++++++++++++++++++------
 drivers/infiniband/hw/mlx5/main.c    | 21 ++++++++++++++++++
 drivers/infiniband/hw/mlx5/mlx5_ib.h |  5 +++--
 drivers/infiniband/hw/mlx5/qp.c      | 42 ++++++++++++++++++++++++++----------
 include/linux/mlx5/qp.h              | 21 ++++++++++++------
 5 files changed, 96 insertions(+), 25 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/ah.c b/drivers/infiniband/hw/mlx5/ah.c
index 6608058..745efa4 100644
--- a/drivers/infiniband/hw/mlx5/ah.c
+++ b/drivers/infiniband/hw/mlx5/ah.c
@@ -32,8 +32,10 @@
 
 #include "mlx5_ib.h"
 
-struct ib_ah *create_ib_ah(struct ib_ah_attr *ah_attr,
-			   struct mlx5_ib_ah *ah)
+static struct ib_ah *create_ib_ah(struct mlx5_ib_dev *dev,
+				  struct mlx5_ib_ah *ah,
+				  struct ib_ah_attr *ah_attr,
+				  enum rdma_link_layer ll)
 {
 	if (ah_attr->ah_flags & IB_AH_GRH) {
 		memcpy(ah->av.rgid, &ah_attr->grh.dgid, 16);
@@ -44,9 +46,20 @@ struct ib_ah *create_ib_ah(struct ib_ah_attr *ah_attr,
 		ah->av.tclass = ah_attr->grh.traffic_class;
 	}
 
-	ah->av.rlid = cpu_to_be16(ah_attr->dlid);
-	ah->av.fl_mlid = ah_attr->src_path_bits & 0x7f;
-	ah->av.stat_rate_sl = (ah_attr->static_rate << 4) | (ah_attr->sl & 0xf);
+	ah->av.stat_rate_sl = (ah_attr->static_rate << 4);
+
+	if (ll == IB_LINK_LAYER_ETHERNET) {
+		memcpy(ah->av.rmac, ah_attr->dmac, sizeof(ah_attr->dmac));
+		ah->av.udp_sport =
+			mlx5_get_roce_udp_sport(dev,
+						ah_attr->port_num,
+						ah_attr->grh.sgid_index);
+		ah->av.stat_rate_sl |= (ah_attr->sl & 0x7) << 1;
+	} else {
+		ah->av.rlid = cpu_to_be16(ah_attr->dlid);
+		ah->av.fl_mlid = ah_attr->src_path_bits & 0x7f;
+		ah->av.stat_rate_sl |= (ah_attr->sl & 0xf);
+	}
 
 	return &ah->ibah;
 }
@@ -54,12 +67,19 @@ struct ib_ah *create_ib_ah(struct ib_ah_attr *ah_attr,
 struct ib_ah *mlx5_ib_create_ah(struct ib_pd *pd, struct ib_ah_attr *ah_attr)
 {
 	struct mlx5_ib_ah *ah;
+	struct mlx5_ib_dev *dev = to_mdev(pd->device);
+	enum rdma_link_layer ll;
+
+	ll = pd->device->get_link_layer(pd->device, ah_attr->port_num);
+
+	if (ll == IB_LINK_LAYER_ETHERNET && !(ah_attr->ah_flags & IB_AH_GRH))
+		return ERR_PTR(-EINVAL);
 
 	ah = kzalloc(sizeof(*ah), GFP_ATOMIC);
 	if (!ah)
 		return ERR_PTR(-ENOMEM);
 
-	return create_ib_ah(ah_attr, ah); /* never fails */
+	return create_ib_ah(dev, ah, ah_attr, ll); /* never fails */
 }
 
 int mlx5_ib_query_ah(struct ib_ah *ibah, struct ib_ah_attr *ah_attr)
diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index 975e332..27dab5d 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -41,6 +41,7 @@
 #include <linux/sched.h>
 #include <rdma/ib_user_verbs.h>
 #include <rdma/ib_addr.h>
+#include <rdma/ib_cache.h>
 #include <linux/mlx5/vport.h>
 #include <rdma/ib_smi.h>
 #include <rdma/ib_umem.h>
@@ -252,6 +253,26 @@ static int mlx5_ib_del_gid(struct ib_device *device, u8 port_num,
 	return set_roce_addr(device, port_num, index, NULL, NULL);
 }
 
+__be16 mlx5_get_roce_udp_sport(struct mlx5_ib_dev *dev, u8 port_num,
+			       int index)
+{
+	struct ib_gid_attr attr;
+	union ib_gid gid;
+
+	if (ib_get_cached_gid(&dev->ib_dev, port_num, index, &gid, &attr))
+		return 0;
+
+	if (!attr.ndev)
+		return 0;
+
+	dev_put(attr.ndev);
+
+	if (attr.gid_type != IB_GID_TYPE_ROCE_UDP_ENCAP)
+		return 0;
+
+	return cpu_to_be16(MLX5_CAP_ROCE(dev->mdev, r_roce_min_src_udp_port));
+}
+
 static int mlx5_use_mad_ifc(struct mlx5_ib_dev *dev)
 {
 	return !dev->mdev->issi;
diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw/mlx5/mlx5_ib.h
index 81df6d4..c5704f2 100644
--- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
+++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
@@ -538,8 +538,6 @@ void mlx5_ib_free_srq_wqe(struct mlx5_ib_srq *srq, int wqe_index);
 int mlx5_MAD_IFC(struct mlx5_ib_dev *dev, int ignore_mkey, int ignore_bkey,
 		 u8 port, const struct ib_wc *in_wc, const struct ib_grh *in_grh,
 		 const void *in_mad, void *response_mad);
-struct ib_ah *create_ib_ah(struct ib_ah_attr *ah_attr,
-			   struct mlx5_ib_ah *ah);
 struct ib_ah *mlx5_ib_create_ah(struct ib_pd *pd, struct ib_ah_attr *ah_attr);
 int mlx5_ib_query_ah(struct ib_ah *ibah, struct ib_ah_attr *ah_attr);
 int mlx5_ib_destroy_ah(struct ib_ah *ah);
@@ -676,6 +674,9 @@ static inline void mlx5_ib_qp_enable_pagefaults(struct mlx5_ib_qp *qp)  {}
 
 #endif /* CONFIG_INFINIBAND_ON_DEMAND_PAGING */
 
+__be16 mlx5_get_roce_udp_sport(struct mlx5_ib_dev *dev, u8 port_num,
+			       int index);
+
 static inline void init_query_mad(struct ib_smp *mad)
 {
 	mad->base_version  = 1;
diff --git a/drivers/infiniband/hw/mlx5/qp.c b/drivers/infiniband/hw/mlx5/qp.c
index 203c8a4..3c8a234 100644
--- a/drivers/infiniband/hw/mlx5/qp.c
+++ b/drivers/infiniband/hw/mlx5/qp.c
@@ -32,6 +32,7 @@
 
 #include <linux/module.h>
 #include <rdma/ib_umem.h>
+#include <rdma/ib_cache.h>
 #include "mlx5_ib.h"
 #include "user.h"
 
@@ -1371,17 +1372,12 @@ static int mlx5_set_path(struct mlx5_ib_dev *dev, const struct ib_ah_attr *ah,
 			 struct mlx5_qp_path *path, u8 port, int attr_mask,
 			 u32 path_flags, const struct ib_qp_attr *attr)
 {
+	enum rdma_link_layer ll = rdma_port_get_link_layer(&dev->ib_dev, port);
 	int err;
 
-	path->fl = (path_flags & MLX5_PATH_FLAG_FL) ? 0x80 : 0;
-	path->free_ar = (path_flags & MLX5_PATH_FLAG_FREE_AR) ? 0x80 : 0;
-
 	if (attr_mask & IB_QP_PKEY_INDEX)
 		path->pkey_index = attr->pkey_index;
 
-	path->grh_mlid	= ah->src_path_bits & 0x7f;
-	path->rlid	= cpu_to_be16(ah->dlid);
-
 	if (ah->ah_flags & IB_AH_GRH) {
 		if (ah->grh.sgid_index >=
 		    dev->mdev->port_caps[port - 1].gid_table_len) {
@@ -1390,7 +1386,27 @@ static int mlx5_set_path(struct mlx5_ib_dev *dev, const struct ib_ah_attr *ah,
 			       dev->mdev->port_caps[port - 1].gid_table_len);
 			return -EINVAL;
 		}
-		path->grh_mlid |= 1 << 7;
+	}
+
+	if (ll == IB_LINK_LAYER_ETHERNET) {
+		if (!(ah->ah_flags & IB_AH_GRH))
+			return -EINVAL;
+		memcpy(path->rmac, ah->dmac, sizeof(ah->dmac));
+		path->udp_sport = mlx5_get_roce_udp_sport(dev, port,
+							  ah->grh.sgid_index);
+		path->dci_cfi_prio_sl = (ah->sl & 0x7) << 4;
+	} else {
+		path->fl = (path_flags & MLX5_PATH_FLAG_FL) ? 0x80 : 0;
+		path->free_ar = (path_flags & MLX5_PATH_FLAG_FREE_AR) ? 0x80 :
+									0;
+		path->rlid = cpu_to_be16(ah->dlid);
+		path->grh_mlid = ah->src_path_bits & 0x7f;
+		if (ah->ah_flags & IB_AH_GRH)
+			path->grh_mlid	|= 1 << 7;
+		path->dci_cfi_prio_sl = ah->sl & 0xf;
+	}
+
+	if (ah->ah_flags & IB_AH_GRH) {
 		path->mgid_index = ah->grh.sgid_index;
 		path->hop_limit  = ah->grh.hop_limit;
 		path->tclass_flowlabel =
@@ -1408,8 +1424,6 @@ static int mlx5_set_path(struct mlx5_ib_dev *dev, const struct ib_ah_attr *ah,
 	if (attr_mask & IB_QP_TIMEOUT)
 		path->ackto_lt = attr->timeout << 3;
 
-	path->sl = ah->sl & 0xf;
-
 	return 0;
 }
 
@@ -1772,15 +1786,21 @@ int mlx5_ib_modify_qp(struct ib_qp *ibqp, struct ib_qp_attr *attr,
 	enum ib_qp_state cur_state, new_state;
 	int err = -EINVAL;
 	int port;
+	enum rdma_link_layer ll = IB_LINK_LAYER_UNSPECIFIED;
 
 	mutex_lock(&qp->mutex);
 
 	cur_state = attr_mask & IB_QP_CUR_STATE ? attr->cur_qp_state : qp->state;
 	new_state = attr_mask & IB_QP_STATE ? attr->qp_state : cur_state;
 
+	if (!(cur_state == new_state && cur_state == IB_QPS_RESET)) {
+		port = attr_mask & IB_QP_PORT ? attr->port_num : qp->port;
+		ll = dev->ib_dev.get_link_layer(&dev->ib_dev, port);
+	}
+
 	if (ibqp->qp_type != MLX5_IB_QPT_REG_UMR &&
 	    !ib_modify_qp_is_ok(cur_state, new_state, ibqp->qp_type, attr_mask,
-				IB_LINK_LAYER_UNSPECIFIED))
+				ll))
 		goto out;
 
 	if ((attr_mask & IB_QP_PORT) &&
@@ -3007,7 +3027,7 @@ static void to_ib_ah_attr(struct mlx5_ib_dev *ibdev, struct ib_ah_attr *ib_ah_at
 	    ib_ah_attr->port_num > MLX5_CAP_GEN(dev, num_ports))
 		return;
 
-	ib_ah_attr->sl = path->sl & 0xf;
+	ib_ah_attr->sl = path->dci_cfi_prio_sl & 0xf;
 
 	ib_ah_attr->dlid	  = be16_to_cpu(path->rlid);
 	ib_ah_attr->src_path_bits = path->grh_mlid & 0x7f;
diff --git a/include/linux/mlx5/qp.h b/include/linux/mlx5/qp.h
index f079fb1..a9ad401 100644
--- a/include/linux/mlx5/qp.h
+++ b/include/linux/mlx5/qp.h
@@ -248,8 +248,12 @@ struct mlx5_av {
 	__be32	dqp_dct;
 	u8	stat_rate_sl;
 	u8	fl_mlid;
-	__be16	rlid;
-	u8	reserved0[10];
+	union {
+		__be16	rlid;
+		__be16  udp_sport;
+	};
+	u8	reserved0[4];
+	u8	rmac[6];
 	u8	tclass;
 	u8	hop_limit;
 	__be32	grh_gid_fl;
@@ -456,11 +460,16 @@ struct mlx5_qp_path {
 	u8			static_rate;
 	u8			hop_limit;
 	__be32			tclass_flowlabel;
-	u8			rgid[16];
-	u8			rsvd1[4];
-	u8			sl;
+	union {
+		u8		rgid[16];
+		u8		rip[16];
+	};
+	u8			f_dscp_ecn_prio;
+	u8			ecn_dscp;
+	__be16			udp_sport;
+	u8			dci_cfi_prio_sl;
 	u8			port;
-	u8			rsvd2[6];
+	u8			rmac[6];
 };
 
 struct mlx5_qp_context {
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
