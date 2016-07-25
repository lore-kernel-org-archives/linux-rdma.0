From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 25/28] IB/hfi1: Rename hfi1_pio_header to hfi1_sdma_header.
Date: Mon, 25 Jul 2016 13:40:22 -0700
Message-ID: <20160725204021.4800.97807.stgit@scvm10.sc.intel.com>
References: <20160725203554.4800.37248.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160725203554.4800.37248.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Don Hiatt <don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Dasaratharaman Chandramouli <dasaratharaman.chandramouli-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Don Hiatt <don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

hfi1_pio_header should really be called hfi1_sdma_header
as it is only used for sdma transmits.

Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Don Hiatt <don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dasaratharaman Chandramouli <dasaratharaman.chandramouli-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/ruc.c         |    2 +-
 drivers/infiniband/hw/hfi1/verbs.c       |    2 +-
 drivers/infiniband/hw/hfi1/verbs.h       |    2 +-
 drivers/infiniband/hw/hfi1/verbs_txreq.h |    2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/ruc.c b/drivers/infiniband/hw/hfi1/ruc.c
index ea7977d..48d5094 100644
--- a/drivers/infiniband/hw/hfi1/ruc.c
+++ b/drivers/infiniband/hw/hfi1/ruc.c
@@ -708,7 +708,7 @@ u32 hfi1_make_grh(struct hfi1_ibport *ibp, struct ib_grh *hdr,
 	return sizeof(struct ib_grh) / sizeof(u32);
 }
 
-#define BTH2_OFFSET (offsetof(struct hfi1_pio_header, hdr.u.oth.bth[2]) / 4)
+#define BTH2_OFFSET (offsetof(struct hfi1_sdma_header, hdr.u.oth.bth[2]) / 4)
 
 /**
  * build_ahg - create ahg in s_ahg
diff --git a/drivers/infiniband/hw/hfi1/verbs.c b/drivers/infiniband/hw/hfi1/verbs.c
index 2b3fa40..67810e3 100644
--- a/drivers/infiniband/hw/hfi1/verbs.c
+++ b/drivers/infiniband/hw/hfi1/verbs.c
@@ -820,7 +820,7 @@ static int build_verbs_tx_desc(
 	u64 pbc)
 {
 	int ret = 0;
-	struct hfi1_pio_header *phdr = &tx->phdr;
+	struct hfi1_sdma_header *phdr = &tx->phdr;
 	u16 hdrbytes = tx->hdr_dwords << 2;
 
 	if (!ahg_info->ahgcount) {
diff --git a/drivers/infiniband/hw/hfi1/verbs.h b/drivers/infiniband/hw/hfi1/verbs.h
index d44550f..d1b101c 100644
--- a/drivers/infiniband/hw/hfi1/verbs.h
+++ b/drivers/infiniband/hw/hfi1/verbs.h
@@ -185,7 +185,7 @@ struct hfi1_ahg_info {
 	u8 ahgidx;
 };
 
-struct hfi1_pio_header {
+struct hfi1_sdma_header {
 	__le64 pbc;
 	struct hfi1_ib_header hdr;
 } __packed;
diff --git a/drivers/infiniband/hw/hfi1/verbs_txreq.h b/drivers/infiniband/hw/hfi1/verbs_txreq.h
index a1d6e08..5660897 100644
--- a/drivers/infiniband/hw/hfi1/verbs_txreq.h
+++ b/drivers/infiniband/hw/hfi1/verbs_txreq.h
@@ -56,7 +56,7 @@
 #include "iowait.h"
 
 struct verbs_txreq {
-	struct hfi1_pio_header	phdr;
+	struct hfi1_sdma_header	phdr;
 	struct sdma_txreq       txreq;
 	struct rvt_qp           *qp;
 	struct rvt_swqe         *wqe;

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
