From: Al Chu <chu11-i2BcT+NCU+M@public.gmane.org>
Subject: [infiniband-diags] [4/4] support --filterdownports in iblinkinfo
Date: Mon, 26 Apr 2010 14:39:43 -0700
Message-ID: <1272317983.29737.50.camel@auk31.llnl.gov>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-ipYeLbUzEvajkj/AEqE5"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--=-ipYeLbUzEvajkj/AEqE5
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

Hi Sasha,

This patch supports a new option called --filterdownports.  The option
will remove downports from the output if they were previously listed as
down in a cache.

This option is useful for clusters that have unpopulated switch ports.
Many system administrators look for the word "Down" in the iblinkinfo
output, however, that ability is limited when so many of the ports are
down all the time b/c of unpopulated ports.  This option attempts to
remove that limitation for clusters with unpopulated ports.

Al

-- 
Albert Chu
chu11-i2BcT+NCU+M@public.gmane.org
Computer Scientist
High Performance Systems Division
Lawrence Livermore National Laboratory

--=-ipYeLbUzEvajkj/AEqE5
Content-Disposition: attachment; filename=0004-support-filterdownports-in-iblinkinfo.patch
Content-Type: message/rfc822; name=0004-support-filterdownports-in-iblinkinfo.patch

From: Albert Chu <chu11-i2BcT+NCU+M@public.gmane.org>
Date: Wed, 21 Apr 2010 17:04:02 -0700
Subject: [PATCH] support --filterdownports in iblinkinfo
Message-Id: <1272317488.29737.29.camel-X2zTWyBD0EhliZ7u+bvwcg@public.gmane.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit


Signed-off-by: Albert Chu <chu11-i2BcT+NCU+M@public.gmane.org>
---
 infiniband-diags/man/iblinkinfo.8 |    9 ++++++++
 infiniband-diags/src/iblinkinfo.c |   40 +++++++++++++++++++++++++++++++++++++
 2 files changed, 49 insertions(+), 0 deletions(-)

diff --git a/infiniband-diags/man/iblinkinfo.8 b/infiniband-diags/man/iblinkinfo.8
index 65ea919..940d008 100644
--- a/infiniband-diags/man/iblinkinfo.8
+++ b/infiniband-diags/man/iblinkinfo.8
@@ -66,6 +66,15 @@ Comma separate multiple diff check key(s).  The available diff checks
 are:\fIport\fR = port connections, \fIstate\fR = port state, \fIlid\fR = lids,
 \fInodedesc\fR = node descriptions.  If \fIport\fR is specified alongside \fIlid\fR
 or \fInodedesc\fR, remote port lids and node descriptions will also be compared.
+.TP
+\fB\-\-filterdownports\fR <filename>
+Filter downports indicated in a ibnetdiscover cache.  If a port was previously
+indicated as down in the specified cache, and is still down, do not output it in the
+resulting output.  This option may be particularly useful for environments
+where switches are not fully populated, thus much of the default iblinkinfo
+info is considered unuseful.  See
+.B ibnetdiscover
+for information on caching ibnetdiscover output.
 
 .SH AUTHOR
 .TP
diff --git a/infiniband-diags/src/iblinkinfo.c b/infiniband-diags/src/iblinkinfo.c
index 19adc20..4b8616e 100644
--- a/infiniband-diags/src/iblinkinfo.c
+++ b/infiniband-diags/src/iblinkinfo.c
@@ -65,6 +65,8 @@ static nn_map_t *node_name_map = NULL;
 static char *load_cache_file = NULL;
 static char *diff_cache_file = NULL;
 static unsigned diffcheck_flags = DIFF_FLAG_DEFAULT;
+static char *filterdownports_cache_file = NULL;
+static ibnd_fabric_t *filterdownports_fabric = NULL;
 
 static uint64_t guid = 0;
 static char *guid_str = NULL;
@@ -116,6 +118,30 @@ void get_msg(char *width_msg, char *speed_msg, int msg_size, ibnd_port_t * port)
 				      buf, 64, &max_speed));
 }
 
+int filterdownport_check(ibnd_node_t * node, ibnd_port_t * port)
+{
+	ibnd_node_t *fsw;
+	ibnd_port_t *fport;
+	int fistate;
+
+	fsw = ibnd_find_node_guid(filterdownports_fabric, node->guid);
+
+	if (!fsw)
+		return 0;
+
+	if (port->portnum > fsw->numports)
+		return 0;
+
+	fport = fsw->ports[port->portnum];
+
+	if (!fport)
+		return 0;
+
+	fistate = mad_get_field(fport->info, 0, IB_PORT_STATE_F);
+
+	return (fistate == IB_LINK_DOWN) ? 1 : 0;
+}
+
 void print_port(ibnd_node_t * node, ibnd_port_t * port, char *out_prefix)
 {
 	char width[64], speed[64], state[64], physstate[64];
@@ -142,6 +168,11 @@ void print_port(ibnd_node_t * node, ibnd_port_t * port, char *out_prefix)
 	width_msg[0] = '\0';
 	speed_msg[0] = '\0';
 
+	if (istate == IB_LINK_DOWN
+	    && filterdownports_fabric
+	    && filterdownport_check(node,port))
+		return;
+
 	/* C14-24.2.1 states that a down port allows for invalid data to be
 	 * returned for all PortInfo components except PortState and
 	 * PortPhysicalState */
@@ -467,6 +498,9 @@ static int process_opt(void *context, int ch, char *optarg)
 			p = strtok(NULL, ",");
 		}
 		break;
+	case 5:
+		filterdownports_cache_file = strdup(optarg);
+		break;
 	case 'S':
 		guid_str = optarg;
 		guid = (uint64_t) strtoull(guid_str, 0, 0);
@@ -539,6 +573,8 @@ int main(int argc, char **argv)
 		 "filename of ibnetdiscover cache to diff"},
 		{"diffcheck", 4, 1, "<key(s)>",
 		 "specify checks to execute for --diff"},
+		{"filterdownports", 5, 1, "<file>",
+		 "filename of ibnetdiscover cache to filter downports"},
 		{"outstanding_smps", 'o', 1, NULL,
 		 "specify the number of outstanding SMP's which should be "
 		 "issued during the scan"},
@@ -591,6 +627,10 @@ int main(int argc, char **argv)
 	    !(diff_fabric = ibnd_load_fabric(diff_cache_file, 0)))
 		IBERROR("loading cached fabric for diff failed\n");
 
+	if (filterdownports_cache_file &&
+	    !(filterdownports_fabric = ibnd_load_fabric(filterdownports_cache_file, 0)))
+		IBERROR("loading cached fabric for filterdownports failed\n");
+
 	if (load_cache_file) {
 		if ((fabric = ibnd_load_fabric(load_cache_file, 0)) == NULL) {
 			fprintf(stderr, "loading cached fabric failed\n");
-- 
1.5.4.5


--=-ipYeLbUzEvajkj/AEqE5--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
