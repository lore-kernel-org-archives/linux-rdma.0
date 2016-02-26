From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 6/7] staging/rdma/hfi1: Fix memory leaks
Date: Fri, 26 Feb 2016 13:33:33 -0800
Message-ID: <20160226213333.16535.24805.stgit@scvm10.sc.intel.com>
References: <20160226213022.16535.8149.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160226213022.16535.8149.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Fix 3 memory leaks reported by the LeakCheck tool in the KEDR framework.

The following resources were allocated memory during their respective
initializations but not freed during cleanup:
1. SDMA map elements
2. PIO map elements
3. HW send context to SW index map

This patch fixes the memory leaks by freeing the allocated memory in the
cleanup path.

Reviewed-by: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/staging/rdma/hfi1/init.c |    2 ++
 drivers/staging/rdma/hfi1/pio.c  |    2 +-
 drivers/staging/rdma/hfi1/sdma.c |    2 +-
 3 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/rdma/hfi1/init.c b/drivers/staging/rdma/hfi1/init.c
index 371ed29..37b3ce8 100644
--- a/drivers/staging/rdma/hfi1/init.c
+++ b/drivers/staging/rdma/hfi1/init.c
@@ -1324,6 +1324,8 @@ static void cleanup_device_data(struct hfi1_devdata *dd)
 	dd->num_send_contexts = 0;
 	kfree(dd->send_contexts);
 	dd->send_contexts = NULL;
+	kfree(dd->hw_to_sw);
+	dd->hw_to_sw = NULL;
 	kfree(dd->boardname);
 	vfree(dd->events);
 	vfree(dd->status);
diff --git a/drivers/staging/rdma/hfi1/pio.c b/drivers/staging/rdma/hfi1/pio.c
index 859cb46..361b43d 100644
--- a/drivers/staging/rdma/hfi1/pio.c
+++ b/drivers/staging/rdma/hfi1/pio.c
@@ -1881,7 +1881,7 @@ void free_pio_map(struct hfi1_devdata *dd)
 	/* Free PIO map if allocated */
 	if (rcu_access_pointer(dd->pio_map)) {
 		spin_lock_irq(&dd->pio_map_lock);
-		kfree(rcu_access_pointer(dd->pio_map));
+		pio_map_free(rcu_access_pointer(dd->pio_map));
 		RCU_INIT_POINTER(dd->pio_map, NULL);
 		spin_unlock_irq(&dd->pio_map_lock);
 		synchronize_rcu();
diff --git a/drivers/staging/rdma/hfi1/sdma.c b/drivers/staging/rdma/hfi1/sdma.c
index 56dc54a..0c688fe 100644
--- a/drivers/staging/rdma/hfi1/sdma.c
+++ b/drivers/staging/rdma/hfi1/sdma.c
@@ -966,7 +966,7 @@ static void sdma_clean(struct hfi1_devdata *dd, size_t num_engines)
 		sde->tx_ring = NULL;
 	}
 	spin_lock_irq(&dd->sde_map_lock);
-	kfree(rcu_access_pointer(dd->sdma_map));
+	sdma_map_free(rcu_access_pointer(dd->sdma_map));
 	RCU_INIT_POINTER(dd->sdma_map, NULL);
 	spin_unlock_irq(&dd->sde_map_lock);
 	synchronize_rcu();

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
