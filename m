From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next 07/17] IB/cxgb3: Remove debug prints after allocation failure
Date: Thu,  3 Nov 2016 07:02:23 +0200
Message-ID: <1478149353-12125-8-git-send-email-leon@kernel.org>
References: <1478149353-12125-1-git-send-email-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1478149353-12125-1-git-send-email-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

The prints after [k|v][m|z|c]alloc() functions are not needed,
because in case of failure, allocator will print their internal
error prints anyway.

Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/hw/cxgb3/cxio_dbg.c | 20 ++++++++------------
 1 file changed, 8 insertions(+), 12 deletions(-)

diff --git a/drivers/infiniband/hw/cxgb3/cxio_dbg.c b/drivers/infiniband/hw/cxgb3/cxio_dbg.c
index 8bca6b4..445e89e 100644
--- a/drivers/infiniband/hw/cxgb3/cxio_dbg.c
+++ b/drivers/infiniband/hw/cxgb3/cxio_dbg.c
@@ -45,10 +45,9 @@ void cxio_dump_tpt(struct cxio_rdev *rdev, u32 stag)
 	int size = 32;
 
 	m = kmalloc(sizeof(*m) + size, GFP_ATOMIC);
-	if (!m) {
-		PDBG("%s couldn't allocate memory.\n", __func__);
+	if (!m)
 		return;
-	}
+
 	m->mem_id = MEM_PMRX;
 	m->addr = (stag>>8) * 32 + rdev->rnic_info.tpt_base;
 	m->len = size;
@@ -82,10 +81,9 @@ void cxio_dump_pbl(struct cxio_rdev *rdev, u32 pbl_addr, uint len, u8 shift)
 	size = npages * sizeof(u64);
 
 	m = kmalloc(sizeof(*m) + size, GFP_ATOMIC);
-	if (!m) {
-		PDBG("%s couldn't allocate memory.\n", __func__);
+	if (!m)
 		return;
-	}
+
 	m->mem_id = MEM_PMRX;
 	m->addr = pbl_addr;
 	m->len = size;
@@ -144,10 +142,9 @@ void cxio_dump_rqt(struct cxio_rdev *rdev, u32 hwtid, int nents)
 	int rc;
 
 	m = kmalloc(sizeof(*m) + size, GFP_ATOMIC);
-	if (!m) {
-		PDBG("%s couldn't allocate memory.\n", __func__);
+	if (!m)
 		return;
-	}
+
 	m->mem_id = MEM_PMRX;
 	m->addr = ((hwtid)<<10) + rdev->rnic_info.rqt_base;
 	m->len = size;
@@ -177,10 +174,9 @@ void cxio_dump_tcb(struct cxio_rdev *rdev, u32 hwtid)
 	int rc;
 
 	m = kmalloc(sizeof(*m) + size, GFP_ATOMIC);
-	if (!m) {
-		PDBG("%s couldn't allocate memory.\n", __func__);
+	if (!m)
 		return;
-	}
+
 	m->mem_id = MEM_CM;
 	m->addr = hwtid * size;
 	m->len = size;
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
