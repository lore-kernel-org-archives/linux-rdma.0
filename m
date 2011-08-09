From: Julia Lawall <julia@diku.dk>
Subject: [PATCH] drivers/infiniband/hw/nes/nes_verbs.c: add missing calls to ib_umem_release
Date: Tue,  9 Aug 2011 16:16:31 +0200
Message-ID: <1312899391-6619-1-git-send-email-julia@diku.dk>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Faisal Latif <faisal.latif@intel.com>
Cc: kernel-janitors@vger.kernel.org, Roland Dreier <roland@kernel.org>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

Add calls to ib_umem_release, as in the other error-handling code in the
same function.

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/infiniband/hw/nes/nes_verbs.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/nes/nes_verbs.c b/drivers/infiniband/hw/nes/nes_verbs.c
index 9f2f7d4..394d0e7 100644
--- a/drivers/infiniband/hw/nes/nes_verbs.c
+++ b/drivers/infiniband/hw/nes/nes_verbs.c
@@ -2338,8 +2338,10 @@ static struct ib_mr *nes_reg_user_mr(struct ib_pd *pd, u64 start, u64 length,
 
 	skip_pages = ((u32)region->offset) >> 12;
 
-	if (ib_copy_from_udata(&req, udata, sizeof(req)))
+	if (ib_copy_from_udata(&req, udata, sizeof(req))) {
+		ib_umem_release(region);
 		return ERR_PTR(-EFAULT);
+	}
 	nes_debug(NES_DBG_MR, "Memory Registration type = %08X.\n", req.reg_type);
 
 	switch (req.reg_type) {
@@ -2631,6 +2633,7 @@ static struct ib_mr *nes_reg_user_mr(struct ib_pd *pd, u64 start, u64 length,
 			return &nesmr->ibmr;
 	}
 
+	ib_umem_release(region);
 	return ERR_PTR(-ENOSYS);
 }
 
