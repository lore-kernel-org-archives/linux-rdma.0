From: Yevgeny Kliteynik <kliteyn-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Subject: [PATCH] opensm/osm_mesh.c: fixing a bug in compare_switches()
Date: Tue, 7 Sep 2010 18:00:30 +0300
Message-ID: <4C86538E.3080206@mellanox.co.il>
Reply-To: kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>, Linux RDMA <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

I'm pretty sure that ";" at the end of "if" statement
is not supposed to be there (not sure how it worked till
now though).
Also, making this condition a bit more readable.

Signed-off-by: Yevgeny Kliteynik <kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
---
 opensm/opensm/osm_mesh.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/opensm/opensm/osm_mesh.c b/opensm/opensm/osm_mesh.c
index 9d1082a..d156b7a 100644
--- a/opensm/opensm/osm_mesh.c
+++ b/opensm/opensm/osm_mesh.c
@@ -1385,7 +1385,8 @@ static int compare_switches(const void *p1, const void *p2)

 	for (i = 0; i < ctx->mesh->dimension; i++) {
 		j = ctx->mesh->dim_order[i];
-		if ((ret = s1->node->coord[j] - s2->node->coord[j]));
+		ret = s1->node->coord[j] - s2->node->coord[j];
+		if (ret)
 			return ret;
 	}

-- 
1.6.2.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
