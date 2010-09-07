From: Yevgeny Kliteynik <kliteyn-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Subject: [PATCH] opensm/osm_helper.c: fix potential overrun of the array
Date: Tue, 7 Sep 2010 18:02:49 +0300
Message-ID: <4C865419.9050005@mellanox.co.il>
Reply-To: kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>, Linux RDMA <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Max index of the ib_sm_method_str[] static array
is 0x20. Fixing OSM_SM_METHOD_STR_UNKNOWN_VAL to
match this value.

Signed-off-by: Yevgeny Kliteynik <kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
---
 opensm/opensm/osm_helper.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/opensm/opensm/osm_helper.c b/opensm/opensm/osm_helper.c
index 196d5aa..0233e70 100644
--- a/opensm/opensm/osm_helper.c
+++ b/opensm/opensm/osm_helper.c
@@ -148,7 +148,7 @@ static const char *ib_sm_method_str[] = {
 	"UNKNOWN"		/* 20 */
 };

-#define OSM_SM_METHOD_STR_UNKNOWN_VAL 0x21
+#define OSM_SM_METHOD_STR_UNKNOWN_VAL 0x20

 static const char *ib_sm_attr_str[] = {
 	"RESERVED",		/* 0 */
-- 
1.6.2.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
