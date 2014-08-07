From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH opensm] osm_link_mgr.c: Fix bug in mlnx extended port info
 setting
Date: Thu, 07 Aug 2014 06:05:16 -0400
Message-ID: <53E34F5C.50102@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Shlomi Nimrodi <shlomin-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Shlomi Nimrodi <shlomin-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Date: Mon, 4 Aug 2014 15:40:43 +0300

In link_mgr_set_physp_pi, set mlnx extended port info speed even if
standard speed setting is not required

Signed-off-by: Shlomi Nimrodi <shlomin-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 opensm/osm_link_mgr.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/opensm/osm_link_mgr.c b/opensm/osm_link_mgr.c
index d5c7dde..0f52a2d 100644
--- a/opensm/osm_link_mgr.c
+++ b/opensm/osm_link_mgr.c
@@ -467,7 +467,7 @@ Send:
 		send_set = TRUE;
 
 	if (!send_set)
-		goto Exit;
+		goto SEND_EPI;
 
 	attr_mod = cl_hton32(port_num);
 	if (issue_ext)
@@ -487,6 +487,7 @@ Send:
 				     cl_ntoh64(p_physp->port_guid),
 				     cl_ntoh64(p_pi->m_key));
 
+SEND_EPI:
 	if (send_set2) {
 		status = osm_req_set(sm, osm_physp_get_dr_path_ptr(p_physp),
 				     payload2, sizeof(payload2),
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
