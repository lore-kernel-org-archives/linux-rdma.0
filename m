From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH][TRIVIAL] opensm/osm_helper.c: Fix commentary typo
Date: Mon, 06 Feb 2012 11:29:59 -0500
Message-ID: <4F300007.3080603@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


12x FDR is 168 rather than 158 Gbps

Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
diff --git a/opensm/osm_helper.c b/opensm/osm_helper.c
index f9f3d9d..49434e5 100644
--- a/opensm/osm_helper.c
+++ b/opensm/osm_helper.c
@@ -453,7 +453,7 @@ static int ordered_rates[] = {
 	4,	/* 11 -  14 Gbps (17 Gbps equiv) */
 	10,	/* 12 -  56 Gbps (68 Gbps equiv) */
 	14,	/* 13 - 112 Gbps (136 Gbps equiv) */
-	15,	/* 14 - 158 Gbps (204 Gbps equiv) */
+	15,	/* 14 - 168 Gbps (204 Gbps equiv) */
 	7,	/* 15 -  25 Gbps (31.25 Gbps equiv) */
 	13,	/* 16 - 100 Gbps (125 Gbps equiv) */
 	16,	/* 17 - 200 Gbps (250 Gbps equiv) */
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
