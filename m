From: Nicholas Mc Guire <hofrat@osadl.org>
Subject: [PATCH 3/3] staging/rdma/hfi1: fix build warning
Date: Mon, 14 Dec 2015 15:43:09 +0100
Message-ID: <1450104189-2653-3-git-send-email-hofrat@osadl.org>
References: <y>
 <1450104189-2653-1-git-send-email-hofrat@osadl.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1450104189-2653-1-git-send-email-hofrat@osadl.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Mike Marciniszyn <infinipath@intel.com>
Cc: Doug Ledford <dledford@redhat.com>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-rdma@vger.kernel.org, devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org, Nicholas Mc Guire <hofrat@osadl.org>
List-Id: linux-rdma@vger.kernel.org

fix the following build warning
drivers/staging/rdma/hfi1/chip.c: In function 'init_qos':
drivers/staging/rdma/hfi1/chip.c:10110:6: warning: unused variable
'rxcontext' [-Wunused-variable]

Signed-off-by: Nicholas Mc Guire <hofrat@osadl.org>
---

Patch was compile tested with: x86_64_defconfig
CONFIG_INFINIBAND=m, CONFIG_STAGING=y, CONFIG_STAGING_RDMA=m

Patch is against linux-next (localversion-next is -next-20151214)

 drivers/staging/rdma/hfi1/chip.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/staging/rdma/hfi1/chip.c b/drivers/staging/rdma/hfi1/chip.c
index 52d2bd7..ec368a8 100644
--- a/drivers/staging/rdma/hfi1/chip.c
+++ b/drivers/staging/rdma/hfi1/chip.c
@@ -10107,7 +10107,6 @@ static void init_qos(struct hfi1_devdata *dd, u32 first_ctxt)
 	unsigned qpns_per_vl, ctxt, i, qpn, n = 1, m;
 	u64 *rsmmap;
 	u64 reg;
-	u8  rxcontext = is_a0(dd) ? 0 : 0xff;  /* 0 is default if a0 ver. */
 
 	/* validate */
 	if (dd->n_krcv_queues <= MIN_KERNEL_KCTXTS ||
-- 
1.7.10.4
