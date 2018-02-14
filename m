From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next 11/14] RDMA/uverbs: Refactor the header validation logic
Date: Wed, 14 Feb 2018 14:38:41 +0200
Message-ID: <20180214123844.30321-12-leon@kernel.org>
References: <20180214123844.30321-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180214123844.30321-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Noa Osherovich <noaos-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Move all header validation logic to be performed before SRCU read lock.

Signed-off-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/core/uverbs_main.c | 90 ++++++++++++++++++-----------------
 1 file changed, 47 insertions(+), 43 deletions(-)

diff --git a/drivers/infiniband/core/uverbs_main.c b/drivers/infiniband/core/uverbs_main.c
index f8f2182ab86b..e07326139ce9 100644
--- a/drivers/infiniband/core/uverbs_main.c
+++ b/drivers/infiniband/core/uverbs_main.c
@@ -677,6 +677,42 @@ static ssize_t process_hdr(struct ib_uverbs_cmd_hdr *hdr,
 	return 0;
 }
 
+static ssize_t verify_hdr(struct ib_uverbs_cmd_hdr *hdr,
+			  struct ib_uverbs_ex_cmd_hdr *ex_hdr,
+			  size_t count, bool extended)
+{
+	if (extended) {
+		count -= sizeof(*hdr) + sizeof(*ex_hdr);
+
+		if ((hdr->in_words + ex_hdr->provider_in_words) * 8 != count)
+			return -EINVAL;
+
+		if (ex_hdr->cmd_hdr_reserved)
+			return -EINVAL;
+
+		if (ex_hdr->response) {
+			if (!hdr->out_words && !ex_hdr->provider_out_words)
+				return -EINVAL;
+
+			if (!access_ok(VERIFY_WRITE,
+				       u64_to_user_ptr(ex_hdr->response),
+				       (hdr->out_words + ex_hdr->provider_out_words) * 8))
+				return -EFAULT;
+		} else {
+			if (hdr->out_words || ex_hdr->provider_out_words)
+				return -EINVAL;
+		}
+
+		return 0;
+	}
+
+	/* not extended command */
+	if (hdr->in_words * 4 != count)
+		return -EINVAL;
+
+	return 0;
+}
+
 static ssize_t ib_uverbs_write(struct file *filp, const char __user *buf,
 			     size_t count, loff_t *pos)
 {
@@ -716,6 +752,10 @@ static ssize_t ib_uverbs_write(struct file *filp, const char __user *buf,
 			return -EFAULT;
 	}
 
+	ret = verify_hdr(&hdr, &ex_hdr, count, extended);
+	if (ret)
+		return ret;
+
 	srcu_key = srcu_read_lock(&file->device->disassociate_srcu);
 	ib_dev = srcu_dereference(file->device->ib_dev,
 				  &file->device->disassociate_srcu);
@@ -729,52 +769,17 @@ static ssize_t ib_uverbs_write(struct file *filp, const char __user *buf,
 		goto out;
 	}
 
-	if (!extended) {
-		if (hdr.in_words * 4 != count) {
-			ret = -EINVAL;
-			goto out;
-		}
+	buf += sizeof(hdr);
 
-		ret = uverbs_cmd_table[command](file, ib_dev,
-						 buf + sizeof(hdr),
-						 hdr.in_words * 4,
-						 hdr.out_words * 4);
+	if (!extended) {
+		ret = uverbs_cmd_table[command](file, ib_dev, buf,
+						hdr.in_words * 4,
+						hdr.out_words * 4);
 	} else {
 		struct ib_udata ucore;
 		struct ib_udata uhw;
-		size_t written_count = count;
-
-		count -= sizeof(hdr) + sizeof(ex_hdr);
-		buf += sizeof(hdr) + sizeof(ex_hdr);
 
-		if ((hdr.in_words + ex_hdr.provider_in_words) * 8 != count) {
-			ret = -EINVAL;
-			goto out;
-		}
-
-		if (ex_hdr.cmd_hdr_reserved) {
-			ret = -EINVAL;
-			goto out;
-		}
-
-		if (ex_hdr.response) {
-			if (!hdr.out_words && !ex_hdr.provider_out_words) {
-				ret = -EINVAL;
-				goto out;
-			}
-
-			if (!access_ok(VERIFY_WRITE,
-				       u64_to_user_ptr(ex_hdr.response),
-				       (hdr.out_words + ex_hdr.provider_out_words) * 8)) {
-				ret = -EFAULT;
-				goto out;
-			}
-		} else {
-			if (hdr.out_words || ex_hdr.provider_out_words) {
-				ret = -EINVAL;
-				goto out;
-			}
-		}
+		buf += sizeof(ex_hdr);
 
 		ib_uverbs_init_udata_buf_or_null(&ucore, buf,
 					u64_to_user_ptr(ex_hdr.response),
@@ -787,8 +792,7 @@ static ssize_t ib_uverbs_write(struct file *filp, const char __user *buf,
 					ex_hdr.provider_out_words * 8);
 
 		ret = uverbs_ex_cmd_table[command](file, ib_dev, &ucore, &uhw);
-		if (!ret)
-			ret = written_count;
+		ret = (ret) ? : count;
 	}
 
 out:
-- 
2.16.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
