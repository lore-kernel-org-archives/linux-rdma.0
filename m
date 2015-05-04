From: ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [RFC PATCH 5/5] IB/core: Add cap_opa_mad helper using RDMA_CORE_CAP_OPA_MAD flag
Date: Mon,  4 May 2015 02:14:59 -0400
Message-ID: <1430720099-32512-6-git-send-email-ira.weiny@intel.com>
References: <1430720099-32512-1-git-send-email-ira.weiny@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1430720099-32512-1-git-send-email-ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
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

Signed-off-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

---
Changes from the OPA series v4:
	Use new cap_opa_mad and RDMA_CORE_CAP_OPA_MAD flag

 include/rdma/ib_verbs.h |   16 ++++++++++++++++
 1 files changed, 16 insertions(+), 0 deletions(-)

diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 01bdf12..31f1ff9 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -363,6 +363,7 @@ union rdma_protocol_stats {
 #define RDMA_CORE_CAP_IB_CM		0x0000000000000004ULL
 #define RDMA_CORE_CAP_IW_CM		0x0000000000000008ULL
 #define RDMA_CORE_CAP_IB_SA		0x0000000000000010ULL
+#define RDMA_CORE_CAP_OPA_MAD		0x0000000000000020ULL
 
 /* Address format                       0x0000FFFF00000000 */
 #define RDMA_CORE_CAP_AF_IB		0x0000000100000000ULL
@@ -1812,6 +1813,21 @@ static inline int cap_ib_mad(struct ib_device *device, u8 port_num)
 }
 
 /**
+ * cap_opa_mad - Check if the port of device supports OPA defined
+ * Management Datagrams.
+ *
+ * @device: Device to be checked
+ * @port_num: Port number of the device
+ *
+ * Return 0 when port of the device does not support OPA
+ * Management Datagrams.
+ */
+static inline int cap_opa_mad(struct ib_device *device, u8 port_num)
+{
+	return !!(device->core_cap_flags[port_num] & RDMA_CORE_CAP_OPA_MAD);
+}
+
+/**
  * cap_ib_smi - Check if the port of device has the capability Infiniband
  * Subnet Management Interface.
  *
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
