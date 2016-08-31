From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 2/5] IB/hfi1: Fix AHG KDETH Intr shift
Date: Wed, 31 Aug 2016 07:24:27 -0700
Message-ID: <20160831142425.27232.97663.stgit@scvm10.sc.intel.com>
References: <20160831141841.27232.61621.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160831141841.27232.61621.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: Harish Chegondi <harish.chegondi-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mitko Haralanov <mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

In the set_txreq_header_ahg(), The KDETH Intr bit is obtained from the
header in the user sdma request using a KDETH_GET shift and mask macro.
This value is then futher right shifted by 16 causing us to lose the
value i.e it is shifted to zero, leading to the following
smatch warning:
drivers/infiniband/hw/hfi1/user_sdma.c:1482 set_txreq_header_ahg()
warn: mask and shift to zero

The Intr bit should be left shifted into its correct position in the
KDETH header before the AHG update.

Reported-by: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Reviewed-by: Mitko Haralanov <mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Harish Chegondi <harish.chegondi-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/user_sdma.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/user_sdma.c b/drivers/infiniband/hw/hfi1/user_sdma.c
index 0ecf279..1694037 100644
--- a/drivers/infiniband/hw/hfi1/user_sdma.c
+++ b/drivers/infiniband/hw/hfi1/user_sdma.c
@@ -114,6 +114,8 @@ MODULE_PARM_DESC(sdma_comp_size, "Size of User SDMA completion ring. Default: 12
 #define KDETH_HCRC_LOWER_SHIFT    24
 #define KDETH_HCRC_LOWER_MASK     0xff
 
+#define AHG_KDETH_INTR_SHIFT 12
+
 #define PBC2LRH(x) ((((x) & 0xfff) << 2) - 4)
 #define LRH2PBC(x) ((((x) >> 2) + 1) & 0xfff)
 
@@ -1480,7 +1482,8 @@ static int set_txreq_header_ahg(struct user_sdma_request *req,
 		/* Clear KDETH.SH on last packet */
 		if (unlikely(tx->flags & TXREQ_FLAGS_REQ_LAST_PKT)) {
 			val |= cpu_to_le16(KDETH_GET(hdr->kdeth.ver_tid_offset,
-								INTR) >> 16);
+						     INTR) <<
+					   AHG_KDETH_INTR_SHIFT);
 			val &= cpu_to_le16(~(1U << 13));
 			AHG_HEADER_SET(req->ahg, diff, 7, 16, 14, val);
 		} else {

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
