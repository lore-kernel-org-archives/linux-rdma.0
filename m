From: ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [RFC PATCH 08/11] IB/IPoIB: Retrieve 32 bit LIDs from path records when running on OPA devices
Date: Fri, 23 Sep 2016 13:44:31 -0400
Message-ID: <1474652674-13110-9-git-send-email-ira.weiny@intel.com>
References: <1474652674-13110-1-git-send-email-ira.weiny@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1474652674-13110-1-git-send-email-ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Dasaratharaman Chandramouli <dasaratharaman.chandramouli-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Don Hiatt <don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Dasaratharaman Chandramouli <dasaratharaman.chandramouli-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Path record responses will contain the 32 bit LID information in the
SGID and DGID field of the responses. Modify IPoIB to use these extended
LIDs in datagram and connected mode communication.

Reviewed-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dasaratharaman Chandramouli <dasaratharaman.chandramouli-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Don Hiatt <don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/ulp/ipoib/ipoib.h           |  4 +++-
 drivers/infiniband/ulp/ipoib/ipoib_cm.c        | 11 +++++++++++
 drivers/infiniband/ulp/ipoib/ipoib_main.c      | 26 ++++++++++++++++++++++++++
 drivers/infiniband/ulp/ipoib/ipoib_multicast.c |  2 +-
 4 files changed, 41 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/ulp/ipoib/ipoib.h b/drivers/infiniband/ulp/ipoib/ipoib.h
index 9dbfcc0ab577..448a46bec769 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib.h
+++ b/drivers/infiniband/ulp/ipoib/ipoib.h
@@ -352,7 +352,7 @@ struct ipoib_dev_priv {
 	u32		  qkey;
 
 	union ib_gid local_gid;
-	u16	     local_lid;
+	u32	     local_lid;
 
 	unsigned int admin_mtu;
 	unsigned int mcast_mtu;
@@ -421,6 +421,8 @@ struct ipoib_path {
 	struct rb_node	      rb_node;
 	struct list_head      list;
 	int  		      valid;
+	u32		      dlid;
+	u32		      slid;
 };
 
 struct ipoib_neigh {
diff --git a/drivers/infiniband/ulp/ipoib/ipoib_cm.c b/drivers/infiniband/ulp/ipoib/ipoib_cm.c
index 4ad297d3de89..3499171913ef 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_cm.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_cm.c
@@ -38,6 +38,7 @@
 #include <linux/slab.h>
 #include <linux/vmalloc.h>
 #include <linux/moduleparam.h>
+#include <rdma/ib_addr.h>
 
 #include "ipoib.h"
 
@@ -1356,6 +1357,16 @@ static void ipoib_cm_tx_start(struct work_struct *work)
 		}
 		memcpy(&pathrec, &p->path->pathrec, sizeof pathrec);
 
+		if (rdma_cap_opa_ah(priv->ca, priv->port)) {
+			if (p->path->dlid >= be16_to_cpu(IB_MULTICAST_LID_BASE))
+				pathrec.dgid.global.interface_id =
+					OPA_MAKE_ID(p->path->dlid);
+
+			if (p->path->slid >= be16_to_cpu(IB_MULTICAST_LID_BASE))
+				pathrec.sgid.global.interface_id =
+					OPA_MAKE_ID(p->path->slid);
+		}
+
 		spin_unlock_irqrestore(&priv->lock, flags);
 		netif_tx_unlock_bh(dev);
 
diff --git a/drivers/infiniband/ulp/ipoib/ipoib_main.c b/drivers/infiniband/ulp/ipoib/ipoib_main.c
index cc1c1b062ea5..2bcde9822e3a 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_main.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_main.c
@@ -52,6 +52,7 @@
 #include <linux/inetdevice.h>
 #include <rdma/ib_cache.h>
 #include <linux/pci.h>
+#include <rdma/ib_addr.h>
 
 #define DRV_VERSION "1.0.0"
 
@@ -766,6 +767,31 @@ static void path_rec_completion(int status,
 	spin_lock_irqsave(&priv->lock, flags);
 
 	if (!IS_ERR_OR_NULL(ah)) {
+		/*
+		 * Extended LIDs might get programmed into GIDs in the
+		 * case of OPA devices. Since we have created the ah
+		 * above which would have made use of the lids, now is
+		 * a good time to change them back to regular GIDs after
+		 * saving the extended LIDs.
+		 */
+		if (rdma_cap_opa_ah(priv->ca, priv->port) &&
+		    ib_is_opa_gid(&pathrec->sgid)) {
+			path->slid = opa_get_lid_from_gid(&pathrec->sgid);
+			pathrec->sgid = path->pathrec.sgid;
+		} else {
+			path->slid = be16_to_cpu(pathrec->slid);
+		}
+
+		if (rdma_cap_opa_ah(priv->ca, priv->port) &&
+		    ib_is_opa_gid(&pathrec->dgid)) {
+			path->dlid = opa_get_lid_from_gid(&pathrec->dgid);
+			pathrec->dgid = path->pathrec.dgid;
+		} else {
+			path->dlid = be16_to_cpu(pathrec->dlid);
+		}
+		ipoib_dbg(priv, "PathRec SGID %pI6 DGID %pI6\n",
+			  pathrec->sgid.raw, pathrec->dgid.raw);
+
 		path->pathrec = *pathrec;
 
 		old_ah   = path->ah;
diff --git a/drivers/infiniband/ulp/ipoib/ipoib_multicast.c b/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
index bff73b53bff8..d3394b6add24 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
@@ -581,7 +581,7 @@ void ipoib_mcast_join_task(struct work_struct *work)
 			  port_attr.state);
 		return;
 	}
-	priv->local_lid = (u16)port_attr.lid;
+	priv->local_lid = port_attr.lid;
 	netif_addr_lock_bh(dev);
 
 	if (!test_bit(IPOIB_FLAG_DEV_ADDR_SET, &priv->flags)) {
-- 
1.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
