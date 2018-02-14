From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next 09/14] RDMA/uverbs: Move uncontext check before SRCU read lock
Date: Wed, 14 Feb 2018 14:38:39 +0200
Message-ID: <20180214123844.30321-10-leon@kernel.org>
References: <20180214123844.30321-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180214123844.30321-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Noa Osherovich <noaos-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

There is no need to take SRCU lock before checking
file->ucontext, so move it do it before it.

Signed-off-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/core/uverbs_main.c | 15 ++++-----------
 1 file changed, 4 insertions(+), 11 deletions(-)

diff --git a/drivers/infiniband/core/uverbs_main.c b/drivers/infiniband/core/uverbs_main.c
index 0cf3664cf7d4..71ffee0dc305 100644
--- a/drivers/infiniband/core/uverbs_main.c
+++ b/drivers/infiniband/core/uverbs_main.c
@@ -705,6 +705,10 @@ static ssize_t ib_uverbs_write(struct file *filp, const char __user *buf,
 	if (ret)
 		return ret;
 
+	if (!file->ucontext &&
+	    (command != IB_USER_VERBS_CMD_GET_CONTEXT || extended))
+		return -EINVAL;
+
 	if (extended && count < (sizeof(hdr) + sizeof(ex_hdr)))
 		return -EINVAL;
 
@@ -721,12 +725,6 @@ static ssize_t ib_uverbs_write(struct file *filp, const char __user *buf,
 		goto out;
 	}
 
-	if (!file->ucontext &&
-	    command != IB_USER_VERBS_CMD_GET_CONTEXT) {
-		ret = -EINVAL;
-		goto out;
-	}
-
 	if (!extended) {
 		if (hdr.in_words * 4 != count) {
 			ret = -EINVAL;
@@ -742,11 +740,6 @@ static ssize_t ib_uverbs_write(struct file *filp, const char __user *buf,
 		struct ib_udata uhw;
 		size_t written_count = count;
 
-		if (!file->ucontext) {
-			ret = -EINVAL;
-			goto out;
-		}
-
 		if (copy_from_user(&ex_hdr, buf + sizeof(hdr), sizeof(ex_hdr))) {
 			ret = -EFAULT;
 			goto out;
-- 
2.16.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
