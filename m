From: "Stan C. Smith" <stan.smith-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] replace (long*)(long) casting with transportable data type (uintptr_t)
Date: Mon, 6 Dec 2010 15:55:11 -0800
Message-ID: <3D555CA8351C471B84CD9D6432AFC6D0@amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Sasha Khapyorsky' <sashakvolt-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Linux RDMA <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Hello,
  Your suggestion of removing extra casts does operate correctly under windows x64/x86 variants.
Windows compilers have improved.

thanks,

Stan.

Signed-off-by: stan smith <stan.smith-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

diff --git a/opensm/libvendor/osm_vendor_ibumad_sa.c b/opensm/libvendor/osm_vendor_ibumad_sa.c
index 1fdcc47..63728ad 100644
--- a/opensm/libvendor/osm_vendor_ibumad_sa.c
+++ b/opensm/libvendor/osm_vendor_ibumad_sa.c
@@ -85,8 +85,7 @@ __osmv_sa_mad_rcv_cb(IN osm_madw_t * p_madw,
 
 	/* obtain the sent context since we store it during send in the ni_ctx */
 	p_query_req_copy =
-	    (osmv_query_req_t *) (long *)(long)(p_req_madw->context.ni_context.
-						node_guid);
+	    (osmv_query_req_t *) p_req_madw->context.ni_context.node_guid;
 
 	/* provide the context of the original request in the result */
 	query_res.query_context = p_query_req_copy->query_context;
@@ -181,8 +180,7 @@ static void __osmv_sa_mad_err_cb(IN void *bind_context, IN osm_madw_t * p_madw)
 
 	/* Obtain the sent context etc */
 	p_query_req_copy =
-	    (osmv_query_req_t *) (long *)(long)(p_madw->context.ni_context.
-						node_guid);
+	    (osmv_query_req_t *) p_madw->context.ni_context.node_guid;
 
 	/* provide the context of the original request in the result */
 	query_res.query_context = p_query_req_copy->query_context;
@@ -433,7 +431,7 @@ __osmv_send_sa_req(IN osmv_sa_bind_info_t * p_bind,
 	}
 	*p_query_req_copy = *p_query_req;
 	p_madw->context.ni_context.node_guid =
-	    (ib_net64_t) (long)p_query_req_copy;
+	    (ib_net64_t) (uintptr_t)p_query_req_copy;
 
 	/* we can support async as well as sync calls */
 	sync = ((p_query_req->flags & OSM_SA_FLAGS_SYNC) == OSM_SA_FLAGS_SYNC);

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
