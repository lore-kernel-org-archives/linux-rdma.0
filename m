From: Hal Rosenstock <hnrose-Wuw85uim5zDR7s880joybQ@public.gmane.org>
Subject: [PATCH][MINOR] opensm/osm_req.c: In osm_send_trap144, eliminate
	redundant clear of m_key in smp
Date: Tue, 22 Jun 2010 10:13:41 -0400
Message-ID: <20100622141341.GA28788@comcast.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


Already cleared by prior memset

Signed-off-by: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
diff --git a/opensm/opensm/osm_req.c b/opensm/opensm/osm_req.c
index b452089..7e9e664 100644
--- a/opensm/opensm/osm_req.c
+++ b/opensm/opensm/osm_req.c
@@ -250,7 +250,6 @@ int osm_send_trap144(osm_sm_t * sm, ib_net16_t local)
 	smp->method = IB_MAD_METHOD_TRAP;
 	smp->trans_id = cl_hton64((uint64_t) cl_atomic_inc(&sm->sm_trans_id));
 	smp->attr_id = IB_MAD_ATTR_NOTICE;
-	smp->m_key = 0;
 
 	ntc = (ib_mad_notice_attr_t *) smp->data;
 
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
