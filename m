From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 6/8] IB/qib: Remove unused qib_7322_intr_msgs[]
Date: Thu, 19 May 2016 05:21:50 -0700
Message-ID: <20160519122149.30706.52152.stgit@scvm10.sc.intel.com>
References: <20160519000433.30706.21093.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160519000433.30706.21093.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Building the qib driver with gcc version 6.1.0 raises the following
build warning:
drivers/infiniband/hw/qib/qib_iba7322.c:1311:39: warning:
'qib_7322_intr_msgs' defined but not used [-Wunused-const-variable=]
 static const struct  qib_hwerror_msgs qib_7322_intr_msgs[] = {
                                       ^~~~~~~~~~~~~~~~~~
Remove the unused qib_7322_intr_msgs[]

Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/qib/qib_iba7322.c |   15 ---------------
 1 files changed, 0 insertions(+), 15 deletions(-)

diff --git a/drivers/infiniband/hw/qib/qib_iba7322.c b/drivers/infiniband/hw/qib/qib_iba7322.c
index 82d7c4b..ce40340 100644
--- a/drivers/infiniband/hw/qib/qib_iba7322.c
+++ b/drivers/infiniband/hw/qib/qib_iba7322.c
@@ -1308,21 +1308,6 @@ static const struct  qib_hwerror_msgs qib_7322p_error_msgs[] = {
 	SYM_LSB(IntMask, fldname##17IntMask)), \
 	.msg = #fldname "_C", .sz = sizeof(#fldname "_C") }
 
-static const struct  qib_hwerror_msgs qib_7322_intr_msgs[] = {
-	INTR_AUTO_P(SDmaInt),
-	INTR_AUTO_P(SDmaProgressInt),
-	INTR_AUTO_P(SDmaIdleInt),
-	INTR_AUTO_P(SDmaCleanupDone),
-	INTR_AUTO_C(RcvUrg),
-	INTR_AUTO_P(ErrInt),
-	INTR_AUTO(ErrInt),      /* non-port-specific errs */
-	INTR_AUTO(AssertGPIOInt),
-	INTR_AUTO_P(SendDoneInt),
-	INTR_AUTO(SendBufAvailInt),
-	INTR_AUTO_C(RcvAvail),
-	{ .mask = 0, .sz = 0 }
-};
-
 #define TXSYMPTOM_AUTO_P(fldname) \
 	{ .mask = SYM_MASK(SendHdrErrSymptom_0, fldname), \
 	.msg = #fldname, .sz = sizeof(#fldname) }

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
