From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH 4/13] opensm/osm_sa_guidinfo_record.c: Use OSM_VENDOR_ID_OPENIB
 define
Date: Fri, 29 Apr 2011 09:27:19 -0400
Message-ID: <4DBABCB7.3060000@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

>From a8183ead5fbfe2dc8424967f6c7d9eef4aa4bdf9 Mon Sep 17 00:00:00 2001
From: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Date: Thu, 28 Apr 2011 23:29:55 +0300
Subject: [PATCH] opensm/osm_sa_guidinfo_record.c: Use OSM_VENDOR_ID_OPENIB define

rather than IB_OPENIB_OUI

Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 opensm/osm_sa_guidinfo_record.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/opensm/osm_sa_guidinfo_record.c b/opensm/osm_sa_guidinfo_record.c
index 79e9c51..c4b7d3d 100644
--- a/opensm/osm_sa_guidinfo_record.c
+++ b/opensm/osm_sa_guidinfo_record.c
@@ -57,7 +57,6 @@
 #include <opensm/osm_pkey.h>
 #include <opensm/osm_sa.h>
 
-#define IB_OPENIB_OUI	0x001405
 #define MOD_GIR_COMP_MASK (IB_GIR_COMPMASK_LID | IB_GIR_COMPMASK_BLOCKNUM)
 
 typedef struct osm_gir_item {
@@ -366,7 +365,7 @@ static ib_net64_t sm_assigned_guid(uint8_t assigned_byte)
 	}
 	return cl_hton64(((uint64_t) uniq_count) |
 			 (((uint64_t) assigned_byte) << 32) |
-			 (((uint64_t) IB_OPENIB_OUI) << 40));
+			 (((uint64_t) OSM_VENDOR_ID_OPENIB) << 40));
 }
 
 static void guidinfo_set(IN osm_sa_t *sa, IN osm_port_t *p_port,
-- 
1.5.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
