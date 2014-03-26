From: "Steve Wise" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: FW: [PATCH] RDMA/cxgb4: set error code on kmalloc() failure
Date: Wed, 26 Mar 2014 10:25:22 -0500
Message-ID: <005b01cf4907$9adfa320$d09ee960$@opengridcomputing.com>
References: <1395846311-29288-1-git-send-email-ydroneaud@opteya.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1395846311-29288-1-git-send-email-ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'David Miller' <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>, roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Acked-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>

Note: This fix applies only to net-next because the commit that introduced this is still
pending in net-next:

commit 05eb23893c2cf9502a9cec0c32e7f1d1ed2895c8
Author: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Date:   Fri Mar 14 21:52:08 2014 +0530

    cxgb4/iw_cxgb4: Doorbell Drop Avoidance Bug Fixes


Dave, can you please merge this?

Thanks,

Steve.

-----Original Message-----
From: Yann Droneaud [mailto:ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org] 
Sent: Wednesday, March 26, 2014 10:05 AM
To: Roland Dreier; Roland Dreier
Cc: Yann Droneaud; linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; Steve Wise; Steve Wise
Subject: [PATCH] RDMA/cxgb4: set error code on kmalloc() failure

If kmalloc() fails in c4iw_alloc_ucontext(), the function
leaves but does not set an error code in ret variable:
it will return 0 to the caller.

This patch set ret to -ENOMEM in such case.

Cc: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: Steve Wise <swise-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Signed-off-by: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/hw/cxgb4/provider.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/cxgb4/provider.c
b/drivers/infiniband/hw/cxgb4/provider.c
index e36d2a27c431..79429256023a 100644
--- a/drivers/infiniband/hw/cxgb4/provider.c
+++ b/drivers/infiniband/hw/cxgb4/provider.c
@@ -128,8 +128,10 @@ static struct ib_ucontext *c4iw_alloc_ucontext(struct ib_device
*ibdev,
 		rhp->rdev.flags |= T4_STATUS_PAGE_DISABLED;
 	} else {
 		mm = kmalloc(sizeof(*mm), GFP_KERNEL);
-		if (!mm)
+		if (!mm) {
+			ret = -ENOMEM;
 			goto err_free;
+		}
 
 		uresp.status_page_size = PAGE_SIZE;
 
-- 
1.9.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
