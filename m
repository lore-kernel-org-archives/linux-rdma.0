From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH 3/4] opensm/osm_pkey.h: Commentary change
Date: Tue, 24 May 2011 13:25:29 -0400
Message-ID: <4DDBEA09.9040902@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org



Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 include/opensm/osm_pkey.h |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/include/opensm/osm_pkey.h b/include/opensm/osm_pkey.h
index 33de7e7..066bbb3 100644
--- a/include/opensm/osm_pkey.h
+++ b/include/opensm/osm_pkey.h
@@ -299,8 +299,7 @@ static inline ib_pkey_table_t *osm_pkey_tbl_new_block_get(const osm_pkey_tbl_t *
 *  osm_pkey_tbl_set_accum_pkeys
 *
 * DESCRIPTION
-*   Stores the given pkey in the "accum_pkeys" array and update
-*   update the "map"
+*   Stores the given pkey and pkey index in the "accum_pkeys" array
 *
 * SYNOPSIS
 */
-- 
1.5.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
