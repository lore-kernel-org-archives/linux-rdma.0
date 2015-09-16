From: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [patch] IB/hfi1: mask vs shift confusion
Date: Wed, 16 Sep 2015 19:03:45 +0300
Message-ID: <20150916160345.GE9735@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mike Marciniszyn <infinipath-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devel-gWbeCf7V1WCQmaza687I9mD2FQJk+8+b@public.gmane.org, kernel-janitors-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

We are shifting by the _MASK macros instead of the _SHIFT ones.

Signed-off-by: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>

diff --git a/drivers/staging/rdma/hfi1/sdma.c b/drivers/staging/rdma/hfi1/sdma.c
index a8c903c..3a457d2 100644
--- a/drivers/staging/rdma/hfi1/sdma.c
+++ b/drivers/staging/rdma/hfi1/sdma.c
@@ -1848,7 +1848,7 @@ static void dump_sdma_state(struct sdma_engine *sde)
 			dd_dev_err(sde->dd,
 				"\taidx: %u amode: %u alen: %u\n",
 				(u8)((desc[1] & SDMA_DESC1_HEADER_INDEX_SMASK)
-					>> SDMA_DESC1_HEADER_INDEX_MASK),
+					>> SDMA_DESC1_HEADER_INDEX_SHIFT),
 				(u8)((desc[1] & SDMA_DESC1_HEADER_MODE_SMASK)
 					>> SDMA_DESC1_HEADER_MODE_SHIFT),
 				(u8)((desc[1] & SDMA_DESC1_HEADER_DWS_SMASK)
@@ -1926,7 +1926,7 @@ void sdma_seqfile_dump_sde(struct seq_file *s, struct sdma_engine *sde)
 		if (desc[0] & SDMA_DESC0_FIRST_DESC_FLAG)
 			seq_printf(s, "\t\tahgidx: %u ahgmode: %u\n",
 				(u8)((desc[1] & SDMA_DESC1_HEADER_INDEX_SMASK)
-					>> SDMA_DESC1_HEADER_INDEX_MASK),
+					>> SDMA_DESC1_HEADER_INDEX_SHIFT),
 				(u8)((desc[1] & SDMA_DESC1_HEADER_MODE_SMASK)
 					>> SDMA_DESC1_HEADER_MODE_SHIFT));
 		head = (head + 1) & sde->sdma_mask;
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
