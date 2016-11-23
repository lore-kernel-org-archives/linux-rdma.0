From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next 1/5] IB/core: Enhance ib_resolve_eth_dmac to be usable for creating AH
Date: Wed, 23 Nov 2016 08:23:22 +0200
Message-ID: <1479882206-31212-2-git-send-email-leon@kernel.org>
References: <1479882206-31212-1-git-send-email-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1479882206-31212-1-git-send-email-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

The function ib_resolve_eth_dmac() requires struct qp_attr * and
qp_attr_mask as parameters while the function might be useful to resolve
dmac for address handles. This patch changes the signature of the
function so it can be used in the flow of creating an address handle.

Signed-off-by: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/core/core_priv.h  |  3 --
 drivers/infiniband/core/uverbs_cmd.c |  8 ++--
 drivers/infiniband/core/verbs.c      | 84 ++++++++++++++++++------------------
 include/rdma/ib_verbs.h              |  3 ++
 4 files changed, 50 insertions(+), 48 deletions(-)

diff --git a/drivers/infiniband/core/core_priv.h b/drivers/infiniband/core/core_priv.h
index 19d499d..1acc95b 100644
--- a/drivers/infiniband/core/core_priv.h
+++ b/drivers/infiniband/core/core_priv.h
@@ -72,9 +72,6 @@ void ib_device_unregister_sysfs(struct ib_device *device);
 void ib_cache_setup(void);
 void ib_cache_cleanup(void);
 
-int ib_resolve_eth_dmac(struct ib_qp *qp,
-			struct ib_qp_attr *qp_attr, int *qp_attr_mask);
-
 typedef void (*roce_netdev_callback)(struct ib_device *device, u8 port,
 	      struct net_device *idev, void *cookie);
 
diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
index cb3f515a..790af84 100644
--- a/drivers/infiniband/core/uverbs_cmd.c
+++ b/drivers/infiniband/core/uverbs_cmd.c
@@ -2402,9 +2402,11 @@ ssize_t ib_uverbs_modify_qp(struct ib_uverbs_file *file,
 	attr->alt_ah_attr.port_num 	    = cmd.alt_dest.port_num;
 
 	if (qp->real_qp == qp) {
-		ret = ib_resolve_eth_dmac(qp, attr, &cmd.attr_mask);
-		if (ret)
-			goto release_qp;
+		if (cmd.attr_mask & IB_QP_AV) {
+			ret = ib_resolve_eth_dmac(qp->device, &attr->ah_attr);
+			if (ret)
+				goto release_qp;
+		}
 		ret = qp->device->modify_qp(qp, attr,
 			modify_qp_mask(qp->qp_type, cmd.attr_mask), &udata);
 	} else {
diff --git a/drivers/infiniband/core/verbs.c b/drivers/infiniband/core/verbs.c
index 8368764..83d01ef 100644
--- a/drivers/infiniband/core/verbs.c
+++ b/drivers/infiniband/core/verbs.c
@@ -1196,66 +1196,66 @@ int ib_modify_qp_is_ok(enum ib_qp_state cur_state, enum ib_qp_state next_state,
 }
 EXPORT_SYMBOL(ib_modify_qp_is_ok);
 
-int ib_resolve_eth_dmac(struct ib_qp *qp,
-			struct ib_qp_attr *qp_attr, int *qp_attr_mask)
+int ib_resolve_eth_dmac(struct ib_device *device,
+			struct ib_ah_attr *ah_attr)
 {
 	int           ret = 0;
 
-	if (*qp_attr_mask & IB_QP_AV) {
-		if (qp_attr->ah_attr.port_num < rdma_start_port(qp->device) ||
-		    qp_attr->ah_attr.port_num > rdma_end_port(qp->device))
-			return -EINVAL;
-
-		if (!rdma_cap_eth_ah(qp->device, qp_attr->ah_attr.port_num))
-			return 0;
-
-		if (rdma_link_local_addr((struct in6_addr *)qp_attr->ah_attr.grh.dgid.raw)) {
-			rdma_get_ll_mac((struct in6_addr *)qp_attr->ah_attr.grh.dgid.raw,
-					qp_attr->ah_attr.dmac);
-		} else {
-			union ib_gid		sgid;
-			struct ib_gid_attr	sgid_attr;
-			int			ifindex;
-			int			hop_limit;
-
-			ret = ib_query_gid(qp->device,
-					   qp_attr->ah_attr.port_num,
-					   qp_attr->ah_attr.grh.sgid_index,
-					   &sgid, &sgid_attr);
-
-			if (ret || !sgid_attr.ndev) {
-				if (!ret)
-					ret = -ENXIO;
-				goto out;
-			}
+	if (ah_attr->port_num < rdma_start_port(device) ||
+	    ah_attr->port_num > rdma_end_port(device))
+		return -EINVAL;
 
-			ifindex = sgid_attr.ndev->ifindex;
+	if (!rdma_cap_eth_ah(device, ah_attr->port_num))
+		return 0;
 
-			ret = rdma_addr_find_l2_eth_by_grh(&sgid,
-							   &qp_attr->ah_attr.grh.dgid,
-							   qp_attr->ah_attr.dmac,
-							   NULL, &ifindex, &hop_limit);
+	if (rdma_link_local_addr((struct in6_addr *)ah_attr->grh.dgid.raw)) {
+		rdma_get_ll_mac((struct in6_addr *)ah_attr->grh.dgid.raw,
+				ah_attr->dmac);
+	} else {
+		union ib_gid		sgid;
+		struct ib_gid_attr	sgid_attr;
+		int			ifindex;
+		int			hop_limit;
+
+		ret = ib_query_gid(device,
+				   ah_attr->port_num,
+				   ah_attr->grh.sgid_index,
+				   &sgid, &sgid_attr);
+
+		if (ret || !sgid_attr.ndev) {
+			if (!ret)
+				ret = -ENXIO;
+			goto out;
+		}
 
-			dev_put(sgid_attr.ndev);
+		ifindex = sgid_attr.ndev->ifindex;
 
-			qp_attr->ah_attr.grh.hop_limit = hop_limit;
-		}
+		ret = rdma_addr_find_l2_eth_by_grh(&sgid,
+						   &ah_attr->grh.dgid,
+						   ah_attr->dmac,
+						   NULL, &ifindex, &hop_limit);
+
+		dev_put(sgid_attr.ndev);
+
+		ah_attr->grh.hop_limit = hop_limit;
 	}
 out:
 	return ret;
 }
 EXPORT_SYMBOL(ib_resolve_eth_dmac);
 
-
 int ib_modify_qp(struct ib_qp *qp,
 		 struct ib_qp_attr *qp_attr,
 		 int qp_attr_mask)
 {
-	int ret;
 
-	ret = ib_resolve_eth_dmac(qp, qp_attr, &qp_attr_mask);
-	if (ret)
-		return ret;
+	if (qp_attr_mask & IB_QP_AV) {
+		int ret;
+
+		ret = ib_resolve_eth_dmac(qp->device, &qp_attr->ah_attr);
+		if (ret)
+			return ret;
+	}
 
 	return qp->device->modify_qp(qp->real_qp, qp_attr, qp_attr_mask, NULL);
 }
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 5ad43a4..a2f21e0 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -3357,4 +3357,7 @@ int ib_sg_to_pages(struct ib_mr *mr, struct scatterlist *sgl, int sg_nents,
 void ib_drain_rq(struct ib_qp *qp);
 void ib_drain_sq(struct ib_qp *qp);
 void ib_drain_qp(struct ib_qp *qp);
+
+int ib_resolve_eth_dmac(struct ib_device *device,
+			struct ib_ah_attr *ah_attr);
 #endif /* IB_VERBS_H */
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
