From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [rdma-next v1 REPOST 03/10] IB/core: Add new SRQ type IB_SRQT_TM
Date: Thu, 17 Aug 2017 15:52:05 +0300
Message-ID: <20170817125212.3173-4-leon@kernel.org>
References: <20170817125212.3173-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170817125212.3173-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Artemy Kovalyov <artemyko-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Artemy Kovalyov <artemyko-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

This patch adds new SRQ type - IB_SRQT_TM. The new SRQ type supports tag
matching and rendezvous offloads for MPI applications.

When SRQ receives a message it will search through the matching list
for the corresponding posted receive buffer. The process of searching
the matching list is called tag matching.
In case the tag matching results in a match, the received message will
be placed in the address specified by the receive buffer. In case no
match was found the message will be placed in a generic buffer until the
corresponding receive buffer will be posted. These messages are called
unexpected and their set is called an unexpected list.

Signed-off-by: Artemy Kovalyov <artemyko-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Yossi Itigin <yosefe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 include/rdma/ib_verbs.h | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 665ebf33424a..e0e48a256d63 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -990,12 +990,14 @@ enum ib_cq_notify_flags {

 enum ib_srq_type {
 	IB_SRQT_BASIC,
-	IB_SRQT_XRC
+	IB_SRQT_XRC,
+	IB_SRQT_TM,
 };

 static inline bool ib_srq_has_cq(enum ib_srq_type srq_type)
 {
-	return srq_type == IB_SRQT_XRC;
+	return srq_type == IB_SRQT_XRC ||
+	       srq_type == IB_SRQT_TM;
 }

 enum ib_srq_attr_mask {
@@ -1021,6 +1023,10 @@ struct ib_srq_init_attr {
 			struct {
 				struct ib_xrcd *xrcd;
 			} xrc;
+
+			struct {
+				u32		max_num_tags;
+			} tag_matching;
 		};
 	} ext;
 };
--
2.14.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
