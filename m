From: Yevgeny Kliteynik <kliteyn-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Subject: [PATCH] opensm/osm_ucast_ftree.c: fix small memory leak in error
	path
Date: Tue, 7 Sep 2010 18:11:01 +0300
Message-ID: <4C865605.4050702@mellanox.co.il>
Reply-To: kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>, Linux RDMA <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Signed-off-by: Yevgeny Kliteynik <kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
---
 opensm/opensm/osm_ucast_ftree.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/opensm/opensm/osm_ucast_ftree.c b/opensm/opensm/osm_ucast_ftree.c
index 88ea344..fb46d0f 100644
--- a/opensm/opensm/osm_ucast_ftree.c
+++ b/opensm/opensm/osm_ucast_ftree.c
@@ -791,8 +791,10 @@ static ftree_hca_t *hca_create(IN osm_node_t * p_osm_node)
 	p_hca->up_port_groups = (ftree_port_group_t **)
 	    malloc(osm_node_get_num_physp(p_hca->p_osm_node) *
 		   sizeof(ftree_port_group_t *));
-	if (!p_hca->up_port_groups)
+	if (!p_hca->up_port_groups) {
+		free(p_hca);
 		return NULL;
+	}
 	p_hca->up_port_groups_num = 0;
 	return p_hca;
 }
-- 
1.6.2.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
