From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 2/4] IB/core: Fix atomic regression with ib_hdrs
Date: Fri, 30 Sep 2016 20:11:04 -0700
Message-ID: <20161001031103.15264.95520.stgit@scvm10.sc.intel.com>
References: <20161001030935.15264.34730.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20161001030935.15264.34730.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

The struct containing atomic_ack_eth isn't packed
which causes the atomic ack 64 bit values to be offset
incorrectly breaking atomic operations for qib and hfi1.

Fix by declaring the struct packed.

There were some inline declarations missing in the new
accessors.  Add those.

Fixes: ea454191a7a9 ("IB/core: Add ib headers for general use")
Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 include/rdma/ib_hdrs.h |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/rdma/ib_hdrs.h b/include/rdma/ib_hdrs.h
index 879faf6..408439f 100644
--- a/include/rdma/ib_hdrs.h
+++ b/include/rdma/ib_hdrs.h
@@ -100,7 +100,7 @@ union ib_ehdrs {
 	struct {
 		__be32 aeth;
 		__be64 atomic_ack_eth; /* potentially unaligned */
-	} at;
+	} __packed at;
 	__be32 imm_data;
 	__be32 aeth;
 	__be32 ieth;
@@ -125,12 +125,12 @@ struct ib_header {
 
 /* accessors for unaligned __be64 items */
 
-static u64 ib_u64_get(__be64 *p)
+static inline u64 ib_u64_get(__be64 *p)
 {
 	return get_unaligned_be64(p);
 }
 
-static void ib_u64_put(u64 val, __be64 *p)
+static inline void ib_u64_put(u64 val, __be64 *p)
 {
 	put_unaligned_be64(val, p);
 }

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
