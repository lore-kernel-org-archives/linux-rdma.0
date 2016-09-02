From: Knut Omang <knut.omang-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 9/9] ib_verbs: Add a new qp create flag to request features for Ethernet over IB
Date: Fri,  2 Sep 2016 02:09:29 +0200
Message-ID: <1472774969-18997-10-git-send-email-knut.omang@oracle.com>
References: <1472774969-18997-1-git-send-email-knut.omang@oracle.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1472774969-18997-1-git-send-email-knut.omang-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Knut Omang <knut.omang-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Some Infiniband HCAs need to know if a QP is going to
be used for Ethernet over IB (EOIB).

Signed-off-by: Knut Omang <knut.omang-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
---
 include/rdma/ib_verbs.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 093d68e..d6f3f55 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -991,6 +991,7 @@ enum ib_qp_create_flags {
 	IB_QP_CREATE_SIGNATURE_EN		= 1 << 6,
 	IB_QP_CREATE_USE_GFP_NOIO		= 1 << 7,
 	IB_QP_CREATE_SCATTER_FCS		= 1 << 8,
+	IB_QP_CREATE_EOIB			= 1 << 9,
 	/* reserve bits 26-31 for low level drivers' internal use */
 	IB_QP_CREATE_RESERVED_START		= 1 << 26,
 	IB_QP_CREATE_RESERVED_END		= 1 << 31,
-- 
2.5.5

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
