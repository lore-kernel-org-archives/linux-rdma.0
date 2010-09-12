From: Yevgeny Kliteynik <kliteyn-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Subject: [PATCH] opensm/osm_helper.c: use ARR_SIZE macro instead of
	hardcoded values
Date: Sun, 12 Sep 2010 11:56:55 +0200
Message-ID: <4C8CA3E7.8060406@mellanox.co.il>
Reply-To: kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>, Linux RDMA <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Signed-off-by: Yevgeny Kliteynik <kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
---
 opensm/opensm/osm_helper.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/opensm/opensm/osm_helper.c b/opensm/opensm/osm_helper.c
index 58bc86b..2597e50 100644
--- a/opensm/opensm/osm_helper.c
+++ b/opensm/opensm/osm_helper.c
@@ -84,7 +84,7 @@ static const char *ib_sa_method_str[] = {
 	"UNKNOWN"		/* 16 */
 };

-#define OSM_SA_METHOD_STR_UNKNOWN_VAL 0x16
+#define OSM_SA_METHOD_STR_UNKNOWN_VAL (ARR_SIZE(ib_sa_method_str) - 1)

 static const char *ib_sa_resp_method_str[] = {
 	"RESERVED",		/* 80 */
@@ -148,7 +148,7 @@ static const char *ib_sm_method_str[] = {
 	"UNKNOWN"		/* 20 */
 };

-#define OSM_SM_METHOD_STR_UNKNOWN_VAL 0x20
+#define OSM_SM_METHOD_STR_UNKNOWN_VAL (ARR_SIZE(ib_sm_method_str) - 1)

 static const char *ib_sm_attr_str[] = {
 	"RESERVED",		/* 0 */
@@ -187,7 +187,7 @@ static const char *ib_sm_attr_str[] = {
 	"UNKNOWN"		/* 21 - always highest value */
 };

-#define OSM_SM_ATTR_STR_UNKNOWN_VAL 0x21
+#define OSM_SM_ATTR_STR_UNKNOWN_VAL (ARR_SIZE(ib_sm_attr_str) - 1)

 static const char *ib_sa_attr_str[] = {
 	"RESERVED",		/* 0 */
@@ -437,7 +437,7 @@ static const char *ib_sa_attr_str[] = {
 	"UNKNOWN"		/* F4 - always highest value */
 };

-#define OSM_SA_ATTR_STR_UNKNOWN_VAL 0xF4
+#define OSM_SA_ATTR_STR_UNKNOWN_VAL (ARR_SIZE(ib_sa_attr_str) - 1)

 static int sprint_uint8_arr(char *buf, size_t size,
 			    const uint8_t * arr, size_t len)
-- 
1.6.2.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
