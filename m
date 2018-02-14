From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next 10/14] RDMa/uverbs: Copy ex_hdr outside of SRCU read lock
Date: Wed, 14 Feb 2018 14:38:40 +0200
Message-ID: <20180214123844.30321-11-leon@kernel.org>
References: <20180214123844.30321-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180214123844.30321-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Noa Osherovich <noaos-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

The SRCU read lock protects the IB device pointer
and doesn't need to be called before copying user
provided header.

Signed-off-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/core/uverbs_main.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/drivers/infiniband/core/uverbs_main.c b/drivers/infiniband/core/uverbs_main.c
index 71ffee0dc305..f8f2182ab86b 100644
--- a/drivers/infiniband/core/uverbs_main.c
+++ b/drivers/infiniband/core/uverbs_main.c
@@ -709,8 +709,12 @@ static ssize_t ib_uverbs_write(struct file *filp, const char __user *buf,
 	    (command != IB_USER_VERBS_CMD_GET_CONTEXT || extended))
 		return -EINVAL;
 
-	if (extended && count < (sizeof(hdr) + sizeof(ex_hdr)))
-		return -EINVAL;
+	if (extended) {
+		if (count < (sizeof(hdr) + sizeof(ex_hdr)))
+			return -EINVAL;
+		if (copy_from_user(&ex_hdr, buf + sizeof(hdr), sizeof(ex_hdr)))
+			return -EFAULT;
+	}
 
 	srcu_key = srcu_read_lock(&file->device->disassociate_srcu);
 	ib_dev = srcu_dereference(file->device->ib_dev,
@@ -740,11 +744,6 @@ static ssize_t ib_uverbs_write(struct file *filp, const char __user *buf,
 		struct ib_udata uhw;
 		size_t written_count = count;
 
-		if (copy_from_user(&ex_hdr, buf + sizeof(hdr), sizeof(ex_hdr))) {
-			ret = -EFAULT;
-			goto out;
-		}
-
 		count -= sizeof(hdr) + sizeof(ex_hdr);
 		buf += sizeof(hdr) + sizeof(ex_hdr);
 
-- 
2.16.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
