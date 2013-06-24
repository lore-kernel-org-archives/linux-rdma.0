From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH opensm] osm_ucast_mgr.c: Fix extra copy in set_lft_block routine
Date: Mon, 24 Jun 2013 12:47:39 -0400
Message-ID: <51C8782B.6080308@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Vladimir Koushnir <vladimirk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Vladimir Koushnir <vladimirk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Signed-off-by: Vladimir Koushnir <vladimirk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
diff --git a/opensm/osm_ucast_mgr.c b/opensm/osm_ucast_mgr.c
index 12db434..f116a51 100644
--- a/opensm/osm_ucast_mgr.c
+++ b/opensm/osm_ucast_mgr.c
@@ -967,7 +967,6 @@ static void ucast_mgr_set_fwd_top(IN cl_map_item_t * p_map_item,
 static int set_lft_block(IN osm_switch_t *p_sw, IN osm_ucast_mgr_t *p_mgr,
 			 IN uint16_t block_id_ho)
 {
-	uint8_t block[IB_SMP_DATA_SIZE];
 	osm_madw_context_t context;
 	osm_dr_path_t *p_path;
 	ib_api_status_t status;
@@ -989,10 +988,10 @@ static int set_lft_block(IN osm_switch_t *p_sw, IN osm_ucast_mgr_t *p_mgr,
 	context.lft_context.node_guid = osm_node_get_node_guid(p_sw->p_node);
 	context.lft_context.set_method = TRUE;
 
-	if (!osm_switch_get_lft_block(p_sw, block_id_ho, block) ||
-	    (!p_sw->need_update && !p_mgr->p_subn->need_update &&
-	     !memcmp(block, p_sw->new_lft + block_id_ho * IB_SMP_DATA_SIZE,
-		     IB_SMP_DATA_SIZE)))
+	if (!p_sw->need_update && !p_mgr->p_subn->need_update &&
+	    !memcmp(p_sw->new_lft + block_id_ho * IB_SMP_DATA_SIZE,
+		    p_sw->lft + block_id_ho * IB_SMP_DATA_SIZE,
+		    IB_SMP_DATA_SIZE))
 		return 0;
 
 	OSM_LOG(p_mgr->p_log, OSM_LOG_DEBUG,
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
