From: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH] opensm: Fix GUIDInfo SET function
Date: Mon, 30 Sep 2013 17:05:55 +0300
Message-ID: <20130930140555.GA3668@calypso.mtr.labs.mlnx>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

osm_req_set parameters order is incorrect. Because of this only block 0
is incorrectly altered.

Signed-off-by: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 opensm/osm_guid_mgr.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/opensm/osm_guid_mgr.c b/opensm/osm_guid_mgr.c
index d826366..e4d1de7 100644
--- a/opensm/osm_guid_mgr.c
+++ b/opensm/osm_guid_mgr.c
@@ -73,10 +73,9 @@ static void guidinfo_set(IN osm_sa_t *sa, IN osm_port_t *p_port,
 
 	status = osm_req_set(sa->sm, osm_physp_get_dr_path_ptr(p_port->p_physp),
 			     payload, sizeof(payload), IB_MAD_ATTR_GUID_INFO,
-			     FALSE,
+			     cl_hton32((uint32_t)block_num), FALSE,
 			     ib_port_info_get_m_key(&p_port->p_physp->port_info),
-			     cl_hton32((uint32_t)block_num),
-			     CL_DISP_MSGID_NONE, &context);
+					            CL_DISP_MSGID_NONE, &context);
 	if (status != IB_SUCCESS)
 		OSM_LOG(sa->p_log, OSM_LOG_ERROR, "ERR 5109: "
 			"Failure initiating GUIDInfo request (%s)\n",
-- 
1.7.11.7

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
