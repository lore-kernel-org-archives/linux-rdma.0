From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH opensm] osm_congestion_control.c: Simplify some code
Date: Mon, 08 Apr 2013 07:37:00 -0400
Message-ID: <5162ABDC.2080808@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: "Chu, Al" <chu11-i2BcT+NCU+M@public.gmane.org>, Shlomi Nimrodi <shlomin-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


No need for p_osm->sm.p_subn->p_osm; just p_osm is sufficient

Found-by: Shlomi Nimrodi <shlomin-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
diff --git a/opensm/osm_congestion_control.c b/opensm/osm_congestion_control.c
index 17af407..e27ba20 100644
--- a/opensm/osm_congestion_control.c
+++ b/opensm/osm_congestion_control.c
@@ -362,7 +362,7 @@ int osm_congestion_control_setup(struct osm_opensm *p_osm)
 	/*
 	 * Do nothing unless the most recent routing attempt was successful.
 	 */
-	if (!p_osm->sm.p_subn->p_osm->routing_engine_used)
+	if (!p_osm->routing_engine_used)
 		return 0;
 
 	cc_setup_mad_data(&p_osm->sm);
@@ -409,7 +409,7 @@ int osm_congestion_control_setup(struct osm_opensm *p_osm)
 
 int osm_congestion_control_wait_pending_transactions(struct osm_opensm *p_osm)
 {
-	osm_congestion_control_t *cc = &p_osm->sm.p_subn->p_osm->cc;
+	osm_congestion_control_t *cc = &p_osm->cc;
 
 	if (!p_osm->subn.opt.congestion_control)
 		return 0;
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
