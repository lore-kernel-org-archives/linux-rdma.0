From: Sergei Zviagintsev <sergei-E844GTqJAzo@public.gmane.org>
Subject: [PATCH] IB/qib: Remove EOL whitespaces
Date: Tue, 21 Apr 2015 02:47:02 +0300
Message-ID: <1429573622-893-1-git-send-email-sergei@s15v.net>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Mike Marciniszyn <infinipath-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Sergei Zviagintsev <sergei-E844GTqJAzo@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Remove EOL whitespaces added by commit 4961772560d2
("infinibad: weird APIs switched to ->write_iter()")

Signed-off-by: Sergei Zviagintsev <sergei-E844GTqJAzo@public.gmane.org>
---
 drivers/infiniband/hw/qib/qib_file_ops.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/qib/qib_file_ops.c b/drivers/infiniband/hw/qib/qib_file_ops.c
index 9ea6c440a00c..14414bc5a34d 100644
--- a/drivers/infiniband/hw/qib/qib_file_ops.c
+++ b/drivers/infiniband/hw/qib/qib_file_ops.c
@@ -2261,7 +2261,7 @@ static ssize_t qib_write_iter(struct kiocb *iocb, struct iov_iter *from)
 
 	if (!iter_is_iovec(from) || !from->nr_segs || !pq)
 		return -EINVAL;
-			 
+
 	return qib_user_sdma_writev(rcd, pq, from->iov, from->nr_segs);
 }
 
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
