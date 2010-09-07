From: Yevgeny Kliteynik <kliteyn-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Subject: [PATCH] opensm/osm_pkey.c: removing unused function
Date: Tue, 7 Sep 2010 17:55:42 +0300
Message-ID: <4C86526E.60007@mellanox.co.il>
Reply-To: kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>, Linux RDMA <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Removing unused (and, may I add, buggy) function.

Signed-off-by: Yevgeny Kliteynik <kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
---
 opensm/opensm/osm_pkey.c |   10 ----------
 1 files changed, 0 insertions(+), 10 deletions(-)

diff --git a/opensm/opensm/osm_pkey.c b/opensm/opensm/osm_pkey.c
index aa7b690..4c5a852 100644
--- a/opensm/opensm/osm_pkey.c
+++ b/opensm/opensm/osm_pkey.c
@@ -104,16 +104,6 @@ void osm_pkey_tbl_init_new_blocks(IN const osm_pkey_tbl_t * p_pkey_tbl)
 			memset(p_block, 0, sizeof(*p_block));
 }

-void osm_pkey_tbl_cleanup_pending(IN osm_pkey_tbl_t * p_pkey_tbl)
-{
-	cl_list_item_t *p_item;
-
-	p_item = cl_qlist_remove_head(&p_pkey_tbl->pending);
-	while (p_item != cl_qlist_end(&p_pkey_tbl->pending)) {
-		free((osm_pending_pkey_t *) p_item);
-	}
-}
-
 ib_api_status_t osm_pkey_tbl_set(IN osm_pkey_tbl_t * p_pkey_tbl,
 				 IN uint16_t block, IN ib_pkey_table_t * p_tbl)
 {
-- 
1.6.2.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
