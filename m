From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH 2/2] opensm/osm_torus.c: Check fabric minimum data VLs on
 switch external ports
Date: Wed, 10 Oct 2012 19:40:13 -0400
Message-ID: <5076075D.9000509@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jim Schutt <jaschut-4OHPYypu0djtX7QSmKvirg@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Also, in sl2vl_entry, use that value when appropriate

Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Jim Schutt <jaschut-4OHPYypu0djtX7QSmKvirg@public.gmane.org>
---
 opensm/osm_torus.c |   35 ++++++++++++++++++++++-------------
 1 files changed, 22 insertions(+), 13 deletions(-)

diff --git a/opensm/osm_torus.c b/opensm/osm_torus.c
index ec2c5ef..82c1db1 100644
--- a/opensm/osm_torus.c
+++ b/opensm/osm_torus.c
@@ -7027,22 +7027,27 @@ bool verify_setup(struct torus *t, struct fabric *f)
 			"ERR 4E20: missing required torus size specification!\n");
 		goto out;
 	}
-	if (t->osm->subn.min_data_vls < 2)
+	if (t->osm->subn.min_data_vls < 2 || t->osm->subn.min_sw_data_vls < 2)
 		OSM_LOG(&t->osm->log, OSM_LOG_INFO,
 			"Warning: Too few data VLs to support torus routing "
-			"without credit loops (have %d need 2)\n",
-			(int)t->osm->subn.min_data_vls);
-	if (t->osm->subn.min_data_vls < 4)
+			"without credit loops (have endport %d switchport %d "
+			"need 2)\n",
+			(int)t->osm->subn.min_data_vls,
+			(int)t->osm->subn.min_sw_data_vls);
+	if (t->osm->subn.min_data_vls < 4 || t->osm->subn.min_sw_data_vls < 4)
 		OSM_LOG(&t->osm->log, OSM_LOG_INFO,
 			"Warning: Too few data VLs to support torus routing "
-			"with a failed switch without credit loops"
-			"(have %d need 4)\n",
-			(int)t->osm->subn.min_data_vls);
-	if (t->osm->subn.min_data_vls < 8)
+			"with a failed switch without credit loops "
+			"(have endport %d switchport %d need 4)\n",
+			(int)t->osm->subn.min_data_vls,
+			(int)t->osm->subn.min_sw_data_vls);
+	if (t->osm->subn.min_data_vls < 8 || t->osm->subn.min_sw_data_vls < 8)
 		OSM_LOG(&t->osm->log, OSM_LOG_INFO,
 			"Warning: Too few data VLs to support torus routing "
-			"with two QoS levels (have %d need 8)\n",
-			(int)t->osm->subn.min_data_vls);
+			"with two QoS levels (have endport %d switchport %d "
+			"need 8)\n",
+			(int)t->osm->subn.min_data_vls,
+			(int)t->osm->subn.min_sw_data_vls);
 	/*
 	 * Be sure all the switches in the torus support the port
 	 * ordering that might have been configured.
@@ -7982,7 +7987,10 @@ unsigned sl2vl_entry(struct torus *t, struct t_switch *sw,
 	else
 		od = TORUS_MAX_DIM;
 
-	data_vls = t->osm->subn.min_data_vls;
+	if (sw)
+		data_vls = t->osm->subn.min_sw_data_vls;
+	else
+		data_vls = t->osm->subn.min_data_vls;
 	vl = 0;
 
 	if (data_vls >= 2)
@@ -9251,9 +9259,10 @@ int torus_build_lfts(void *context)
 
 	OSM_LOG(&torus->osm->log, OSM_LOG_INFO,
 		"Found fabric w/ %d links, %d switches, %d CA ports, "
-		"minimum %d data VLs\n",
+		"minimum data VLs: endport %d, switchport %d\n",
 		(int)fabric->link_cnt, (int)fabric->switch_cnt,
-		(int)fabric->ca_cnt, (int)ctx->osm->subn.min_data_vls);
+		(int)fabric->ca_cnt, (int)ctx->osm->subn.min_data_vls,
+		(int)ctx->osm->subn.min_sw_data_vls);
 
 	if (!verify_setup(torus, fabric))
 		goto out;
-- 
1.7.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
