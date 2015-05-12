From: ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH 5/5] IB/core: Add rdma_cap_opa_mad helper using RDMA_CORE_CAP_OPA_MAD flag
Date: Mon, 11 May 2015 21:46:58 -0400
Message-ID: <1431395218-27693-6-git-send-email-ira.weiny@intel.com>
References: <1431395218-27693-1-git-send-email-ira.weiny@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1431395218-27693-1-git-send-email-ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

OPA MADs share a common header with IBTA MADs but with a different base version
and an extended length.  These MADs increase the performance of management
traffic on OPA devices.

Sharing a common header with IBTA MADs allows us to share most of the MAD
processing code when dealing with OPA MADs in addition to supporting some IBTA
MADs on OPA devices.

This patch adds the Core Capability flag for OPA MADs.

Signed-off-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

---
 include/rdma/ib_verbs.h | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 162a831..c4b37b3 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -362,6 +362,7 @@ union rdma_protocol_stats {
 #define RDMA_CORE_CAP_IB_CM             0x00000004
 #define RDMA_CORE_CAP_IW_CM             0x00000008
 #define RDMA_CORE_CAP_IB_SA             0x00000010
+#define RDMA_CORE_CAP_OPA_MAD           0x00000020
 
 /* Address format                       0x000FF000 */
 #define RDMA_CORE_CAP_AF_IB             0x00001000
@@ -386,6 +387,8 @@ union rdma_protocol_stats {
 					| RDMA_CORE_CAP_ETH_AH)
 #define RDMA_CORE_PORT_IWARP           (RDMA_CORE_CAP_PROT_IWARP \
 					| RDMA_CORE_CAP_IW_CM)
+#define RDMA_CORE_PORT_INTEL_OPA       (RDMA_CORE_PORT_IBA_IB  \
+					| RDMA_CORE_CAP_OPA_MAD)
 
 struct ib_port_attr {
 	enum ib_port_state	state;
@@ -1836,6 +1839,21 @@ static inline bool rdma_cap_ib_mad(struct ib_device *device, u8 port_num)
 }
 
 /**
+ * rdma_cap_opa_mad - Check if the port of device supports OPA defined
+ * Management Datagrams.
+ *
+ * @device: Device to be checked
+ * @port_num: Port number of the device
+ *
+ * Return 0 when port of the device does not support OPA
+ * Management Datagrams.
+ */
+static inline int rdma_cap_opa_mad(struct ib_device *device, u8 port_num)
+{
+	return (device->port_immutable[port_num].core_cap_flags & RDMA_CORE_CAP_OPA_MAD);
+}
+
+/**
  * rdma_cap_ib_smi - Check if the port of device has the capability Infiniband
  * Subnet Management Interface.
  *
-- 
1.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
