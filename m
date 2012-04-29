From: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH] opensm: Fix PathRecord reply to be the same for
 allow_both_pkeys ON and OFF
Date: Sun, 29 Apr 2012 21:44:39 +0300
Message-ID: <20120429184439.GA3610@calypso>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Signed-off-by: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 opensm/osm_pkey.c |   13 +++++++++++--
 1 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/opensm/osm_pkey.c b/opensm/osm_pkey.c
index 30a5767..e95adb2 100644
--- a/opensm/osm_pkey.c
+++ b/opensm/osm_pkey.c
@@ -335,12 +335,21 @@ boolean_t osm_physp_share_this_pkey(IN const osm_physp_t * p_physp1,
 				    IN boolean_t allow_both_pkeys)
 {
 	ib_net16_t *pkey1, *pkey2;
+	ib_net16_t full_pkey, limited_pkey;
 
 	if (allow_both_pkeys) {
+		full_pkey = pkey | IB_PKEY_TYPE_MASK;
+		limited_pkey = pkey & ~IB_PKEY_TYPE_MASK;
 		pkey1 = cl_map_get(&(osm_physp_get_pkey_tbl(p_physp1))->keys,
-				   pkey);
+				   full_pkey);
+		if (!pkey1)
+			pkey1 = cl_map_get(&(osm_physp_get_pkey_tbl(p_physp1))->keys,
+					   limited_pkey);
 		pkey2 = cl_map_get(&(osm_physp_get_pkey_tbl(p_physp2))->keys,
-				   pkey);
+				   full_pkey);
+		if (!pkey2)
+			pkey2 = cl_map_get(&(osm_physp_get_pkey_tbl(p_physp2))->keys,
+					   limited_pkey);
 	} else {
 		pkey1 = cl_map_get(&(osm_physp_get_pkey_tbl(p_physp1))->keys,
 				   ib_pkey_get_base(pkey));
-- 
1.7.7.6

-- Alex
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
