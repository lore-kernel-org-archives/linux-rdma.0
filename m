From: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Subject: [PATCHv3 for-3.13 4/9] IB/uverbs: check reserved field in extended command header
Date: Wed, 11 Dec 2013 23:01:47 +0100
Message-ID: <49b0607ea0a3e7bcc6333de36867f2dbd376650a.1386798254.git.ydroneaud@opteya.com>
References: <cover.1386798254.git.ydroneaud@opteya.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1386798254.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
In-Reply-To: <cover.1386798254.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
References: <cover.1386798254.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

As noted by Daniel Vetter in its article "Botching up ioctls"[1]

  "Check *all* unused fields and flags and all the padding for
   whether it's 0, and reject the ioctl if that's not the case.
   Otherwise your nice plan for future extensions is going right
   down the gutters since someone *will* submit an ioctl struct
   with random stack garbage in the yet unused parts. Which then
   bakes in the ABI that those fields can never be used for
   anything else but garbage."

It's important to ensure that reserved fields are set to known
value, so that it will be possible to use them latter to extend
the ABI.

The same reasonning apply to comp_mask field present in newer
uverbs command: per commit 22878dbc9173, unsupported values in
comp_mask are rejected.

[1] http://blog.ffwll.ch/2013/11/botching-up-ioctls.html

Link: http://marc.info/?i=cover.1386798254.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Signed-off-by: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/core/uverbs_main.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/infiniband/core/uverbs_main.c b/drivers/infiniband/core/uverbs_main.c
index 6c4fc6338b26..8652c13f6ea2 100644
--- a/drivers/infiniband/core/uverbs_main.c
+++ b/drivers/infiniband/core/uverbs_main.c
@@ -669,6 +669,9 @@ static ssize_t ib_uverbs_write(struct file *filp, const char __user *buf,
 		if ((hdr.in_words + ex_hdr.provider_in_words) * 8 != count)
 			return -EINVAL;
 
+		if (ex_hdr.cmd_hdr_reserved)
+			return -EINVAL;
+
 		response = (char __user *)(unsigned long)ex_hdr.response;
 
 		if (response) {
-- 
1.8.4.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
