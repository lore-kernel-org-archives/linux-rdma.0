From: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: [PATCH] libibnetdisc: remove man page of removed API
Date: Fri, 6 Nov 2009 19:00:24 +0200
Message-ID: <20091106170024.GJ7192@me>
References: <1257190397.580.30.camel@auk31.llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1257190397.580.30.camel-X2zTWyBD0EhliZ7u+bvwcg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Al Chu <chu11-i2BcT+NCU+M@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


Remove man page for removed ibnd_update_node() API. Also removing its
entry from library version script.

Signed-off-by: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
---
 infiniband-diags/libibnetdisc/Makefile.am          |    3 +--
 .../libibnetdisc/man/ibnd_update_node.3            |   17 -----------------
 infiniband-diags/libibnetdisc/src/libibnetdisc.map |    1 -
 3 files changed, 1 insertions(+), 20 deletions(-)
 delete mode 100644 infiniband-diags/libibnetdisc/man/ibnd_update_node.3

diff --git a/infiniband-diags/libibnetdisc/Makefile.am b/infiniband-diags/libibnetdisc/Makefile.am
index 7085f14..636d142 100644
--- a/infiniband-diags/libibnetdisc/Makefile.am
+++ b/infiniband-diags/libibnetdisc/Makefile.am
@@ -44,8 +44,7 @@ man_MANS = man/ibnd_debug.3 \
 	man/ibnd_find_node_guid.3 \
 	man/ibnd_iter_nodes.3 \
 	man/ibnd_iter_nodes_type.3 \
-	man/ibnd_show_progress.3 \
-	man/ibnd_update_node.3
+	man/ibnd_show_progress.3
 
 EXTRA_DIST = $(srcdir)/src/libibnetdisc.map libibnetdisc.ver $(man_MANS)
 
diff --git a/infiniband-diags/libibnetdisc/man/ibnd_update_node.3 b/infiniband-diags/libibnetdisc/man/ibnd_update_node.3
deleted file mode 100644
index 472f3cd..0000000
--- a/infiniband-diags/libibnetdisc/man/ibnd_update_node.3
+++ /dev/null
@@ -1,17 +0,0 @@
-.TH IBND_UPDATE_NODE 3  "July 25, 2008" "OpenIB" "OpenIB Programmer's Manual"
-.SH "NAME"
-ibnd_update_node \- Update the node specified with new data from the fabric.
-.SH "SYNOPSIS"
-.nf
-.B #include <infiniband/ibnetdisc.h>
-.sp
-.BI "ibnd_node_t *ibnd_update_node(ibnd_node_t *node)"
-.SH "DESCRIPTION"
-.B ibnd_update_node()
-Update the node info, port info, and node description of the node specified.
-.SH "RETURN VALUE"
-.B ibnd_update_node()
-Return NULL on failure, otherwise a valid ibnd_node_t object which is part of the fabric object.
-.SH "AUTHORS"
-.TP
-Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
diff --git a/infiniband-diags/libibnetdisc/src/libibnetdisc.map b/infiniband-diags/libibnetdisc/src/libibnetdisc.map
index bd108ab..13bb65a 100644
--- a/infiniband-diags/libibnetdisc/src/libibnetdisc.map
+++ b/infiniband-diags/libibnetdisc/src/libibnetdisc.map
@@ -5,7 +5,6 @@ IBNETDISC_1.0 {
 		ibnd_discover_fabric;
 		ibnd_destroy_fabric;
 		ibnd_find_node_guid;
-		ibnd_update_node;
 		ibnd_find_node_dr;
 		ibnd_is_xsigo_guid;
 		ibnd_is_xsigo_tca;
-- 
1.6.5.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
