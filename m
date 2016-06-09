From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 08/10] IB/hfi1: Fix potential buffer overflow
Date: Thu, 09 Jun 2016 07:51:51 -0700
Message-ID: <20160609145150.12702.26140.stgit@scvm10.sc.intel.com>
References: <20160609144644.12702.4832.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160609144644.12702.4832.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tadeusz Struk <tadeusz.struk-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Tadeusz Struk <tadeusz.struk-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

This fixes potential buffer overflow because the sprintf function
doesn't check buffer boundaries. Use snprintf instead.

Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Tadeusz Struk <tadeusz.struk-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/qsfp.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/qsfp.c b/drivers/infiniband/hw/hfi1/qsfp.c
index 2441669..9fb5616 100644
--- a/drivers/infiniband/hw/hfi1/qsfp.c
+++ b/drivers/infiniband/hw/hfi1/qsfp.c
@@ -579,7 +579,8 @@ int qsfp_dump(struct hfi1_pportdata *ppd, char *buf, int len)
 
 	if (ppd->qsfp_info.cache_valid) {
 		if (QSFP_IS_CU(cache[QSFP_MOD_TECH_OFFS]))
-			sprintf(lenstr, "%dM ", cache[QSFP_MOD_LEN_OFFS]);
+			snprintf(lenstr, sizeof(lenstr), "%dM ",
+				 cache[QSFP_MOD_LEN_OFFS]);
 
 		power_byte = cache[QSFP_MOD_PWR_OFFS];
 		sofar += scnprintf(buf + sofar, len - sofar, "PWR:%.3sW\n",

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
