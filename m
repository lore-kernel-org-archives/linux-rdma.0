From: Sasha Khapyorsky <sashakvolt-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 2/3] OpenSM: don't remove our own SM port.
Date: Mon, 22 Jul 2013 19:09:49 +0300
Message-ID: <20130722160948.GB24222@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Roy.Koren-mb1K0bWo544@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


When cleaning up remotes of non reachable ports anymore. Make exception
for our own local SM port. In that case port still be in SM DB and
running single port mode is possible.

Signed-off-by: Sasha Khapyorsky <sashakh-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 opensm/osm_drop_mgr.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/opensm/osm_drop_mgr.c b/opensm/osm_drop_mgr.c
index b309273..5113fa2 100644
--- a/opensm/osm_drop_mgr.c
+++ b/opensm/osm_drop_mgr.c
@@ -114,7 +114,9 @@ static void drop_mgr_clean_physp(osm_sm_t * sm, IN osm_physp_t * p_physp)
 			   the remote port, since it is no longer reachable.
 			   This can be done if we reset the discovery count
 			   of the remote port. */
-			if (!p_remote_physp->p_node->sw) {
+			if (!p_remote_physp->p_node->sw &&
+			    p_remote_physp->port_guid !=
+			    sm->p_subn->sm_port_guid) {
 				p_remote_port->discovery_count = 0;
 				OSM_LOG(sm->p_log, OSM_LOG_DEBUG,
 					"Resetting discovery count of node: "
-- 
1.8.1.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
