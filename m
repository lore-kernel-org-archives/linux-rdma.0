From: Albert Chu <chu11-i2BcT+NCU+M@public.gmane.org>
Subject: [PATCH] opensm/osm_ucast_ftree.c: Fix invalid debug output message
Date: Fri, 01 Mar 2013 16:39:13 -0800
Message-ID: <1362184753.28997.96.camel@auk59.llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Fix branch logic bug in which

Marking I/O port GUID 0x0011750000771101

was output, when it should have instead output

Marking non-CN port GUID 0x0011750000771101

Signed-off-by: Albert L. Chu <chu11-i2BcT+NCU+M@public.gmane.org>
---
 opensm/osm_ucast_ftree.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/opensm/osm_ucast_ftree.c b/opensm/osm_ucast_ftree.c
index 932ec6a..99d6981 100644
--- a/opensm/osm_ucast_ftree.c
+++ b/opensm/osm_ucast_ftree.c
@@ -3360,7 +3360,9 @@ fabric_construct_hca_ports(IN ftree_fabric_t * p_ftree, IN ftree_hca_t * p_hca)
 				if (p_elem != (name_map_item_t *)
 				    cl_qmap_end(&p_ftree->io_guid_tbl))
 					is_io = TRUE;
+			}
 
+			if (is_io) {
 				OSM_LOG(&p_ftree->p_osm->log, OSM_LOG_DEBUG,
 					"Marking I/O port GUID 0x%016" PRIx64
 					"\n",
-- 
1.7.1



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
