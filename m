From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 07/21] IB/hfi1: Simplify init_qpmap_table()
Date: Tue, 12 Apr 2016 10:50:35 -0700
Message-ID: <20160412175033.24485.46180.stgit@scvm10.sc.intel.com>
References: <20160412174746.24485.92280.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160412174746.24485.92280.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Make init_qpmap_table() easier to understand by simplifying
the loop indexing and writing each register when it is "full",
removing the need for a follow-on register write.

Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/staging/rdma/hfi1/chip.c |    7 ++-----
 1 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/rdma/hfi1/chip.c b/drivers/staging/rdma/hfi1/chip.c
index 79dc29a..56753c6 100644
--- a/drivers/staging/rdma/hfi1/chip.c
+++ b/drivers/staging/rdma/hfi1/chip.c
@@ -13451,20 +13451,17 @@ static void init_qpmap_table(struct hfi1_devdata *dd,
 	int i;
 	u64 ctxt = first_ctxt;
 
-	for (i = 0; i < 256;) {
+	for (i = 0; i < 256; i++) {
 		reg |= ctxt << (8 * (i % 8));
-		i++;
 		ctxt++;
 		if (ctxt > last_ctxt)
 			ctxt = first_ctxt;
-		if (i % 8 == 0) {
+		if (i % 8 == 7) {
 			write_csr(dd, regno, reg);
 			reg = 0;
 			regno += 8;
 		}
 	}
-	if (i % 8)
-		write_csr(dd, regno, reg);
 
 	add_rcvctrl(dd, RCV_CTRL_RCV_QP_MAP_ENABLE_SMASK
 			| RCV_CTRL_RCV_BYPASS_ENABLE_SMASK);

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
