From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH V5 7/8] IB/uverbs: Resolve Ethernet L2 addresses when modifying QP
Date: Thu, 14 Nov 2013 00:29:51 +0200
Message-ID: <1384381792-2023-8-git-send-email-ogerlitz@mellanox.com>
References: <1384381792-2023-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1384381792-2023-1-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, tzahio-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Moni Shoua <monis-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Moni Shoua <monis-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

Existing user space applications provide only IBoE L3 address attributes
to the kernel when they issue QP modify. To comply with them and let such
apps to keep work transparently under the IBoE GID IP addressing changes,
added Eth L2 address resolution in the user-kernel linking piece - uverbs.

Signed-off-by: Moni Shoua <monis-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/core/uverbs_cmd.c |   27 +++++++++++++++++++++++++++
 1 files changed, 27 insertions(+), 0 deletions(-)

diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
index 5bb2a82..74242b9 100644
--- a/drivers/infiniband/core/uverbs_cmd.c
+++ b/drivers/infiniband/core/uverbs_cmd.c
@@ -36,8 +36,10 @@
 #include <linux/file.h>
 #include <linux/fs.h>
 #include <linux/slab.h>
+#include <linux/in6.h>
 
 #include <asm/uaccess.h>
+#include <rdma/ib_addr.h>
 
 #include "uverbs.h"
 
@@ -1911,6 +1913,7 @@ ssize_t ib_uverbs_modify_qp(struct ib_uverbs_file *file,
 	struct ib_qp              *qp;
 	struct ib_qp_attr         *attr;
 	int                        ret;
+	union ib_gid		   sgid;
 
 	if (copy_from_user(&cmd, buf, sizeof cmd))
 		return -EFAULT;
@@ -1974,6 +1977,30 @@ ssize_t ib_uverbs_modify_qp(struct ib_uverbs_file *file,
 	attr->alt_ah_attr.ah_flags 	    = cmd.alt_dest.is_global ? IB_AH_GRH : 0;
 	attr->alt_ah_attr.port_num 	    = cmd.alt_dest.port_num;
 
+	if ((cmd.attr_mask & IB_QP_AV)  &&
+	    (rdma_port_get_link_layer(qp->device, attr->ah_attr.port_num) == IB_LINK_LAYER_ETHERNET)) {
+		ret = ib_query_gid(qp->device, attr->ah_attr.port_num,
+				   attr->ah_attr.grh.sgid_index, &sgid);
+		if (ret)
+			goto out;
+		if (rdma_link_local_addr((struct in6_addr *)attr->ah_attr.grh.dgid.raw)) {
+			rdma_get_ll_mac((struct in6_addr *)attr->ah_attr.grh.dgid.raw, attr->ah_attr.dmac);
+			rdma_get_ll_mac((struct in6_addr *)sgid.raw, attr->smac);
+			attr->vlan_id = rdma_get_vlan_id(&sgid);
+		} else {
+			ret = rdma_addr_find_dmac_by_grh(&sgid, &attr->ah_attr.grh.dgid,
+					attr->ah_attr.dmac, &attr->vlan_id);
+			if (ret)
+				goto out;
+			ret = rdma_addr_find_smac_by_sgid(&sgid, attr->smac, NULL);
+			if (ret)
+				goto out;
+		}
+		cmd.attr_mask |= IB_QP_SMAC;
+		if (attr->vlan_id < 0xFFFF)
+			cmd.attr_mask |= IB_QP_VID;
+	}
+
 	if (qp->real_qp == qp) {
 		ret = qp->device->modify_qp(qp, attr,
 			modify_qp_mask(qp->qp_type, cmd.attr_mask), &udata);
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
