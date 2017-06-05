From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next V1 1/6] IB/core: Enable QP creation which is associated to underlay QP
Date: Mon,  5 Jun 2017 08:00:16 +0300
Message-ID: <20170605050021.12236-2-leon@kernel.org>
References: <20170605050021.12236-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170605050021.12236-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Enable QP creation which is associated to some underlay QP as of IPoIB QP.
It comes to allow in downstream patches  a user space applications to
accelerate send and receive traffic which is typically handled by IPoIB ULP.

A successful QP creation will end-up by having an overlay QP (e.g. the
created one) which is associated to an already existing underlay one
(e.g. IPoIB QP).

The underlay QP is responsible for the transport, the packets on the
wire will hold its QPN, its pkey will be used, etc.

The overlay QP can steer incoming packets which were target to the
underlay QP into its own RQ. It can post send WQEs on its own SQ, the
hardware will use the transport properties of the underlay QP
to format the packets on the wire.
Note: The underlay QP should be in an RTR/RTS state in order to enable
the overlay QP to work properly.

Each QP should manage its properties and objects via modify, query and
destroy. Specifically, overlay QP can't affect the underlay QP
properties and vice versa.

Signed-off-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Maor Gottlieb <maorg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 include/rdma/ib_verbs.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index ba8314ec5768..ba97b33f31c5 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -1059,6 +1059,7 @@ enum ib_qp_create_flags {
 	IB_QP_CREATE_USE_GFP_NOIO		= 1 << 7,
 	IB_QP_CREATE_SCATTER_FCS		= 1 << 8,
 	IB_QP_CREATE_CVLAN_STRIPPING		= 1 << 9,
+	IB_QP_CREATE_ASSOC_QPN			= 1 << 10,
 	/* reserve bits 26-31 for low level drivers' internal use */
 	IB_QP_CREATE_RESERVED_START		= 1 << 26,
 	IB_QP_CREATE_RESERVED_END		= 1 << 31,
@@ -1086,6 +1087,7 @@ struct ib_qp_init_attr {
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
