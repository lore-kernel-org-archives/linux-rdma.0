From: Yann Droneaud <ydroneaud@opteya.com>
Subject: [PATCH for v3.14 4/5] IB/qib: add missing braces in do_qib_user_sdma_queue_create()
Date: Mon, 10 Mar 2014 23:06:28 +0100
Message-ID: <f28ab1857476910252cb34ab79a377eef4e85890.1394485254.git.ydroneaud@opteya.com>
References: <cover.1394485254.git.ydroneaud@opteya.com>
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <cover.1394485254.git.ydroneaud@opteya.com>
In-Reply-To: <cover.1394485254.git.ydroneaud@opteya.com>
References: <cover.1394485254.git.ydroneaud@opteya.com>
Sender: stable-owner@vger.kernel.org
To: Roland Dreier <roland@purestorage.com>, Roland Dreier <roland@kernel.org>
Cc: linux-rdma@vger.kernel.org, Yann Droneaud <ydroneaud@opteya.com>, Mike Marciniszyn <mike.marciniszyn@intel.com>, infinipath@intel.com, Julia Lawall <julia.lawall@lip6.fr>, cocci@systeme.lip6.fr, stable@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

Commit c804f07248895ff9c moved qib_assign_ctxt() to
do_qib_user_sdma_queue_create() but dropped the braces
around the statements.

This was spotted by coccicheck (coccinelle/spatch):

$ make C=2 CHECK=scripts/coccicheck drivers/infiniband/hw/qib/

  CHECK   drivers/infiniband/hw/qib/qib_file_ops.c
drivers/infiniband/hw/qib/qib_file_ops.c:1583:2-23: code aligned with following code on line 1587

This patch adds braces back.

Link: http://marc.info/?i=cover.1394485254.git.ydroneaud@opteya.com
Cc: Mike Marciniszyn <mike.marciniszyn@intel.com>
Cc: infinipath@intel.com
Cc: Julia Lawall <julia.lawall@lip6.fr>
Cc: cocci@systeme.lip6.fr
Cc: stable@vger.kernel.org
Signed-off-by: Yann Droneaud <ydroneaud@opteya.com>
---
 drivers/infiniband/hw/qib/qib_file_ops.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/qib/qib_file_ops.c b/drivers/infiniband/hw/qib/qib_file_ops.c
index 275f247f9fca..2023cd61b897 100644
--- a/drivers/infiniband/hw/qib/qib_file_ops.c
+++ b/drivers/infiniband/hw/qib/qib_file_ops.c
@@ -1578,7 +1578,7 @@ static int do_qib_user_sdma_queue_create(struct file *fp)
 	struct qib_ctxtdata *rcd = fd->rcd;
 	struct qib_devdata *dd = rcd->dd;
 
-	if (dd->flags & QIB_HAS_SEND_DMA)
+	if (dd->flags & QIB_HAS_SEND_DMA) {
 
 		fd->pq = qib_user_sdma_queue_create(&dd->pcidev->dev,
 						    dd->unit,
@@ -1586,6 +1586,7 @@ static int do_qib_user_sdma_queue_create(struct file *fp)
 						    fd->subctxt);
 		if (!fd->pq)
 			return -ENOMEM;
+	}
 
 	return 0;
 }
-- 
1.8.5.3
