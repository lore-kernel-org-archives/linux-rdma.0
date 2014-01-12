From: Svetlana Mavrina <another.karnil@gmail.com>
Subject: [PATCH] amso1100: Add check if cache memory was allocated before freeing it
Date: Sun, 12 Jan 2014 11:56:09 +0000
Message-ID: <1389527769-6602-1-git-send-email-another.karnil@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: tom@opengridcomputing.com
Cc: Svetlana Mavrina <another.karnil@gmail.com>, swise@opengridcomputing.com, roland@kernel.org, sean.hefty@intel.com, hal.rosenstock@gmail.com, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, ldv-project@linuxtesting.org
List-Id: linux-rdma@vger.kernel.org

From: Svetlana Mavrina <another.karnil@gmail.com>

There is a path in handle_vq() where kmem_cache_free()
can be called with pointer to a local variable.
It can happen if vq_repbuf_alloc() failed to allocate memory from cache
and req is NULL.

The patch adds check if cache memory was allocated before freeing it.

Found by Linux Driver Verification project (linuxtesting.org).

Signed-off-by: Svetlana Mavrina <another.karnil@gmail.com>
Reviewed-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
---
 drivers/infiniband/hw/amso1100/c2_intr.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/amso1100/c2_intr.c b/drivers/infiniband/hw/amso1100/c2_intr.c
index 8951db4ae29d..3a17d9b36dba 100644
--- a/drivers/infiniband/hw/amso1100/c2_intr.c
+++ b/drivers/infiniband/hw/amso1100/c2_intr.c
@@ -169,7 +169,8 @@ static void handle_vq(struct c2_dev *c2dev, u32 mq_index)
 		 * We should never get here, as the adapter should
 		 * never send us a reply that we're not expecting.
 		 */
-		vq_repbuf_free(c2dev, host_msg);
+		if (reply_msg != NULL)
+			vq_repbuf_free(c2dev, host_msg);
 		pr_debug("handle_vq: UNEXPECTEDLY got NULL req\n");
 		return;
 	}
-- 
1.8.1.2
