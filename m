From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH] opensm/osm_subnet.c: Support MLNX ExtendedPortInfo for ConnectIB
 device
Date: Sun, 08 Jul 2012 11:43:21 -0400
Message-ID: <4FF9AA99.1060909@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
diff --git a/opensm/osm_subnet.c b/opensm/osm_subnet.c
index 46b82f1..1365e93 100644
--- a/opensm/osm_subnet.c
+++ b/opensm/osm_subnet.c
@@ -801,7 +801,7 @@ int is_mlnx_ext_port_info_supported(ib_net16_t devid)
 	devid_ho = cl_ntoh16(devid);
 	if (devid_ho == 0xc738)
 		return 1;
-	if (devid_ho >= 0x1003 && devid_ho <= 0x1010)
+	if (devid_ho >= 0x1003 && devid_ho <= 0x1011)
 		return 1;
 	return 0;
 }
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
