From: SF Markus Elfring <elfring-Rn4VEauK+AKRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Subject: [PATCH v2] IB/core: Use memdup_user() rather than duplicating its
 implementation
Date: Mon, 22 Aug 2016 18:30:33 +0200
Message-ID: <3a5989cb-5a01-f502-c7fc-c489079ee73e@users.sourceforge.net>
References: <566ABCD9.1060404@users.sourceforge.net>
 <f7bb3caf-81cd-fba9-afc8-5fac72b8a4b3@users.sourceforge.net>
 <1471802623.3746.1.camel@perches.com>
 <683187e0-2e6a-88c0-f87a-9c5f0489370a@users.sourceforge.net>
 <1471809188.3746.18.camel@perches.com>
 <5e87f691-edb9-0a12-ff7a-59854c2ca2f8@users.sourceforge.net>
 <1471859215.2764.24.camel@opteya.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1471859215.2764.24.camel-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Joe Perches <joe-6d6DIl74uiNBDgjK7y7TUQ@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Cc: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, kernel-janitors-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Julia Lawall <julia.lawall-L2FTfq7BK8M@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Markus Elfring <elfring-Rn4VEauK+AKRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Date: Mon, 22 Aug 2016 18:23:24 +0200

* Reuse existing functionality from memdup_user() instead of keeping
  duplicate source code.

  This issue was detected by using the Coccinelle software.

* The local variable "ret" will be set to an appropriate value a bit later.
  Thus omit the explicit initialisation at the beginning.

Signed-off-by: Markus Elfring <elfring-Rn4VEauK+AKRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
---

v2: The desired changes were put into a single patch instead of
    distributing them over two update steps.

 include/rdma/ib_verbs.h | 11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 6f667dd..0d8100f 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -2199,22 +2199,17 @@ static inline bool ib_is_udata_cleared(struct ib_udata *udata,
 				       size_t len)
 {
 	const void __user *p = udata->inbuf + offset;
-	bool ret = false;
+	bool ret;
 	u8 *buf;
 
 	if (len > USHRT_MAX)
 		return false;
 
-	buf = kmalloc(len, GFP_KERNEL);
-	if (!buf)
+	buf = memdup_user(p, len);
+	if (IS_ERR(buf))
 		return false;
 
-	if (copy_from_user(buf, p, len))
-		goto free;
-
 	ret = !memchr_inv(buf, 0, len);
-
-free:
 	kfree(buf);
 	return ret;
 }
-- 
2.9.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
