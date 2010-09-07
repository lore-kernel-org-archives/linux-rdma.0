From: Yevgeny Kliteynik <kliteyn-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Subject: [PATCH] opensm/osm_helper.c: cosmetics - move define closer to the
	relevant code
Date: Tue, 7 Sep 2010 18:03:52 +0300
Message-ID: <4C865458.9030903@mellanox.co.il>
Reply-To: kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>, Linux RDMA <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

OSM_SA_METHOD_STR_UNKNOWN_VAL refers to ib_sa_method_str[].
Moving it closer to the array.

Signed-off-by: Yevgeny Kliteynik <kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
---
 opensm/opensm/osm_helper.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/opensm/opensm/osm_helper.c b/opensm/opensm/osm_helper.c
index 0233e70..58bc86b 100644
--- a/opensm/opensm/osm_helper.c
+++ b/opensm/opensm/osm_helper.c
@@ -84,6 +84,8 @@ static const char *ib_sa_method_str[] = {
 	"UNKNOWN"		/* 16 */
 };

+#define OSM_SA_METHOD_STR_UNKNOWN_VAL 0x16
+
 static const char *ib_sa_resp_method_str[] = {
 	"RESERVED",		/* 80 */
 	"SubnAdmGetResp",	/* 81 */
@@ -110,8 +112,6 @@ static const char *ib_sa_resp_method_str[] = {
 	"UNKNOWN"
 };

-#define OSM_SA_METHOD_STR_UNKNOWN_VAL 0x16
-
 static const char *ib_sm_method_str[] = {
 	"RESERVED0",		/* 0 */
 	"SubnGet",		/* 1 */
-- 
1.6.2.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
