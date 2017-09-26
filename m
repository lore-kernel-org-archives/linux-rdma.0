From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH for-rc 6/7] IB/opa_vnic: Properly set vesw port status
Date: Tue, 26 Sep 2017 06:44:20 -0700
Message-ID: <20170926134418.11429.48455.stgit@scvm10.sc.intel.com>
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

Update eth_link_status and operating status information to
represent the overall status of the virtual Ethernet switch port.

Reviewed-by: Sudeep Dutt <sudeep.dutt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Niranjana Vishwanathapura <niranjana.vishwanathapura-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/ulp/opa_vnic/opa_vnic_netdev.c |   39 +++++++++++++++------
 1 files changed, 27 insertions(+), 12 deletions(-)

diff --git a/drivers/infiniband/ulp/opa_vnic/opa_vnic_netdev.c b/drivers/infiniband/ulp/opa_vnic/opa_vnic_netdev.c
index 30f7858..ce57e0f 100644
--- a/drivers/infiniband/ulp/opa_vnic/opa_vnic_netdev.c
+++ b/drivers/infiniband/ulp/opa_vnic/opa_vnic_netdev.c
@@ -112,6 +112,27 @@ static u16 opa_vnic_select_queue(struct net_device *netdev, struct sk_buff *skb,
 	return rc;
 }
 
+static void opa_vnic_update_state(struct opa_vnic_adapter *adapter, bool up)
+{
+	struct __opa_veswport_info *info = &adapter->info;
+
+	mutex_lock(&adapter->lock);
+	/* Operational state can only be DROP_ALL or FORWARDING */
+	if ((info->vport.config_state == OPA_VNIC_STATE_FORWARDING) && up) {
+		info->vport.oper_state = OPA_VNIC_STATE_FORWARDING;
+		info->vport.eth_link_status = OPA_VNIC_ETH_LINK_UP;
+	} else {
+		info->vport.oper_state = OPA_VNIC_STATE_DROP_ALL;
+		info->vport.eth_link_status = OPA_VNIC_ETH_LINK_DOWN;
+	}
+
+	if (info->vport.config_state == OPA_VNIC_STATE_FORWARDING)
+		netif_dormant_off(adapter->netdev);
+	else
+		netif_dormant_on(adapter->netdev);
+	mutex_unlock(&adapter->lock);
+}
+
 /* opa_vnic_process_vema_config - process vema configuration updates */
 void opa_vnic_process_vema_config(struct opa_vnic_adapter *adapter)
 {
@@ -164,14 +185,8 @@ void opa_vnic_process_vema_config(struct opa_vnic_adapter *adapter)
 		adapter->flow_tbl[i] = port_count ? port_num[i % port_count] :
 						    OPA_VNIC_INVALID_PORT;
 
-	/* Operational state can only be DROP_ALL or FORWARDING */
-	if (info->vport.config_state == OPA_VNIC_STATE_FORWARDING) {
-		info->vport.oper_state = OPA_VNIC_STATE_FORWARDING;
-		netif_dormant_off(netdev);
-	} else {
-		info->vport.oper_state = OPA_VNIC_STATE_DROP_ALL;
-		netif_dormant_on(netdev);
-	}
+	/* update state */
+	opa_vnic_update_state(adapter, !!(netdev->flags & IFF_UP));
 }
 
 /*
@@ -269,8 +284,8 @@ static int opa_netdev_open(struct net_device *netdev)
 		return rc;
 	}
 
-	/* Update eth link status and send trap */
-	adapter->info.vport.eth_link_status = OPA_VNIC_ETH_LINK_UP;
+	/* Update status and send trap */
+	opa_vnic_update_state(adapter, true);
 	opa_vnic_vema_report_event(adapter,
 				   OPA_VESWPORT_TRAP_ETH_LINK_STATUS_CHANGE);
 	return 0;
@@ -288,8 +303,8 @@ static int opa_netdev_close(struct net_device *netdev)
 		return rc;
 	}
 
-	/* Update eth link status and send trap */
-	adapter->info.vport.eth_link_status = OPA_VNIC_ETH_LINK_DOWN;
+	/* Update status and send trap */
+	opa_vnic_update_state(adapter, false);
 	opa_vnic_vema_report_event(adapter,
 				   OPA_VESWPORT_TRAP_ETH_LINK_STATUS_CHANGE);
 	return 0;

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
