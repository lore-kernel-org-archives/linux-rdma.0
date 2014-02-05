From: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH] opensm: Rename ib_switch_info_set_state_change function in ib_types.h
Date: Wed,  5 Feb 2014 14:25:11 +0200
Message-ID: <1391603111-21633-1-git-send-email-alexne@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Function name collides with a function defined ibutils package.
New name: ib_switch_info_state_change_set

Signed-off-by: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 include/iba/ib_types.h |    6 +++---
 opensm/osm_state_mgr.c |    2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/include/iba/ib_types.h b/include/iba/ib_types.h
index 249ee16..a0bb31c 100644
--- a/include/iba/ib_types.h
+++ b/include/iba/ib_types.h
@@ -6507,9 +6507,9 @@ ib_switch_info_clear_state_change(IN ib_switch_info_t * const p_si)
 * SEE ALSO
 *********/
 
-/****f* IBA Base: Types/ib_switch_info_set_state_change
+/****f* IBA Base: Types/ib_switch_info_state_change_set
 * NAME
-*	ib_switch_info_set_state_change
+*	ib_switch_info_state_change_set
 *
 * DESCRIPTION
 *	Clears the switch's state change bit.
@@ -6517,7 +6517,7 @@ ib_switch_info_clear_state_change(IN ib_switch_info_t * const p_si)
 * SYNOPSIS
 */
 static inline void OSM_API
-ib_switch_info_set_state_change(IN ib_switch_info_t * const p_si)
+ib_switch_info_state_change_set(IN ib_switch_info_t * const p_si)
 {
 	p_si->life_state = (uint8_t) ((p_si->life_state & ~IB_SWITCH_PSC) | IB_SWITCH_PSC);
 }
diff --git a/opensm/osm_state_mgr.c b/opensm/osm_state_mgr.c
index 5080b22..f9b20e2 100644
--- a/opensm/osm_state_mgr.c
+++ b/opensm/osm_state_mgr.c
@@ -559,7 +559,7 @@ static void state_mgr_reset_state_change_bit(IN cl_map_item_t * obj,
 
 	si = p_sw->switch_info;
 
-	ib_switch_info_set_state_change(&si);
+	ib_switch_info_state_change_set(&si);
 
 	OSM_LOG(sm->p_log, OSM_LOG_DEBUG,
 		"Resetting PortStateChange on switch GUID 0x%016" PRIx64 "\n",
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
