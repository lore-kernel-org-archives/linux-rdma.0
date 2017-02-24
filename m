From: Minfei Huang <mnghuan@gmail.com>
Subject: [PATCH] ib_srp: Let compiler ignore the useless debug code
Date: Fri, 24 Feb 2017 16:44:51 +0800
Message-ID: <20170224084451.42117-1-mnghuan@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: bart.vanassche@sandisk.com, dledford@redhat.com, sean.hefty@intel.com, hal.rosenstock@gmail.com
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, Minfei Huang <mnghuan@gmail.com>
List-Id: linux-rdma@vger.kernel.org

"if (0)" is used to make this block of debug code not be executed. There
is a more elegant way to let compiler ignore this code, using
"#if 0 .. #endif" instead.

Although it may be optimised by some compilers with specified parameter,
just for readable.

Signed-off-by: Minfei Huang <mnghuan@gmail.com>
---
 drivers/infiniband/ulp/srp/ib_srp.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index 36529e3..f2d7821 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -2023,12 +2023,12 @@ static void srp_recv_done(struct ib_cq *cq, struct ib_wc *wc)
 
 	opcode = *(u8 *) iu->buf;
 
-	if (0) {
-		shost_printk(KERN_ERR, target->scsi_host,
-			     PFX "recv completion, opcode 0x%02x\n", opcode);
-		print_hex_dump(KERN_ERR, "", DUMP_PREFIX_OFFSET, 8, 1,
-			       iu->buf, wc->byte_len, true);
-	}
+#if 0
+	shost_printk(KERN_ERR, target->scsi_host,
+			PFX "recv completion, opcode 0x%02x\n", opcode);
+	print_hex_dump(KERN_ERR, "", DUMP_PREFIX_OFFSET, 8, 1,
+			iu->buf, wc->byte_len, true);
+#endif
 
 	switch (opcode) {
 	case SRP_RSP:
-- 
2.10.1 (Apple Git-78)
