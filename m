From: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH 20/27] Fix crash in ucast cache when chain of switches connected back at once to the fabric
Date: Tue, 31 Jul 2012 19:04:48 +0300
Message-ID: <1343750695-28063-20-git-send-email-alexne@mellanox.com>
References: <1343750695-28063-1-git-send-email-alexne@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1343750695-28063-1-git-send-email-alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Vladimir Koushnir <vladimirk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Signed-off-by: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Vladimir Koushnir <vladimirk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 opensm/osm_ucast_cache.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/opensm/osm_ucast_cache.c b/opensm/osm_ucast_cache.c
index fc28be7..f0b2346 100644
--- a/opensm/osm_ucast_cache.c
+++ b/opensm/osm_ucast_cache.c
@@ -325,6 +325,8 @@ cache_restore_ucast_info(osm_ucast_mgr_t * p_mgr,
 		free(p_sw->hops);
 	p_sw->hops = p_cache_sw->hops;
 	p_cache_sw->hops = NULL;
+
+	p_sw->need_update = 2;
 }
 
 static void ucast_cache_dump(osm_ucast_mgr_t * p_mgr)
-- 
1.7.11.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
