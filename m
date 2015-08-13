From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-next 4/9] IB/core: Add ROCE_UDP_ENCAP (RoCE V2) type
Date: Thu, 13 Aug 2015 19:03:09 +0300
Message-ID: <1439481794-27998-5-git-send-email-matanb@mellanox.com>
References: <1439481794-27998-1-git-send-email-matanb@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1439481794-27998-1-git-send-email-matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Somnath Kotur <Somnath.Kotur-idTK6quXuVSLFuii7jzJGg@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Adding RoCE v2 GID type and port type. Vendors
which support this type will get their GID table
populated with RoCE v2 GIDs automatically.

Signed-off-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/core/cache.c         |  1 +
 drivers/infiniband/core/roce_gid_mgmt.c |  3 ++-
 include/rdma/ib_verbs.h                 | 23 +++++++++++++++++++++--
 3 files changed, 24 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/core/cache.c b/drivers/infiniband/core/cache.c
index 513a1ef..ddd0406 100644
--- a/drivers/infiniband/core/cache.c
+++ b/drivers/infiniband/core/cache.c
@@ -115,6 +115,7 @@ struct ib_gid_table {
 
 static const char * const gid_type_str[] = {
 	[IB_GID_TYPE_IB]	= "IB/RoCE v1",
+	[IB_GID_TYPE_ROCE_UDP_ENCAP]	= "RoCE v2",
 };
 
 const char *ib_cache_gid_type_str(enum ib_gid_type gid_type)
diff --git a/drivers/infiniband/core/roce_gid_mgmt.c b/drivers/infiniband/core/roce_gid_mgmt.c
index 7dec6f2..46b52b9 100644
--- a/drivers/infiniband/core/roce_gid_mgmt.c
+++ b/drivers/infiniband/core/roce_gid_mgmt.c
@@ -71,7 +71,8 @@ static const struct {
 	bool (*is_supported)(const struct ib_device *device, u8 port_num);
 	enum ib_gid_type gid_type;
 } PORT_CAP_TO_GID_TYPE[] = {
-	{rdma_protocol_roce,   IB_GID_TYPE_ROCE},
+	{rdma_protocol_roce_eth_encap, IB_GID_TYPE_ROCE},
+	{rdma_protocol_roce_udp_encap, IB_GID_TYPE_ROCE_UDP_ENCAP},
 };
 
 #define CAP_TO_GID_TABLE_SIZE	ARRAY_SIZE(PORT_CAP_TO_GID_TYPE)
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index a85926d..dd06be8 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -70,6 +70,7 @@ enum ib_gid_type {
 	/* If link layer is Ethernet, this is RoCE V1 */
 	IB_GID_TYPE_IB        = 0,
 	IB_GID_TYPE_ROCE      = 0,
+	IB_GID_TYPE_ROCE_UDP_ENCAP = 1,
 	IB_GID_TYPE_SIZE
 };
 
@@ -398,6 +399,7 @@ union rdma_protocol_stats {
 #define RDMA_CORE_CAP_PROT_IB           0x00100000
 #define RDMA_CORE_CAP_PROT_ROCE         0x00200000
 #define RDMA_CORE_CAP_PROT_IWARP        0x00400000
+#define RDMA_CORE_CAP_PROT_ROCE_UDP_ENCAP 0x00800000
 
 #define RDMA_CORE_PORT_IBA_IB          (RDMA_CORE_CAP_PROT_IB  \
 					| RDMA_CORE_CAP_IB_MAD \
@@ -410,6 +412,12 @@ union rdma_protocol_stats {
 					| RDMA_CORE_CAP_IB_CM   \
 					| RDMA_CORE_CAP_AF_IB   \
 					| RDMA_CORE_CAP_ETH_AH)
+#define RDMA_CORE_PORT_IBA_ROCE_UDP_ENCAP			\
+					(RDMA_CORE_CAP_PROT_ROCE_UDP_ENCAP \
+					| RDMA_CORE_CAP_IB_MAD  \
+					| RDMA_CORE_CAP_IB_CM   \
+					| RDMA_CORE_CAP_AF_IB   \
+					| RDMA_CORE_CAP_ETH_AH)
 #define RDMA_CORE_PORT_IWARP           (RDMA_CORE_CAP_PROT_IWARP \
 					| RDMA_CORE_CAP_IW_CM)
 #define RDMA_CORE_PORT_INTEL_OPA       (RDMA_CORE_PORT_IBA_IB  \
@@ -1919,6 +1927,17 @@ static inline bool rdma_protocol_ib(const struct ib_device *device, u8 port_num)
 
 static inline bool rdma_protocol_roce(const struct ib_device *device, u8 port_num)
 {
+	return device->port_immutable[port_num].core_cap_flags &
+		(RDMA_CORE_CAP_PROT_ROCE | RDMA_CORE_CAP_PROT_ROCE_UDP_ENCAP);
+}
+
+static inline bool rdma_protocol_roce_udp_encap(const struct ib_device *device, u8 port_num)
+{
+	return device->port_immutable[port_num].core_cap_flags & RDMA_CORE_CAP_PROT_ROCE_UDP_ENCAP;
+}
+
+static inline bool rdma_protocol_roce_eth_encap(const struct ib_device *device, u8 port_num)
+{
 	return device->port_immutable[port_num].core_cap_flags & RDMA_CORE_CAP_PROT_ROCE;
 }
 
@@ -1929,8 +1948,8 @@ static inline bool rdma_protocol_iwarp(const struct ib_device *device, u8 port_n
 
 static inline bool rdma_ib_or_roce(const struct ib_device *device, u8 port_num)
 {
-	return device->port_immutable[port_num].core_cap_flags &
-		(RDMA_CORE_CAP_PROT_IB | RDMA_CORE_CAP_PROT_ROCE);
+	return rdma_protocol_ib(device, port_num) ||
+		rdma_protocol_roce(device, port_num);
 }
 
 /**
-- 
2.1.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
