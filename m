From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH] IB/iser: use sector_div instead of do_div
Date: Fri, 20 Nov 2015 17:41:36 +0100
Message-ID: <5922990.8IJpyksX8K@wuerfel>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Or Gerlitz <ogerlitz@mellanox.com>, Sagi Grimberg <sagig@mellanox.com>
Cc: nico@fluxnic.net, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, Roi Dayan <roid@mellanox.com>, Doug Ledford <dledford@redhat.com>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, linux-rdma@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

do_div is the wrong way to divide a sector_t, as it is less
efficient when sector_t is 32-bit wide. With the upcoming
do_div optimizations, the kernel starts warning about this:

drivers/infiniband/ulp/iser/iser_verbs.c:1296:4: note: in expansion of macro 'do_div'
include/asm-generic/div64.h:224:22: warning: passing argument 1 of '__div64_32' from incompatible pointer type

This changes the code to use sector_div instead, which always
produces optimal code.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>

diff --git a/drivers/infiniband/ulp/iser/iser_verbs.c b/drivers/infiniband/ulp/iser/iser_verbs.c
index a93070210109..42f4da620f2e 100644
--- a/drivers/infiniband/ulp/iser/iser_verbs.c
+++ b/drivers/infiniband/ulp/iser/iser_verbs.c
@@ -1293,7 +1293,7 @@ u8 iser_check_task_pi_status(struct iscsi_iser_task *iser_task,
 		if (mr_status.fail_status & IB_MR_CHECK_SIG_STATUS) {
 			sector_t sector_off = mr_status.sig_err.sig_err_offset;
 
-			do_div(sector_off, sector_size + 8);
+			sector_div(sector_off, sector_size + 8);
 			*sector = scsi_get_lba(iser_task->sc) + sector_off;
 
 			pr_err("PI error found type %d at sector %llx "
