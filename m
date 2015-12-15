From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-next V2 2/5] IB/core: Add ib_is_udata_cleared
Date: Tue, 15 Dec 2015 20:30:10 +0200
Message-ID: <1450204213-5630-3-git-send-email-matanb@mellanox.com>
References: <1450204213-5630-1-git-send-email-matanb@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1450204213-5630-1-git-send-email-matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Eran Ben Elisha <eranbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Extending core and vendor verb commands require us to check that the
unknown part of the user's given command is all zeros.
Adding ib_is_udata_cleared in order to do so.

Signed-off-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 include/rdma/ib_verbs.h | 27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 9a68a19..33ab4eb 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -50,6 +50,8 @@
 #include <linux/workqueue.h>
 #include <linux/socket.h>
 #include <uapi/linux/if_ether.h>
+#include <linux/string.h>
+#include <linux/slab.h>
 
 #include <linux/atomic.h>
 #include <linux/mmu_notifier.h>
@@ -1887,6 +1889,31 @@ static inline int ib_copy_to_udata(struct ib_udata *udata, void *src, size_t len
 	return copy_to_user(udata->outbuf, src, len) ? -EFAULT : 0;
 }
 
+static inline bool ib_is_udata_cleared(struct ib_udata *udata,
+				       size_t offset,
+				       size_t len)
+{
+	const void __user *p = udata->inbuf + offset;
+	bool ret = false;
+	u8 *buf;
+
+	if (len > USHRT_MAX)
+		return false;
+
+	buf = kmalloc(len, GFP_KERNEL);
+	if (!buf)
+		return false;
+
+	if (copy_from_user(buf, p, len))
+		goto free;
+
+	ret = !memchr_inv(buf, 0, len);
+
+free:
+	kfree(buf);
+	return ret;
+}
+
 /**
  * ib_modify_qp_is_ok - Check that the supplied attribute mask
  * contains all required attributes and no attributes not allowed for
-- 
2.1.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
