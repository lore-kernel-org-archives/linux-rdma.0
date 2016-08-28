From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next 03/10] IB/core: Add new SRQ type IB_SRQT_TAG_MATCHING
Date: Sun, 28 Aug 2016 14:00:43 +0300
Message-ID: <1472382050-25908-4-git-send-email-leon@kernel.org>
References: <1472382050-25908-1-git-send-email-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1472382050-25908-1-git-send-email-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Artemy Kovalyov <artemyko-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Artemy Kovalyov <artemyko-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

New SRQ type - IB_SRQT_TAG_MATCHING. It supports extended tag matching
receive buffers topology and rendezvouz offload.

When SRQ receives a message it will search through the matching list
for the corresponding posted receive buffer. The process of searching
the matching list is called tag matching.
In case the tag matching results in a match, the received message will
be placed in the address specified by the receive buffer. In case no
match was found the message will be placed in a generic buffer until the
corresponding receive buffer will be posted. These messages are called
unexpected and their set is called an unexpected list.

Signed-off-by: Artemy Kovalyov <artemyko-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 include/rdma/ib_verbs.h | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 8b92698..0e7a711 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -932,12 +932,14 @@ enum ib_cq_notify_flags {
 
 enum ib_srq_type {
 	IB_SRQT_BASIC,
-	IB_SRQT_XRC
+	IB_SRQT_XRC,
+	IB_SRQT_TAG_MATCHING,
 };
 
 static inline bool ib_srq_has_cq(enum ib_srq_type srq_type)
 {
-	return srq_type == IB_SRQT_XRC;
+	return srq_type == IB_SRQT_XRC ||
+	       srq_type == IB_SRQT_TAG_MATCHING;
 }
 
 enum ib_srq_attr_mask {
@@ -962,6 +964,11 @@ struct ib_srq_init_attr {
 			struct ib_xrcd *xrcd;
 			struct ib_cq   *cq;
 		} xrc;
+
+		struct {
+			struct ib_cq   *cq;
+			u32		list_size;
+		} tag_matching;
 	} ext;
 };
 
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
