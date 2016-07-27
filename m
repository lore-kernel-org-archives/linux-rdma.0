From: Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH libmlx5 1/6] fix size in malloc of qp->sq.wr_data
Date: Wed, 27 Jul 2016 15:17:22 -0400
Message-ID: <1469647047-7544-2-git-send-email-jarod@redhat.com>
References: <1469647047-7544-1-git-send-email-jarod@redhat.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1469647047-7544-1-git-send-email-jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Coverity complaint:

1. libmlx5-1.2.1/src/verbs.c:989: suspicious_sizeof: Passing argument
"qp->sq.wqe_cnt * 8UL /* sizeof (qp->sq.wr_data) */" to function "malloc"
and then casting the return value to "uint32_t *" is suspicious.
2. libmlx5-1.2.1/src/verbs.c:989: remediation: Did you intend to use
"sizeof (*qp->sq.wr_data)" instead of "sizeof (qp->sq.wr_data)"?

 #   987|   		}
 #   988|
 #   989|-> 		qp->sq.wr_data = malloc(qp->sq.wqe_cnt * sizeof(qp->sq.wr_data));
 #   990|   		if (!qp->sq.wr_data) {
 #   991|   			errno = ENOMEM;

The other mallocs in this same area properly use sizeof(*foo), this one
should too.

CC: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 src/verbs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/verbs.c b/src/verbs.c
index 40f66c6..7ed394e 100644
--- a/src/verbs.c
+++ b/src/verbs.c
@@ -986,7 +986,7 @@ static int mlx5_alloc_qp_buf(struct ibv_context *context,
 			return err;
 		}
 
-		qp->sq.wr_data = malloc(qp->sq.wqe_cnt * sizeof(qp->sq.wr_data));
+		qp->sq.wr_data = malloc(qp->sq.wqe_cnt * sizeof(*qp->sq.wr_data));
 		if (!qp->sq.wr_data) {
 			errno = ENOMEM;
 			err = -1;
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
