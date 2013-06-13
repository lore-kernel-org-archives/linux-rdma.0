From: Albert Chu <chu11-i2BcT+NCU+M@public.gmane.org>
Subject: [PATCH 2/2] ibnetdiscover: Output vlcap in full output format
Date: Thu, 13 Jun 2013 14:26:48 -0700
Message-ID: <1371158808.13124.176.camel@auk59.llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

The additional vlcap information is useful when simulating a fabric
in ibsim and fabric VL information is needed.

Signed-off-by: Albert L. Chu <chu11-i2BcT+NCU+M@public.gmane.org>
---
 doc/man/ibnetdiscover.8.in     |    2 +-
 doc/rst/ibnetdiscover.8.in.rst |    2 +-
 src/ibnetdiscover.c            |   10 +++++++---
 3 files changed, 9 insertions(+), 5 deletions(-)

diff --git a/doc/man/ibnetdiscover.8.in b/doc/man/ibnetdiscover.8.in
index 0c3d8a4..78e7e52 100644
--- a/doc/man/ibnetdiscover.8.in
+++ b/doc/man/ibnetdiscover.8.in
@@ -63,7 +63,7 @@ List of connected routers
 Show progress information during discovery.
 .sp
 \fB\-f, \-\-full\fP
-Show full information (ports\(aq speed and width)
+Show full information (ports\(aq speed and width, vlcap)
 .sp
 \fB\-p, \-\-ports\fP
 Obtain a ports report which is a
diff --git a/doc/rst/ibnetdiscover.8.in.rst b/doc/rst/ibnetdiscover.8.in.rst
index f68db31..61a5667 100644
--- a/doc/rst/ibnetdiscover.8.in.rst
+++ b/doc/rst/ibnetdiscover.8.in.rst
@@ -50,7 +50,7 @@ List of connected routers
 Show progress information during discovery.
 
 **-f, --full**
-Show full information (ports' speed and width)
+Show full information (ports' speed and width, vlcap)
 
 **-p, --ports**
 Obtain a ports report which is a
diff --git a/src/ibnetdiscover.c b/src/ibnetdiscover.c
index b9fb243..c8c19aa 100644
--- a/src/ibnetdiscover.c
+++ b/src/ibnetdiscover.c
@@ -361,6 +361,8 @@ void out_switch_port(ibnd_port_t * port, int group, char *out_prefix)
 					IB_PORT_LINK_WIDTH_ACTIVE_F);
 	uint32_t ispeed = mad_get_field(port->info, 0,
 					IB_PORT_LINK_SPEED_ACTIVE_F);
+	uint32_t vlcap = mad_get_field(port->info, 0,
+				       IB_PORT_VL_CAP_F);
 	uint32_t fdr10 = mad_get_field(port->ext_info, 0,
 				       IB_MLNX_EXT_PORT_LINK_SPEED_ACTIVE_F);
 	uint32_t cap_mask, espeed;
@@ -408,7 +410,7 @@ void out_switch_port(ibnd_port_t * port, int group, char *out_prefix)
 			dump_linkspeedext_compat(espeed, ispeed, fdr10));
 
 	if (full_info)
-		fprintf(f, " s=%d w=%d", ispeed, iwidth);
+		fprintf(f, " s=%d w=%d v=%d", ispeed, iwidth, vlcap);
 
 	if (ibnd_is_xsigo_tca(port->remoteport->guid))
 		fprintf(f, " slot %d", port->portnum);
@@ -427,6 +429,8 @@ void out_ca_port(ibnd_port_t * port, int group, char *out_prefix)
 					IB_PORT_LINK_WIDTH_ACTIVE_F);
 	uint32_t ispeed = mad_get_field(port->info, 0,
 					IB_PORT_LINK_SPEED_ACTIVE_F);
+	uint32_t vlcap = mad_get_field(port->info, 0,
+				       IB_PORT_VL_CAP_F);
 	uint32_t fdr10 = mad_get_field(port->ext_info, 0,
 				       IB_MLNX_EXT_PORT_LINK_SPEED_ACTIVE_F);
 	uint32_t cap_mask, espeed;
@@ -464,7 +468,7 @@ void out_ca_port(ibnd_port_t * port, int group, char *out_prefix)
 			dump_linkspeedext_compat(espeed, ispeed, fdr10));
 
 	if (full_info)
-		fprintf(f, " s=%d w=%d", ispeed, iwidth);
+		fprintf(f, " s=%d w=%d v=%d", ispeed, iwidth, vlcap);
 	fprintf(f, "\n");
 
 	free(rem_nodename);
@@ -1063,7 +1067,7 @@ int main(int argc, char **argv)
 	ibnd_fabric_t *diff_fabric = NULL;
 
 	const struct ibdiag_opt opts[] = {
-		{"full", 'f', 0, NULL, "show full information (ports' speed and width)"},
+		{"full", 'f', 0, NULL, "show full information (ports' speed and width, vlcap)"},
 		{"show", 's', 0, NULL, "show more information"},
 		{"list", 'l', 0, NULL, "list of connected nodes"},
 		{"grouping", 'g', 0, NULL, "show grouping"},
-- 
1.7.1



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
