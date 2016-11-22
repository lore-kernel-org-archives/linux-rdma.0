From: Dasaratharaman Chandramouli
        <dasaratharaman.chandramouli-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v2 01/11] IB/core: Add rdma_cap_opa_ah to expose opa address handles
Date: Tue, 22 Nov 2016 14:38:42 -0500
Message-ID: <1479843532-47496-2-git-send-email-dasaratharaman.chandramouli@intel.com>
References: <1479843532-47496-1-git-send-email-dasaratharaman.chandramouli@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1479843532-47496-1-git-send-email-dasaratharaman.chandramouli-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dasaratharaman Chandramouli <dasaratharaman.chandramouli-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Don Hiatt <don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

rdma_cap_opa_ah(..) enables core components to check if the
corresponding port supports extended addresses

Reviewed-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dasaratharaman Chandramouli <dasaratharaman.chandramouli-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Don Hiatt <don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 include/rdma/ib_verbs.h | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 5ad43a4..30fa96e 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -479,6 +479,7 @@ static inline struct rdma_hw_stats *rdma_alloc_hw_stats_struct(
 /* Address format                       0x000FF000 */
 #define RDMA_CORE_CAP_AF_IB             0x00001000
 #define RDMA_CORE_CAP_ETH_AH            0x00002000
+#define RDMA_CORE_CAP_OPA_AH            0x00004000
 
 /* Protocol                             0xFFF00000 */
 #define RDMA_CORE_CAP_PROT_IB           0x00100000
@@ -2472,6 +2473,26 @@ static inline bool rdma_cap_eth_ah(const struct ib_device *device, u8 port_num)
 }
 
 /**
+ * rdma_cap_opa_ah - Check if the port of device has the capability
+ * OPA Address handle
+ * @device: Device to check
+ * @port_num: Port number to check
+ *
+ * OPA Address handles enable use of 32 bit LIDs by using a specially
+ * formatted GID field to carry the LID. This check enables kernel
+ * components to identify such a scheme so that they can then try
+ * to make use of the LID in the GID field.
+ *
+ * Return: true if we are running as a OPA device which enables
+ * 32 bit LIDs to be used in the fabric.
+ */
+static inline bool rdma_cap_opa_ah(struct ib_device *device, u8 port_num)
+{
+	return (device->port_immutable[port_num].core_cap_flags &
+		RDMA_CORE_CAP_OPA_AH) == RDMA_CORE_CAP_OPA_AH;
+}
+
+/**
  * rdma_max_mad_size - Return the max MAD size required by this RDMA Port.
  *
  * @device: Device
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
