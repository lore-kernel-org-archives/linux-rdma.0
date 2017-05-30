From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next 1/6] IB/core: Enable QP creation which is associated to underlay QP
Date: Tue, 30 May 2017 10:15:57 +0300
Message-ID: <20170530071602.8139-2-leon@kernel.org>
References: <20170530071602.8139-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170530071602.8139-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Enable QP creation which is associated to underlay QP.
The created QP will manage the scattering objects as of RQ and SQ, while
the transport attributes will be managed by its underlay QP

This comes as a pre-patch for downstream patches in this series to
enable flow steering on the underlay IPoIB QP.

Signed-off-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Maor Gottlieb <maorg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 include/rdma/ib_verbs.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index f0cb4906478a..58bea71e54c6 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -1058,6 +1058,7 @@ enum ib_qp_create_flags {
 	IB_QP_CREATE_USE_GFP_NOIO		= 1 << 7,
 	IB_QP_CREATE_SCATTER_FCS		= 1 << 8,
 	IB_QP_CREATE_CVLAN_STRIPPING		= 1 << 9,
+	IB_QP_CREATE_ASSOC_QPN			= 1 << 10,
 	/* reserve bits 26-31 for low level drivers' internal use */
 	IB_QP_CREATE_RESERVED_START		= 1 << 26,
 	IB_QP_CREATE_RESERVED_END		= 1 << 31,
@@ -1085,6 +1086,7 @@ struct ib_qp_init_attr {
 	 */
 	u8			port_num;
 	struct ib_rwq_ind_table *rwq_ind_tbl;
+	u32			associated_qpn;
 };

 struct ib_qp_open_attr {
--
2.12.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
