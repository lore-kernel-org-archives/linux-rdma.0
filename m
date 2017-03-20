From: Dasaratharaman Chandramouli
        <dasaratharaman.chandramouli-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v2 6/7] IB/core: Add rdma_cap_opa_ah to expose opa address handles
Date: Mon, 20 Mar 2017 19:38:09 -0400
Message-ID: <1490053090-32840-7-git-send-email-dasaratharaman.chandramouli@intel.com>
References: <1490053090-32840-1-git-send-email-dasaratharaman.chandramouli@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1490053090-32840-1-git-send-email-dasaratharaman.chandramouli-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Don Hiatt <don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

rdma_cap_opa_ah(..) enables core components to check if the
corresponding port supports OPA extended addressing.

Reviewed-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Don Hiatt <don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dasaratharaman Chandramouli <dasaratharaman.chandramouli-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 include/rdma/ib_verbs.h | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 8c61532..64cc4ef 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -493,6 +493,7 @@ static inline struct rdma_hw_stats *rdma_alloc_hw_stats_struct(
 /* Address format                       0x000FF000 */
 #define RDMA_CORE_CAP_AF_IB             0x00001000
 #define RDMA_CORE_CAP_ETH_AH            0x00002000
+#define RDMA_CORE_CAP_OPA_AH            0x00004000
 
 /* Protocol                             0xFFF00000 */
 #define RDMA_CORE_CAP_PROT_IB           0x00100000
@@ -2519,6 +2520,21 @@ static inline bool rdma_cap_eth_ah(const struct ib_device *device, u8 port_num)
 }
 
 /**
+ * rdma_cap_opa_ah - Check if the port of device supports
+ * OPA Address handles
+ * @device: Device to check
+ * @port_num: Port number to check
+ *
+ * Return: true if we are running on an OPA device which supports
+ * the extended OPA addressing.
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
