From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCHv2] infiniband-diags: Support MLNX ExtendedPortInfo for ConnectIB
 device
Date: Sun, 08 Jul 2012 13:49:37 -0400
Message-ID: <4FF9C831.8010506@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Daniel Klein <danielk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
Change since v1:
Added similar change to libibnetdisc
Pointed out by Daniel Klein <danielk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

diff --git a/libibnetdisc/src/ibnetdisc.c b/libibnetdisc/src/ibnetdisc.c
index a0cbe3e..3a7dd8f 100644
--- a/libibnetdisc/src/ibnetdisc.c
+++ b/libibnetdisc/src/ibnetdisc.c
@@ -205,7 +205,7 @@ static int
is_mlnx_ext_port_info_supported(ibnd_port_t * port)

 	if (devid == 0xc738)
 		return 1;
-	if (devid >= 0x1003 && devid <= 0x1010)
+	if (devid >= 0x1003 && devid <= 0x1011)
 		return 1;
 	return 0;
 }
diff --git a/src/ibdiag_common.c b/src/ibdiag_common.c
index 78882a2..ebe8797 100644
--- a/src/ibdiag_common.c
+++ b/src/ibdiag_common.c
@@ -501,7 +501,7 @@ int is_mlnx_ext_port_info_supported(uint32_t devid)
 	if (ibd_ibnetdisc_flags & IBND_CONFIG_MLX_EPI) {
 		if (devid == 0xc738)
 			return 1;
-		if (devid >= 0x1003 && devid <= 0x1010)
+		if (devid >= 0x1003 && devid <= 0x1011)
 			return 1;
 	}
 	return 0;
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
