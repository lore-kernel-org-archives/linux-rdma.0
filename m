From: Nicholas Mc Guire <hofrat@osadl.org>
Subject: [PATCH 2/3] staging/rdma/hfi1: check return value of kcalloc
Date: Mon, 14 Dec 2015 15:43:08 +0100
Message-ID: <1450104189-2653-2-git-send-email-hofrat@osadl.org>
References: <y>
 <1450104189-2653-1-git-send-email-hofrat@osadl.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1450104189-2653-1-git-send-email-hofrat@osadl.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Mike Marciniszyn <infinipath@intel.com>
Cc: Doug Ledford <dledford@redhat.com>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-rdma@vger.kernel.org, devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org, Nicholas Mc Guire <hofrat@osadl.org>
List-Id: linux-rdma@vger.kernel.org

Add a null check after the kcalloc call as proposed by
Mike Marciniszyn <mike.marciniszyn@intel.com>.

Signed-off-by: Nicholas Mc Guire <hofrat@osadl.org>
---

Patch was compile tested with: x86_64_defconfig
CONFIG_INFINIBAND=m, CONFIG_STAGING=y, CONFIG_STAGING_RDMA=m

Patch is against linux-next (localversion-next is -next-20151214)

 drivers/staging/rdma/hfi1/chip.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/staging/rdma/hfi1/chip.c b/drivers/staging/rdma/hfi1/chip.c
index 31eec8a..52d2bd7 100644
--- a/drivers/staging/rdma/hfi1/chip.c
+++ b/drivers/staging/rdma/hfi1/chip.c
@@ -10129,6 +10129,9 @@ static void init_qos(struct hfi1_devdata *dd, u32 first_ctxt)
 	if (num_vls * qpns_per_vl > dd->chip_rcv_contexts)
 		goto bail;
 	rsmmap = kcalloc(NUM_MAP_REGS, sizeof(u64), GFP_KERNEL);
+	if (!rsmmap)
+		goto bail;
+
 	/* init the local copy of the table */
 	for (i = 0, ctxt = first_ctxt; i < num_vls; i++) {
 		unsigned tctxt;
-- 
1.7.10.4
