From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [RFC ABI V5 07/10] IB/core: Support getting IOCTL header/SGEs from kernel space
Date: Thu, 27 Oct 2016 17:43:15 +0300
Message-ID: <1477579398-6875-8-git-send-email-matanb@mellanox.com>
References: <1477579398-6875-1-git-send-email-matanb@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1477579398-6875-1-git-send-email-matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

In order to allow compatability header, allow passing
ib_uverbs_ioctl_hdr and ib_uverbs_attr from kernel space.

Signed-off-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/core/uverbs_ioctl.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/drivers/infiniband/core/uverbs_ioctl.c b/drivers/infiniband/core/uverbs_ioctl.c
index 9d56b17..c02b6d5 100644
--- a/drivers/infiniband/core/uverbs_ioctl.c
+++ b/drivers/infiniband/core/uverbs_ioctl.c
@@ -176,10 +176,11 @@ static int uverbs_handle_action(struct ib_uverbs_attr __user *uattr_ptr,
 	return ret;
 }
 
-static long ib_uverbs_cmd_verbs(struct ib_device *ib_dev,
-				struct ib_uverbs_file *file,
-				struct ib_uverbs_ioctl_hdr *hdr,
-				void __user *buf)
+long ib_uverbs_cmd_verbs(struct ib_device *ib_dev,
+			 struct ib_uverbs_file *file,
+			 struct ib_uverbs_ioctl_hdr *hdr,
+			 void __user *buf,
+			 mm_segment_t oldfs)
 {
 	const struct uverbs_type *type;
 	const struct uverbs_action *action;
@@ -193,6 +194,7 @@ static long ib_uverbs_cmd_verbs(struct ib_device *ib_dev,
 	} *ctx = NULL;
 	struct uverbs_attr *curr_attr;
 	size_t ctx_size;
+	mm_segment_t currentfs = get_fs();
 
 	if (!ib_dev)
 		return -EIO;
@@ -240,8 +242,10 @@ static long ib_uverbs_cmd_verbs(struct ib_device *ib_dev,
 		goto out;
 	}
 
+	set_fs(oldfs);
 	err = uverbs_handle_action(buf, ctx->uattrs, hdr->num_attrs, ib_dev,
 				   file, action, ctx->uverbs_attr_array);
+	set_fs(currentfs);
 out:
 	kfree(ctx);
 	return err;
@@ -296,7 +300,8 @@ long ib_uverbs_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 		if (!down_read_trylock(&file->close_sem))
 			return -EIO;
 		err = ib_uverbs_cmd_verbs(ib_dev, file, &hdr,
-					  (__user void *)arg + sizeof(hdr));
+					  (__user void *)arg + sizeof(hdr),
+					  get_fs());
 		up_read(&file->close_sem);
 	}
 out:
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
