From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] IB/Verbs: Improve docs for rdma-helpers
Date: Mon, 18 May 2015 13:02:45 -0400
Message-ID: <ba467a840f9f3fb2dbfde68470f9102c0c688ae9.1431968395.git.dledford@redhat.com>
References: <1431968291.3114.13.camel@redhat.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1431968291.3114.13.camel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Michael Wang <yun.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Increase the level of documentation for the rdma_cap_* helpers
introduced by Michael Wang <yun.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>.

This patch is loosely based on a patch Michael wrote to enhance the
documentation of these functions, but has been significantly modified
in terms of verbiage.  In addition, the comments were moved from a kernel
Documentation/infiniband/ file to being inline in the header file itself
for the functions in question.  Finally, the documentation was formated
in proper kdoc format.

Signed-off-by: Michael Wang <yun.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Signed-off-by: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 include/rdma/ib_verbs.h | 132 +++++++++++++++++++++++++++++++++---------------
 1 file changed, 92 insertions(+), 40 deletions(-)

diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 8d59479eea4d..81740c14fdb1 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -1775,14 +1775,16 @@ static inline bool rdma_ib_or_iboe(struct ib_device *device, u8 port_num)
 }
 
 /**
- * rdma_cap_ib_mad - Check if the port of device has the capability Infiniband
+ * rdma_cap_ib_mad - Check if the port of a device supports Infiniband
  * Management Datagrams.
+ * @device: Device to check
+ * @port_num: Port number to check
  *
- * @device: Device to be checked
- * @port_num: Port number of the device
+ * Management Datagrams (MAD) are a required part of the InfiniBand
+ * specification and are supported on all InfiniBand devices.  A slightly
+ * extended version are also supported on OPA interfaces.
  *
- * Return false when port of the device don't support Infiniband
- * Management Datagrams.
+ * Return: true if the port supports sending/receiving of MAD packets.
  */
 static inline bool rdma_cap_ib_mad(struct ib_device *device, u8 port_num)
 {
@@ -1790,14 +1792,24 @@ static inline bool rdma_cap_ib_mad(struct ib_device *device, u8 port_num)
 }
 
 /**
- * rdma_cap_ib_smi - Check if the port of device has the capability Infiniband
- * Subnet Management Interface.
+ * rdma_cap_ib_smi - Check if the port of a device provides an Infiniband
+ * Subnet Management Agent (SMA) on the Subnet Management Interface (SMI).
+ * @device: Device to check
+ * @port_num: Port number to check
  *
- * @device: Device to be checked
- * @port_num: Port number of the device
+ * Each InfiniBand node is required to provide a Subnet Management Agent
+ * that the subnet manager can access.  Prior to the fabric being fully
+ * configured by the subnet manager, the SMA is accessed via a well known
+ * interface called the Subnet Management Interface (SMI).  This interface
+ * uses directed route packets to communicate with the SM to get around the
+ * chicken and egg problem of the SM needing to know what's on the fabric
+ * in order to configure the fabric, and needing to configure the fabric in
+ * order to send packets to the devices on the fabric.  These directed
+ * route packets do not need the fabric fully configured in order to reach
+ * their destination.  The SMI is the only method allowed to send
+ * directed route packets on an InfiniBand fabric.
  *
- * Return false when port of the device don't support Infiniband
- * Subnet Management Interface.
+ * Return: true if the port provides an SMI.
  */
 static inline bool rdma_cap_ib_smi(struct ib_device *device, u8 port_num)
 {
@@ -1807,12 +1819,17 @@ static inline bool rdma_cap_ib_smi(struct ib_device *device, u8 port_num)
 /**
  * rdma_cap_ib_cm - Check if the port of device has the capability Infiniband
  * Communication Manager.
+ * @device: Device to check
+ * @port_num: Port number to check
  *
- * @device: Device to be checked
- * @port_num: Port number of the device
+ * The InfiniBand Communication Manager is one of many pre-defined General
+ * Service Agents (GSA) that are accessed via the General Service
+ * Interface (GSI).  It's role is to facilitate establishment of connections
+ * between nodes as well as other management related tasks for established
+ * connections.
  *
- * Return false when port of the device don't support Infiniband
- * Communication Manager.
+ * Return: true if the port supports an IB CM (this does not guarantee that
+ * a CM is actually running however).
  */
 static inline bool rdma_cap_ib_cm(struct ib_device *device, u8 port_num)
 {
@@ -1822,12 +1839,14 @@ static inline bool rdma_cap_ib_cm(struct ib_device *device, u8 port_num)
 /**
  * rdma_cap_iw_cm - Check if the port of device has the capability IWARP
  * Communication Manager.
+ * @device: Device to check
+ * @port_num: Port number to check
  *
- * @device: Device to be checked
- * @port_num: Port number of the device
+ * Similar to above, but specific to iWARP connections which have a different
+ * managment protocol than InfiniBand.
  *
- * Return false when port of the device don't support IWARP
- * Communication Manager.
+ * Return: true if the port supports an iWARP CM (this does not guarantee that
+ * a CM is actually running however).
  */
 static inline bool rdma_cap_iw_cm(struct ib_device *device, u8 port_num)
 {
@@ -1837,12 +1856,17 @@ static inline bool rdma_cap_iw_cm(struct ib_device *device, u8 port_num)
 /**
  * rdma_cap_ib_sa - Check if the port of device has the capability Infiniband
  * Subnet Administration.
+ * @device: Device to check
+ * @port_num: Port number to check
  *
- * @device: Device to be checked
- * @port_num: Port number of the device
+ * An InfiniBand Subnet Administration (SA) service is a pre-defined General
+ * Service Agent (GSA) provided by the Subnet Manager (SM).  On InfiniBand
+ * fabrics, devices should resolve routes to other hosts by contacting the
+ * SA to query the proper route.
  *
- * Return false when port of the device don't support Infiniband
- * Subnet Administration.
+ * Return: true if the port should act as a client to the fabric Subnet
+ * Administration interface.  This does not imply that the SA service is
+ * running locally.
  */
 static inline bool rdma_cap_ib_sa(struct ib_device *device, u8 port_num)
 {
@@ -1852,12 +1876,19 @@ static inline bool rdma_cap_ib_sa(struct ib_device *device, u8 port_num)
 /**
  * rdma_cap_ib_mcast - Check if the port of device has the capability Infiniband
  * Multicast.
+ * @device: Device to check
+ * @port_num: Port number to check
  *
- * @device: Device to be checked
- * @port_num: Port number of the device
+ * InfiniBand multicast registration is more complex than normal IPv4 or
+ * IPv6 multicast registration.  Each Host Channel Adapter must register
+ * with the Subnet Manager when it wishes to join a multicast group.  It
+ * should do so only once regardless of how many queue pairs it subscribes
+ * to this group.  And it should leave the group only after all queue pairs
+ * attached to the group have been detached.
  *
- * Return false when port of the device don't support Infiniband
- * Multicast.
+ * Return: true if the port must undertake the additional adminstrative
+ * overhead of registering/unregistering with the SM and tracking of the
+ * total number of queue pairs attached to the multicast group.
  */
 static inline bool rdma_cap_ib_mcast(struct ib_device *device, u8 port_num)
 {
@@ -1867,12 +1898,15 @@ static inline bool rdma_cap_ib_mcast(struct ib_device *device, u8 port_num)
 /**
  * rdma_cap_af_ib - Check if the port of device has the capability
  * Native Infiniband Address.
+ * @device: Device to check
+ * @port_num: Port number to check
  *
- * @device: Device to be checked
- * @port_num: Port number of the device
+ * InfiniBand addressing uses a port's GUID + Subnet Prefix to make a default
+ * GID.  RoCE uses a different mechanism, but still generates a GID via
+ * a prescribed mechanism and port specific data.
  *
- * Return false when port of the device don't support
- * Native Infiniband Address.
+ * Return: true if the port uses a GID address to identify devices on the
+ * network.
  */
 static inline bool rdma_cap_af_ib(struct ib_device *device, u8 port_num)
 {
@@ -1881,13 +1915,19 @@ static inline bool rdma_cap_af_ib(struct ib_device *device, u8 port_num)
 
 /**
  * rdma_cap_eth_ah - Check if the port of device has the capability
- * Ethernet Address Handler.
+ * Ethernet Address Handle.
+ * @device: Device to check
+ * @port_num: Port number to check
  *
- * @device: Device to be checked
- * @port_num: Port number of the device
+ * RoCE is InfiniBand over Ethernet, and it uses a well defined technique
+ * to fabricate GIDs over Ethernet/IP specific addresses native to the
+ * port.  Normally, packet headers are generated by the sending host
+ * adapter, but when sending connectionless datagrams, we must manually
+ * inject the proper headers for the fabric we are communicating over.
  *
- * Return false when port of the device don't support
- * Ethernet Address Handler.
+ * Return: true if we are running as a RoCE port and must force the
+ * addition of a Global Route Header built from our Ethernet Address
+ * Handle into our header list for connectionless packets.
  */
 static inline bool rdma_cap_eth_ah(struct ib_device *device, u8 port_num)
 {
@@ -1897,12 +1937,24 @@ static inline bool rdma_cap_eth_ah(struct ib_device *device, u8 port_num)
 /**
  * rdma_cap_read_multi_sge - Check if the port of device has the capability
  * RDMA Read Multiple Scatter-Gather Entries.
+ * @device: Device to check
+ * @port_num: Port number to check
  *
- * @device: Device to be checked
- * @port_num: Port number of the device
+ * iWARP has a restriction that RDMA READ requests may only have a single
+ * Scatter/Gather Entry (SGE) in the work request.
  *
- * Return false when port of the device don't support
- * RDMA Read Multiple Scatter-Gather Entries.
+ * NOTE: although the linux kernel currently assumes all devices are either
+ * single SGE RDMA READ devices or identical SGE maximums for RDMA READs and
+ * WRITEs, according to Tom Talpey, this is not accurate.  There are some
+ * devices out there that support more than a single SGE on RDMA READ
+ * requests, but do not support the same number of SGEs as they do on
+ * RDMA WRITE requests.  The linux kernel would need rearchitecting to
+ * support these imbalanced READ/WRITE SGEs allowed devices.  So, for now,
+ * suffice with either the device supports the same READ/WRITE SGEs, or
+ * it only gets one READ sge.
+ *
+ * Return: true for any device that allows more than one SGE in RDMA READ
+ * requests.
  */
 static inline bool rdma_cap_read_multi_sge(struct ib_device *device,
 					   u8 port_num)
-- 
2.1.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
