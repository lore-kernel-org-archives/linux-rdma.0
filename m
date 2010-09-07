From: Yevgeny Kliteynik <kliteyn-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Subject: [PATCH] libvendor/osm_vendor_mlx_sa.c: remove useless "if"
	statement
Date: Tue, 7 Sep 2010 22:34:52 +0300
Message-ID: <4C8693DC.1010607@mellanox.co.il>
Reply-To: kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>, Linux RDMA <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Content of p_query_req_copy is used in the function,
so no point checking if it's NULL before the free()

Signed-off-by: Yevgeny Kliteynik <kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
---
 opensm/libvendor/osm_vendor_mlx_sa.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/opensm/libvendor/osm_vendor_mlx_sa.c b/opensm/libvendor/osm_vendor_mlx_sa.c
index 0cc3f19..9050af8 100644
--- a/opensm/libvendor/osm_vendor_mlx_sa.c
+++ b/opensm/libvendor/osm_vendor_mlx_sa.c
@@ -210,8 +210,7 @@ void __osmv_sa_mad_err_cb(IN void *bind_context, IN osm_madw_t * p_madw)
 	if ((p_query_req_copy->flags & OSM_SA_FLAGS_SYNC) == OSM_SA_FLAGS_SYNC)
 		cl_event_signal(&p_bind->sync_event);

-	if (p_query_req_copy)
-		free(p_query_req_copy);
+	free(p_query_req_copy);
 	OSM_LOG_EXIT(p_bind->p_log);
 }

-- 
1.6.2.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
