From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH libibverbs 1/3] Extend devinfo verbosity mode
Date: Thu, 19 May 2016 15:52:47 +0300
Message-ID: <1463662369-18395-2-git-send-email-yishaih@mellanox.com>
References: <1463662369-18395-1-git-send-email-yishaih@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1463662369-18395-1-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Extend verbosity mode to print device capability flags in text format.

Signed-off-by: Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 examples/devinfo.c | 81 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 81 insertions(+)

diff --git a/examples/devinfo.c b/examples/devinfo.c
index a8de982..5da6773 100644
--- a/examples/devinfo.c
+++ b/examples/devinfo.c
@@ -205,6 +205,86 @@ static const char *link_layer_str(uint8_t link_layer)
 	}
 }
 
+static void print_device_cap_flags(uint32_t dev_cap_flags)
+{
+	uint32_t unknown_flags = ~(IBV_DEVICE_RESIZE_MAX_WR |
+				   IBV_DEVICE_BAD_PKEY_CNTR |
+				   IBV_DEVICE_BAD_QKEY_CNTR |
+				   IBV_DEVICE_RAW_MULTI |
+				   IBV_DEVICE_AUTO_PATH_MIG |
+				   IBV_DEVICE_CHANGE_PHY_PORT |
+				   IBV_DEVICE_UD_AV_PORT_ENFORCE |
+				   IBV_DEVICE_CURR_QP_STATE_MOD |
+				   IBV_DEVICE_SHUTDOWN_PORT |
+				   IBV_DEVICE_INIT_TYPE |
+				   IBV_DEVICE_PORT_ACTIVE_EVENT |
+				   IBV_DEVICE_SYS_IMAGE_GUID |
+				   IBV_DEVICE_RC_RNR_NAK_GEN |
+				   IBV_DEVICE_SRQ_RESIZE |
+				   IBV_DEVICE_N_NOTIFY_CQ |
+				   IBV_DEVICE_MEM_WINDOW |
+				   IBV_DEVICE_UD_IP_CSUM |
+				   IBV_DEVICE_XRC |
+				   IBV_DEVICE_MEM_MGT_EXTENSIONS |
+				   IBV_DEVICE_MEM_WINDOW_TYPE_2A |
+				   IBV_DEVICE_MEM_WINDOW_TYPE_2B |
+				   IBV_DEVICE_RC_IP_CSUM |
+				   IBV_DEVICE_RAW_IP_CSUM |
+				   IBV_DEVICE_MANAGED_FLOW_STEERING);
+
+	if (dev_cap_flags & IBV_DEVICE_RESIZE_MAX_WR)
+		printf("\t\t\t\t\tRESIZE_MAX_WR\n");
+	if (dev_cap_flags & IBV_DEVICE_BAD_PKEY_CNTR)
+		printf("\t\t\t\t\tBAD_PKEY_CNTR\n");
+	if (dev_cap_flags & IBV_DEVICE_BAD_QKEY_CNTR)
+		printf("\t\t\t\t\tBAD_QKEY_CNTR\n");
+	if (dev_cap_flags & IBV_DEVICE_RAW_MULTI)
+		printf("\t\t\t\t\tRAW_MULTI\n");
+	if (dev_cap_flags & IBV_DEVICE_AUTO_PATH_MIG)
+		printf("\t\t\t\t\tAUTO_PATH_MIG\n");
+	if (dev_cap_flags & IBV_DEVICE_CHANGE_PHY_PORT)
+		printf("\t\t\t\t\tCHANGE_PHY_PORT\n");
+	if (dev_cap_flags & IBV_DEVICE_UD_AV_PORT_ENFORCE)
+		printf("\t\t\t\t\tUD_AV_PORT_ENFORCE\n");
+	if (dev_cap_flags & IBV_DEVICE_CURR_QP_STATE_MOD)
+		printf("\t\t\t\t\tCURR_QP_STATE_MOD\n");
+	if (dev_cap_flags & IBV_DEVICE_SHUTDOWN_PORT)
+		printf("\t\t\t\t\tSHUTDOWN_PORT\n");
+	if (dev_cap_flags & IBV_DEVICE_INIT_TYPE)
+		printf("\t\t\t\t\tINIT_TYPE\n");
+	if (dev_cap_flags & IBV_DEVICE_PORT_ACTIVE_EVENT)
+		printf("\t\t\t\t\tPORT_ACTIVE_EVENT\n");
+	if (dev_cap_flags & IBV_DEVICE_SYS_IMAGE_GUID)
+		printf("\t\t\t\t\tSYS_IMAGE_GUID\n");
+	if (dev_cap_flags & IBV_DEVICE_RC_RNR_NAK_GEN)
+		printf("\t\t\t\t\tRC_RNR_NAK_GEN\n");
+	if (dev_cap_flags & IBV_DEVICE_SRQ_RESIZE)
+		printf("\t\t\t\t\tSRQ_RESIZE\n");
+	if (dev_cap_flags & IBV_DEVICE_N_NOTIFY_CQ)
+		printf("\t\t\t\t\tN_NOTIFY_CQ\n");
+	if (dev_cap_flags & IBV_DEVICE_MEM_WINDOW)
+		printf("\t\t\t\t\tMEM_WINDOW\n");
+	if (dev_cap_flags & IBV_DEVICE_UD_IP_CSUM)
+		printf("\t\t\t\t\tUD_IP_CSUM\n");
+	if (dev_cap_flags & IBV_DEVICE_XRC)
+		printf("\t\t\t\t\tXRC\n");
+	if (dev_cap_flags & IBV_DEVICE_MEM_MGT_EXTENSIONS)
+		printf("\t\t\t\t\tMEM_MGT_EXTENSIONS\n");
+	if (dev_cap_flags & IBV_DEVICE_MEM_WINDOW_TYPE_2A)
+		printf("\t\t\t\t\tMEM_WINDOW_TYPE_2A\n");
+	if (dev_cap_flags & IBV_DEVICE_MEM_WINDOW_TYPE_2B)
+		printf("\t\t\t\t\tMEM_WINDOW_TYPE_2B\n");
+	if (dev_cap_flags & IBV_DEVICE_RC_IP_CSUM)
+		printf("\t\t\t\t\tRC_IP_CSUM\n");
+	if (dev_cap_flags & IBV_DEVICE_RAW_IP_CSUM)
+		printf("\t\t\t\t\tRAW_IP_CSUM\n");
+	if (dev_cap_flags & IBV_DEVICE_MANAGED_FLOW_STEERING)
+		printf("\t\t\t\t\tMANAGED_FLOW_STEERING\n");
+	if (dev_cap_flags & unknown_flags)
+		printf("\t\t\t\t\tUnknown flags: 0x%" PRIX32 "\n",
+		       dev_cap_flags & unknown_flags);
+}
+
 void print_odp_trans_caps(uint32_t trans)
 {
 	uint32_t unknown_transport_caps = ~(IBV_ODP_SUPPORT_SEND |
@@ -304,6 +384,7 @@ static int print_hca_cap(struct ibv_device *ib_dev, uint8_t ib_port)
 		printf("\tmax_qp:\t\t\t\t%d\n", device_attr.orig_attr.max_qp);
 		printf("\tmax_qp_wr:\t\t\t%d\n", device_attr.orig_attr.max_qp_wr);
 		printf("\tdevice_cap_flags:\t\t0x%08x\n", device_attr.orig_attr.device_cap_flags);
+		print_device_cap_flags(device_attr.orig_attr.device_cap_flags);
 		printf("\tmax_sge:\t\t\t%d\n", device_attr.orig_attr.max_sge);
 		printf("\tmax_sge_rd:\t\t\t%d\n", device_attr.orig_attr.max_sge_rd);
 		printf("\tmax_cq:\t\t\t\t%d\n", device_attr.orig_attr.max_cq);
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
