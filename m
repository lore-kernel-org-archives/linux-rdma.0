From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 6/6] IB/qib,staging/rdma/hfi1: use setup_timer api
Date: Thu, 04 Feb 2016 11:03:45 -0800
Message-ID: <20160204190342.8378.4594.stgit@scvm10.sc.intel.com>
References: <20160204190024.8378.5080.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160204190024.8378.5080.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hari Prasath Gujulan Elango <hgujulan-Vi+0cqmPEYlBDgjK7y7TUQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Hari Prasath Gujulan Elango <hgujulan-Vi+0cqmPEYlBDgjK7y7TUQ@public.gmane.org>

Replace the timer API's to initialize a timer & then assign the callback
function by the setup_timer() API.

Signed-off-by: Hari Prasath Gujulan Elango <hgujulan-Vi+0cqmPEYlBDgjK7y7TUQ@public.gmane.org>
Signed-off-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/qib/qib_verbs.c |    4 +---
 drivers/staging/rdma/hfi1/verbs.c     |    4 +---
 2 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/infiniband/hw/qib/qib_verbs.c b/drivers/infiniband/hw/qib/qib_verbs.c
index 4158362..2abe31d 100644
--- a/drivers/infiniband/hw/qib/qib_verbs.c
+++ b/drivers/infiniband/hw/qib/qib_verbs.c
@@ -1602,9 +1602,7 @@ int qib_register_ib_device(struct qib_devdata *dd)
 		init_ibport(ppd + i);
 
 	/* Only need to initialize non-zero fields. */
-	init_timer(&dev->mem_timer);
-	dev->mem_timer.function = mem_timer;
-	dev->mem_timer.data = (unsigned long) dev;
+	setup_timer(&dev->mem_timer, mem_timer, (unsigned long)dev);
 
 	qpt_mask = dd->qpn_mask;
 
diff --git a/drivers/staging/rdma/hfi1/verbs.c b/drivers/staging/rdma/hfi1/verbs.c
index 0ee6b1d..35f6d92 100644
--- a/drivers/staging/rdma/hfi1/verbs.c
+++ b/drivers/staging/rdma/hfi1/verbs.c
@@ -1455,9 +1455,7 @@ int hfi1_register_ib_device(struct hfi1_devdata *dd)
 
 	/* Only need to initialize non-zero fields. */
 
-	init_timer(&dev->mem_timer);
-	dev->mem_timer.function = mem_timer;
-	dev->mem_timer.data = (unsigned long) dev;
+	setup_timer(&dev->mem_timer, mem_timer, (unsigned long)dev);
 
 	seqlock_init(&dev->iowait_lock);
 	INIT_LIST_HEAD(&dev->txwait);

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
