From: ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH 11/14] IB/core: Add rdma_cap_opa_mad helper
Date: Wed, 20 May 2015 04:13:32 -0400
Message-ID: <1432109615-19564-12-git-send-email-ira.weiny@intel.com>
References: <1432109615-19564-1-git-send-email-ira.weiny@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1432109615-19564-1-git-send-email-ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org, hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

OPA MADs share a common header with IBTA MADs but with a different base version
and an extended length.  These MADs increase the performance of management
traffic on OPA devices.

Sharing a common header with IBTA MADs allows us to share most of the MAD
processing code when dealing with OPA MADs in addition to supporting some IBTA
MADs on OPA devices.

This patch adds the Core Capability flag for OPA MADs as well as a helper
function for testing that flag both of which are used in future patches.

Signed-off-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 include/rdma/ib_verbs.h | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 7b1dcb380987..6d729651901c 100644
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
@@ -1873,6 +1876,24 @@ static inline bool rdma_cap_ib_mad(struct ib_device *device, u8 port_num)
 }
 
 /**
+ * rdma_cap_opa_mad - Check if the port of device provides support for OPA
+ * Management Datagrams.
+ * @device: Device to check
+ * @port_num: Port number to check
+ *
+ * Intel OmniPath devices extend and/or replace the InfiniBand Management
+ * datagrams with their own versions.  These OPA MADs share many but not all of
+ * the characteristics of InfiniBand MADs.
+ *
+ * Return: true if the port supports OPA MAD packet formats.
+ */
+static inline bool rdma_cap_opa_mad(struct ib_device *device, u8 port_num)
+{
+	return (device->port_immutable[port_num].core_cap_flags & RDMA_CORE_CAP_OPA_MAD)
+		== RDMA_CORE_CAP_OPA_MAD;
+}
+
+/**
  * rdma_cap_ib_smi - Check if the port of a device provides an Infiniband
  * Subnet Management Agent (SMA) on the Subnet Management Interface (SMI).
  * @device: Device to check
-- 
1.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
