From: Wei Yongjun <weiyj.lk-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v2] qedr: remove pointless NULL check in qedr_post_send()
Date: Wed,  2 Nov 2016 13:11:32 +0000
Message-ID: <1478092292-17225-1-git-send-email-weiyj.lk@gmail.com>
References: <1477672406-31487-1-git-send-email-weiyj.lk@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1477672406-31487-1-git-send-email-weiyj.lk-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Ram Amrani <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, Rajesh Borundia <rajesh.borundia-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Wei Yongjun <weiyongjun1-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Wei Yongjun <weiyongjun1-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

Remove pointless NULL check for 'wr' in qedr_post_send().

Signed-off-by: Wei Yongjun <weiyongjun1-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
v1 -> v2: remove pointless NULL check as Ram's suggestion
---
 drivers/infiniband/hw/qedr/verbs.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/infiniband/hw/qedr/verbs.c b/drivers/infiniband/hw/qedr/verbs.c
index a615142..ed7521a 100644
--- a/drivers/infiniband/hw/qedr/verbs.c
+++ b/drivers/infiniband/hw/qedr/verbs.c
@@ -2981,11 +2981,6 @@ int qedr_post_send(struct ib_qp *ibqp, struct ib_send_wr *wr,
 		return -EINVAL;
 	}
 
-	if (!wr) {
-		DP_ERR(dev, "Got an empty post send.\n");
-		return -EINVAL;
-	}
-
 	while (wr) {
 		rc = __qedr_post_send(ibqp, wr, bad_wr);
 		if (rc)

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
