From: Hal Rosenstock <hnrose-Wuw85uim5zDR7s880joybQ@public.gmane.org>
Subject: [PATCH] opensm/osm_sa_path_record.c: Add error code to newly added
	log message
Date: Mon, 24 May 2010 15:42:51 -0400
Message-ID: <20100524194251.GA26919@comcast.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


added in commit 1010c9c5014d5a6af2db33e27ae7156f239e7254

Signed-off-by: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 opensm/opensm/osm_sa_path_record.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/opensm/opensm/osm_sa_path_record.c b/opensm/opensm/osm_sa_path_record.c
index 9fa0c1e..de97dcd 100644
--- a/opensm/opensm/osm_sa_path_record.c
+++ b/opensm/opensm/osm_sa_path_record.c
@@ -377,7 +377,7 @@ static ib_api_status_t pr_rcv_get_path_parms(IN osm_sa_t * sa,
 		/* update number of hops traversed */
 		hops++;
 		if (hops > MAX_HOPS) {
-			OSM_LOG(sa->p_log, OSM_LOG_ERROR,
+			OSM_LOG(sa->p_log, OSM_LOG_ERROR, "ERR 1F25: "
 				"Path from GUID 0x%016" PRIx64 " (%s) to"
 				" lid %u GUID 0x%016" PRIx64 " (%s) needs"
 				" more than %d hops, max %d hops allowed\n",
-- 
1.5.6.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
