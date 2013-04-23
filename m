From: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH] opensm: Fix Q_Key, TClass and limited keys parsing warnings in partitions.conf
Date: Tue, 23 Apr 2013 17:09:19 +0300
Message-ID: <1366726159-19201-1-git-send-email-alexne@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Parsing these paraters caused 'unrecognized mgroup flag' warning.

Moreover fixed man page/doc for Q_Key/TClass paramters.

Signed-off-by: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 doc/partition-config.txt | 4 ++--
 man/opensm.8.in          | 4 ++--
 opensm/osm_prtn_config.c | 4 +++-
 3 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/doc/partition-config.txt b/doc/partition-config.txt
index f49d473..3581ef6 100644
--- a/doc/partition-config.txt
+++ b/doc/partition-config.txt
@@ -94,11 +94,11 @@ General file format:
 			    mgid.  Furthermore specifying multiple scope
 			    settings will result in multiple MC groups
 			    being created.
-        qkey=<val>      - specifies the Q_Key for this MC group
+        Q_Key=<val>     - specifies the Q_Key for this MC group
                           (default: 0x0b1b for IP groups, 0 for other groups)
                           WARNING: changing this for the broadcast group may
 			           break IPoIB on client nodes!!!
-        tclass=<val>    - specifies tclass for this MC group
+        TClass=<val>    - specifies tclass for this MC group
                           (default is 0)
         FlowLabel=<val> - specifies FlowLabel for this MC group
                           (default is 0)
diff --git a/man/opensm.8.in b/man/opensm.8.in
index 37e2eee..4ab7b30 100644
--- a/man/opensm.8.in
+++ b/man/opensm.8.in
@@ -619,9 +619,9 @@ General file format:
                             mgid.  Furthermore specifying multiple scope
                             settings will result in multiple MC groups
                             being created.
-        qkey=<val>      - specifies the Q_Key for this MC group
+        Q_Key=<val>      - specifies the Q_Key for this MC group
                           (default: 0x0b1b for IP groups, 0 for other groups)
-        tclass=<val>    - specifies tclass for this MC group
+        TClass=<val>    - specifies tclass for this MC group
                           (default is 0)
         FlowLabel=<val> - specifies FlowLabel for this MC group
                           (default is 0)
diff --git a/opensm/osm_prtn_config.c b/opensm/osm_prtn_config.c
index a3524b1..8f4a673 100644
--- a/opensm/osm_prtn_config.c
+++ b/opensm/osm_prtn_config.c
@@ -296,12 +296,14 @@ static int parse_group_flag(unsigned lineno, osm_log_t * p_log,
 		else
 			flags->scope_mask |= (1<<scope);
 	} else if (!strncmp(flag, "Q_Key", strlen(flag))) {
+		rc = 1;
 		if (!val || (flags->Q_Key = strtoul(val, NULL, 0)) == 0)
 			OSM_LOG(p_log, OSM_LOG_VERBOSE,
 				"PARSE WARN: line %d: "
 				"flag \'Q_Key\' requires valid value"
 				" - using '0'\n", lineno);
 	} else if (!strncmp(flag, "TClass", strlen(flag))) {
+		rc =1;
 		if (!val || (flags->TClass = strtoul(val, NULL, 0)) == 0)
 			OSM_LOG(p_log, OSM_LOG_VERBOSE,
 				"PARSE WARN: line %d: "
@@ -406,7 +408,7 @@ static int partition_add_port(unsigned lineno, struct part_conf *conf,
 			membership = FULL;
 		else if (!strncmp(flag, "both", strlen(flag)))
 			membership = BOTH;
-		else if (!strncmp(flag, "limited", strlen(flag))) {
+		else if (strncmp(flag, "limited", strlen(flag))) {
 			OSM_LOG(conf->p_log, OSM_LOG_VERBOSE,
 				"PARSE WARN: line %d: "
 				"unrecognized port flag \'%s\'."
-- 
1.7.11.7

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
