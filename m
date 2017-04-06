From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: [PATCH] IB/vmw_pvrdma: Spare annotate imm_data
Date: Thu, 6 Apr 2017 16:33:14 -0600
Message-ID: <20170406223314.GA3893@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Adit Ranadive <aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>, VMware PV-Drivers <pv-drivers-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

imm_data is copied directly from the ib_send_wr and ib_wc which have
it marked as __be32, copy that mark into the uapi structures as well.

Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
---
 include/uapi/rdma/vmw_pvrdma-abi.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

This fixes sparse errors in user space and kernel space

diff --git a/include/uapi/rdma/vmw_pvrdma-abi.h b/include/uapi/rdma/vmw_pvrdma-abi.h
index 5016abc9ee9712..c8c1d2d6df4d52 100644
--- a/include/uapi/rdma/vmw_pvrdma-abi.h
+++ b/include/uapi/rdma/vmw_pvrdma-abi.h
@@ -222,7 +222,7 @@ struct pvrdma_sq_wqe_hdr {
 	__u32 opcode;		/* operation type */
 	__u32 send_flags;	/* wr flags */
 	union {
-		__u32 imm_data;
+		__be32 imm_data;
 		__u32 invalidate_rkey;
 	} ex;
 	__u32 reserved;
@@ -273,7 +273,7 @@ struct pvrdma_cqe {
 	__u32 opcode;
 	__u32 status;
 	__u32 byte_len;
-	__u32 imm_data;
+	__be32 imm_data;
 	__u32 src_qp;
 	__u32 wc_flags;
 	__u32 vendor_err;
-- 
2.7.4
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
