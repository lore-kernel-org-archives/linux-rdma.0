From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH 3/3] opensm: Fix crash found with ucast cache
Date: Thu, 28 Jun 2012 13:10:49 -0400
Message-ID: <4FEC9019.5070806@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Yevgeny Kliteynik <kliteyn-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>, Vladimir Koushnir <vladimirk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


OpenSM crashes in case of ucast_cache usage, but the bug itself is in discovery
logic.

Consider the following scenario:
 - SM is running
 - SM gets some trap (let's say link state change)
 - SM starts heavy sweep
 - switch X discovered: setting p_sw->need_update to 2
 - while still in heavy sweep, more traps received
 - heavy sweep done (note: just the heavy sweep, w/o other stages, such as ucast
 manager)
 - there were traps, hence new heavy sweep started immediately
 - p_sw->need_update field of all switches is reset to default value of 1, which
 is also done for switch X
 - heavy sweep completed
 - proceeding to next stages ...

As a result, we get newly discovered switch X w/o configuration of LFT or other
fields, but also w/o indication that this is a new switch, because p_sw->need_up
date field was reset.

Signed-off-by: Yevgeny Kliteynik <kliteyn-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Vladimir Koushnir <vladimirk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 opensm/osm_state_mgr.c |    3 ++-
 opensm/osm_ucast_mgr.c |    2 +-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/opensm/osm_state_mgr.c b/opensm/osm_state_mgr.c
index 2629fc5..6de11aa 100644
--- a/opensm/osm_state_mgr.c
+++ b/opensm/osm_state_mgr.c
@@ -108,7 +108,8 @@ static void state_mgr_reset_switch_count(IN cl_map_item_t * p_map_item,
 {
 	osm_switch_t *p_sw = (osm_switch_t *) p_map_item;
 
-	p_sw->need_update = 1;
+	if (p_sw->max_lid_ho != 0)
+		p_sw->need_update = 1;
 }
 
 static void state_mgr_get_sw_info(IN cl_map_item_t * p_object, IN void *context)
diff --git a/opensm/osm_ucast_mgr.c b/opensm/osm_ucast_mgr.c
index b850009..2f37eba 100644
--- a/opensm/osm_ucast_mgr.c
+++ b/opensm/osm_ucast_mgr.c
@@ -905,7 +905,7 @@ static void ucast_mgr_set_fwd_top(IN cl_map_item_t * p_map_item,
 
 	OSM_LOG_ENTER(p_mgr->p_log);
 
-	CL_ASSERT(p_sw);
+	CL_ASSERT(p_sw && p_sw->max_lid_ho);
 
 	p_node = p_sw->p_node;
 
-- 
1.7.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
