From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH ibacm] Add support for name cache
Date: Fri, 19 Jul 2013 14:30:04 -0400
Message-ID: <51E985AC.5090506@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Similar to IPv4 and IPv6 preload, (host)name cache preload is
now supported in addr_preload_file when acm_hosts is specified
for addr_preload setting.

Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
diff --git a/acm_notes.txt b/acm_notes.txt
index d204484..3f24322 100644
--- a/acm_notes.txt
+++ b/acm_notes.txt
@@ -136,7 +136,7 @@ none which does not preload these caches.  See dump_pr.notes.txt in dump_pr
 for more information on the opensm_full_v1 file format and how to configure
 OpenSM to generate this file.
 
-Additional IPv4 and IPv6 caches can be be preloaded by using the
-addr_preload option.  The default is none which does not preload these
+Additionally, the name, IPv4, and IPv6 caches can be be preloaded by using
+the addr_preload option.  The default is none which does not preload these
 caches.  To preload these caches, set this option to acm_hosts and
 configure the addr_data_file appropriately.
diff --git a/ibacm_hosts.data b/ibacm_hosts.data
index 9011691..78b978d 100644
--- a/ibacm_hosts.data
+++ b/ibacm_hosts.data
@@ -3,10 +3,13 @@
 # Entry format is:
 # address IB GID
 #
+# The address may be one of the following:
+# host_name - ascii character string, up to 31 characters
 # address - IPv4 or IPv6 formatted address
 #
 # There can be multiple entries for a single IB GID
 #
 # Samples:
+# luna3 fe80::8:f104:39a:169
 # 192.168.1.3 fe80::8:f104:39a:169
 # fe80::208:f104:39a:169 fe80::8:f104:39a:169
diff --git a/man/ibacm.1 b/man/ibacm.1
index 0ff58a2..fb15752 100644
--- a/man/ibacm.1
+++ b/man/ibacm.1
@@ -157,8 +157,8 @@ See dump_pr.notes.txt in dump_pr for more information on the
 full_opensm_v1 file format and how to configure OpenSM to
 generate this file.
 .P
-Additional IPv4 and IPv6 caches can be be preloaded by using the
-addr_preload option.  The default is none which does not preload these
+Additionally, the name, IPv4, and IPv6 caches can be be preloaded by using
+the addr_preload option.  The default is none which does not preload these
 caches. To preload these caches, set this option to acm_hosts and
 configure the addr_data_file appropriately.
 .SH "SEE ALSO"
diff --git a/src/acm.c b/src/acm.c
index 7f926b4..09051dc 100644
--- a/src/acm.c
+++ b/src/acm.c
@@ -2832,20 +2832,18 @@ static void acm_parse_hosts_file(struct acm_ep *ep)
 			acm_log(0, "ERROR - %s is not IB GID\n", gid);
 			continue;
 		}
+		memset(name, 0, ACM_MAX_ADDRESS);
 		if (inet_pton(AF_INET, addr, &ip_addr) > 0) {
 			addr_type = ACM_ADDRESS_IP;
+			memcpy(name, &ip_addr, 4);
 		} else if (inet_pton(AF_INET6, addr, &ip_addr) > 0) {
 			addr_type = ACM_ADDRESS_IP6;
+			memcpy(name, &ip_addr, sizeof(ip_addr));
 		} else {
-			acm_log(0, "ERROR - %s is not IP address\n", addr);
-			continue;
+			addr_type = ACM_ADDRESS_NAME;
+			strncpy((char *)name, addr, ACM_MAX_ADDRESS);
 		}
 
-		memset(name, 0, ACM_MAX_ADDRESS);
-		if (addr_type == ACM_ADDRESS_IP)
-			memcpy(name, &ip_addr, 4);
-		else
-			memcpy(name, &ip_addr, sizeof(ip_addr));
 		dest = acm_acquire_dest(ep, addr_type, name);
 		if (!dest) {
 			acm_log(0, "ERROR - unable to create dest %s\n", addr);
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
