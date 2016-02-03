From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 45/54] staging/rdma/hfi1,
 IB/core: Fix LinkDownReason define for consistency
Date: Wed, 03 Feb 2016 14:36:58 -0800
Message-ID: <20160203223654.5923.82285.stgit@scvm10.sc.intel.com>
References: <20160203222512.5923.30980.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160203222512.5923.30980.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Easwar Hariharan <easwar.hariharan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Easwar Hariharan <easwar.hariharan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

LinkDownReason LocalMediaNotInstalled lacked an underscore
and was inconsistent with other defines in the same family.
This patch fixes this.

Reviewed-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Easwar Hariharan <easwar.hariharan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/staging/rdma/hfi1/chip.c     |    4 ++--
 drivers/staging/rdma/hfi1/platform.c |    2 +-
 include/rdma/opa_port_info.h         |    2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/rdma/hfi1/chip.c b/drivers/staging/rdma/hfi1/chip.c
index 8c06e3b..f31cc23 100644
--- a/drivers/staging/rdma/hfi1/chip.c
+++ b/drivers/staging/rdma/hfi1/chip.c
@@ -5950,12 +5950,12 @@ static void handle_qsfp_int(struct hfi1_devdata *dd, u32 src_ctx, u64 reg)
 
 			if ((ppd->offline_disabled_reason >
 			  HFI1_ODR_MASK(
-			  OPA_LINKDOWN_REASONLOCAL_MEDIA_NOT_INSTALLED)) ||
+			  OPA_LINKDOWN_REASON_LOCAL_MEDIA_NOT_INSTALLED)) ||
 			  (ppd->offline_disabled_reason ==
 			  HFI1_ODR_MASK(OPA_LINKDOWN_REASON_NONE)))
 				ppd->offline_disabled_reason =
 				HFI1_ODR_MASK(
-				OPA_LINKDOWN_REASONLOCAL_MEDIA_NOT_INSTALLED);
+				OPA_LINKDOWN_REASON_LOCAL_MEDIA_NOT_INSTALLED);
 
 			if (ppd->host_link_state == HLS_DN_POLL) {
 				/*
diff --git a/drivers/staging/rdma/hfi1/platform.c b/drivers/staging/rdma/hfi1/platform.c
index c3df1d8..506a827 100644
--- a/drivers/staging/rdma/hfi1/platform.c
+++ b/drivers/staging/rdma/hfi1/platform.c
@@ -816,7 +816,7 @@ void tune_serdes(struct hfi1_pportdata *ppd)
 		} else
 			ppd->offline_disabled_reason =
 			   HFI1_ODR_MASK(
-				OPA_LINKDOWN_REASONLOCAL_MEDIA_NOT_INSTALLED);
+				OPA_LINKDOWN_REASON_LOCAL_MEDIA_NOT_INSTALLED);
 		break;
 	default:
 		dd_dev_info(ppd->dd, "%s: Unknown port type\n", __func__);
diff --git a/include/rdma/opa_port_info.h b/include/rdma/opa_port_info.h
index a0fa975..2b95c2c 100644
--- a/include/rdma/opa_port_info.h
+++ b/include/rdma/opa_port_info.h
@@ -97,7 +97,7 @@
 #define OPA_LINKDOWN_REASON_WIDTH_POLICY			41
 /* 42-48 reserved */
 #define OPA_LINKDOWN_REASON_DISCONNECTED			49
-#define OPA_LINKDOWN_REASONLOCAL_MEDIA_NOT_INSTALLED		50
+#define OPA_LINKDOWN_REASON_LOCAL_MEDIA_NOT_INSTALLED		50
 #define OPA_LINKDOWN_REASON_NOT_INSTALLED			51
 #define OPA_LINKDOWN_REASON_CHASSIS_CONFIG			52
 /* 53 reserved */

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
