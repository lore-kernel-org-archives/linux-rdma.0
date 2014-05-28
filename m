From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH opensm] osm_helper.c: In osm_get_lsa_str, fix printing of
 wrong FDR10 data if link is down
Date: Wed, 28 May 2014 09:06:07 -0400
Message-ID: <5385DF3F.2010103@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Shlomi Nimrodi <shlomin-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Shlomi Nimrodi <shlomin-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Date: Tue, 27 May 2014 19:03:14 +0300

Signed-off-by: Shlomi Nimrodi <shlomin-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 opensm/osm_helper.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/opensm/osm_helper.c b/opensm/osm_helper.c
index b078e33..db39542 100644
--- a/opensm/osm_helper.c
+++ b/opensm/osm_helper.c
@@ -3185,7 +3185,7 @@ static const char *lsea_str_fixed_width[] = {
 const char *osm_get_lsa_str(IN uint8_t lsa, IN uint8_t lsea, IN uint8_t state,
 			    IN uint8_t fdr10)
 {
-	if (lsa > IB_LINK_SPEED_ACTIVE_10)
+	if (lsa > IB_LINK_SPEED_ACTIVE_10 || state == IB_LINK_DOWN)
 		return lsa_str_fixed_width[3];
 	if (lsea == IB_LINK_SPEED_EXT_ACTIVE_NONE) {
 		if (fdr10)
-- 
1.7.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
