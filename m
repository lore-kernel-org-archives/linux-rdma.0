From: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH 1/5] opensm/include/iba/ib_types.h: Fix shadow declaration warnings
Date: Mon,  3 Feb 2014 13:05:12 +0200
Message-ID: <1391425516-14462-1-git-send-email-alexne@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Calling cl_ntoh32(cl_ntoh32()) causes shadow parameters redefinition.
The fix is to split the cl_ntoh32() calls.

Signed-off-by: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 include/iba/ib_types.h |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/include/iba/ib_types.h b/include/iba/ib_types.h
index 86fa07b..a5136d4 100644
--- a/include/iba/ib_types.h
+++ b/include/iba/ib_types.h
@@ -8164,9 +8164,10 @@ static inline void OSM_API
 ib_inform_info_set_qpn(IN ib_inform_info_t * p_ii, IN ib_net32_t const qpn)
 {
 	uint32_t tmp = cl_ntoh32(p_ii->g_or_v.generic.qpn_resp_time_val);
+	uint32_t qpn_h = cl_ntoh32(qpn);
 
 	p_ii->g_or_v.generic.qpn_resp_time_val =
-	    cl_hton32((tmp & 0x000000ff) | ((cl_ntoh32(qpn) << 8) & 0xffffff00)
+	    cl_hton32((tmp & 0x000000ff) | ((qpn_h << 8) & 0xffffff00)
 	    );
 }
 
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
