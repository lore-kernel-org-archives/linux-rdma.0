From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH opensm] opensm/osm_db_pack.c: Removed uneeded asserts
Date: Tue, 23 Jul 2013 11:17:03 -0400
Message-ID: <51EE9E6F.8000402@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


From: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Out of range lids isn't a fatal event and SM code just ignores these
lids.

Signed-off-by: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 opensm/osm_db_pack.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/opensm/osm_db_pack.c b/opensm/osm_db_pack.c
index 708a875..8cddd06 100644
--- a/opensm/osm_db_pack.c
+++ b/opensm/osm_db_pack.c
@@ -73,14 +73,18 @@ static inline int unpack_lids(IN char *p_lid_str, OUT uint16_t * p_min_lid,
 	if (!p_num)
 		return 1;
 	tmp = strtoul(p_num, NULL, 0);
-	CL_ASSERT(tmp < 0x10000);
+	if (tmp >= 0xC000)
+		return 1;
+
 	*p_min_lid = (uint16_t) tmp;
 
 	p_num = strtok_r(NULL, " \t", &p_next);
 	if (!p_num)
 		return 1;
 	tmp = strtoul(p_num, NULL, 0);
-	CL_ASSERT(tmp < 0x10000);
+	if (tmp >= 0xC000)
+		return 1;
+
 	*p_max_lid = (uint16_t) tmp;
 
 	return 0;
-- 
1.7.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
