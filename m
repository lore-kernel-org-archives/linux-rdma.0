From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH ibacm] Update documentation for the "new" preload option names
Date: Fri, 19 Jul 2013 14:00:02 -0400
Message-ID: <51E97EA2.6060500@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
diff --git a/acm_notes.txt b/acm_notes.txt
index 3903b8a..d204484 100644
--- a/acm_notes.txt
+++ b/acm_notes.txt
@@ -137,5 +137,6 @@ for more information on the opensm_full_v1 file format and how to configure
 OpenSM to generate this file.
 
 Additional IPv4 and IPv6 caches can be be preloaded by using the
-addr_preload option.  The default is "none" which does not preload these
-caches.
+addr_preload option.  The default is none which does not preload these
+caches.  To preload these caches, set this option to acm_hosts and
+configure the addr_data_file appropriately.
diff --git a/man/ibacm.1 b/man/ibacm.1
index 2ca7eec..0ff58a2 100644
--- a/man/ibacm.1
+++ b/man/ibacm.1
@@ -1,4 +1,4 @@
-.TH "ibacm" 1 "2013-06-18" "ibacm" "ibacm" ibacm
+.TH "ibacm" 1 "2013-07-18" "ibacm" "ibacm" ibacm
 .SH NAME
 ibacm \- address and route resolution services for InfiniBand.
 .SH SYNOPSIS
@@ -151,14 +151,15 @@ and LID destination addresses.  These caches can be optionally
 preloaded. ibacm supports the OpenSM dump_pr plugin "full" PathRecord
 format which is used to preload these caches.
 The file format is specified in the ibacm_opts.cfg file via the
-path_rec_fmt parameter which should be set to full_opensm_v1 for this file
-format.  Default format is none which does not preload these caches.
+route_preload setting which should be set to full_opensm_v1 for this
+file format.  Default format is none which does not preload these caches.
 See dump_pr.notes.txt in dump_pr for more information on the
 full_opensm_v1 file format and how to configure OpenSM to
 generate this file.
 .P
 Additional IPv4 and IPv6 caches can be be preloaded by using the
-hosts_file option.  The default is "none" which does not preload these
-caches.
+addr_preload option.  The default is none which does not preload these
+caches. To preload these caches, set this option to acm_hosts and
+configure the addr_data_file appropriately.
 .SH "SEE ALSO"
 ibacm(7), ib_acme(1), rdma_cm(7)
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
