From: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: [PATCH] opensm/osm_state_mgr.c: in cleanup_switch() check only
 relevant LFT part
Date: Tue, 13 Oct 2009 19:56:47 +0200
Message-ID: <20091013175647.GS13830@me>
References: <20091013130002.GA20173@comcast.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20091013130002.GA20173-Wuw85uim5zDR7s880joybQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Hal Rosenstock <hnrose-Wuw85uim5zDR7s880joybQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


In cleanup_switch() be sure that only relevant LFT entries were updated,
don't care about outdated part of LFT.

Signed-off-by: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
---
 opensm/opensm/osm_state_mgr.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/opensm/opensm/osm_state_mgr.c b/opensm/opensm/osm_state_mgr.c
index c40c9d3..4035657 100644
--- a/opensm/opensm/osm_state_mgr.c
+++ b/opensm/opensm/osm_state_mgr.c
@@ -1011,7 +1011,7 @@ static void cleanup_switch(cl_map_item_t * item, void *log)
 	if (!sw->new_lft)
 		return;
 
-	if (memcmp(sw->lft, sw->new_lft, sw->lft_size))
+	if (memcmp(sw->lft, sw->new_lft, sw->max_lid_ho + 1))
 		osm_log(log, OSM_LOG_ERROR, "ERR 331D: "
 			"LFT of switch 0x%016" PRIx64 " is not up to date\n",
 			cl_ntoh64(sw->p_node->node_info.node_guid));
-- 
1.6.5

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
