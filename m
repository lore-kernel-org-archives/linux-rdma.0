From: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] IB/qib: fix test of unsigned variable
Date: Mon, 11 May 2015 08:13:15 -0400
Message-ID: <20150511121315.21044.78464.stgit@phlsvslse11.ph.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Commit d4988623cc60 ("IB/qib: use arch_phys_wc_add()")
adjusted mtrr inititialization to use the new interface.

Unfortunately, the new interface returns a signed
value and the patch tested the unsigned wc_cookie.

Fix the issue by using 'ret' and only assigning
wc_cookie from ret when ret >= 0.   Additionally, insure
ret is 0 on success.

Signed-off-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/qib/qib_wc_x86_64.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/hw/qib/qib_wc_x86_64.c b/drivers/infiniband/hw/qib/qib_wc_x86_64.c
index 6d61ef9..85525be 100644
--- a/drivers/infiniband/hw/qib/qib_wc_x86_64.c
+++ b/drivers/infiniband/hw/qib/qib_wc_x86_64.c
@@ -116,9 +116,11 @@ int qib_enable_wc(struct qib_devdata *dd)
 	}
 
 	if (!ret) {
-		dd->wc_cookie = arch_phys_wc_add(pioaddr, piolen);
-		if (dd->wc_cookie < 0)
-			ret = -EINVAL;
+		ret = arch_phys_wc_add(pioaddr, piolen);
+		if (ret >= 0) {
+			dd->wc_cookie = ret;
+			ret = 0;
+		}
 	}
 
 	return ret;

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
