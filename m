From: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH 1/3] opensm/osm_ucast_dfsssp.c: Removed unused variables
Date: Sat, 19 May 2012 22:43:21 +0300
Message-ID: <20120519194321.GB2110@calypso>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jens Domke <jens.domke-PZVgAJowwIsUtdQbppsyvg@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Signed-off-by: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Jens Domke <jens.domke-PZVgAJowwIsUtdQbppsyvg@public.gmane.org>
---
 opensm/osm_ucast_dfsssp.c |    6 +-----
 1 files changed, 1 insertions(+), 5 deletions(-)

diff --git a/opensm/osm_ucast_dfsssp.c b/opensm/osm_ucast_dfsssp.c
index f0af95a..d91ea40 100644
--- a/opensm/osm_ucast_dfsssp.c
+++ b/opensm/osm_ucast_dfsssp.c
@@ -931,16 +931,12 @@ static int remove_path_from_cdg(cdg_node_t ** cdg_root, osm_port_t * src_port,
 {
 	osm_node_t *local_node = NULL, *remote_node = NULL;
 	uint16_t local_lid = 0, remote_lid = 0;
-	uint32_t srcdest = 0;
 	uint8_t local_port = 0, remote_port = 0;
 	uint64_t channelID = 0;
 
 	cdg_node_t *channel_head = NULL, *channel = NULL, *last_channel = NULL;
 	cdg_link_t *linklist = NULL;
 
-	/* set the identifier for the src/dest pair to remove this on each edge of the cdg */
-	srcdest = (((uint32_t) slid) << 16) + ((uint32_t) dlid);
-
 	channel_head = (cdg_node_t *) malloc(sizeof(cdg_node_t));
 	if (!channel_head)
 		goto ERROR;
@@ -1578,7 +1574,7 @@ static int dfsssp_remove_deadlocks(dfsssp_context_t * dfsssp_ctx)
 
 	cl_qmap_t *port_tbl = &p_mgr->p_subn->port_guid_tbl;	/* 1 managment port per switch + 1 or 2 ports for each Hca */
 	cl_map_item_t *item1 = NULL, *item2 = NULL;
-	osm_port_t *port = NULL, *src_port = NULL, *dest_port = NULL;
+	osm_port_t *src_port = NULL, *dest_port = NULL;
 
 	uint32_t i = 0, err = 0;
 	uint8_t test_vl = 0, vl_avail = 0, vl_needed = 1;
-- 
1.7.7.6


-- 

-- Alex
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
