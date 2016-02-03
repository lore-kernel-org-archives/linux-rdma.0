From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 11/54] staging/rdma/hfi1: Make firmware failure messages
 warnings
Date: Wed, 03 Feb 2016 14:32:06 -0800
Message-ID: <20160203223202.5923.3065.stgit@scvm10.sc.intel.com>
References: <20160203222512.5923.30980.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160203222512.5923.30980.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Make firmware validation failure and missing firmware messages
a warning since alternates can be tried.  Add an error message
when all attempts fail.

Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/staging/rdma/hfi1/firmware.c |   18 ++++++++++--------
 1 files changed, 10 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/rdma/hfi1/firmware.c b/drivers/staging/rdma/hfi1/firmware.c
index d954e1a..817cbf9 100644
--- a/drivers/staging/rdma/hfi1/firmware.c
+++ b/drivers/staging/rdma/hfi1/firmware.c
@@ -433,8 +433,8 @@ static int obtain_one_firmware(struct hfi1_devdata *dd, const char *name,
 
 	ret = request_firmware(&fdet->fw, name, &dd->pcidev->dev);
 	if (ret) {
-		dd_dev_err(dd, "cannot find firmware \"%s\", err %d\n",
-			   name, ret);
+		dd_dev_warn(dd, "cannot find firmware \"%s\", err %d\n",
+			    name, ret);
 		return ret;
 	}
 
@@ -572,7 +572,7 @@ retry:
 		 * We tried the original and it failed.  Move to the
 		 * alternate.
 		 */
-		dd_dev_info(dd, "using alternate firmware names\n");
+		dd_dev_warn(dd, "using alternate firmware names\n");
 		/*
 		 * Let others run.  Some systems, when missing firmware, does
 		 * something that holds for 30 seconds.  If we do that twice
@@ -626,6 +626,7 @@ done:
 			fw_state = FW_TRY;
 			goto retry;
 		}
+		dd_dev_err(dd, "unable to obtain working firmware\n");
 		fw_state = FW_ERR;
 		fw_err = -ENOENT;
 	} else {
@@ -896,16 +897,17 @@ static int run_rsa(struct hfi1_devdata *dd, const char *who,
 			MISC_ERR_STATUS_MISC_FW_AUTH_FAILED_ERR_SMASK
 			| MISC_ERR_STATUS_MISC_KEY_MISMATCH_ERR_SMASK);
 	/*
-	 * All that is left are the current errors.  Print failure details,
-	 * if any.
+	 * All that is left are the current errors.  Print warnings on
+	 * authorization failure details, if any.  Firmware authorization
+	 * can be retried, so these are only warnings.
 	 */
 	reg = read_csr(dd, MISC_ERR_STATUS);
 	if (ret) {
 		if (reg & MISC_ERR_STATUS_MISC_FW_AUTH_FAILED_ERR_SMASK)
-			dd_dev_err(dd, "%s firmware authorization failed\n",
-				who);
+			dd_dev_warn(dd, "%s firmware authorization failed\n",
+				    who);
 		if (reg & MISC_ERR_STATUS_MISC_KEY_MISMATCH_ERR_SMASK)
-			dd_dev_err(dd, "%s firmware key mismatch\n", who);
+			dd_dev_warn(dd, "%s firmware key mismatch\n", who);
 	}
 
 	return ret;

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
