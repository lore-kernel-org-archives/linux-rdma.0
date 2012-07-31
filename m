From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH] opensm/osm_congestion_control.c: Skip TID 0 on 32 bit wraparound
Date: Tue, 31 Jul 2012 12:27:09 -0400
Message-ID: <5018075D.5030902@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Chu, Al" <chu11-i2BcT+NCU+M@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
diff --git a/opensm/osm_congestion_control.c b/opensm/osm_congestion_control.c
index 640f3fa..9a9dfcd 100644
--- a/opensm/osm_congestion_control.c
+++ b/opensm/osm_congestion_control.c
@@ -82,7 +82,12 @@ static void cc_mad_post(osm_congestion_control_t *p_cc,
 	p_cc_mad->header.status = 0;
 	p_cc_mad->header.class_spec = 0;
 	p_cc_mad->header.trans_id =
-		cl_hton64((uint64_t) cl_atomic_inc(&p_cc->trans_id));
+		cl_hton64((uint64_t) cl_atomic_inc(&p_cc->trans_id) &
+			  (uint64_t) (0xFFFFFFFF));
+	if (p_cc_mad->header.trans_id == 0)
+		p_cc_mad->header.trans_id =
+			cl_hton64((uint64_t) cl_atomic_inc(&p_cc->trans_id) &
+				  (uint64_t) (0xFFFFFFFF));
 	p_cc_mad->header.attr_id = attr_id;
 	p_cc_mad->header.resv = 0;
 	p_cc_mad->header.attr_mod = attr_mod;
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
