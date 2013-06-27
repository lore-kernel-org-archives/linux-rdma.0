From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH v2 15/16 ibacm] Add support for preloading IPv4 and IPv6 ACM
 caches
Date: Thu, 27 Jun 2013 15:14:32 -0400
Message-ID: <51CC8F18.3000509@dev.mellanox.co.il>
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
Change from v1:
Eliminated command line option in favor of option file parameters

 Makefile.am     |    2 +-
 acm_notes.txt   |    3 ++
 ibacm_hosts.cfg |   12 ++++++++
 ibacm_opts.cfg  |    6 ++++
 man/ibacm.1     |    4 ++
 src/acm.c       |   83 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 src/acme.c      |    6 ++++
 7 files changed, 115 insertions(+), 1 deletions(-)
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
index 50f0286..991b251 100644
--- a/acm_notes.txt
+++ b/acm_notes.txt
@@ -138,3 +138,6 @@ none which does not preload these caches.  See dump_pr.notes.txt in dump_pr
 for more information on the full_opensm_v1 file format and how to configure
 OpenSM to generate this file.
 
+Additional IPv4 and IPv6 caches can be be preloaded by using the
+hosts_file option.  The default is "none" which does not preload these
+caches.
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
diff --git a/ibacm_opts.cfg b/ibacm_opts.cfg
index 968a99d..0e21d37 100644
--- a/ibacm_opts.cfg
+++ b/ibacm_opts.cfg
@@ -155,3 +155,9 @@ path_rec_fmt none
 # If path_rec_fmt is other than "none", full pathname of path records file
 # to use for preloading the ACM cache.  Default is ACM_CONF_DIR/ibacm_path_records.dump
 
+# hosts_file:
+# none - No hosts file
+# If hosts_file is other than "none", full pathname of hosts file
+
+hosts_file none
+
diff --git a/man/ibacm.1 b/man/ibacm.1
index 7c5f83d..7e11393 100644
--- a/man/ibacm.1
+++ b/man/ibacm.1
@@ -156,5 +156,9 @@ format.  Default format is none which does not preload these caches.
 See dump_pr.notes.txt in dump_pr for more information on the
 full_opensm_v1 file format and how to configure OpenSM to
 generate this file.
+.P
+Additional IPv4 and IPv6 caches can be be preloaded by using the
+hosts_file option.  The default is "none" which does not preload these
+caches.
 .SH "SEE ALSO"
 ibacm(7), ib_acme(1), rdma_cm(7)
diff --git a/src/acm.c b/src/acm.c
index 74c99e3..faa851a 100644
--- a/src/acm.c
+++ b/src/acm.c
@@ -219,6 +219,7 @@ static char *acme = BINDIR "/ib_acme -A";
 static char *opts_file = ACM_CONF_DIR "/" ACM_OPTS_FILE;
 static char *addr_file = ACM_CONF_DIR "/" ACM_ADDR_FILE;
 static char path_rec_file[128] = ACM_CONF_DIR "/" ACM_PATH_REC_FILE;
+static char hosts_file[128] = "none";
 static char log_file[128] = "/var/log/ibacm.log";
 static int log_level = 0;
 static char lock_file[128] = "/var/run/ibacm.pid";
@@ -234,6 +235,7 @@ static int resolve_depth = 1;
 static int sa_depth = 1;
 static int send_depth = 1;
 static int recv_depth = 1024;
+static int hosts_opt = 0;
 static uint8_t min_mtu = IBV_MTU_2048;
 static uint8_t min_rate = IBV_RATE_10_GBPS;
 static enum acm_path_rec_fmt path_rec_fmt = ACM_PATH_REV_FMT_NONE;
@@ -2790,6 +2792,73 @@ err:
 	return ret;
 }
 
+static void acm_parse_hosts_file(struct acm_ep *ep)
+{
+	FILE *f;
+	char s[120];
+	char addr[INET6_ADDRSTRLEN], gid[INET6_ADDRSTRLEN];
+	uint8_t name[ACM_MAX_ADDRESS];
+	struct in6_addr ip_addr, ib_addr;
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
@@ -3046,6 +3115,12 @@ static void acm_ep_up(struct acm_port *port, uint16_t pkey_index)
 			acm_log(1, "unable to find ep in path records\n");
 	}
 
+	if (hosts_opt) {
+		if (path_rec_fmt == ACM_PATH_REV_FMT_NONE)
+			acm_log(0, "when using hosts file option should also use path records option\n");
+		acm_parse_hosts_file(ep);
+	}
+
 	return;
 
 err2:
@@ -3362,6 +3437,13 @@ static void acm_set_options(void)
 			path_rec_fmt = acm_convert_path_rec_fmt(value);
 		else if (!stricmp("path_rec_file", opt))
 			strcpy(path_rec_file, value);
+		else if (!stricmp("hosts_file", opt)) {
+			strcpy(hosts_file, value);
+			if (!stricmp(hosts_file, "none"))
+				hosts_opt = 0;
+			else
+				hosts_opt = 1;
+		}
 	}
 
 	fclose(f);
@@ -3387,6 +3469,7 @@ static void acm_log_options(void)
 	acm_log(0, "minimum rate %d\n", min_rate);
 	acm_log(0, "path record format %d\n", path_rec_fmt);
 	acm_log(0, "path record file %s\n", path_rec_file);
+	acm_log(0, "hosts file %s\n", hosts_file);
 }
 
 static FILE *acm_open_log(void)
diff --git a/src/acme.c b/src/acme.c
index 5ba5c0a..648e97f 100644
--- a/src/acme.c
+++ b/src/acme.c
@@ -256,6 +256,12 @@ static void gen_opts_temp(FILE *f)
 	fprintf(f, "# If path_rec_fmt is other than \"none\", full pathname of path records file\n");
 	fprintf(f, "# to use for preloading the ACM cache.  Default is ACM_CONF_DIR/ibacm_path_records.dump\n");
 	fprintf(f, "\n");
+	fprintf(f, "# hosts_file:\n");
+	fprintf(f, "# none - No hosts file\n");
+	fprintf(f, "# If hosts_file is other than \"none\", full pathname of hosts file\n");
+	fprintf(f, "\n");
+	fprintf(f, "hosts_file none\n");
+	fprintf(f, "\n");
 }
 
 static int open_dir(void)
-- 
1.7.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
