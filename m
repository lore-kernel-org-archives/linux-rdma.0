From: Doron Shohamd <dorons-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: add support of reload net topology file
Date: Wed, 17 Feb 2010 16:51:02 +0200
Message-ID: <4B7C0256.7080505@voltaire.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

add new command 'reload' in order to reload net topology file

Signed-off-by: Doron Shoham <dorons-smomgflXvOZWk0Htik3J/w@public.gmane.org>
---
 ibsim/ibsim.c   |   21 ++++++++++++++++++---
 ibsim/sim_cmd.c |    6 ++++++
 2 files changed, 24 insertions(+), 3 deletions(-)

diff --git a/ibsim/ibsim.c b/ibsim/ibsim.c
index e720f0d..98be195 100644
--- a/ibsim/ibsim.c
+++ b/ibsim/ibsim.c
@@ -73,6 +73,8 @@ extern int ignoreduplicate;
 int ibdebug;
 int parsedebug;
 int simverb;
+FILE *infile, *outfile;
+char *netfile;
 
 static Client clients[IBSIM_MAX_CLIENTS];
 static int simctl = -1;
@@ -82,6 +84,13 @@ static int listen_to_port = IBSIM_DEFAULT_SERVER_PORT;
 static int remote_mode = 0;
 static char* socket_basename;
 
+extern int 	netnodes, netswitches, netports, netaliases;
+extern Node *nodes;
+extern Switch *switches;
+extern Port *ports;
+extern Port **lids;
+extern char (*aliases)[NODEIDLEN + NODEPREFIX + 1];	// aliases map format: "%s@%s"
+
 static size_t make_name(union name_t *name, uint32_t addr, unsigned short port,
 			const char *fmt, ...)
 {
@@ -553,8 +562,15 @@ int sim_cmd_file(FILE * f, char *s)
 	return 0;
 }
 
-static int sim_init_net(char *netconf, FILE * out)
+int sim_init_net(char *netconf, FILE * out)
 {
+	netnodes = netswitches = netports = netaliases = 0;
+	memset(nodes, 0, maxnetnodes*sizeof(*nodes));
+	memset(switches, 0, maxnetswitches*sizeof(*switches));
+	memset(ports, 0, maxnetports*sizeof(*ports));
+	memset(lids, 0, maxlinearcap*sizeof(*lids));
+	memset(aliases, 0, maxnetaliases*sizeof(*aliases));
+
 	DEBUG("reading %s", netconf);
 	if (read_netconf(netconf, out) < 0)
 		return -1;
@@ -716,8 +732,7 @@ int main(int argc, char **argv)
 {
 	extern int alloc_core(void);
 	extern void free_core(void);
-	char *outfname = 0, *netfile;
-	FILE *infile, *outfile;
+	char *outfname = 0;
 	int status;
 
 	static char const str_opts[] = "rf:dpvIsN:S:P:L:M:l:Vhu";
diff --git a/ibsim/sim_cmd.c b/ibsim/sim_cmd.c
index 6d3a893..51a407c 100644
--- a/ibsim/sim_cmd.c
+++ b/ibsim/sim_cmd.c
@@ -49,12 +49,15 @@
 #define DEBUG	if (simverb > 1 || ibdebug) IBWARN
 
 extern void free_core(void);
+extern int sim_init_net(char *, FILE *);
 
 extern Node *nodes;
 extern Switch *switches;
 extern Port *ports;
 extern Port **lids;
 extern int netnodes, netports, netswitches;
+extern char *netfile;
+extern FILE *outfile;
 
 #define NAMELEN	NODEIDLEN
 
@@ -822,6 +825,7 @@ static int dump_help(FILE * f)
 		);
 	fprintf(f,
 		"\tBaselid \"nodeid\"[port] <lid> [lmc] : change port's lid (lmc)\n");
+	fprintf(f, "\tReload : reload net topology file\n");
 	fprintf(f, "\tVerbose [newlevel] - show/set simulator verbosity\n");
 	fprintf(f, "\t\t\t0 - silent\n");
 	fprintf(f, "\t\t\t1 - debug verbose\n");
@@ -907,6 +911,8 @@ int do_cmd(char *buf, FILE *f)
 	 */
 	else if (!strncasecmp(line, "ReLink", cmd_len))
 		r = do_relink(f, line);
+	else if (!strncasecmp(line, "Reload", cmd_len))
+		r = sim_init_net(netfile, outfile);
 	else if (*line != '\n' && *line != '\0')
 		fprintf(f, "command \'%s\' unknown - skipped\n", line);
 
-- 
1.5.5

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
