From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH for-rc 2/7] IB/opa_vnic: Set POD value for Ethernet MTU
Date: Tue, 26 Sep 2017 06:43:54 -0700
Message-ID: <20170926134353.11429.40112.stgit@scvm10.sc.intel.com>
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

Set power on default value of 1500 for eth_mtu.

Reviewed-by: Sudeep Dutt <sudeep.dutt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Niranjana Vishwanathapura <niranjana.vishwanathapura-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/ulp/opa_vnic/opa_vnic_netdev.c |    1 +
 drivers/infiniband/ulp/opa_vnic/opa_vnic_vema.c   |    1 +
 2 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/infiniband/ulp/opa_vnic/opa_vnic_netdev.c b/drivers/infiniband/ulp/opa_vnic/opa_vnic_netdev.c
index 41fd05b..305f3a8 100644
--- a/drivers/infiniband/ulp/opa_vnic/opa_vnic_netdev.c
+++ b/drivers/infiniband/ulp/opa_vnic/opa_vnic_netdev.c
@@ -183,6 +183,7 @@ static inline void opa_vnic_set_pod_values(struct opa_vnic_adapter *adapter)
 	adapter->info.vport.max_smac_ent = OPA_VNIC_MAX_SMAC_LIMIT;
 	adapter->info.vport.config_state = OPA_VNIC_STATE_DROP_ALL;
 	adapter->info.vport.eth_link_status = OPA_VNIC_ETH_LINK_DOWN;
+	adapter->info.vesw.eth_mtu = ETH_DATA_LEN;
 }
 
 /* opa_vnic_set_mac_addr - change mac address */
diff --git a/drivers/infiniband/ulp/opa_vnic/opa_vnic_vema.c b/drivers/infiniband/ulp/opa_vnic/opa_vnic_vema.c
index 21f0b48..4b615c1 100644
--- a/drivers/infiniband/ulp/opa_vnic/opa_vnic_vema.c
+++ b/drivers/infiniband/ulp/opa_vnic/opa_vnic_vema.c
@@ -186,6 +186,7 @@ static inline void vema_get_pod_values(struct opa_veswport_info *port_info)
 		cpu_to_be16(OPA_VNIC_MAX_SMAC_LIMIT);
 	port_info->vport.oper_state = OPA_VNIC_STATE_DROP_ALL;
 	port_info->vport.config_state = OPA_VNIC_STATE_DROP_ALL;
+	port_info->vesw.eth_mtu = cpu_to_be16(ETH_DATA_LEN);
 }
 
 /**

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
