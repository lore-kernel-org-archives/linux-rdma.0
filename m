From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH for-rc 1/7] IB/opa_vnic: Mark unused Ethernet MTU fields as
 reserved
Date: Tue, 26 Sep 2017 06:43:48 -0700
Message-ID: <20170926134346.11429.60930.stgit@scvm10.sc.intel.com>
References: <20170926134250.11429.58329.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170926134250.11429.58329.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Niranjana Vishwanathapura <niranjana.vishwanathapura-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Sudeep Dutt <sudeep.dutt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Niranjana Vishwanathapura <niranjana.vishwanathapura-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Per pcp mtu fields are not used, mark them as reserved.

Reviewed-by: Sudeep Dutt <sudeep.dutt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Niranjana Vishwanathapura <niranjana.vishwanathapura-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/ulp/opa_vnic/opa_vnic_encap.h   |    8 +++-----
 .../infiniband/ulp/opa_vnic/opa_vnic_internal.h    |    5 ++---
 drivers/infiniband/ulp/opa_vnic/opa_vnic_netdev.c  |    2 +-
 .../infiniband/ulp/opa_vnic/opa_vnic_vema_iface.c  |   10 ++--------
 4 files changed, 8 insertions(+), 17 deletions(-)

diff --git a/drivers/infiniband/ulp/opa_vnic/opa_vnic_encap.h b/drivers/infiniband/ulp/opa_vnic/opa_vnic_encap.h
index 4c434b9..be45697 100644
--- a/drivers/infiniband/ulp/opa_vnic/opa_vnic_encap.h
+++ b/drivers/infiniband/ulp/opa_vnic/opa_vnic_encap.h
@@ -111,8 +111,7 @@
  * @pkey: partition key
  * @u_mcast_dlid: unknown multicast dlid
  * @u_ucast_dlid: array of unknown unicast dlids
- * @eth_mtu: MTUs for each vlan PCP
- * @eth_mtu_non_vlan: MTU for non vlan packets
+ * @eth_mtu: Ethernet MTU
  */
 struct opa_vesw_info {
 	__be16  fabric_id;
@@ -128,9 +127,8 @@ struct opa_vesw_info {
 	__be32  u_mcast_dlid;
 	__be32  u_ucast_dlid[OPA_VESW_MAX_NUM_DEF_PORT];
 
-	u8      rsvd3[44];
-	__be16  eth_mtu[OPA_VNIC_MAX_NUM_PCP];
-	__be16  eth_mtu_non_vlan;
+	u8      rsvd3[60];
+	__be16  eth_mtu;
 	u8      rsvd4[2];
 } __packed;
 
diff --git a/drivers/infiniband/ulp/opa_vnic/opa_vnic_internal.h b/drivers/infiniband/ulp/opa_vnic/opa_vnic_internal.h
index ca29e6d..a90c631 100644
--- a/drivers/infiniband/ulp/opa_vnic/opa_vnic_internal.h
+++ b/drivers/infiniband/ulp/opa_vnic/opa_vnic_internal.h
@@ -89,9 +89,8 @@ struct __opa_vesw_info {
 	u32  u_mcast_dlid;
 	u32  u_ucast_dlid[OPA_VESW_MAX_NUM_DEF_PORT];
 
-	u8   rsvd3[44];
-	u16  eth_mtu[OPA_VNIC_MAX_NUM_PCP];
-	u16  eth_mtu_non_vlan;
+	u8   rsvd3[60];
+	u16  eth_mtu;
 	u8   rsvd4[2];
 } __packed;
 
diff --git a/drivers/infiniband/ulp/opa_vnic/opa_vnic_netdev.c b/drivers/infiniband/ulp/opa_vnic/opa_vnic_netdev.c
index 1a3c253..41fd05b 100644
--- a/drivers/infiniband/ulp/opa_vnic/opa_vnic_netdev.c
+++ b/drivers/infiniband/ulp/opa_vnic/opa_vnic_netdev.c
@@ -140,7 +140,7 @@ void opa_vnic_process_vema_config(struct opa_vnic_adapter *adapter)
 
 	/* Handle MTU limit change */
 	rtnl_lock();
-	netdev->max_mtu = max_t(unsigned int, info->vesw.eth_mtu_non_vlan,
+	netdev->max_mtu = max_t(unsigned int, info->vesw.eth_mtu,
 				netdev->min_mtu);
 	if (netdev->mtu > netdev->max_mtu)
 		dev_set_mtu(netdev, netdev->max_mtu);
diff --git a/drivers/infiniband/ulp/opa_vnic/opa_vnic_vema_iface.c b/drivers/infiniband/ulp/opa_vnic/opa_vnic_vema_iface.c
index c273396..5856ae3 100644
--- a/drivers/infiniband/ulp/opa_vnic/opa_vnic_vema_iface.c
+++ b/drivers/infiniband/ulp/opa_vnic/opa_vnic_vema_iface.c
@@ -177,10 +177,7 @@ void opa_vnic_get_vesw_info(struct opa_vnic_adapter *adapter,
 		info->u_ucast_dlid[i] = cpu_to_be32(src->u_ucast_dlid[i]);
 
 	memcpy(info->rsvd3, src->rsvd3, ARRAY_SIZE(src->rsvd3));
-	for (i = 0; i < OPA_VNIC_MAX_NUM_PCP; i++)
-		info->eth_mtu[i] = cpu_to_be16(src->eth_mtu[i]);
-
-	info->eth_mtu_non_vlan = cpu_to_be16(src->eth_mtu_non_vlan);
+	info->eth_mtu = cpu_to_be16(src->eth_mtu);
 	memcpy(info->rsvd4, src->rsvd4, ARRAY_SIZE(src->rsvd4));
 }
 
@@ -212,10 +209,7 @@ void opa_vnic_set_vesw_info(struct opa_vnic_adapter *adapter,
 		dst->u_ucast_dlid[i] = be32_to_cpu(info->u_ucast_dlid[i]);
 
 	memcpy(dst->rsvd3, info->rsvd3, ARRAY_SIZE(info->rsvd3));
-	for (i = 0; i < OPA_VNIC_MAX_NUM_PCP; i++)
-		dst->eth_mtu[i] = be16_to_cpu(info->eth_mtu[i]);
-
-	dst->eth_mtu_non_vlan = be16_to_cpu(info->eth_mtu_non_vlan);
+	dst->eth_mtu = be16_to_cpu(info->eth_mtu);
 	memcpy(dst->rsvd4, info->rsvd4, ARRAY_SIZE(info->rsvd4));
 }
 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
