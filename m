From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next 01/10] IB/core: Add raw packet protocol
Date: Sun, 27 Nov 2016 16:51:27 +0200
Message-ID: <1480258296-27032-2-git-send-email-leon@kernel.org>
References: <1480258296-27032-1-git-send-email-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1480258296-27032-1-git-send-email-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Steve Wise <swise-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, "Wei Hu(Xavier)" <xavier.huwei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Faisal Latif <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Selvin Xavier <selvin.xavier-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>, Devesh Sharma <devesh.sharma-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>, Mitesh Ahuja <mitesh.ahuja-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>, Christian Benvenuti <benve-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, Dave Goodell <dgoodell-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Define raw packet protocol which comes to denote this port supports
the RAW_PACKET QP type. To be used in downstream patches where the
IB core serves a query on the supported QP types for device/port.

Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 include/rdma/ib_verbs.h | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 5ad43a4..0cb3194 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -485,6 +485,7 @@ static inline struct rdma_hw_stats *rdma_alloc_hw_stats_struct(
 #define RDMA_CORE_CAP_PROT_ROCE         0x00200000
 #define RDMA_CORE_CAP_PROT_IWARP        0x00400000
 #define RDMA_CORE_CAP_PROT_ROCE_UDP_ENCAP 0x00800000
+#define RDMA_CORE_CAP_PROT_RAW_PACKET   0x01000000
 
 #define RDMA_CORE_PORT_IBA_IB          (RDMA_CORE_CAP_PROT_IB  \
 					| RDMA_CORE_CAP_IB_MAD \
@@ -508,6 +509,8 @@ static inline struct rdma_hw_stats *rdma_alloc_hw_stats_struct(
 #define RDMA_CORE_PORT_INTEL_OPA       (RDMA_CORE_PORT_IBA_IB  \
 					| RDMA_CORE_CAP_OPA_MAD)
 
+#define RDMA_CORE_PORT_RAW_PACKET	(RDMA_CORE_CAP_PROT_RAW_PACKET)
+
 struct ib_port_attr {
 	u64			subnet_prefix;
 	enum ib_port_state	state;
@@ -2286,6 +2289,11 @@ static inline bool rdma_ib_or_roce(const struct ib_device *device, u8 port_num)
 		rdma_protocol_roce(device, port_num);
 }
 
+static inline bool rdma_protocol_raw_packet(const struct ib_device *device, u8 port_num)
+{
+	return device->port_immutable[port_num].core_cap_flags & RDMA_CORE_CAP_PROT_RAW_PACKET;
+}
+
 /**
  * rdma_cap_ib_mad - Check if the port of a device supports Infiniband
  * Management Datagrams.
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
