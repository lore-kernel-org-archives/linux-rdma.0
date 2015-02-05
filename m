From: majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
Subject: [PATCH libibverbs 1/3] Update ibv_post_send manual page
Date: Thu,  5 Feb 2015 13:10:35 +0200
Message-ID: <1423134637-14438-2-git-send-email-majd@mellanox.com>
References: <1423134637-14438-1-git-send-email-majd@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1423134637-14438-1-git-send-email-majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Align the ibv_send_wr structure according to the infiniband/verbs.h

Signed-off-by: Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 man/ibv_post_send.3 |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/man/ibv_post_send.3 b/man/ibv_post_send.3
index 33fbb50..9571575 100644
--- a/man/ibv_post_send.3
+++ b/man/ibv_post_send.3
@@ -60,8 +60,18 @@ uint32_t        remote_qkey;    /* Q_Key number of the destination QP */
 } ud;
 .in -8
 } wr;
+union {
+.in +8
+struct {
+.in +8
+uint32_t remote_srqn;            /* Number of the remote SRQ */
+.in -8
+} xrc;
+.in -8
+} qp_type;
 .in -8
 };
+.fi
 .sp
 .nf
 struct ibv_sge {
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
