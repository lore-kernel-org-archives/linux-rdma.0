From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: [PATCH v2 rdma-core 7/8] vmw_pvrdma: Update kernel header
Date: Thu, 20 Jul 2017 11:01:03 -0600
Message-ID: <1500570064-11712-8-git-send-email-jgunthorpe@obsidianresearch.com>
References: <1500570064-11712-1-git-send-email-jgunthorpe@obsidianresearch.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1500570064-11712-1-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <notifications-9UaJU3cA/F/QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

For sparse to be clean we need the updated endian annotations.

>From kernel commit cc47dd684ee0 ("IB/vmw_pvrdma: Spare annotate imm_data")

Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Acked-by: Adit Ranadive <aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
---
 buildlib/fixup-include/rdma-vmw_pvrdma-abi.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/buildlib/fixup-include/rdma-vmw_pvrdma-abi.h b/buildlib/fixup-include/rdma-vmw_pvrdma-abi.h
index 5016abc9ee9712..c8c1d2d6df4d52 100644
--- a/buildlib/fixup-include/rdma-vmw_pvrdma-abi.h
+++ b/buildlib/fixup-include/rdma-vmw_pvrdma-abi.h
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
