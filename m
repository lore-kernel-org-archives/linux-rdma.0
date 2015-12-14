From: Nicholas Mc Guire <hofrat@osadl.org>
Subject: [PATCH 1/3] staging/rdma/hfi1: consolidate kmalloc_array+memset into kcalloc
Date: Mon, 14 Dec 2015 15:43:07 +0100
Message-ID: <1450104189-2653-1-git-send-email-hofrat@osadl.org>
References: <y>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <y>
Sender: linux-kernel-owner@vger.kernel.org
To: Mike Marciniszyn <infinipath@intel.com>
Cc: Doug Ledford <dledford@redhat.com>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-rdma@vger.kernel.org, devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org, Nicholas Mc Guire <hofrat@osadl.org>
List-Id: linux-rdma@vger.kernel.org

rather than using kmalloc_array + memset it seems cleaner to simply use
kcalloc which will deliver memory set to zero.

Signed-off-by: Nicholas Mc Guire <hofrat@osadl.org>
---

Patch was compile tested with: x86_64_defconfig
CONFIG_INFINIBAND=m, CONFIG_STAGING=y, CONFIG_STAGING_RDMA=m

Patch is against linux-next (localversion-next is -next-20151214)

 drivers/staging/rdma/hfi1/chip.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/staging/rdma/hfi1/chip.c b/drivers/staging/rdma/hfi1/chip.c
index dc69159..31eec8a 100644
--- a/drivers/staging/rdma/hfi1/chip.c
+++ b/drivers/staging/rdma/hfi1/chip.c
@@ -10128,8 +10128,7 @@ static void init_qos(struct hfi1_devdata *dd, u32 first_ctxt)
 		goto bail;
 	if (num_vls * qpns_per_vl > dd->chip_rcv_contexts)
 		goto bail;
-	rsmmap = kmalloc_array(NUM_MAP_REGS, sizeof(u64), GFP_KERNEL);
-	memset(rsmmap, rxcontext, NUM_MAP_REGS * sizeof(u64));
+	rsmmap = kcalloc(NUM_MAP_REGS, sizeof(u64), GFP_KERNEL);
 	/* init the local copy of the table */
 	for (i = 0, ctxt = first_ctxt; i < num_vls; i++) {
 		unsigned tctxt;
-- 
1.7.10.4
