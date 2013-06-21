From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH 14/15 ibacm] Add support for preloading IPv4 and IPv6 ACM
 caches
Date: Fri, 21 Jun 2013 07:02:48 -0400
Message-ID: <51C432D8.8030608@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


A hosts file (ibacm_hosts.cfg) is configured with tuples of
IP addresses (either IPv4 or IPv6) and IB GID. This information
in conjunction with the path record preloading allows
for the IPv4 and IPv6 ACM caches to be preloaded.

IPv4 was tested with both rping and ucmatose as well as
acme. IPv6 was tested with ucmatose and acme.

The remaining ACM cache to be preloaded is the name cache.
This will be added in subsequent patch.

Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 Makefile.am     |    2 +-
 acm_notes.txt   |    3 ++
 ibacm_hosts.cfg |   12 ++++++++
 linux/osd.h     |    1 +
 man/ibacm.1     |   11 ++++++-
 src/acm.c       |   84 ++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 6 files changed, 109 insertions(+), 4 deletions(-)
 create mode 100644 ibacm_hosts.cfg

diff --git a/Makefile.am b/Makefile.am
index de035bc..c97326a 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -20,7 +20,7 @@ man_MANS = \
 
 EXTRA_DIST = src/acm_mad.h src/libacm.h ibacm.init.in \
 	     linux/osd.h linux/dlist.h ibacm.spec.in $(man_MANS) ibacm_opts.cfg \
-	     ibacm_addr.cfg
+	     ibacm_addr.cfg ibacm_hosts.cfg
 
 install-exec-hook:
 	install -D -m 755 ibacm.init $(DESTDIR)$(sysconfdir)/init.d/ibacm;
diff --git a/acm_notes.txt b/acm_notes.txt
index 5c20129..a3f3a91 100644
--- a/acm_notes.txt
+++ b/acm_notes.txt
@@ -139,3 +139,6 @@ this  file  format and how to configure OpenSM to output this file.  By
 default, if the -p option  is  specified,  the  default  file  used  to
 preload these caches is ACM_CONF_DIR/ibacm_path_record.dump
 
+Additional IPv4 and IPv6 caches can be be preloaded by using the -H
+option. By default, the default hosts file used to preload these
+caches is ACM_CONF_DIR/ibacm_hosts.cfg
diff --git a/ibacm_hosts.cfg b/ibacm_hosts.cfg
new file mode 100644
index 0000000..32b6594
--- /dev/null
+++ b/ibacm_hosts.cfg
@@ -0,0 +1,12 @@
+# InfiniBand Communication Management Assistant for clusters hosts file
+#
+# Entry format is:
+# address IB GID
+#
+# address - IPv4 or IPv6 formatted address
+#
+# There can be multiple entries for a single IB GID
+#
+# Samples:
+# 192.168.1.3 fe80::8:f104:39a:169 
+# fe80::208:f104:39a:169 fe80::8:f104:39a:169
diff --git a/linux/osd.h b/linux/osd.h
index 0b6884f..6ea01cb 100644
--- a/linux/osd.h
+++ b/linux/osd.h
@@ -59,6 +59,7 @@
 #define ACM_ADDR_FILE "ibacm_addr.cfg"
 #define ACM_OPTS_FILE "ibacm_opts.cfg"
 #define ACM_PATH_REC_FILE "ibacm_path_records.dump"
+#define ACM_HOSTS_FILE "ibacm_hosts.cfg"
 
 #define LIB_DESTRUCTOR __attribute__((destructor))
 #define CDECL_FUNC
diff --git a/man/ibacm.1 b/man/ibacm.1
index 382b4c0..0693a8f 100644
--- a/man/ibacm.1
+++ b/man/ibacm.1
@@ -1,10 +1,10 @@
-.TH "ibacm" 1 "2013-06-18" "ibacm" "ibacm" ibacm
+.TH "ibacm" 1 "2013-06-20" "ibacm" "ibacm" ibacm
 .SH NAME
 ibacm \- address and route resolution services for InfiniBand.
 .SH SYNOPSIS
 .sp
 .nf
-\fIibacm\fR [-D] [-P] [-A addr_file] [-O option_file] [-p [path_rec_file]]
+\fIibacm\fR [-D] [-P] [-A addr_file] [-O option_file] [-p [path_rec_file]] [-H [hosts_file]]
 .fi
 .SH "DESCRIPTION"
 The IB ACM implements and provides a framework for name,
@@ -49,6 +49,9 @@ option configuration file
 .TP
 \-p [path_rec_file]
 optional path records file for preloading ACM cache
+.TP
+\-H [hosts_file]
+optional hosts file for preloading ACM cache
 .SH "QUICK START GUIDE"
 1. Prerequisites: libibverbs and libibumad must be installed.
 The IB stack should be running with IPoIB configured.
@@ -159,5 +162,9 @@ format which is the default.  See dump_pr.notes.txt in dump_pr for
 more information on both this file format and how to configure OpenSM
 to output this file.  By default, if the -p option is specified, the default
 file used to preload these caches is ACM_CONF_DIR/ibacm_path_record.dump
+.P
+Additional IPv4 and IPv6 caches can be be preloaded by using the -H
+option. By default, the default hosts file used to preload these
+caches is ACM_CONF_DIR/ibacm_hosts.cfg
 .SH "SEE ALSO"
 ibacm(7), ib_acme(1), rdma_cm(7)
diff --git a/src/acm.c b/src/acm.c
index 55d9e2d..ea5c884 100644
--- a/src/acm.c
+++ b/src/acm.c
@@ -218,6 +218,7 @@ static char *acme = BINDIR "/ib_acme -A";
 static char *opts_file = ACM_CONF_DIR "/" ACM_OPTS_FILE;
 static char *addr_file = ACM_CONF_DIR "/" ACM_ADDR_FILE;
 static char *path_rec_file = ACM_CONF_DIR "/" ACM_PATH_REC_FILE;
+static char *hosts_file = ACM_CONF_DIR "/" ACM_HOSTS_FILE;
 static char log_file[128] = "/var/log/ibacm.log";
 static int log_level = 0;
 static char lock_file[128] = "/var/run/ibacm.pid";
@@ -234,6 +235,7 @@ static int sa_depth = 1;
 static int send_depth = 1;
 static int recv_depth = 1024;
 static int path_rec_opt = 0;
+static int hosts_opt = 0;
 static uint8_t min_mtu = IBV_MTU_2048;
 static uint8_t min_rate = IBV_RATE_10_GBPS;
 static enum acm_path_rec_fmt path_rec_fmt = ACM_PATH_REV_FMT_OSM_FULL_V1;
@@ -2785,6 +2787,73 @@ err:
 	return ret;
 }
 
+static void acm_parse_hosts_file(struct acm_ep *ep)
+{
+	FILE *f;
+	char s[120];
+	char addr[INET6_ADDRSTRLEN], gid[INET6_ADDRSTRLEN];
+	uint8_t name[ACM_MAX_ADDRESS];
+        struct in6_addr ip_addr, ib_addr;
+	struct acm_dest *dest, *new_dest;
+	uint8_t addr_type;
+
+	if (!(f = fopen(hosts_file, "r"))) {
+		acm_log(0, "ERROR - couldn't open %s\n", hosts_file);
+		return;
+        }
+
+	while (fgets(s, sizeof s, f)) {
+		if (s[0] == '#')
+			continue;
+
+		if (sscanf(s, "%46s%46s", addr, gid) != 2)
+			continue;
+
+		acm_log(2, "%s", s);
+		if (inet_pton(AF_INET6, gid, &ib_addr) <= 0) {
+			acm_log(0, "ERROR - %s is not IB GID\n", gid);
+			continue;
+		}
+		if (inet_pton(AF_INET, addr, &ip_addr) > 0)
+			addr_type = ACM_ADDRESS_IP;
+		else if (inet_pton(AF_INET6, addr, &ip_addr) > 0)
+			addr_type = ACM_ADDRESS_IP6;
+		else {
+			acm_log(0, "ERROR - %s is not IP address\n", addr);
+			continue;
+		}
+
+		memset(name, 0, ACM_MAX_ADDRESS);
+		memcpy(name, &ib_addr, sizeof(ib_addr));
+		dest = acm_get_dest(ep, ACM_ADDRESS_GID, name);
+		if (!dest) {
+			acm_log(0, "ERROR - IB GID %s not found in cache\n", gid);
+			continue;
+		}
+
+		memset(name, 0, ACM_MAX_ADDRESS);
+		if (addr_type == ACM_ADDRESS_IP)
+			memcpy(name, &ip_addr, 4);
+		else
+			memcpy(name, &ip_addr, sizeof(ip_addr));
+		new_dest = acm_acquire_dest(ep, addr_type, name);
+		if (!new_dest) {
+			acm_log(0, "ERROR - unable to create dest %s\n", addr);
+			continue;
+		}
+		new_dest->path = dest->path;
+		new_dest->remote_qpn = dest->remote_qpn;
+		new_dest->addr_timeout = dest->addr_timeout;
+		new_dest->route_timeout = dest->route_timeout;
+		new_dest->state = dest->state;
+		acm_put_dest(new_dest);
+		acm_log(1, "added host %s address type %d IB GID %s\n",
+			addr, addr_type, gid);
+	}
+
+	fclose(f);
+}
+
 static int acm_assign_ep_names(struct acm_ep *ep)
 {
 	FILE *faddr;
@@ -3041,6 +3110,12 @@ static void acm_ep_up(struct acm_port *port, uint16_t pkey_index)
 			acm_log(1, "unable to find ep in path records\n");
 	}
 
+	if (hosts_opt) {
+		if (!path_rec_opt)
+			acm_log(0, "when using hosts file option should also use path records option\n");
+		acm_parse_hosts_file(ep);
+	}
+
 	return;
 
 err2:
@@ -3447,6 +3522,8 @@ static void show_usage(char *program)
 	printf("                          (default %s/%s)\n", ACM_CONF_DIR, ACM_OPTS_FILE);
 	printf("   [-p [path_rec_file]] - optional path records file\n");
 	printf("                          (default %s/%s)\n", ACM_CONF_DIR, ACM_PATH_REC_FILE); 
+	printf("   [-H [hosts_file]]    - optional hosts file\n");
+	printf("                          (default %s/%s)\n", ACM_CONF_DIR, ACM_HOSTS_FILE);
 }
 
 static char *opt_arg(int argc, char **argv)
@@ -3464,7 +3541,7 @@ int CDECL_FUNC main(int argc, char **argv)
 {
 	int i, op, daemon = 1;
 
-	while ((op = getopt(argc, argv, "DPA:O:p::")) != -1) {
+	while ((op = getopt(argc, argv, "DPA:O:p::H::")) != -1) {
 		switch (op) {
 		case 'D':
 			/* option no longer required */
@@ -3483,6 +3560,11 @@ int CDECL_FUNC main(int argc, char **argv)
 			if (opt_arg(argc, argv))
 				path_rec_file = opt_arg(argc, argv);
 			break;
+		case 'H':
+			hosts_opt = 1;
+			if (opt_arg(argc, argv))
+				hosts_file = opt_arg(argc, argv);
+			break;
 		default:
 			show_usage(argv[0]);
 			exit(1);
-- 
1.7.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
