From: Vasiliy Kulikov <segoon-cxoSlKxDwOJWk0Htik3J/w@public.gmane.org>
Subject: [PATCH v2] infiniband: core: fix information leak to userspace
Date: Sun, 14 Nov 2010 12:22:52 +0300
Message-ID: <20101114092252.GA5323@albatros>
References: <1289054481-18145-1-git-send-email-segooon@gmail.com>
 <ada39r8ohiz.fsf@cisco.com>
 <20101112180844.GA11533@albatros>
 <CF9C39F99A89134C9CF9C4CCB68B8DDF25B85224A6@orsmsx501.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CF9C39F99A89134C9CF9C4CCB68B8DDF25B85224A6-osO9UTpF0USkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, "kernel-janitors-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <kernel-janitors-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Alex Chiang <achiang-VXdhtT5mjnY@public.gmane.org>, Andi Kleen <ak-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Greg Kroah-Hartman <gregkh-l3A5Bk7waGM@public.gmane.org>, Julia Lawall <julia-dAYI7NvHqcQ@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

ib_ucm_init_qp_attr() and ucma_init_qp_attr() pass struct ib_uverbs_qp_attr
with reserved, qp_state, {ah_attr,alt_ah_attr}{reserved,->grh.reserved}
fields uninitialized to copy_to_user().  It leads to leaking of contents of
kernel stack memory to userspace.

Signed-off-by: Vasiliy Kulikov <segoon-cxoSlKxDwOJWk0Htik3J/w@public.gmane.org>
---
 Compile tested.

 drivers/infiniband/core/uverbs_marshall.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/infiniband/core/uverbs_marshall.c b/drivers/infiniband/core/uverbs_marshall.c
index 5440da0..1b1146f 100644
--- a/drivers/infiniband/core/uverbs_marshall.c
+++ b/drivers/infiniband/core/uverbs_marshall.c
@@ -40,18 +40,21 @@ void ib_copy_ah_attr_to_user(struct ib_uverbs_ah_attr *dst,
 	dst->grh.sgid_index        = src->grh.sgid_index;
 	dst->grh.hop_limit         = src->grh.hop_limit;
 	dst->grh.traffic_class     = src->grh.traffic_class;
+	memset(&dst->grh.reserved, 0, sizeof(dst->grh.reserved));
 	dst->dlid 	    	   = src->dlid;
 	dst->sl   	    	   = src->sl;
 	dst->src_path_bits 	   = src->src_path_bits;
 	dst->static_rate   	   = src->static_rate;
 	dst->is_global             = src->ah_flags & IB_AH_GRH ? 1 : 0;
 	dst->port_num 	    	   = src->port_num;
+	dst->reserved 		   = 0;
 }
 EXPORT_SYMBOL(ib_copy_ah_attr_to_user);
 
 void ib_copy_qp_attr_to_user(struct ib_uverbs_qp_attr *dst,
 			     struct ib_qp_attr *src)
 {
+	dst->qp_state	        = src->qp_state;
 	dst->cur_qp_state	= src->cur_qp_state;
 	dst->path_mtu		= src->path_mtu;
 	dst->path_mig_state	= src->path_mig_state;
@@ -83,6 +86,7 @@ void ib_copy_qp_attr_to_user(struct ib_uverbs_qp_attr *dst,
 	dst->rnr_retry		= src->rnr_retry;
 	dst->alt_port_num	= src->alt_port_num;
 	dst->alt_timeout	= src->alt_timeout;
+	memset(dst->reserved, 0, sizeof(dst->reserved));
 }
 EXPORT_SYMBOL(ib_copy_qp_attr_to_user);
 
-- 
1.7.0.4
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
