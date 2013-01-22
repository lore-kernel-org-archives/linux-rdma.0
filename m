From: Jens Domke <domke.j.aa@m.titech.ac.jp>
Subject: [PATCH 03/10] opensm/osm_ucast_dfsssp.c : fix dereference null return value
Date: Wed, 23 Jan 2013 01:39:42 +0900
Message-ID: <1358872782-16912-1-git-send-email-domke.j.aa@m.titech.ac.jp>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Torsten Hoefler <htor-gy3b+zu4XSAfv37vnLkPlQ@public.gmane.org>, Dan Ben Yosef <danby-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Jens Domke <domke.j.aa@m.titech.ac.jp>
List-Id: linux-rdma@vger.kernel.org

From: Dan Ben Yosef <danby-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>

Dereferencing a null pointer "remote_node"

Signed-off-by: Dan Ben Yosef <danby-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Signed-off-by: Jens Domke <domke.j.aa@m.titech.ac.jp>
---
 opensm/osm_ucast_dfsssp.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/opensm/osm_ucast_dfsssp.c b/opensm/osm_ucast_dfsssp.c
index 013bad4..af1b062 100644
--- a/opensm/osm_ucast_dfsssp.c
+++ b/opensm/osm_ucast_dfsssp.c
@@ -815,7 +815,7 @@ static int update_channel_dep_graph(cdg_node_t ** cdg_root,
 		    osm_node_get_remote_node(local_node, local_port,
 					     &remote_port);
 		/* if remote_node is a Hca, then the last channel from switch to Hca would be a sink in the cdg -> skip */
-		if (!remote_node->sw)
+		if (!remote_node || !remote_node->sw)
 			break;
 		remote_lid = cl_ntoh16(osm_node_get_base_lid(remote_node, 0));
 
@@ -961,7 +961,7 @@ static int remove_path_from_cdg(cdg_node_t ** cdg_root, osm_port_t * src_port,
 		    osm_node_get_remote_node(local_node, local_port,
 					     &remote_port);
 		/* if remote_node is a Hca, then the last channel from switch to Hca would be a sink in the cdg -> skip */
-		if (!remote_node->sw)
+		if (!remote_node || !remote_node->sw)
 			break;
 		remote_lid = cl_ntoh16(osm_node_get_base_lid(remote_node, 0));
 
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
