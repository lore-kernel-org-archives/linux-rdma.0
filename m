From: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Subject: [PATCHv4 for-3.13 09/10] IB/uverbs: check access to userspace response buffer in extended command
Date: Tue, 17 Dec 2013 10:58:58 +0100
Message-ID: <16ed474c560fe771e49d1cf0f0ee2b6c84e12234.1387273677.git.ydroneaud@opteya.com>
References: <cover.1387273677.git.ydroneaud@opteya.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1387273677.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
In-Reply-To: <cover.1387273677.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
References: <cover.1387273677.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This patch adds a check on the output buffer with access_ok(VERIFY_WRITE,
...) to ensure the whole buffer is in userspace memory before using the
pointer in uverbs functions. If the buffer or a subset of it is not valid,
returns -EFAULT to the caller.

This will also catch invalid buffer before the final call to copy_to_user()
which happen late in most uverb functions.

Just like the check in read(2) syscall, it's a sanity check to detect
invalid parameters provided by userspace. This particular check was added
in vfs_read() by Linus Torvalds for v2.6.12 with following commit message:

https://git.kernel.org/cgit/linux/kernel/git/tglx/history.git/commit/?id=fd770e66c9a65b14ce114e171266cf6f393df502

  Make read/write always do the full "access_ok()" tests.

  The actual user copy will do them too, but only for the
  range that ends up being actually copied. That hides
  bugs when the range has been clamped by file size or other
  issues.

Note: there's no need to check input buffer since vfs_write() already does
access_ok(VERIFY_READ, ...) as part of write() syscall.

Link: http://marc.info/?i=cover.1387273677.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org
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
