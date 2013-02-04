From: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH] opensm/osm_torus.c: In dump_torus, make sure switch is
 present before dumping
Date: Mon, 4 Feb 2013 11:36:00 +0200
Message-ID: <20130204093600.GA13151@calypso.mtl.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Fix segmentation fault in osm_torus.c.

Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 opensm/osm_torus.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/opensm/osm_torus.c b/opensm/osm_torus.c
index 1510233..e63cb40 100644
--- a/opensm/osm_torus.c
+++ b/opensm/osm_torus.c
@@ -7517,11 +7517,12 @@ void dump_torus(struct torus *t)
 	for (k = 0; k < z_sz; k++)
 		for (j = 0; j < y_sz; j++)
 			for (i = 0; i < x_sz; i++)
-				fprintf(file, "switch %u,%u,%u GUID 0x%04"
-					PRIx64 " (%s)\n",
-					i, j, k,
-					cl_ntoh64(t->sw[i][j][k]->n_id),
-					t->sw[i][j][k]->osm_switch->p_node->print_desc);
+				if (t->sw[i][j][k])
+					fprintf(file, "switch %u,%u,%u GUID 0x%04"
+						PRIx64 " (%s)\n",
+						i, j, k,
+						cl_ntoh64(t->sw[i][j][k]->n_id),
+						t->sw[i][j][k]->osm_switch->p_node->print_desc);
 	fclose(file);
 }
 
-- 
1.7.11.7

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
