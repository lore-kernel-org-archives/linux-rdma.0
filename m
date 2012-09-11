From: Yevgeny Kliteynik <kliteyn-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Subject: [PATCH 4/8 v2] opensm/libvendor/osm_vendor_ibumad_sa.c: use wrapper
 function instead of direct access
Date: Tue, 11 Sep 2012 18:28:23 +0300
Message-ID: <504F5897.5080301@mellanox.co.il>
Reply-To: <kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Linux RDMA <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Yevgeny Kliteynik <kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Use existing wrapper function to get to context instead of direct access.

Signed-off-by: Yevgeny Kliteynik <kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
---
 libvendor/osm_vendor_ibumad_sa.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/libvendor/osm_vendor_ibumad_sa.c b/libvendor/osm_vendor_ibumad_sa.c
index 1d482c0..f715cf6 100644
--- a/libvendor/osm_vendor_ibumad_sa.c
+++ b/libvendor/osm_vendor_ibumad_sa.c
@@ -84,9 +84,8 @@ __osmv_sa_mad_rcv_cb(IN osm_madw_t * p_madw,
 	}

 	/* obtain the sent context since we store it during send in the ni_ctx */
-	p_query_req_copy =
-	    (osmv_query_req_t *) (uintptr_t)(p_req_madw->context.ni_context.
-						node_guid);
+	p_query_req_copy = (osmv_query_req_t *)
+            (uintptr_t)(osm_madw_get_ni_context_ptr(p_req_madw)->node_guid);

 	/* provide the context of the original request in the result */
 	query_res.query_context = p_query_req_copy->query_context;
@@ -180,9 +179,8 @@ static void __osmv_sa_mad_err_cb(IN void *bind_context, IN osm_madw_t * p_madw)
 	OSM_LOG_ENTER(p_bind->p_log);

 	/* Obtain the sent context etc */
-	p_query_req_copy =
-	    (osmv_query_req_t *) (uintptr_t)(p_madw->context.ni_context.
-						node_guid);
+	p_query_req_copy = (osmv_query_req_t *)
+            (uintptr_t)(osm_madw_get_ni_context_ptr(p_madw)->node_guid);

 	/* provide the context of the original request in the result */
 	query_res.query_context = p_query_req_copy->query_context;
@@ -433,7 +431,7 @@ __osmv_send_sa_req(IN osmv_sa_bind_info_t * p_bind,
 		goto Exit;
 	}
 	*p_query_req_copy = *p_query_req;
-	p_madw->context.ni_context.node_guid =
+	osm_madw_get_ni_context_ptr(p_madw)->node_guid =
 	    (ib_net64_t) (uintptr_t)p_query_req_copy;

 	/* we can support async as well as sync calls */
-- 
1.7.11.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
