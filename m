From: ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [RFC PATCH 03/11] IB/sa: Modify SM Address handle to program GRH when using large lids
Date: Fri, 23 Sep 2016 13:44:26 -0400
Message-ID: <1474652674-13110-4-git-send-email-ira.weiny@intel.com>
References: <1474652674-13110-1-git-send-email-ira.weiny@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1474652674-13110-1-git-send-email-ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Don Hiatt <don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Dasaratharaman Chandramouli <dasaratharaman.chandramouli-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Don Hiatt <don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

When either the port lid or the sm lid is above the ib unicast lid
space, the SMI creates an address handle with the revelant GRH
information.

Reviewed-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dasaratharaman Chandramouli <dasaratharaman.chandramouli-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Don Hiatt <don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/core/sa_query.c | 20 +++++++++++++++++++-
 include/rdma/ib_addr.h             |  2 ++
 2 files changed, 21 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/core/sa_query.c b/drivers/infiniband/core/sa_query.c
index b9bf7aa055e7..0f5fdfb787fb 100644
--- a/drivers/infiniband/core/sa_query.c
+++ b/drivers/infiniband/core/sa_query.c
@@ -958,7 +958,6 @@ static void update_sm_ah(struct work_struct *work)
 		pr_err("Couldn't find index for default PKey\n");
 
 	memset(&ah_attr, 0, sizeof ah_attr);
-	ah_attr.dlid     = port_attr.sm_lid;
 	ah_attr.sl       = port_attr.sm_sl;
 	ah_attr.port_num = port->port_num;
 	if (port_attr.grh_required) {
@@ -967,6 +966,25 @@ static void update_sm_ah(struct work_struct *work)
 		ah_attr.grh.dgid.global.interface_id = cpu_to_be64(IB_SA_WELL_KNOWN_GUID);
 	}
 
+	if (rdma_cap_opa_ah(port->agent->device, port->port_num)) {
+		ah_attr.dlid = OPA_TO_IB_UCAST_LID(port_attr.sm_lid);
+		if ((port_attr.sm_lid >= be16_to_cpu(IB_MULTICAST_LID_BASE)) ||
+		    (port_attr.lid >= be16_to_cpu(IB_MULTICAST_LID_BASE))) {
+			if (port_attr.grh_required)
+				pr_warn("Overwriting GRH specified in SM AH\n");
+			ah_attr.ah_flags = IB_AH_GRH;
+			ah_attr.grh.hop_limit = 1;
+			ah_attr.grh.sgid_index = 0;
+			/* Same prefix as sgid */
+			ah_attr.grh.dgid.global.subnet_prefix =
+				cpu_to_be64(port_attr.subnet_prefix);
+			ah_attr.grh.dgid.global.interface_id =
+					OPA_MAKE_ID(port_attr.sm_lid);
+		}
+	} else {
+		ah_attr.dlid     = (u16)port_attr.sm_lid;
+	}
+
 	new_ah->ah = ib_create_ah(port->agent->qp->pd, &ah_attr);
 	if (IS_ERR(new_ah->ah)) {
 		pr_warn("Couldn't create new SM AH\n");
diff --git a/include/rdma/ib_addr.h b/include/rdma/ib_addr.h
index 04074d7e0763..e6293338dfb1 100644
--- a/include/rdma/ib_addr.h
+++ b/include/rdma/ib_addr.h
@@ -51,6 +51,8 @@
 
 #define OPA_TO_IB_UCAST_LID(x)	(((x) >= be16_to_cpu(IB_MULTICAST_LID_BASE)) \
 				 ? 0 : x)
+#define	OPA_STL_OUI		(0x00066AULL)
+#define OPA_MAKE_ID(x)		(cpu_to_be64(OPA_STL_OUI << 40 | (x)))
 
 struct rdma_addr_client {
 	atomic_t refcount;
-- 
1.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
