From: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH] opensm/osm_link_mgr.c: Fix sending PortInfo(Set) with AM SMSupportExtendedSpeeds bit set for switch base port 0
Date: Mon,  4 Feb 2013 15:20:07 +0200
Message-ID: <1359984011-30753-6-git-send-email-alexne@mellanox.com>
References: <1359984011-30753-1-git-send-email-alexne@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1359984011-30753-1-git-send-email-alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

link_mgr mistakenly assums that port supports extended speeds when setting
AM SMSupportExtendedSpeeds.

Signed-off-by: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 opensm/osm_link_mgr.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/opensm/osm_link_mgr.c b/opensm/osm_link_mgr.c
index 9d73e74..26671bf 100644
--- a/opensm/osm_link_mgr.c
+++ b/opensm/osm_link_mgr.c
@@ -102,7 +102,7 @@ static int link_mgr_set_physp_pi(osm_sm_t * sm, IN osm_physp_t * p_physp,
 	uint8_t port_num, mtu, op_vls, smsl = OSM_DEFAULT_SL;
 	boolean_t esp0 = FALSE, send_set = FALSE, send_set2 = FALSE;
 	osm_physp_t *p_remote_physp, *physp0;
-	int issue_ext = 1, fdr10_change = 0;
+	int issue_ext = 0, fdr10_change = 0;
 	int ret = 0;
 	ib_net32_t attr_mod, cap_mask;
 	boolean_t update_mkey = FALSE;
@@ -365,8 +365,8 @@ static int link_mgr_set_physp_pi(osm_sm_t * sm, IN osm_physp_t * p_physp,
 			cap_mask = physp0->port_info.capability_mask;
 		} else
 			cap_mask = p_pi->capability_mask;
-		if (!(cap_mask & IB_PORT_CAP_HAS_EXT_SPEEDS))
-			issue_ext = 0;
+		if (cap_mask & IB_PORT_CAP_HAS_EXT_SPEEDS)
+			issue_ext = 1;
 
 		/* Do peer ports support extended link speeds ? */
 		if (port_num != 0 && p_remote_physp) {
-- 
1.7.11.7

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
