From: Albert Chu <chu11-i2BcT+NCU+M@public.gmane.org>
Subject: [opensm] [PATCH 2/2] Do not load configs from the default config
	file and specified config file
Date: Thu, 10 Nov 2011 10:01:40 -0800
Message-ID: <1320948100.22519.338.camel@auk59.llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

If a config file is specified on the command line, only that config file should
be used, it should not be parsed in addition to the default.

Signed-off-by: Albert L. Chu <chu11-i2BcT+NCU+M@public.gmane.org>
---
 opensm/main.c |   13 ++++++-------
 1 files changed, 6 insertions(+), 7 deletions(-)

diff --git a/opensm/main.c b/opensm/main.c
index f7a6d83..3edc52f 100644
--- a/opensm/main.c
+++ b/opensm/main.c
@@ -660,12 +660,6 @@ int main(int argc, char *argv[])
 	printf("-------------------------------------------------\n");
 	printf("%s\n", OSM_VERSION);
 
-	osm_subn_set_default_opt(&opt);
-
-	if (osm_subn_parse_conf_file(OSM_DEFAULT_CONFIG_FILE, &opt) < 0)
-		printf("\nFail to parse config file \'%s\'\n",
-		       OSM_DEFAULT_CONFIG_FILE);
-
 	do {
 		next_option = getopt_long_only(argc, argv, short_option,
 					       long_option, NULL);
@@ -681,7 +675,12 @@ int main(int argc, char *argv[])
 
 	optind = 0;		/* reset command line */
 
-	if (config_file && osm_subn_parse_conf_file(config_file, &opt) < 0)
+	if (!config_file)
+		config_file = OSM_DEFAULT_CONFIG_FILE;
+
+	osm_subn_set_default_opt(&opt);
+
+	if (osm_subn_parse_conf_file(config_file, &opt) < 0)
 		printf("\nFail to parse config file \'%s\'\n", config_file);
 
 	printf("Command Line Arguments:\n");
-- 
1.7.1



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
