From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH] opensm/osm_console.c: Add display of FDR10 ports to portstatus_parse
Date: Thu, 08 Mar 2012 08:04:14 -0500
Message-ID: <4F58AE4E.10006@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 opensm/osm_console.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/opensm/osm_console.c b/opensm/osm_console.c
index 0465868..e521421 100644
--- a/opensm/osm_console.c
+++ b/opensm/osm_console.c
@@ -899,6 +899,8 @@ static void portstatus_parse(char **p_last, osm_opensm_t * p_osm, FILE * out)
 		fprintf(out, "   %" PRIu64 " at 5.0 Gbps\n", fs.ports_ddr);
 	if (fs.ports_qdr)
 		fprintf(out, "   %" PRIu64 " at 10.0 Gbps\n", fs.ports_qdr);
+	if (fs.ports_fdr10)
+		fprintf(out, "   %" PRIu64 " at 10.0 Gbps (FDR10)\n", fs.ports_fdr10);
 	if (fs.ports_fdr)
 		fprintf(out, "   %" PRIu64 " at 14.0625 Gbps\n", fs.ports_fdr);
 	if (fs.ports_edr)
-- 
1.7.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
