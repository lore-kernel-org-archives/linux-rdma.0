From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH opensm] osm_state_mgr.c: Fix error print in state_mgr_check_tbl_consistency()
Date: Wed, 20 Nov 2013 18:26:36 -0500
Message-ID: <528D452C.1030405@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


From: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Need to print NodeDesc and PortNum for both p_port_ref and
p_port_stored.

Signed-off-by: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 opensm/osm_state_mgr.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/opensm/osm_state_mgr.c b/opensm/osm_state_mgr.c
index bf6181a..36e9f6c 100644
--- a/opensm/osm_state_mgr.c
+++ b/opensm/osm_state_mgr.c
@@ -1312,8 +1312,8 @@ static void state_mgr_check_tbl_consistency(IN osm_sm_t * sm)
 				p_port_ref->p_node->print_desc,
 				p_port_ref->p_physp->port_num,
 				cl_ntoh64(osm_port_get_guid(p_port_stored)),
-				p_port_ref->p_node->print_desc,
-				p_port_ref->p_physp->port_num);
+				p_port_stored->p_node->print_desc,
+				p_port_stored->p_physp->port_num);
 
 		/* In any of these cases we want to set NULL in the
 		 * port_lid_tbl, since this entry is invalid. Also, make sure
-- 
1.7.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
