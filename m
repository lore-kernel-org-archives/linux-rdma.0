From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH] opensm/osm_link_mgr.c: Fix sending PortInfo Set for ports
 supporting extended speed
Date: Wed, 09 May 2012 07:41:18 -0400
Message-ID: <4FAA57DE.8030708@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Vladimir Koushnir <vladimirk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Comparison to LinkSpeedExtEnabled should use LinkSpeedExtSupported rather
than LinkSpeedSupported

Signed-off-by: Vladimir Koushnir <vladimirk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
diff --git a/opensm/osm_link_mgr.c b/opensm/osm_link_mgr.c
index 88b61da..d9241be 100644
--- a/opensm/osm_link_mgr.c
+++ b/opensm/osm_link_mgr.c
@@ -393,7 +393,7 @@ static int link_mgr_set_physp_pi(osm_sm_t * sm, IN osm_physp_t * p_physp,
 				if (sm->p_subn->opt.force_link_speed_ext &&
 				    (sm->p_subn->opt.force_link_speed_ext != IB_LINK_SPEED_EXT_SET_LSES ||
 				     p_pi->link_speed_ext_enabled !=
-				     ib_port_info_get_link_speed_sup(p_pi))) {
+				     ib_port_info_get_link_speed_ext_sup(p_pi))) {
 					p_pi->link_speed_ext_enabled = sm->p_subn->opt.force_link_speed_ext;
 					if (memcmp(&p_pi->link_speed_ext_enabled,
 						   &p_old_pi->link_speed_ext_enabled,
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
