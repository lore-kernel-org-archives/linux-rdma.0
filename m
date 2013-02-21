From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH] osmtest/osmt_multicast.c: Fix IPoIB MC group recognition
Date: Thu, 21 Feb 2013 12:06:58 -0500
Message-ID: <51265432.10800@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Recognize IPoIB groups by signature in MGID

Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 osmtest/osmt_multicast.c |   21 ++++++++++++++++++---
 1 files changed, 18 insertions(+), 3 deletions(-)

diff --git a/osmtest/osmt_multicast.c b/osmtest/osmt_multicast.c
index d24f03a..ac8d1b2 100644
--- a/osmtest/osmt_multicast.c
+++ b/osmtest/osmt_multicast.c
@@ -435,10 +435,23 @@ void osmt_init_mc_query_rec(IN osmtest_t * const p_osmt,
  * - Try GetTable with PortGUID wildcarded and get back some groups.
  ***********************************************************************/
 
+#define PREFIX_MASK CL_HTON64(0xff10ffff00000000ULL)
+#define PREFIX_SIGNATURE CL_HTON64(0xff10601b00000000ULL)
+#define IPV4_PREFIX_MASK CL_HTON64(0xff10ffff00000000ULL)
+#define PREFIX_SIGNATURE_IPV4 CL_HTON64(0xff10401b00000000ULL)
+
+static unsigned is_ipv4_mgid(ib_gid_t * mgid)
+{
+	return ((mgid->unicast.prefix & IPV4_PREFIX_MASK) == PREFIX_SIGNATURE_IPV4);
+}
+
+static unsigned is_ipv6_mgid(ib_gid_t * mgid)
+{
+	return ((mgid->unicast.prefix & PREFIX_MASK) == PREFIX_SIGNATURE);
+}
+
 /* The following macro can be used only within the osmt_run_mcast_flow() function */
-#define IS_IPOIB_MGID(p_mgid) \
-           ( !memcmp(&osm_ipoib_good_mgid,    (p_mgid), sizeof(osm_ipoib_good_mgid)) || \
-             !memcmp(&osm_ts_ipoib_good_mgid, (p_mgid), sizeof(osm_ts_ipoib_good_mgid)) )
+#define IS_IPOIB_MGID(p_mgid) (is_ipv4_mgid(p_mgid) || is_ipv6_mgid(p_mgid))
 
 ib_api_status_t osmt_run_mcast_flow(IN osmtest_t * const p_osmt)
 {
@@ -486,6 +499,7 @@ ib_api_status_t osmt_run_mcast_flow(IN osmtest_t * const p_osmt)
 		 0xff, 0xff, 0xff, 0xee,	/* 32 bit IPv4 broadcast address */
 		 },
 	};
+#if 0
 	static ib_gid_t osm_ts_ipoib_good_mgid = {
 		{
 		 0xff,		/* multicast field */
@@ -496,6 +510,7 @@ ib_api_status_t osmt_run_mcast_flow(IN osmtest_t * const p_osmt)
 		 0x00, 0x00, 0x00, 0x01,	/* 32 bit IPv4 broadcast address */
 		 },
 	};
+#endif
 	static ib_gid_t osm_ipoib_good_mgid = {
 		{
 		 0xff,		/* multicast field */
-- 
1.7.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
