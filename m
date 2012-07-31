From: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH 26/27] opensm: Fix crash found with ucast cache
Date: Tue, 31 Jul 2012 19:04:54 +0300
Message-ID: <1343750695-28063-26-git-send-email-alexne@mellanox.com>
References: <1343750695-28063-1-git-send-email-alexne@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1343750695-28063-1-git-send-email-alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Yevgeny Kliteynik <kliteyn-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>, Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Vladimir Koushnir <vladimirk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Yevgeny Kliteynik <kliteyn-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

OpenSM crashes in case of ucast_cache usage, but the bug itself is in discovery logic.

Consider the following scenario:
 - SM is running
 - SM gets some trap (let's say link state change)
 - SM starts heavy sweep
 - switch X discovered: setting p_sw->need_update to 2
 - while still in heavy sweep, more traps received
 - heavy sweep done (note: just the heavy sweep, w/o other stages, such as ucast manager)
 - there were traps, hence new heavy sweep started immediately
 - p_sw->need_update field of all switches is reset to default value of 1, which is also done for switch X
 - heavy sweep completed
 - proceeding to next stages ...

As a result, we get newly discovered switch X w/o configuration of LFT or other fields, but also w/o indication that this is a new switch, because p_sw->need_update field was reset.

Signed-off-by: Yevgeny Kliteynik <kliteyn-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Vladimir Koushnir <vladimirk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 opensm/osm_state_mgr.c | 3 ++-
 opensm/osm_ucast_mgr.c | 2 +-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/opensm/osm_state_mgr.c b/opensm/osm_state_mgr.c
index 00e9c72..183be36 100644
--- a/opensm/osm_state_mgr.c
+++ b/opensm/osm_state_mgr.c
@@ -111,7 +111,8 @@ static void state_mgr_reset_switch_count(IN cl_map_item_t * p_map_item,
 {
 	osm_switch_t *p_sw = (osm_switch_t *) p_map_item;
 
-	p_sw->need_update = 1;
+	if (p_sw->max_lid_ho != 0)
+		p_sw->need_update = 1;
 }
 
 static void state_mgr_get_sw_info(IN cl_map_item_t * p_object, IN void *context)
diff --git a/opensm/osm_ucast_mgr.c b/opensm/osm_ucast_mgr.c
index f33cc4c..b4cf0f2 100644
--- a/opensm/osm_ucast_mgr.c
+++ b/opensm/osm_ucast_mgr.c
@@ -907,7 +907,7 @@ static void ucast_mgr_set_fwd_top(IN cl_map_item_t * p_map_item,
 
 	OSM_LOG_ENTER(p_mgr->p_log);
 
-	CL_ASSERT(p_sw);
+	CL_ASSERT(p_sw && p_sw->max_lid_ho);
 
 	p_node = p_sw->p_node;
 
-- 
1.7.11.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
