From: "Jim Schutt" <jaschut-4OHPYypu0djtX7QSmKvirg@public.gmane.org>
Subject: [PATCH v2 10/15] opensm: Add opensm option to specify file name
 for extra torus-2QoS configuration information.
Date: Wed, 10 Mar 2010 11:06:51 -0700
Message-ID: <1268244416-20351-10-git-send-email-jaschut@sandia.gov>
References: <1268244416-20351-1-git-send-email-jaschut@sandia.gov>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1268244416-20351-1-git-send-email-jaschut-4OHPYypu0djtX7QSmKvirg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org, eitan-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org, jaschut-4OHPYypu0djtX7QSmKvirg@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


Signed-off-by: Jim Schutt <jaschut-4OHPYypu0djtX7QSmKvirg@public.gmane.org>
---
 opensm/include/opensm/osm_base.h   |   18 ++++++++++++++++++
 opensm/include/opensm/osm_subnet.h |    5 +++++
 opensm/opensm/main.c               |    9 +++++++++
 opensm/opensm/osm_subnet.c         |    1 +
 opensm/opensm/osm_torus.c          |    2 +-
 5 files changed, 34 insertions(+), 1 deletions(-)

diff --git a/opensm/include/opensm/osm_base.h b/opensm/include/opensm/osm_base.h
index 4e9aaa9..8720c38 100644
--- a/opensm/include/opensm/osm_base.h
+++ b/opensm/include/opensm/osm_base.h
@@ -277,6 +277,24 @@ BEGIN_C_DECLS
 #endif /* __WIN__ */
 /***********/
 
+/****d* OpenSM: Base/OSM_DEFAULT_TORUS_CONF_FILE
+* NAME
+*	OSM_DEFAULT_TORUS_CONF_FILE
+*
+* DESCRIPTION
+*	Specifies the default file name for extra torus-2QoS configuration
+*
+* SYNOPSIS
+*/
+#ifdef __WIN__
+#define OSM_DEFAULT_TORUS_CONF_FILE strcat(GetOsmCachePath(), "osm-torus-2QoS.conf")
+#elif defined(OPENSM_CONFIG_DIR)
+#define OSM_DEFAULT_TORUS_CONF_FILE OPENSM_CONFIG_DIR "/torus-2QoS.conf"
+#else
+#define OSM_DEFAULT_TORUS_CONF_FILE "/etc/opensm/torus-2QoS.conf"
+#endif /* __WIN__ */
+/***********/
+
 /****d* OpenSM: Base/OSM_DEFAULT_PREFIX_ROUTES_FILE
 * NAME
 *	OSM_DEFAULT_PREFIX_ROUTES_FILE
diff --git a/opensm/include/opensm/osm_subnet.h b/opensm/include/opensm/osm_subnet.h
index d74a57c..d2d9661 100644
--- a/opensm/include/opensm/osm_subnet.h
+++ b/opensm/include/opensm/osm_subnet.h
@@ -201,6 +201,7 @@ typedef struct osm_subn_opt {
 	char *guid_routing_order_file;
 	char *sa_db_file;
 	boolean_t sa_db_dump;
+	char *torus_conf_file;
 	boolean_t do_mesh_analysis;
 	boolean_t exit_on_fatal;
 	boolean_t honor_guid2lid_file;
@@ -418,6 +419,10 @@ typedef struct osm_subn_opt {
 *		When TRUE causes OpenSM to dump SA DB at the end of every
 *		light sweep regardless the current verbosity level.
 *
+*	torus_conf_file
+*		Name of the file with extra configuration info for torus-2QoS
+*		routing engine.
+*
 *	exit_on_fatal
 *		If TRUE (default) - SM will exit on fatal subnet initialization
 *		issues.
diff --git a/opensm/opensm/main.c b/opensm/opensm/main.c
index f396de4..578ae9f 100644
--- a/opensm/opensm/main.c
+++ b/opensm/opensm/main.c
@@ -231,6 +231,10 @@ static void show_usage(void)
 	       "          Set the order port guids will be routed for the MinHop\n"
 	       "          and Up/Down routing algorithms to the guids provided in the\n"
 	       "          given file (one to a line)\n\n");
+	printf("--torus_config <path to file>\n"
+	       "          This option defines the file name for the extra configuration\n"
+	       "          info needed for the torus-2QoS routing engine.   The default\n"
+	       "          name is \'"OSM_DEFAULT_TORUS_CONF_FILE"\'\n\n");
 	printf("--once, -o\n"
 	       "          This option causes OpenSM to configure the subnet\n"
 	       "          once, then exit.  Ports remain in the ACTIVE state.\n\n");
@@ -610,6 +614,7 @@ int main(int argc, char *argv[])
 		{"sm_sl", 1, NULL, 7},
 		{"retries", 1, NULL, 8},
 		{"log_prefix", 1, NULL, 9},
+		{"torus_config", 1, NULL, 10},
 		{NULL, 0, NULL, 0}	/* Required at the end of the array */
 	};
 
@@ -992,6 +997,10 @@ int main(int argc, char *argv[])
 			SET_STR_OPT(opt.log_prefix, optarg);
 			printf("Log prefix = %s\n", opt.log_prefix);
 			break;
+		case 10:
+			SET_STR_OPT(opt.torus_conf_file, optarg);
+			printf("Torus-2QoS config file = %s\n", opt.torus_conf_file);
+			break;
 		case 'h':
 		case '?':
 		case ':':
diff --git a/opensm/opensm/osm_subnet.c b/opensm/opensm/osm_subnet.c
index 55b9384..47aa529 100644
--- a/opensm/opensm/osm_subnet.c
+++ b/opensm/opensm/osm_subnet.c
@@ -758,6 +758,7 @@ void osm_subn_set_default_opt(IN osm_subn_opt_t * p_opt)
 	p_opt->guid_routing_order_file = NULL;
 	p_opt->sa_db_file = NULL;
 	p_opt->sa_db_dump = FALSE;
+	p_opt->torus_conf_file = strdup(OSM_DEFAULT_TORUS_CONF_FILE);
 	p_opt->do_mesh_analysis = FALSE;
 	p_opt->exit_on_fatal = TRUE;
 	p_opt->enable_quirks = FALSE;
diff --git a/opensm/opensm/osm_torus.c b/opensm/opensm/osm_torus.c
index 7f80034..7c3b550 100644
--- a/opensm/opensm/osm_torus.c
+++ b/opensm/opensm/osm_torus.c
@@ -9043,7 +9043,7 @@ int torus_build_lfts(void *context)
 	torus->osm = ctx->osm;
 	fabric->osm = ctx->osm;
 
-	if (!parse_config(OPENSM_CONFIG_DIR "/opensm-torus.conf",
+	if (!parse_config(ctx->osm->subn.opt.torus_conf_file,
 			  fabric, torus))
 		goto out;
 
-- 
1.6.6.1


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
