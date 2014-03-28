From: Randy Dunlap <rdunlap@infradead.org>
Subject: [PATCH -next] infiniband: fix iser_verbs.c format warning
Date: Fri, 28 Mar 2014 14:03:40 -0700
Message-ID: <5335E3AC.8080401@infradead.org>
References: <20140328180950.322d12920ce31e0ad3dace59@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-next-owner@vger.kernel.org>
In-Reply-To: <20140328180950.322d12920ce31e0ad3dace59@canb.auug.org.au>
Sender: linux-next-owner@vger.kernel.org
To: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Or Gerlitz <ogerlitz@mellanox.com>, Roi Dayan <roid@mellanox.com>, linux-rdma@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, Roland Dreier <roland@kernel.org>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>
List-Id: linux-rdma@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>

Fix pr_err (printk) format warning:

drivers/infiniband/ulp/iser/iser_verbs.c:1181:4: warning: format '%lx' expects argument of type 'long unsigned int', but argument 3 has type 'sector_t' [-Wformat]

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc:	Or Gerlitz <ogerlitz@mellanox.com>
Cc:	Roi Dayan <roid@mellanox.com>
Cc:	linux-rdma@vger.kernel.org
---
 drivers/infiniband/ulp/iser/iser_verbs.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- linux-next-20140328.orig/drivers/infiniband/ulp/iser/iser_verbs.c
+++ linux-next-20140328/drivers/infiniband/ulp/iser/iser_verbs.c
@@ -1178,9 +1178,10 @@ u8 iser_check_task_pi_status(struct iscs
 			do_div(sector_off, sector_size + 8);
 			*sector = scsi_get_lba(iser_task->sc) + sector_off;
 
-			pr_err("PI error found type %d at sector %lx "
+			pr_err("PI error found type %d at sector %llx "
 			       "expected %x vs actual %x\n",
-			       mr_status.sig_err.err_type, *sector,
+			       mr_status.sig_err.err_type,
+			       (unsigned long long)*sector,
 			       mr_status.sig_err.expected,
 			       mr_status.sig_err.actual);
 
