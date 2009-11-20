From: "Jim Schutt" <jaschut-4OHPYypu0djtX7QSmKvirg@public.gmane.org>
Subject: [PATCH 07/11] opensm: Add opensm option to specify file name
 for extra torus-2QoS configuration information.
Date: Fri, 20 Nov 2009 12:15:05 -0700
Message-ID: <1258744509-11148-7-git-send-email-jaschut@sandia.gov>
References: <1258744509-11148-1-git-send-email-jaschut@sandia.gov>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1258744509-11148-1-git-send-email-jaschut-4OHPYypu0djtX7QSmKvirg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org, eitan-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org, jaschut-4OHPYypu0djtX7QSmKvirg@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


Signed-off-by: Jim Schutt <jaschut-4OHPYypu0djtX7QSmKvirg@public.gmane.org>
---
 opensm/include/opensm/osm_base.h   |   18 ++++++++++++++++++
 opensm/include/opensm/osm_subnet.h |    5 +++++
 opensm/opensm/main.c               |    8 ++++++++
 opensm/opensm/osm_subnet.c         |    1 +
 opensm/opensm/osm_ucast_torus.c    |    2 +-
 5 files changed, 33 insertions(+), 1 deletions(-)

diff --git a/opensm/include/opensm/osm_base.h b/opensm/include/opensm/osm_base.h
index 9d8bf98..0a90ba8 100644
--- a/opensm/include/opensm/osm_base.h
+++ b/opensm/include/opensm/osm_base.h
@@ -278,6 +278,24 @@ BEGIN_C_DECLS
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
index c303e86..6350dfb 100644
--- a/opensm/include/opensm/osm_subnet.h
+++ b/opensm/include/opensm/osm_subnet.h
@@ -200,6 +200,7 @@ typedef struct osm_subn_opt {
 	char *ids_guid_file;
 	char *guid_routing_order_file;
 	char *sa_db_file;
+	char *torus_conf_file;
 	boolean_t do_mesh_analysis;
 	boolean_t exit_on_fatal;
 	boolean_t honor_guid2lid_file;
@@ -411,6 +412,10 @@ typedef struct osm_subn_opt {
 *	sa_db_file
 *		Name of the SA database file.
 *
+*	torus_conf_file
+*		Name of the file with extra configuration info for torus-2QoS
+*		routing engine.
+*
 *	exit_on_fatal
 *		If TRUE (default) - SM will exit on fatal subnet initialization
 *		issues.
diff --git a/opensm/opensm/main.c b/opensm/opensm/main.c
index 18efde1..488327c 100644
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
@@ -607,6 +611,7 @@ int main(int argc, char *argv[])
 		{"lash_start_vl", 1, NULL, 6},
 		{"sm_sl", 1, NULL, 7},
 		{"retries", 1, NULL, 8},
+		{"torus_config", 1, NULL, 9},
 		{NULL, 0, NULL, 0}	/* Required at the end of the array */
 	};
 
@@ -985,6 +990,9 @@ int main(int argc, char *argv[])
 			printf(" Transaction retries = %u\n",
 			       opt.transaction_retries);
 			break;
+		case 9:
+			SET_STR_OPT(opt.torus_conf_file, optarg);
+			break;
 		case 'h':
 		case '?':
 		case ':':
diff --git a/opensm/opensm/osm_subnet.c b/opensm/opensm/osm_subnet.c
index 19ba730..c9bb20c 100644
--- a/opensm/opensm/osm_subnet.c
+++ b/opensm/opensm/osm_subnet.c
@@ -747,6 +747,7 @@ void osm_subn_set_default_opt(IN osm_subn_opt_t * p_opt)
 	p_opt->ids_guid_file = NULL;
 	p_opt->guid_routing_order_file = NULL;
 	p_opt->sa_db_file = NULL;
+	p_opt->torus_conf_file = strdup(OSM_DEFAULT_TORUS_CONF_FILE);
 	p_opt->do_mesh_analysis = FALSE;
 	p_opt->exit_on_fatal = TRUE;
 	p_opt->enable_quirks = FALSE;
diff --git a/opensm/opensm/osm_ucast_torus.c b/opensm/opensm/osm_ucast_torus.c
index 149189f..6fff73e 100644
--- a/opensm/opensm/osm_ucast_torus.c
+++ b/opensm/opensm/osm_ucast_torus.c
@@ -8573,7 +8573,7 @@ int torus_build_lfts(void *context)
 	torus->osm = ctx->osm;
 	fabric->osm = ctx->osm;
 
-	if (!parse_config(OPENSM_CONFIG_DIR "/opensm-torus.conf",
+	if (!parse_config(ctx->osm->subn.opt.torus_conf_file,
 			  fabric, torus))
 		goto out;
 
-- 
1.5.6.GIT


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
