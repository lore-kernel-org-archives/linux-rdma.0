From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH 5/6] IB/hfi1: Use bit 0 instead of bit 1
Date: Fri, 3 Jun 2016 12:10:37 -0700
Message-ID: <ff26909c-8aff-392e-e5eb-927d69fa2573@sandisk.com>
References: <86c06ca1-753c-6b45-3f65-f9a19f7693cf@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <86c06ca1-753c-6b45-3f65-f9a19f7693cf-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Marciniszyn, Mike" <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

The first argument of test_bit() and clear_bit() is a bit number and
not a bitmask. Hence change that first argument from (1 << 0) into 0.
This patch avoids that smatch reports the following warnings:

user_sdma.c:1059: sdma_cache_evict() warn: test_bit() takes a bit number
user_sdma.c:1590: sdma_rb_remove() warn: test_bit() takes a bit number

Signed-off-by: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/user_sdma.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/hfi1/user_sdma.c b/drivers/infiniband/hw/hfi1/user_sdma.c
index 29f4795..2eca5b7 100644
--- a/drivers/infiniband/hw/hfi1/user_sdma.c
+++ b/drivers/infiniband/hw/hfi1/user_sdma.c
@@ -183,7 +183,7 @@ struct user_sdma_iovec {
 	struct sdma_mmu_node *node;
 };
 
-#define SDMA_CACHE_NODE_EVICT BIT(0)
+#define SDMA_CACHE_NODE_EVICT 0
 
 struct sdma_mmu_node {
 	struct mmu_rb_node rb;
-- 
2.8.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
