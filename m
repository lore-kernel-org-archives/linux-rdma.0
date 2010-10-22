From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: [PATCH] [IB/QIB] Process RDMA WRITE ONLY with IMMEDIATE properly
Date: Fri, 22 Oct 2010 16:00:48 -0600
Message-ID: <20101022220048.GA1998@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ralph Campbell <ralph.campbell-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>, RDMA list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

See table 35 in IBA - the header order for RDMA_WRITE_ONLY_WITH_IMMEDIATE
and SEND_LAST_WITH_IMMEDIATE is different, the RDMA_WRITE_ONLY has
a RETH header before the immediate data, so we need a different code path
to extract the immediate data.

I tested this with a userspace app that does RDMA_WRITE with immediate
on a QLE7140.

Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
---
 drivers/infiniband/hw/qib/qib_rc.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/drivers/infiniband/hw/qib/qib_rc.c b/drivers/infiniband/hw/qib/qib_rc.c
index 40c0a37..8d87ce3 100644
--- a/drivers/infiniband/hw/qib/qib_rc.c
+++ b/drivers/infiniband/hw/qib/qib_rc.c
@@ -2076,7 +2076,12 @@ send_last:
 			goto nack_op_err;
 		if (!ret)
 			goto rnr_nak;
-		goto send_last_imm;
+
+		wc.ex.imm_data = ohdr->u.rc.imm_data;
+		hdrsize += 4;
+		wc.wc_flags = IB_WC_WITH_IMM;
+
+		goto send_last;
 
 	case OP(RDMA_READ_REQUEST): {
 		struct qib_ack_entry *e;
-- 
1.6.0.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
