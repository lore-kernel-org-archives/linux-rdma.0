From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: [PATCH] IB/srp: introduce print_hex_dump()
Date: Thu, 29 Jul 2010 17:56:37 +0200
Message-ID: <201007291756.37672.bvanassche@acm.org>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Reduces the number of source code lines in ib_srp.c by replacing an explicit
loop by a call to print_hex_dump().

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index ed3f9eb..a072719 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -879,21 +879,10 @@ static void srp_handle_recv(struct srp_target_port *target, struct ib_wc *wc)
 	opcode = *(u8 *) iu->buf;
 
 	if (0) {
-		int i;
-
 		shost_printk(KERN_ERR, target->scsi_host,
 			     PFX "recv completion, opcode 0x%02x\n", opcode);
-
-		for (i = 0; i < wc->byte_len; ++i) {
-			if (i % 8 == 0)
-				printk(KERN_ERR "  [%02x] ", i);
-			printk(" %02x", ((u8 *) iu->buf)[i]);
-			if ((i + 1) % 8 == 0)
-				printk("\n");
-		}
-
-		if (wc->byte_len % 8)
-			printk("\n");
+		print_hex_dump(KERN_ERR, "", DUMP_PREFIX_OFFSET, 8, 1,
+			       iu->buf, wc->byte_len, true);
 	}
 
 	switch (opcode) {
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
