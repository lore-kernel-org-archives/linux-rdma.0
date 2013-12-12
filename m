From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH V6 for-next 7/7] IB/core: Resolve Ethernet L2 addresses when modifying QP
Date: Thu, 12 Dec 2013 18:03:17 +0200
Message-ID: <1386864197-10591-8-git-send-email-ogerlitz@mellanox.com>
References: <1386864197-10591-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1386864197-10591-1-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Moni Shoua <monis-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Existing user space applications provide only IBoE L3 address attributes
to the kernel when they issue QP modify call. To comply with them and let such
apps (plus kernel consumers which don't use the RDMA-CM) to keep work transparently
under the IBoE GID IP addressing changes, added Eth L2 address resolution helper.

Signed-off-by: Moni Shoua <monis-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/core/core_priv.h  |    2 +
 drivers/infiniband/core/uverbs_cmd.c |    4 +++
 drivers/infiniband/core/verbs.c      |   43 ++++++++++++++++++++++++++++++++++
 3 files changed, 49 insertions(+), 0 deletions(-)

diff --git a/drivers/infiniband/core/core_priv.h b/drivers/infiniband/core/core_priv.h
index a565af5..87d1936 100644
--- a/drivers/infiniband/core/core_priv.h
+++ b/drivers/infiniband/core/core_priv.h
@@ -49,4 +49,6 @@ void ib_sysfs_cleanup(void);
 int  ib_cache_setup(void);
 void ib_cache_cleanup(void);
 
+int ib_resolve_eth_l2_attrs(struct ib_qp *qp,
+			    struct ib_qp_attr *qp_attr, int *qp_attr_mask);
 #endif /* _CORE_PRIV_H */
diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
index 65f6e7d..9e6230a 100644
--- a/drivers/infiniband/core/uverbs_cmd.c
+++ b/drivers/infiniband/core/uverbs_cmd.c
@@ -40,6 +40,7 @@
 #include <asm/uaccess.h>
 
 #include "uverbs.h"
+#include "core_priv.h"
 
 struct uverbs_lock_class {
 	struct lock_class_key	key;
@@ -1961,6 +1962,9 @@ ssize_t ib_uverbs_modify_qp(struct ib_uverbs_file *file,
 	attr->alt_ah_attr.port_num 	    = cmd.alt_dest.port_num;
 
 	if (qp->real_qp == qp) {
+		ret = ib_resolve_eth_l2_attrs(qp, attr, &cmd.attr_mask);
+		if (ret)
+			goto out;
 		ret = qp->device->modify_qp(qp, attr,
 			modify_qp_mask(qp->qp_type, cmd.attr_mask), &udata);
 	} else {
diff --git a/drivers/infiniband/core/verbs.c b/drivers/infiniband/core/verbs.c
index 7978394..b3acfc0 100644
--- a/drivers/infiniband/core/verbs.c
+++ b/drivers/infiniband/core/verbs.c
@@ -46,6 +46,8 @@
 #include <rdma/ib_cache.h>
 #include <rdma/ib_addr.h>
 
+#include "core_priv.h"
+
 int ib_rate_to_mult(enum ib_rate rate)
 {
 	switch (rate) {
@@ -859,10 +861,51 @@ int ib_modify_qp_is_ok(enum ib_qp_state cur_state, enum ib_qp_state next_state,
 }
 EXPORT_SYMBOL(ib_modify_qp_is_ok);
 
+int ib_resolve_eth_l2_attrs(struct ib_qp *qp,
+			    struct ib_qp_attr *qp_attr, int *qp_attr_mask)
+{
+	int           ret = 0;
+	union ib_gid  sgid;
+
+	if ((*qp_attr_mask & IB_QP_AV)  &&
+	    (rdma_port_get_link_layer(qp->device, qp_attr->ah_attr.port_num) == IB_LINK_LAYER_ETHERNET)) {
+		ret = ib_query_gid(qp->device, qp_attr->ah_attr.port_num,
+				   qp_attr->ah_attr.grh.sgid_index, &sgid);
+		if (ret)
+			goto out;
+		if (rdma_link_local_addr((struct in6_addr *)qp_attr->ah_attr.grh.dgid.raw)) {
+			rdma_get_ll_mac((struct in6_addr *)qp_attr->ah_attr.grh.dgid.raw, qp_attr->ah_attr.dmac);
+			rdma_get_ll_mac((struct in6_addr *)sgid.raw, qp_attr->smac);
+			qp_attr->vlan_id = rdma_get_vlan_id(&sgid);
+		} else {
+			ret = rdma_addr_find_dmac_by_grh(&sgid, &qp_attr->ah_attr.grh.dgid,
+					qp_attr->ah_attr.dmac, &qp_attr->vlan_id);
+			if (ret)
+				goto out;
+			ret = rdma_addr_find_smac_by_sgid(&sgid, qp_attr->smac, NULL);
+			if (ret)
+				goto out;
+		}
+		*qp_attr_mask |= IB_QP_SMAC;
+		if (qp_attr->vlan_id < 0xFFFF)
+			*qp_attr_mask |= IB_QP_VID;
+	}
+out:
+	return ret;
+}
+EXPORT_SYMBOL(ib_resolve_eth_l2_attrs);
+
+
 int ib_modify_qp(struct ib_qp *qp,
 		 struct ib_qp_attr *qp_attr,
 		 int qp_attr_mask)
 {
+	int ret;
+
+	ret = ib_resolve_eth_l2_attrs(qp, qp_attr, &qp_attr_mask);
+	if (ret)
+		return ret;
+
 	return qp->device->modify_qp(qp->real_qp, qp_attr, qp_attr_mask, NULL);
 }
 EXPORT_SYMBOL(ib_modify_qp);
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
