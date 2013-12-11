From: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Subject: [PATCHv3 for-3.13 8/9] IB/uverbs: check access to userspace response buffer in extended command
Date: Wed, 11 Dec 2013 23:01:51 +0100
Message-ID: <701fc3ee1136bbb4a0fd3d560c3ec1ee3bb3b828.1386798254.git.ydroneaud@opteya.com>
References: <cover.1386798254.git.ydroneaud@opteya.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1386798254.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
In-Reply-To: <cover.1386798254.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
References: <cover.1386798254.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Just like vfs_read(), uverbs_write() must check output buffer
(eg. response) with access_ok(VERIFY_WRITE,...) to ensure
it's in userspace memory before using the pointer in uverbs
functions.

If the buffer or a subset of the buffer is not valid,
returns -EFAULT.

Note: there's no need to check input buffer (eg. command)
since vfs_write() does the check access_ok(VERIFY_READ, ...)
as part of write() syscall.

Link: http://marc.info/?i=cover.1386798254.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Signed-off-by: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/core/uverbs_main.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/infiniband/core/uverbs_main.c b/drivers/infiniband/core/uverbs_main.c
index 8652c13f6ea2..0be1dd86f768 100644
--- a/drivers/infiniband/core/uverbs_main.c
+++ b/drivers/infiniband/core/uverbs_main.c
@@ -677,6 +677,11 @@ static ssize_t ib_uverbs_write(struct file *filp, const char __user *buf,
 		if (response) {
 			if (!hdr.out_words && !ex_hdr.provider_out_words)
 				return -EINVAL;
+
+			if (!access_ok(VERIFY_WRITE,
+				       response,
+				       (hdr.out_words + ex_hdr.provider_out_words) * 8))
+				return -EFAULT;
 		} else {
 			if (hdr.out_words || ex_hdr.provider_out_words)
 				return -EINVAL;
-- 
1.8.4.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
