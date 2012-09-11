From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: [PATCH 4/6] opensm: osm_pkey: Remove unused variables
Date: Tue, 11 Sep 2012 16:19:17 +0200
Message-ID: <504F4865.3040608@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Signed-off-by: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
---
 opensm/osm_pkey.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/opensm/osm_pkey.c b/opensm/osm_pkey.c
index 98e2aee..bb45f57 100644
--- a/opensm/osm_pkey.c
+++ b/opensm/osm_pkey.c
@@ -369,9 +369,6 @@ ib_net16_t osm_physp_find_common_pkey(IN const osm_physp_t * p_physp1,
 	uint64_t pkey1_base, pkey2_base;
 	const osm_pkey_tbl_t *pkey_tbl1, *pkey_tbl2;
 	cl_map_iterator_t map_iter1, map_iter2;
-	ib_net16_t key;
-	const osm_pkey_tbl_t *pkey_tbl;
-	cl_map_iterator_t map_iter, map_end;
 
 	pkey_tbl1 = osm_physp_get_pkey_tbl(p_physp1);
 	pkey_tbl2 = osm_physp_get_pkey_tbl(p_physp2);
-- 
1.7.7

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
