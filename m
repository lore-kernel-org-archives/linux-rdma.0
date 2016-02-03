From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 12/54] staging/rdma/hfi1: Don't attempt to qualify or tune
 loopback plugs
Date: Wed, 03 Feb 2016 14:32:14 -0800
Message-ID: <20160203223211.5923.91935.stgit@scvm10.sc.intel.com>
References: <20160203222512.5923.30980.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160203222512.5923.30980.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Easwar Hariharan <easwar.hariharan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Easwar Hariharan <easwar.hariharan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Loopback plugs used for testing hardware don't need to be qualified to
bring the link up unlike production cables. This patch adds an exception
for loopback plugs to the QSFP and SerDes tuning algortihm.

Reviewed-by: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Easwar Hariharan <easwar.hariharan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/staging/rdma/hfi1/platform.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/rdma/hfi1/platform.c b/drivers/staging/rdma/hfi1/platform.c
index 9aa5e06..c3df1d8 100644
--- a/drivers/staging/rdma/hfi1/platform.c
+++ b/drivers/staging/rdma/hfi1/platform.c
@@ -737,7 +737,8 @@ void tune_serdes(struct hfi1_pportdata *ppd)
 	ppd->driver_link_ready = 0;
 	ppd->offline_disabled_reason = HFI1_ODR_MASK(OPA_LINKDOWN_REASON_NONE);
 
-	if (loopback == LOOPBACK_SERDES || loopback == LOOPBACK_LCB ||
+	/* Skip the tuning for testing (loopback != none) and simulations */
+	if (loopback != LOOPBACK_NONE ||
 	    ppd->dd->icode == ICODE_FUNCTIONAL_SIMULATOR ||
 	    !dd->pcfg_cache.cache_valid) {
 		ppd->driver_link_ready = 1;

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
