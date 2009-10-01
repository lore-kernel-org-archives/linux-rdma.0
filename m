From: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: [PATCH] opensm/osm_mesh.c: simplify compare_switches() function
Date: Thu, 1 Oct 2009 19:04:43 +0200
Message-ID: <20091001170443.GS17846@me>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Simplify compare_switches() qsort's comparator function.

Signed-off-by: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
---
 opensm/opensm/osm_mesh.c |   12 ++++--------
 1 files changed, 4 insertions(+), 8 deletions(-)

diff --git a/opensm/opensm/osm_mesh.c b/opensm/opensm/osm_mesh.c
index e5c53d9..76191d9 100644
--- a/opensm/opensm/osm_mesh.c
+++ b/opensm/opensm/osm_mesh.c
@@ -1370,21 +1370,17 @@ static int reorder_links(lash_t *p_lash, mesh_t *mesh)
  */
 static int compare_switches(const void *p1, const void *p2)
 {
-	int i, j, d;
 	const comp_t *cp1 = p1, *cp2 = p2;
 	const sort_ctx_t *ctx = &cp1->ctx;
 	switch_t *s1 = ctx->p_lash->switches[cp1->index];
 	switch_t *s2 = ctx->p_lash->switches[cp2->index];
+	int i, j;
+	int ret;
 
 	for (i = 0; i < ctx->mesh->dimension; i++) {
 		j = ctx->mesh->dim_order[i];
-		d = s1->node->coord[j] - s2->node->coord[j];
-
-		if (d > 0)
-			return 1;
-
-		if (d < 0)
-			return -1;
+		if ((ret = s1->node->coord[j] - s2->node->coord[j]));
+			return ret;
 	}
 
 	return 0;
-- 
1.6.5.rc1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
