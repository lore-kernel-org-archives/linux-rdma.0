From: Yevgeny Kliteynik <kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH 1/3 v3] opensm: connect switches in tree - added new option
Date: Wed, 04 Nov 2009 13:08:57 +0200
Message-ID: <4AF160C9.1030908@dev.mellanox.co.il>
Reply-To: kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: Linux RDMA <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Adding new option: '--connect_switches'
This option should connect more switches with a
down/up routes in up/down and fat-tree routing.

[v3 - no changes since v2, just rebased and resolved conflicts]

Signed-off-by: Yevgeny Kliteynik <kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
---
 opensm/include/opensm/osm_subnet.h |   10 ++++++++--
 opensm/man/opensm.8.in             |   11 +++++++++--
 opensm/opensm/main.c               |   15 +++++++++++++--
 opensm/opensm/osm_subnet.c         |    7 +++++++
 4 files changed, 37 insertions(+), 6 deletions(-)

diff --git a/opensm/include/opensm/osm_subnet.h b/opensm/include/opensm/osm_subnet.h
index 0302f91..ecb0a62 100644
--- a/opensm/include/opensm/osm_subnet.h
+++ b/opensm/include/opensm/osm_subnet.h
@@ -191,6 +191,7 @@ typedef struct osm_subn_opt {
 	char *routing_engine_names;
 	boolean_t use_ucast_cache;
 	boolean_t connect_roots;
+	boolean_t connect_switches;
 	char *lid_matrix_dump_file;
 	char *lfts_file;
 	char *root_guid_file;
@@ -374,8 +375,13 @@ typedef struct osm_subn_opt {
 *
 *	connect_roots
 *		The option which will enforce root to root connectivity with
-*		up/down routing engine (even if this violates "pure" deadlock
-*		free up/down algorithm)
+*		up/down and fat-tree routing engines (even if this violates
+*		"pure" deadlock free up/down or fat-tree algorithm)
+*
+*	connect_switches
+*		The option which will enforce switch to switch connectivity
+*		with up/down and fat-tree routing engines (even if this
+*		violates "pure" deadlock free up/down or fat-tree algorithm)
 *
 *	use_ucast_cache
 *		When TRUE enables unicast routing cache.
diff --git a/opensm/man/opensm.8.in b/opensm/man/opensm.8.in
index bd8ab4e..1dc76de 100644
--- a/opensm/man/opensm.8.in
+++ b/opensm/man/opensm.8.in
@@ -19,6 +19,7 @@ opensm \- InfiniBand subnet manager and administration (SM/SA)
 [\-\-lash_start_vl <vl number>]
 [\-A | \-\-ucast_cache]
 [\-z | \-\-connect_roots]
+[\-\-connect_switches]
 [\-M <file name> | \-\-lid_matrix_file <file name>]
 [\-U <file name> | \-\-lfts_file <file name>]
 [\-S | \-\-sadb_file <file name>]
@@ -171,8 +172,14 @@ recalculations: one when the host goes down, and the other when
 the host comes back online.
 .TP
 \fB\-z\fR, \fB\-\-connect_roots\fR
-This option enforces a routing engine (currently up/down
-only) to make connectivity between root switches and in
+This option enforces routing engines (up/down and
+fat-tree) to make connectivity between root switches and in
+this way to be fully IBA complaint. In many cases this can
+violate "pure" deadlock free algorithm, so use it carefully.
+.TP
+\fB\-\-connect_switches\fR
+This option enforces routing engines (up/down and
+fat-tree) to make connectivity between all switches and in
 this way to be fully IBA complaint. In many cases this can
 violate "pure" deadlock free algorithm, so use it carefully.
 .TP
diff --git a/opensm/opensm/main.c b/opensm/opensm/main.c
index 5c8cd9b..34809a1 100644
--- a/opensm/opensm/main.c
+++ b/opensm/opensm/main.c
@@ -186,8 +186,14 @@ static void show_usage(void)
 	printf("--sm_sl <sl number>\n"
 	       "          Sets the SL to use to communicate with the SM/SA. Defaults to 0.\n\n");
 	printf("--connect_roots, -z\n"
-	       "          This option enforces a routing engine (currently\n"
-	       "          up/down only) to make connectivity between root switches\n"
+	       "          This option enforces routing engines (up/down and \n"
+	       "          fat-tree) to make connectivity between root switches\n"
+	       "          and in this way be IBA compliant. In many cases,\n"
+	       "          this can violate \"pure\" deadlock free algorithm, so\n"
+	       "          use it carefully.\n\n");
+	printf("--connect_switches\n"
+	       "          This option enforces routing engines (up/down and \n"
+	       "          fat-tree) to make connectivity between all the switches\n"
 	       "          and in this way be IBA compliant. In many cases,\n"
 	       "          this can violate \"pure\" deadlock free algorithm, so\n"
 	       "          use it carefully.\n\n");
@@ -604,6 +610,7 @@ int main(int argc, char *argv[])
 		{"lash_start_vl", 1, NULL, 6},
 		{"sm_sl", 1, NULL, 7},
 		{"retries", 1, NULL, 8},
+		{"connect_switches", 0, NULL, 9},
 		{NULL, 0, NULL, 0}	/* Required at the end of the array */
 	};

@@ -982,6 +989,10 @@ int main(int argc, char *argv[])
 			printf(" Transaction retries = %u\n",
 			       opt.transaction_retries);
 			break;
+		case 9:
+			opt.connect_switches = TRUE;
+			printf(" Connect switches option is on\n");
+			break;
 		case 'h':
 		case '?':
 		case ':':
diff --git a/opensm/opensm/osm_subnet.c b/opensm/opensm/osm_subnet.c
index cac5e94..798d4ad 100644
--- a/opensm/opensm/osm_subnet.c
+++ b/opensm/opensm/osm_subnet.c
@@ -328,6 +328,7 @@ static const opt_rec_t opt_tbl[] = {
 	{ "sweep_on_trap", OPT_OFFSET(sweep_on_trap), opts_parse_boolean, NULL, 1 },
 	{ "routing_engine", OPT_OFFSET(routing_engine_names), opts_parse_charp, NULL, 0 },
 	{ "connect_roots", OPT_OFFSET(connect_roots), opts_parse_boolean, NULL, 1 },
+	{ "connect_switches", OPT_OFFSET(connect_switches), opts_parse_boolean, NULL, 1 },
 	{ "use_ucast_cache", OPT_OFFSET(use_ucast_cache), opts_parse_boolean, NULL, 1 },
 	{ "log_file", OPT_OFFSET(log_file), opts_parse_charp, NULL, 0 },
 	{ "log_max_size", OPT_OFFSET(log_max_size), opts_parse_uint32, opts_setup_log_max_size, 1 },
@@ -737,6 +738,7 @@ void osm_subn_set_default_opt(IN osm_subn_opt_t * p_opt)
 	p_opt->use_ucast_cache = FALSE;
 	p_opt->routing_engine_names = NULL;
 	p_opt->connect_roots = FALSE;
+	p_opt->connect_switches = FALSE;
 	p_opt->lid_matrix_dump_file = NULL;
 	p_opt->lfts_file = NULL;
 	p_opt->root_guid_file = NULL;
@@ -1387,6 +1389,11 @@ int osm_subn_output_conf(FILE *out, IN osm_subn_opt_t * p_opts)
 		p_opts->connect_roots ? "TRUE" : "FALSE");

 	fprintf(out,
+		"# Connect switchess (use FALSE if unsure)\n"
+		"connect_switches %s\n\n",
+		p_opts->connect_switches ? "TRUE" : "FALSE");
+
+	fprintf(out,
 		"# Use unicast routing cache (use FALSE if unsure)\n"
 		"use_ucast_cache %s\n\n",
 		p_opts->use_ucast_cache ? "TRUE" : "FALSE");
-- 
1.5.1.4


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
