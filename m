From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH opensm] libvendor/osm_pkt_randomizer.c: Fix broken compilation
 with vendor sim
Date: Mon, 22 Jul 2013 21:19:48 -0400
Message-ID: <51EDDA34.5090204@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Eitan Zahavi <eitan-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Due to change in number of args to osm_dr_path_init.
   
Signed-off-by: Eitan Zahavi <eitan-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
diff --git a/libvendor/osm_pkt_randomizer.c b/libvendor/osm_pkt_randomizer.c
index cfc5a8f..5ea1f4a 100644
--- a/libvendor/osm_pkt_randomizer.c
+++ b/libvendor/osm_pkt_randomizer.c
@@ -234,8 +234,7 @@ osm_pkt_randomizer_mad_drop(IN osm_log_t * p_log,
 		/* This is a lid route mad. Don't drop it */
 		goto Exit;
 
-	osm_dr_path_init(&dr_path, 0,	/* The h_bind is not really important for us to save */
-			 p_smp->hop_count, p_smp->initial_path);
+	osm_dr_path_init(&dr_path, p_smp->hop_count, p_smp->initial_path);
 
 	if (__osm_pkt_randomizer_process_path
 	    (p_log, p_pkt_randomizer, &dr_path)) {
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
