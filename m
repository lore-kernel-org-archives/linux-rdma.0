From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH V1 FIXES for-3.11 1/4] IB/core: Create QP1 using the pkey index which contains the default pkey
Date: Thu, 18 Jul 2013 14:02:29 +0300
Message-ID: <1374145352-27816-2-git-send-email-ogerlitz@mellanox.com>
References: <1374145352-27816-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1374145352-27816-1-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>

Currently, QP1 is created using pkey index 0. This patch simply looks for
the index containing the default pkey, rather than hard-coding pkey index 0.

This change will have no effect in Native mode, since QP0 and QP1 are created
before the SM configures the port, so pkey table will still be the default
table defined by the IB Spec, in C10-123: "If non-volatile storage is not used
to hold P_Key Table contents, then if a PM (Partition Manager) is not present,
and prior to PM initialization of the P_Key Table, the P_Key Table must act as
if it contains a single valid entry, at P_Key_ix = 0, containing the default
partition key. All other entries in the P_Key Table must be invalid."

Thus, in the native mode case, the driver will find the default pkey
at index 0 (so it will be no different than the hard-coding).

However, in SRIOV mode, for VFs, the pkey table may be paravirtualized, so
that the VF's pkey index zero may not necessarily be mapped to the real pkey
index 0. For VFs, therefore, it is important to find the virtual index which
maps to the real default pkey.

This commit does the following for QP1 creation:

1. Find the pkey index containing the default pkey, and use that index if found.
   ib_find_pkey() returns the index of the limited-membership default pkey
   (0x7FFF) if the full-member default pkey is not in the table.

2. If neither form of the default pkey is found, use pkey index 0 (previous behavior).

Reviewed-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/core/mad.c |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/drivers/infiniband/core/mad.c b/drivers/infiniband/core/mad.c
index dc3fd1e..4c837e6 100644
--- a/drivers/infiniband/core/mad.c
+++ b/drivers/infiniband/core/mad.c
@@ -2663,6 +2663,7 @@ static int ib_mad_port_start(struct ib_mad_port_private *port_priv)
 	int ret, i;
 	struct ib_qp_attr *attr;
 	struct ib_qp *qp;
+	u16 pkey_index;
 
 	attr = kmalloc(sizeof *attr, GFP_KERNEL);
 	if (!attr) {
@@ -2670,6 +2671,11 @@ static int ib_mad_port_start(struct ib_mad_port_private *port_priv)
 		return -ENOMEM;
 	}
 
+	ret = ib_find_pkey(port_priv->device, port_priv->port_num,
+			   IB_DEFAULT_PKEY_FULL, &pkey_index);
+	if (ret)
+		pkey_index = 0;
+
 	for (i = 0; i < IB_MAD_QPS_CORE; i++) {
 		qp = port_priv->qp_info[i].qp;
 		if (!qp)
@@ -2680,7 +2686,7 @@ static int ib_mad_port_start(struct ib_mad_port_private *port_priv)
 		 * one is needed for the Reset to Init transition
 		 */
 		attr->qp_state = IB_QPS_INIT;
-		attr->pkey_index = 0;
+		attr->pkey_index = pkey_index;
 		attr->qkey = (qp->qp_num == 0) ? 0 : IB_QP1_QKEY;
 		ret = ib_modify_qp(qp, attr, IB_QP_STATE |
 					     IB_QP_PKEY_INDEX | IB_QP_QKEY);
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
