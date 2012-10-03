From: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH] net/mlx4_core: Adjust the flow steering attach wrapper so that VFs work under SRIOV/IB
Date: Wed,  3 Oct 2012 17:38:48 +0200
Message-ID: <1349278729-3284-1-git-send-email-jackm@dev.mellanox.co.il>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yevgenyp-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Currently, the Infiniband stack does not support flow steering at the
verbs level. As a result, the only usage of flow steering in the
IB driver is for L2 multicast attaches. Thus, we need to add the IB case to
procedure mlx4_QP_FLOW_STEERING_ATTACH_wrapper() to allow IPoIB to work on
VFs over ConnectX3 when flow steering is enabled.

Currently, the IB case in mlx4_QP_FLOW_STEERING_ATTACH_wrapper()
is missing, so the procedure returns -EINVAL and IPoIB on VFs fails to operate.

Signed-off-by: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 .../net/ethernet/mellanox/mlx4/resource_tracker.c  |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

Commit 7fb40f87... "net/mlx4_core: Add security check / enforcement for flow steering
rules set for VMs" left a hole which causes failures on multicast attaches done by SRIOV/IB
VFs over ConnectX3 when flow steering is enabled.  When it was submitted, SRIOV/IB was
not yet in the upstream kernel.

Additionally, the V2 patch set was submitted before 7fb40f87.., hence that commit needs
an adjustment for SRIOV/IB VF multicast attach support. 

diff --git a/drivers/net/ethernet/mellanox/mlx4/resource_tracker.c b/drivers/net/ethernet/mellanox/mlx4/resource_tracker.c
index ba6506f..926c911 100644
--- a/drivers/net/ethernet/mellanox/mlx4/resource_tracker.c
+++ b/drivers/net/ethernet/mellanox/mlx4/resource_tracker.c
@@ -3094,6 +3094,8 @@ int mlx4_QP_FLOW_STEERING_ATTACH_wrapper(struct mlx4_dev *dev, int slave,
 		if (validate_eth_header_mac(slave, rule_header, rlist))
 			return -EINVAL;
 		break;
+	case MLX4_NET_TRANS_RULE_ID_IB:
+		break;
 	case MLX4_NET_TRANS_RULE_ID_IPV4:
 	case MLX4_NET_TRANS_RULE_ID_TCP:
 	case MLX4_NET_TRANS_RULE_ID_UDP:
-- 
1.7.9.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
