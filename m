From: "Stan C. Smith" <stan.smith-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] opensm - cleanup
Date: Mon, 24 May 2010 20:58:48 -0700
Message-ID: <59F66ECB77704137A5F122AE78B5D554@amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


Cleanup __WIN__ clauses by using predefined macros.

signed-off-by: stan smith <stan.smith-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

--- a/opensm/include/opensm/osm_base.h	2010-05-22 14:26:26.000000000 -0700
+++ b/opensm/include/opensm/osm_base.h	2010-05-11 17:47:37.886597800 -0700
@@ -181,7 +181,7 @@
 * SYNOPSIS
 */
 #ifdef __WIN__
-#define OSM_DEFAULT_TMP_DIR GetOsmTempPath()
+#define OSM_DEFAULT_TMP_DIR "%TEMP%\\"
 #else
 #define OSM_DEFAULT_TMP_DIR "/var/log/"
 #endif
@@ -196,7 +196,7 @@
 * SYNOPSIS
 */
 #ifdef __WIN__
-#define OSM_DEFAULT_CACHE_DIR GetOsmCachePath()
+#define OSM_DEFAULT_CACHE_DIR "%TEMP%"
 #else
 #define OSM_DEFAULT_CACHE_DIR "/var/cache/opensm"
 #endif
@@ -211,7 +211,7 @@
 * SYNOPSIS
 */
 #ifdef __WIN__
-#define OSM_DEFAULT_LOG_FILE strcat(GetOsmTempPath(), "osm.log")
+#define OSM_DEFAULT_LOG_FILE OSM_DEFAULT_TMP_DIR "osm.log"
 #else
 #define OSM_DEFAULT_LOG_FILE "/var/log/opensm.log"
 #endif
@@ -226,15 +226,13 @@
 *
 * SYNOPSIS
 */
-#ifdef __WIN__
-#define OSM_DEFAULT_CONFIG_FILE strcat(GetOsmCachePath(), "opensm.conf")
-#elif defined(HAVE_DEFAULT_OPENSM_CONFIG_FILE)
+#if defined(HAVE_DEFAULT_OPENSM_CONFIG_FILE)
 #define OSM_DEFAULT_CONFIG_FILE HAVE_DEFAULT_OPENSM_CONFIG_FILE
 #elif defined (OPENSM_CONFIG_DIR)
 #define OSM_DEFAULT_CONFIG_FILE OPENSM_CONFIG_DIR "/opensm.conf"
 #else
 #define OSM_DEFAULT_CONFIG_FILE "/etc/opensm/opensm.conf"
-#endif /* __WIN__ */
+#endif
 /***********/
 
 /****d* OpenSM: Base/OSM_DEFAULT_PARTITION_CONFIG_FILE
@@ -246,15 +244,13 @@
 *
 * SYNOPSIS
 */
-#ifdef __WIN__
-#define OSM_DEFAULT_PARTITION_CONFIG_FILE strcat(GetOsmCachePath(), "osm-partitions.conf")
-#elif defined(HAVE_DEFAULT_PARTITION_CONFIG_FILE)
+#if defined(HAVE_DEFAULT_PARTITION_CONFIG_FILE)
 #define OSM_DEFAULT_PARTITION_CONFIG_FILE HAVE_DEFAULT_PARTITION_CONFIG_FILE
 #elif defined(OPENSM_CONFIG_DIR)
 #define OSM_DEFAULT_PARTITION_CONFIG_FILE OPENSM_CONFIG_DIR "/partitions.conf"
 #else
 #define OSM_DEFAULT_PARTITION_CONFIG_FILE "/etc/opensm/partitions.conf"
-#endif /* __WIN__ */
+#endif
 /***********/
 
 /****d* OpenSM: Base/OSM_DEFAULT_QOS_POLICY_FILE
@@ -266,15 +262,13 @@
 *
 * SYNOPSIS
 */
-#ifdef __WIN__
-#define OSM_DEFAULT_QOS_POLICY_FILE strcat(GetOsmCachePath(), "osm-qos-policy.conf")
-#elif defined(HAVE_DEFAULT_QOS_POLICY_FILE)
+#if defined(HAVE_DEFAULT_QOS_POLICY_FILE)
 #define OSM_DEFAULT_QOS_POLICY_FILE HAVE_DEFAULT_QOS_POLICY_FILE
 #elif defined(OPENSM_CONFIG_DIR)
 #define OSM_DEFAULT_QOS_POLICY_FILE OPENSM_CONFIG_DIR "/qos-policy.conf"
 #else
 #define OSM_DEFAULT_QOS_POLICY_FILE "/etc/opensm/qos-policy.conf"
-#endif /* __WIN__ */
+#endif
 /***********/
 
 /****d* OpenSM: Base/OSM_DEFAULT_PREFIX_ROUTES_FILE
@@ -286,9 +280,7 @@
 *
 * SYNOPSIS
 */
-#ifdef __WIN__
-#define OSM_DEFAULT_PREFIX_ROUTES_FILE strcat(GetOsmCachePath(), "osm-prefix-routes.conf")
-#elif defined(HAVE_DEFAULT_PREFIX_ROUTES_FILE)
+#if defined(HAVE_DEFAULT_PREFIX_ROUTES_FILE)
 #define OSM_DEFAULT_PREFIX_ROUTES_FILE HAVE_DEFAULT_PREFIX_ROUTES_FILE
 #elif defined(OPENSM_CONFIG_DIR)
 #define OSM_DEFAULT_PREFIX_ROUTES_FILE OPENSM_CONFIG_DIR "/prefix-routes.conf"

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
