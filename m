From: ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH 1/3] IB/core cleanup: Add const to RDMA helpers
Date: Sun, 31 May 2015 17:15:29 -0400
Message-ID: <1433106931-5215-2-git-send-email-ira.weiny@intel.com>
References: <1433106931-5215-1-git-send-email-ira.weiny@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1433106931-5215-1-git-send-email-ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

The ib_device passed to the new RDMA helpers is constant.  Declare the
ib_device as const in the following functions.

rdma_protocol_ib
rdma_protocol_roce
rdma_protocol_iwarp
rdma_ib_or_roce
rdma_cap_ib_mad
rdma_cap_ib_smi
rdma_cap_ib_cm
rdma_cap_iw_cm
rdma_cap_ib_sa
rdma_cap_ib_mcast
rdma_cap_af_ib
rdma_cap_eth_ah

Signed-off-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

---
Changes from V1:
	Update commit message

 include/rdma/ib_verbs.h |   24 ++++++++++++------------
 1 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index ad499bd..f19739a 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -1831,22 +1831,22 @@ static inline u8 rdma_end_port(const struct ib_device *device)
 		0 : device->phys_port_cnt;
 }
 
-static inline bool rdma_protocol_ib(struct ib_device *device, u8 port_num)
+static inline bool rdma_protocol_ib(const struct ib_device *device, u8 port_num)
 {
 	return device->port_immutable[port_num].core_cap_flags & RDMA_CORE_CAP_PROT_IB;
 }
 
-static inline bool rdma_protocol_roce(struct ib_device *device, u8 port_num)
+static inline bool rdma_protocol_roce(const struct ib_device *device, u8 port_num)
 {
 	return device->port_immutable[port_num].core_cap_flags & RDMA_CORE_CAP_PROT_ROCE;
 }
 
-static inline bool rdma_protocol_iwarp(struct ib_device *device, u8 port_num)
+static inline bool rdma_protocol_iwarp(const struct ib_device *device, u8 port_num)
 {
 	return device->port_immutable[port_num].core_cap_flags & RDMA_CORE_CAP_PROT_IWARP;
 }
 
-static inline bool rdma_ib_or_roce(struct ib_device *device, u8 port_num)
+static inline bool rdma_ib_or_roce(const struct ib_device *device, u8 port_num)
 {
 	return device->port_immutable[port_num].core_cap_flags &
 		(RDMA_CORE_CAP_PROT_IB | RDMA_CORE_CAP_PROT_ROCE);
@@ -1864,7 +1864,7 @@ static inline bool rdma_ib_or_roce(struct ib_device *device, u8 port_num)
  *
  * Return: true if the port supports sending/receiving of MAD packets.
  */
-static inline bool rdma_cap_ib_mad(struct ib_device *device, u8 port_num)
+static inline bool rdma_cap_ib_mad(const struct ib_device *device, u8 port_num)
 {
 	return device->port_immutable[port_num].core_cap_flags & RDMA_CORE_CAP_IB_MAD;
 }
@@ -1889,7 +1889,7 @@ static inline bool rdma_cap_ib_mad(struct ib_device *device, u8 port_num)
  *
  * Return: true if the port provides an SMI.
  */
-static inline bool rdma_cap_ib_smi(struct ib_device *device, u8 port_num)
+static inline bool rdma_cap_ib_smi(const struct ib_device *device, u8 port_num)
 {
 	return device->port_immutable[port_num].core_cap_flags & RDMA_CORE_CAP_IB_SMI;
 }
@@ -1909,7 +1909,7 @@ static inline bool rdma_cap_ib_smi(struct ib_device *device, u8 port_num)
  * Return: true if the port supports an IB CM (this does not guarantee that
  * a CM is actually running however).
  */
-static inline bool rdma_cap_ib_cm(struct ib_device *device, u8 port_num)
+static inline bool rdma_cap_ib_cm(const struct ib_device *device, u8 port_num)
 {
 	return device->port_immutable[port_num].core_cap_flags & RDMA_CORE_CAP_IB_CM;
 }
@@ -1926,7 +1926,7 @@ static inline bool rdma_cap_ib_cm(struct ib_device *device, u8 port_num)
  * Return: true if the port supports an iWARP CM (this does not guarantee that
  * a CM is actually running however).
  */
-static inline bool rdma_cap_iw_cm(struct ib_device *device, u8 port_num)
+static inline bool rdma_cap_iw_cm(const struct ib_device *device, u8 port_num)
 {
 	return device->port_immutable[port_num].core_cap_flags & RDMA_CORE_CAP_IW_CM;
 }
@@ -1946,7 +1946,7 @@ static inline bool rdma_cap_iw_cm(struct ib_device *device, u8 port_num)
  * Administration interface.  This does not imply that the SA service is
  * running locally.
  */
-static inline bool rdma_cap_ib_sa(struct ib_device *device, u8 port_num)
+static inline bool rdma_cap_ib_sa(const struct ib_device *device, u8 port_num)
 {
 	return device->port_immutable[port_num].core_cap_flags & RDMA_CORE_CAP_IB_SA;
 }
@@ -1968,7 +1968,7 @@ static inline bool rdma_cap_ib_sa(struct ib_device *device, u8 port_num)
  * overhead of registering/unregistering with the SM and tracking of the
  * total number of queue pairs attached to the multicast group.
  */
-static inline bool rdma_cap_ib_mcast(struct ib_device *device, u8 port_num)
+static inline bool rdma_cap_ib_mcast(const struct ib_device *device, u8 port_num)
 {
 	return rdma_cap_ib_sa(device, port_num);
 }
@@ -1986,7 +1986,7 @@ static inline bool rdma_cap_ib_mcast(struct ib_device *device, u8 port_num)
  * Return: true if the port uses a GID address to identify devices on the
  * network.
  */
-static inline bool rdma_cap_af_ib(struct ib_device *device, u8 port_num)
+static inline bool rdma_cap_af_ib(const struct ib_device *device, u8 port_num)
 {
 	return device->port_immutable[port_num].core_cap_flags & RDMA_CORE_CAP_AF_IB;
 }
@@ -2007,7 +2007,7 @@ static inline bool rdma_cap_af_ib(struct ib_device *device, u8 port_num)
  * addition of a Global Route Header built from our Ethernet Address
  * Handle into our header list for connectionless packets.
  */
-static inline bool rdma_cap_eth_ah(struct ib_device *device, u8 port_num)
+static inline bool rdma_cap_eth_ah(const struct ib_device *device, u8 port_num)
 {
 	return device->port_immutable[port_num].core_cap_flags & RDMA_CORE_CAP_ETH_AH;
 }
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
