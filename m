From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH opensm] osm_ucast_cache.c: Fix memory leak in ucast_cache
Date: Mon, 28 Oct 2013 11:09:54 -0400
Message-ID: <526E7E42.8060302@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


From: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

When invalidating cache p_sw->hops[i] arrays aren't cleared.

Signed-off-by: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 opensm/osm_ucast_cache.c |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/opensm/osm_ucast_cache.c b/opensm/osm_ucast_cache.c
index e3f7c7b..2238ba3 100644
--- a/opensm/osm_ucast_cache.c
+++ b/opensm/osm_ucast_cache.c
@@ -114,13 +114,19 @@ static cache_switch_t *cache_sw_new(uint16_t lid_ho, unsigned num_ports)
 
 static void cache_sw_destroy(cache_switch_t * p_sw)
 {
+	unsigned i;
+
 	if (!p_sw)
 		return;
 
 	if (p_sw->lft)
 		free(p_sw->lft);
-	if (p_sw->hops)
+	if (p_sw->hops) {
+		for (i = 0; i < p_sw->num_hops; i++)
+			if (p_sw->hops[i])
+				free(p_sw->hops[i]);
 		free(p_sw->hops);
+	}
 	free(p_sw);
 }
 
-- 
1.7.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
