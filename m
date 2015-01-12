From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH infiniband-diags] ibdiag_common.c: Add more supported device
 IDs
Date: Mon, 12 Jan 2015 14:08:13 -0500
Message-ID: <54B41B9D.5020700@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Add support for ConnectX-3 and ConnectX-4. 

Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
diff --git a/src/ibdiag_common.c b/src/ibdiag_common.c
index 8c749c7..384d342 100644
--- a/src/ibdiag_common.c
+++ b/src/ibdiag_common.c
@@ -499,9 +499,9 @@ conv_cnt_human_readable(uint64_t val64, float *val, int data)
 int is_mlnx_ext_port_info_supported(uint32_t devid)
 {
 	if (ibd_ibnetdisc_flags & IBND_CONFIG_MLX_EPI) {
-		if (devid == 0xc738)
+		if (devid == 0xc738 || devid == 0xcb84)
 			return 1;
-		if (devid >= 0x1003 && devid <= 0x1011)
+		if (devid >= 0x1003 && devid <= 0x1016)
 			return 1;
 	}
 	return 0;
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
