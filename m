From: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v2] IB/hfi1: Prevent a NULL dereference
Date: Tue, 9 Jan 2018 23:03:46 +0300
Message-ID: <20180109200346.rlsrxa24xmltpz2r@mwanda>
References: <14063C7AD467DE4B82DEDB5C278E8663A9F7F391@fmsmsx107.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <14063C7AD467DE4B82DEDB5C278E8663A9F7F391-96pTJSsuoYRzLByeVOV5+bfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-janitors-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

In the original code, we set "fd->uctxt" to NULL and then dereference it
which will cause an Oops.

Fixes: f2a3bc00a03c ("IB/hfi1: Protect context array set/clear with spinlock")
Signed-off-by: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
---
v2: In v1, I accidentally moved the __clear_bit() out from under the
    spin_lock().  Thanks for the review, Michael!

diff --git a/drivers/infiniband/hw/hfi1/file_ops.c b/drivers/infiniband/hw/hfi1/file_ops.c
index 82086241aac3..bd6f03cc5ee0 100644
--- a/drivers/infiniband/hw/hfi1/file_ops.c
+++ b/drivers/infiniband/hw/hfi1/file_ops.c
@@ -763,11 +763,11 @@ static int complete_subctxt(struct hfi1_filedata *fd)
 	}
 
 	if (ret) {
-		hfi1_rcd_put(fd->uctxt);
-		fd->uctxt = NULL;
 		spin_lock_irqsave(&fd->dd->uctxt_lock, flags);
 		__clear_bit(fd->subctxt, fd->uctxt->in_use_ctxts);
 		spin_unlock_irqrestore(&fd->dd->uctxt_lock, flags);
+		hfi1_rcd_put(fd->uctxt);
+		fd->uctxt = NULL;
 	}
 
 	return ret;
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
