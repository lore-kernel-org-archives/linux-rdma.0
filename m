From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH opensm 5/5] osm_ucast_mgr.c: Select exit ports for lid offset
 > 0 using new_lft
Date: Thu, 08 Jan 2015 07:50:03 -0500
Message-ID: <54AE7CFB.6010402@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Daniel Klein <danielk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Daniel Klein <danielk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Bug description:
When opensm selects from which port it should continue selecting
exit ports for lids with lid offset > 0, it uses the lft that was
calculated and assigned to the switch on the previous sweep instead of
the new lft.

Signed-off-by: Daniel Klein <danielk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 opensm/osm_ucast_mgr.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/opensm/osm_ucast_mgr.c b/opensm/osm_ucast_mgr.c
index 7dc69f3..a268ce2 100644
--- a/opensm/osm_ucast_mgr.c
+++ b/opensm/osm_ucast_mgr.c
@@ -235,7 +235,7 @@ static void ucast_mgr_process_port(IN osm_ucast_mgr_t * p_mgr,
 	if (lid_offset && !p_mgr->is_dor)
 		/* ignore potential overflow - it is handled in osm_switch.c */
 		start_from =
-		    osm_switch_get_port_by_lid(p_sw, lid_ho - 1, OSM_LFT) + 1;
+		    osm_switch_get_port_by_lid(p_sw, lid_ho - 1, OSM_NEW_LFT) + 1;
 
 	OSM_LOG(p_mgr->p_log, OSM_LOG_DEBUG,
 		"Processing port 0x%" PRIx64
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
