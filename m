From: Julia Lawall <Julia.Lawall@lip6.fr>
Subject: [PATCH 3/3] IB/core: constify mmu_notifier_ops structures
Date: Sun, 29 Nov 2015 23:02:51 +0100
Message-ID: <1448834571-2988-4-git-send-email-Julia.Lawall@lip6.fr>
References: <1448834571-2988-1-git-send-email-Julia.Lawall@lip6.fr>
Return-path: <kernel-janitors-owner@vger.kernel.org>
In-Reply-To: <1448834571-2988-1-git-send-email-Julia.Lawall@lip6.fr>
Sender: kernel-janitors-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: kernel-janitors@vger.kernel.org, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

This mmu_notifier_ops structure is never modified, so declare it as
const, like the other mmu_notifier_ops structures.

Done with the help of Coccinelle.

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
The patches in this series are independent of each other.

 drivers/infiniband/core/umem_odp.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/core/umem_odp.c b/drivers/infiniband/core/umem_odp.c
index 40becdb..e69bf26 100644
--- a/drivers/infiniband/core/umem_odp.c
+++ b/drivers/infiniband/core/umem_odp.c
@@ -232,7 +232,7 @@ static void ib_umem_notifier_invalidate_range_end(struct mmu_notifier *mn,
 	ib_ucontext_notifier_end_account(context);
 }
 
-static struct mmu_notifier_ops ib_umem_notifiers = {
+static const struct mmu_notifier_ops ib_umem_notifiers = {
 	.release                    = ib_umem_notifier_release,
 	.invalidate_page            = ib_umem_notifier_invalidate_page,
 	.invalidate_range_start     = ib_umem_notifier_invalidate_range_start,

