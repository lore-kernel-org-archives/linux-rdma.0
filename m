From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH opensm] osm_ucast_ftree.c: replace assert with error return
 value
Date: Mon, 30 Dec 2013 07:24:48 -0500
Message-ID: <52C16610.4080402@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Daniel Klein <danielk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Daniel Klein <danielk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Removed assert in fabric_create_leaf_switch_array() that checks that the
number of leafs is > 1. Instead the function returns -1, which fails the
routing engine.

Signed-off-by: Daniel Klein <danielk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 opensm/osm_ucast_ftree.c |    9 ++++++++-
 1 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/opensm/osm_ucast_ftree.c b/opensm/osm_ucast_ftree.c
index 581c233..4cec0ae 100644
--- a/opensm/osm_ucast_ftree.c
+++ b/opensm/osm_ucast_ftree.c
@@ -1719,12 +1719,19 @@ static int fabric_create_leaf_switch_array(IN ftree_fabric_t * p_ftree)
 			last_leaf_idx = i;
 		}
 	}
-	CL_ASSERT(first_leaf_idx < last_leaf_idx);
 
 	OSM_LOG(&p_ftree->p_osm->log, OSM_LOG_DEBUG,
 		"Full leaf array info: first_leaf_idx = %u, last_leaf_idx = %u\n",
 		first_leaf_idx, last_leaf_idx);
 
+	if (first_leaf_idx >= last_leaf_idx) {
+		osm_log_v2(&p_ftree->p_osm->log, OSM_LOG_INFO, FILE_ID,
+			   "Faild to find leaf switches - topology is not "
+			   "fat-tree\n");
+		res = -1;
+		goto Exit;
+	}
+
 	/* Create array of REAL leaf switches, sorted by index.
 	   This array may contain switches at the same rank w/o CNs,
 	   in case this is the order of indexing. */
-- 
1.7.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
