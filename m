From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: [PATCH 3/4] IB/srpt: Introduce two helper functions
Date: Wed, 6 Apr 2016 11:57:20 -0700
Message-ID: <57055C10.3060108@sandisk.com>
References: <57055BC6.7070402@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <57055BC6.7070402@sandisk.com>
Sender: target-devel-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, target-devel <target-devel@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

Move the functionality for initializing and cleaning up I/O
contexts into two new functions. This patch does not change any
functionality.

Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: Nicholas Bellinger <nab@linux-iscsi.org>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Sagi Grimberg <sagig@mellanox.com>
---
 drivers/infiniband/ulp/srpt/ib_srpt.c | 64 +++++++++++++++++++++++++++--------
 1 file changed, 49 insertions(+), 15 deletions(-)

diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniband/ulp/srpt/ib_srpt.c
index 07dfc50..cce6c46 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.c
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
@@ -581,6 +581,31 @@ static void srpt_unregister_mad_agent(struct srpt_device *sdev)
 	}
 }
 
+static int srpt_init_ioctx(struct srpt_device *sdev,
+					  struct srpt_ioctx *ioctx,
+					  int dma_size,
+					  enum dma_data_direction dir)
+{
+	int ret = -ENOMEM;
+
+	ioctx->buf = kmalloc(dma_size, GFP_KERNEL);
+	if (!ioctx->buf)
+		goto out;
+
+	ioctx->dma = ib_dma_map_single(sdev->device, ioctx->buf, dma_size, dir);
+	if (ib_dma_mapping_error(sdev->device, ioctx->dma))
+		goto free_buf;
+
+	ret = 0;
+
+out:
+	return ret;
+
+free_buf:
+	kfree(ioctx->buf);
+	goto out;
+}
+
 /**
  * srpt_alloc_ioctx() - Allocate an SRPT I/O context structure.
  */
@@ -592,24 +617,34 @@ static struct srpt_ioctx *srpt_alloc_ioctx(struct srpt_device *sdev,
 
 	ioctx = kmalloc(ioctx_size, GFP_KERNEL);
 	if (!ioctx)
-		goto err;
-
-	ioctx->buf = kmalloc(dma_size, GFP_KERNEL);
-	if (!ioctx->buf)
-		goto err_free_ioctx;
+		goto out;
 
-	ioctx->dma = ib_dma_map_single(sdev->device, ioctx->buf, dma_size, dir);
-	if (ib_dma_mapping_error(sdev->device, ioctx->dma))
-		goto err_free_buf;
+	if (srpt_init_ioctx(sdev, ioctx, dma_size, dir) < 0)
+		goto free;
 
+out:
 	return ioctx;
 
-err_free_buf:
-	kfree(ioctx->buf);
-err_free_ioctx:
+free:
 	kfree(ioctx);
-err:
-	return NULL;
+	ioctx = NULL;
+	goto out;
+}
+
+/*
+ * Note: it is safe to call this function for a zero-initialized buffer
+ * even if srpt_init_ioctx() has not been called.
+ */
+static void srpt_cleanup_ioctx(struct srpt_device *sdev,
+			       struct srpt_ioctx *ioctx,
+			       int dma_size,
+			       enum dma_data_direction dir)
+{
+	if (!ioctx->buf)
+		return;
+
+	ib_dma_unmap_single(sdev->device, ioctx->dma, dma_size, dir);
+	kfree(ioctx->buf);
 }
 
 /**
@@ -621,8 +656,7 @@ static void srpt_free_ioctx(struct srpt_device *sdev, struct srpt_ioctx *ioctx,
 	if (!ioctx)
 		return;
 
-	ib_dma_unmap_single(sdev->device, ioctx->dma, dma_size, dir);
-	kfree(ioctx->buf);
+	srpt_cleanup_ioctx(sdev, ioctx, dma_size, dir);
 	kfree(ioctx);
 }
 
-- 
2.7.4
