From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH libibverbs V6 1/2] Add ibv_port_cap_flags
Date: Thu, 18 Sep 2014 17:53:10 +0300
Message-ID: <1411051991-17456-2-git-send-email-matanb@mellanox.com>
References: <1411051991-17456-1-git-send-email-matanb@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1411051991-17456-1-git-send-email-matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Add an enum that describes ibv_port_cap_flags that complies
with the respective kernel enum.

This value could be fetched when using ibv_query_port in
port_cap_flags.

Change-Id: I499565f17d378f525796ee187ef0fac91fd48c21
Signed-off-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 include/infiniband/verbs.h |   26 ++++++++++++++++++++++++++
 1 files changed, 26 insertions(+), 0 deletions(-)

diff --git a/include/infiniband/verbs.h b/include/infiniband/verbs.h
index 9826b72..4eb68f1 100644
--- a/include/infiniband/verbs.h
+++ b/include/infiniband/verbs.h
@@ -191,6 +191,32 @@ enum {
 	IBV_LINK_LAYER_ETHERNET,
 };
 
+enum ibv_port_cap_flags {
+	IBV_PORT_SM				= 1 <<  1,
+	IBV_PORT_NOTICE_SUP			= 1 <<  2,
+	IBV_PORT_TRAP_SUP			= 1 <<  3,
+	IBV_PORT_OPT_IPD_SUP			= 1 <<  4,
+	IBV_PORT_AUTO_MIGR_SUP			= 1 <<  5,
+	IBV_PORT_SL_MAP_SUP			= 1 <<  6,
+	IBV_PORT_MKEY_NVRAM			= 1 <<  7,
+	IBV_PORT_PKEY_NVRAM			= 1 <<  8,
+	IBV_PORT_LED_INFO_SUP			= 1 <<  9,
+	IBV_PORT_SYS_IMAGE_GUID_SUP		= 1 << 11,
+	IBV_PORT_PKEY_SW_EXT_PORT_TRAP_SUP	= 1 << 12,
+	IBV_PORT_EXTENDED_SPEEDS_SUP		= 1 << 14,
+	IBV_PORT_CM_SUP				= 1 << 16,
+	IBV_PORT_SNMP_TUNNEL_SUP		= 1 << 17,
+	IBV_PORT_REINIT_SUP			= 1 << 18,
+	IBV_PORT_DEVICE_MGMT_SUP		= 1 << 19,
+	IBV_PORT_VENDOR_CLASS_SUP		= 1 << 20,
+	IBV_PORT_DR_NOTICE_SUP			= 1 << 21,
+	IBV_PORT_CAP_MASK_NOTICE_SUP		= 1 << 22,
+	IBV_PORT_BOOT_MGMT_SUP			= 1 << 23,
+	IBV_PORT_LINK_LATENCY_SUP		= 1 << 24,
+	IBV_PORT_CLIENT_REG_SUP			= 1 << 25,
+	IBV_PORT_IP_BASED_GIDS			= 1 << 26
+};
+
 struct ibv_port_attr {
 	enum ibv_port_state	state;
 	enum ibv_mtu		max_mtu;
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
