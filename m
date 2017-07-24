From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH for-next 13/13] IB/hfi1: Split copy_to_user data copy for
 better security
Date: Mon, 24 Jul 2017 07:46:42 -0700
Message-ID: <20170724144641.10034.83618.stgit@scvm10.sc.intel.com>
References: <20170724144415.10034.26787.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170724144415.10034.26787.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Michael J. Ruhl" <michael.j.ruhl-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Michael J. Ruhl <michael.j.ruhl-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

A copy_to_user() call assumes that two members of a data structure
are sequential.  Since this may not always be true, separate the copies
to ensure a safe copy.

Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Michael J. Ruhl <michael.j.ruhl-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/file_ops.c |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/file_ops.c b/drivers/infiniband/hw/hfi1/file_ops.c
index 7be75e0..650c1e5 100644
--- a/drivers/infiniband/hw/hfi1/file_ops.c
+++ b/drivers/infiniband/hw/hfi1/file_ops.c
@@ -268,12 +268,14 @@ static long hfi1_file_ioctl(struct file *fp, unsigned int cmd,
 			/*
 			 * Copy the number of tidlist entries we used
 			 * and the length of the buffer we registered.
-			 * These fields are adjacent in the structure so
-			 * we can copy them at the same time.
 			 */
 			addr = arg + offsetof(struct hfi1_tid_info, tidcnt);
 			if (copy_to_user((void __user *)addr, &tinfo.tidcnt,
-					 sizeof(tinfo.tidcnt) +
+					 sizeof(tinfo.tidcnt)))
+				return -EFAULT;
+
+			addr = arg + offsetof(struct hfi1_tid_info, length);
+			if (copy_to_user((void __user *)addr, &tinfo.length,
 					 sizeof(tinfo.length)))
 				ret = -EFAULT;
 		}

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
