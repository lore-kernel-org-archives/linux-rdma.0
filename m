From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH for-rc 4/7] IB/opa_vnic: Properly return the total MACs in
 UC MAC list
Date: Tue, 26 Sep 2017 06:44:07 -0700
Message-ID: <20170926134406.11429.2358.stgit@scvm10.sc.intel.com>
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

Do not include EM specified MAC address in total MACs of the
UC MAC list.

Reviewed-by: Sudeep Dutt <sudeep.dutt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Niranjana Vishwanathapura <niranjana.vishwanathapura-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 .../infiniband/ulp/opa_vnic/opa_vnic_vema_iface.c  |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/ulp/opa_vnic/opa_vnic_vema_iface.c b/drivers/infiniband/ulp/opa_vnic/opa_vnic_vema_iface.c
index 5856ae3..5553900 100644
--- a/drivers/infiniband/ulp/opa_vnic/opa_vnic_vema_iface.c
+++ b/drivers/infiniband/ulp/opa_vnic/opa_vnic_vema_iface.c
@@ -342,7 +342,7 @@ void opa_vnic_query_mcast_macs(struct opa_vnic_adapter *adapter,
 void opa_vnic_query_ucast_macs(struct opa_vnic_adapter *adapter,
 			       struct opa_veswport_iface_macs *macs)
 {
-	u16 start_idx, tot_macs, num_macs, idx = 0, count = 0;
+	u16 start_idx, tot_macs, num_macs, idx = 0, count = 0, em_macs = 0;
 	struct netdev_hw_addr *ha;
 
 	start_idx = be16_to_cpu(macs->start_idx);
@@ -353,8 +353,10 @@ void opa_vnic_query_ucast_macs(struct opa_vnic_adapter *adapter,
 
 		/* Do not include EM specified MAC address */
 		if (!memcmp(adapter->info.vport.base_mac_addr, ha->addr,
-			    ARRAY_SIZE(adapter->info.vport.base_mac_addr)))
+			    ARRAY_SIZE(adapter->info.vport.base_mac_addr))) {
+			em_macs++;
 			continue;
+		}
 
 		if (start_idx > idx++)
 			continue;
@@ -377,7 +379,7 @@ void opa_vnic_query_ucast_macs(struct opa_vnic_adapter *adapter,
 	}
 
 	tot_macs = netdev_hw_addr_list_count(&adapter->netdev->dev_addrs) +
-		   netdev_uc_count(adapter->netdev);
+		   netdev_uc_count(adapter->netdev) - em_macs;
 	macs->tot_macs_in_lst = cpu_to_be16(tot_macs);
 	macs->num_macs_in_msg = cpu_to_be16(count);
 	macs->gen_count = cpu_to_be16(adapter->info.vport.uc_macs_gen_count);

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
