From: Jan Dakinevich <jan.dakinevich@virtuozzo.com>
Subject: [PATCH] ib_srpt: use kvmalloc to allocate ring pointers
Date: Mon,  9 Jul 2018 16:51:08 +0300
Message-ID: <1531144268-25361-1-git-send-email-jan.dakinevich@virtuozzo.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>, Bart Van Assche <bart.vanassche@wdc.com>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Denis Lunev <den@virtuozzo.com>, Konstantin Khorenko <khorenko@virtuozzo.com>, Jan Dakinevich <jan.dakinevich@virtuozzo.com>
List-Id: linux-rdma@vger.kernel.org

An array of pointers to SRPT contexts in ib_device is over 30KiB even
in default case, in which an amount of contexts is 4095. The patch
is intended to weed out large contigous allocation for non-DMA memory.

Signed-off-by: Jan Dakinevich <jan.dakinevich@virtuozzo.com>
---
 drivers/infiniband/ulp/srpt/ib_srpt.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniband/ulp/srpt/ib_srpt.c
index 3081c62..de167af 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.c
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
@@ -720,7 +720,7 @@ static struct srpt_ioctx **srpt_alloc_ioctx_ring(struct srpt_device *sdev,
 	WARN_ON(ioctx_size != sizeof(struct srpt_recv_ioctx)
 		&& ioctx_size != sizeof(struct srpt_send_ioctx));
 
-	ring = kmalloc_array(ring_size, sizeof(ring[0]), GFP_KERNEL);
+	ring = kvmalloc_array(ring_size, sizeof(ring[0]), GFP_KERNEL);
 	if (!ring)
 		goto out;
 	for (i = 0; i < ring_size; ++i) {
@@ -734,7 +734,7 @@ static struct srpt_ioctx **srpt_alloc_ioctx_ring(struct srpt_device *sdev,
 err:
 	while (--i >= 0)
 		srpt_free_ioctx(sdev, ring[i], dma_size, dir);
-	kfree(ring);
+	kvfree(ring);
 	ring = NULL;
 out:
 	return ring;
@@ -759,7 +759,7 @@ static void srpt_free_ioctx_ring(struct srpt_ioctx **ioctx_ring,
 
 	for (i = 0; i < ring_size; ++i)
 		srpt_free_ioctx(sdev, ioctx_ring[i], dma_size, dir);
-	kfree(ioctx_ring);
+	kvfree(ioctx_ring);
 }
 
 /**
-- 
2.1.4
