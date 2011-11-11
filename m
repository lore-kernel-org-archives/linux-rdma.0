From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: [PATCH 1/3] ib_srpt: Update encode_wr_id() argument type
Date: Fri, 11 Nov 2011 12:15:14 +0100
Message-ID: <201111111215.14297.bvanassche@acm.org>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Nicholas Bellinger <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>, Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Since commit 6b7227866 the first argument passed to encode_wr_id()
is always of type enum srpt_opcode. Make this explicit by updating
the function declaration. Also insert a blank line between
function definitions as is done in the rest of the Linux kernel.

Signed-off-by: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: Nicholas Bellinger <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>
Cc: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Cc: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
---
 drivers/infiniband/ulp/srpt/ib_srpt.h |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.h b/drivers/infiniband/ulp/srpt/ib_srpt.h
index fe9e81c..a484941 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.h
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.h
@@ -138,14 +138,16 @@ enum srpt_opcode {
 	SRPT_RDMA_WRITE_LAST,
 };
 
-static inline u64 encode_wr_id(u8 opcode, u32 idx)
+static inline u64 encode_wr_id(enum srpt_opcode opcode, u32 idx)
 {
 	return ((u64)opcode << 32) | idx;
 }
+
 static inline enum srpt_opcode opcode_from_wr_id(u64 wr_id)
 {
 	return wr_id >> 32;
 }
+
 static inline u32 idx_from_wr_id(u64 wr_id)
 {
 	return (u32)wr_id;
-- 
1.7.3.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
