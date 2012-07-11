From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: [PATCH V2 08/10] opensm/console: add abreviations for perfmgr
 commands
Date: Wed, 11 Jul 2012 11:48:16 -0700
Message-ID: <20120711114816.dd375d8ec8c399bf38ec281b@llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Add:
   "pm" for "perfmgr"
   "pc" for "print_counters"

Changes since V1:
	My rebase got cross wired for the console help message.  Fix this.

Signed-off-by: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
---
 opensm/osm_console.c |   16 ++++++++++++++--
 1 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/opensm/osm_console.c b/opensm/osm_console.c
index b6d7d31..fd247c9 100644
--- a/opensm/osm_console.c
+++ b/opensm/osm_console.c
@@ -239,7 +239,10 @@ static void help_update_desc(FILE *out, int detail)
 static void help_perfmgr(FILE * out, int detail)
 {
 	fprintf(out,
-		"perfmgr [enable|disable|clear_counters|dump_counters|print_counters|dump_redir|clear_redir|set_rm_nodes|clear_rm_nodes|clear_inactive|sweep_time[seconds]]\n");
+		"perfmgr(pm) [enable|disable\n"
+		"             |clear_counters|dump_counters|print_counters(pc)\n"
+		"             |set_rm_nodes|clear_rm_nodes|clear_inactive\n"
+		"             |dump_redir|clear_redir|sweep_time[seconds]]\n");
 	if (detail) {
 		fprintf(out,
 			"perfmgr -- print the performance manager state\n");
@@ -255,6 +258,8 @@ static void help_perfmgr(FILE * out, int detail)
 			"   [print_counters [<nodename|nodeguid>][:<port>]] -- print the internal counters\n"
 			"                                                      Optionaly limit output by name, guid, or port\n");
 		fprintf(out,
+			"   [pc [<nodename|nodeguid>][:<port>]] -- same as print_counters\n");
+		fprintf(out,
 			"   [dump_redir [<nodename|nodeguid>]] -- dump the redirection table\n");
 		fprintf(out,
 			"   [clear_redir [<nodename|nodeguid>]] -- clear the redirection table\n");
@@ -265,6 +270,11 @@ static void help_perfmgr(FILE * out, int detail)
 			"   [clear_inactive] -- Delete inactive nodes from the DB\n");
 	}
 }
+static void help_pm(FILE *out, int detail)
+{
+	if (detail)
+		help_perfmgr(out, detail);
+}
 #endif				/* ENABLE_OSM_PERF_MGR */
 
 /* more help routines go here */
@@ -1465,7 +1475,8 @@ static void perfmgr_parse(char **p_last, osm_opensm_t * p_osm, FILE * out)
 		} else if (strcmp(p_cmd, "clear_inactive") == 0) {
 			unsigned cnt = osm_perfmgr_delete_inactive(&p_osm->perfmgr);
 			fprintf(out, "Removed %u nodes from Database\n", cnt);
-		} else if (strcmp(p_cmd, "print_counters") == 0) {
+		} else if (strcmp(p_cmd, "print_counters") == 0 ||
+			   strcmp(p_cmd, "pc") == 0) {
 			char *port = NULL;
 			p_cmd = name_token(p_last);
 			if (p_cmd) {
@@ -1663,6 +1674,7 @@ static const struct command console_cmds[] = {
 	{"version", &help_version, &version_parse},
 #ifdef ENABLE_OSM_PERF_MGR
 	{"perfmgr", &help_perfmgr, &perfmgr_parse},
+	{"pm", &help_pm, &perfmgr_parse},
 #endif				/* ENABLE_OSM_PERF_MGR */
 	{"dump_portguid", &help_dump_portguid, &dump_portguid_parse},
 	{NULL, NULL, NULL}	/* end of array */
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
