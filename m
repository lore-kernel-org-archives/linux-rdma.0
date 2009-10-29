From: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: [PATCH] opensm/osm_mcast_mgr: simplify alloc_mfts()
Date: Thu, 29 Oct 2009 21:18:28 +0200
Message-ID: <20091029191828.GC20136@me>
References: <20091023234856.GA1482@comcast.net>
 <20091029191732.GB20136@me>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20091029191732.GB20136@me>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hnrose-Wuw85uim5zDR7s880joybQ@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


Remove not actually needed 'max_mlid' variable from alloc_mft()
function.

Signed-off-by: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
---
 opensm/opensm/osm_mcast_mgr.c |   14 ++++----------
 1 files changed, 4 insertions(+), 10 deletions(-)

diff --git a/opensm/opensm/osm_mcast_mgr.c b/opensm/opensm/osm_mcast_mgr.c
index a5e9758..faa0c4b 100644
--- a/opensm/opensm/osm_mcast_mgr.c
+++ b/opensm/opensm/osm_mcast_mgr.c
@@ -1048,17 +1048,12 @@ static int alloc_mfts(osm_sm_t * sm)
 	int i;
 	cl_map_item_t *item;
 	osm_switch_t *p_sw;
-	int max_mlid = 0;
 
 	for (i = sm->p_subn->max_mcast_lid_ho - IB_LID_MCAST_START_HO; i >= 0;
-	     i--) {
-		if (sm->p_subn->mgroups[i]) {
-			max_mlid = i + IB_LID_MCAST_START_HO;
+	     i--)
+		if (sm->p_subn->mgroups[i])
 			break;
-		}
-	}
-
-	if (max_mlid == 0)
+	if (i < 0)
 		return 0;
 
 	/* Now, walk switches and (re)allocate multicast tables */
@@ -1066,8 +1061,7 @@ static int alloc_mfts(osm_sm_t * sm)
 	     item != cl_qmap_end(&sm->p_subn->sw_guid_tbl);
 	     item = cl_qmap_next(item)) {
 		p_sw = (osm_switch_t *)item;
-		if (osm_mcast_tbl_realloc(&p_sw->mcast_tbl,
-					  max_mlid - IB_LID_MCAST_START_HO))
+		if (osm_mcast_tbl_realloc(&p_sw->mcast_tbl, i))
 			return -1;
 	}
 	return 0;
-- 
1.6.5.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
