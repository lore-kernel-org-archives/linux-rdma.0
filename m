From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH for-next 04/10] IB/hfi1: Remove reading platform
 configuration from EFI variable
Date: Fri, 09 Jun 2017 15:59:46 -0700
Message-ID: <20170609225945.26710.9315.stgit@scvm10.sc.intel.com>
References: <20170609225424.26710.70167.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170609225424.26710.70167.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jan Sokolowski <jan.sokolowski-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jakub Byczkowski <jakub.byczkowski-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Jan Sokolowski <jan.sokolowski-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Currently, platform configuration can be read from EFI variable
for discrete cards. It will happen when reading from EPROM fails.
EFI variables should not be queried for platform configuration
in any scenario.

Reviewed-by: Jakub Byczkowski <jakub.byczkowski-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Jan Sokolowski <jan.sokolowski-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/platform.c |   10 ----------
 1 files changed, 0 insertions(+), 10 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/platform.c b/drivers/infiniband/hw/hfi1/platform.c
index cbda9b1..41307e4 100644
--- a/drivers/infiniband/hw/hfi1/platform.c
+++ b/drivers/infiniband/hw/hfi1/platform.c
@@ -136,7 +136,6 @@ static void save_platform_config_fields(struct hfi1_devdata *dd)
 void get_platform_config(struct hfi1_devdata *dd)
 {
 	int ret = 0;
-	unsigned long size = 0;
 	u8 *temp_platform_config = NULL;
 	u32 esize;
 
@@ -160,15 +159,6 @@ void get_platform_config(struct hfi1_devdata *dd)
 			dd->platform_config.size = esize;
 			return;
 		}
-		/* fail, try EFI variable */
-
-		ret = read_hfi1_efi_var(dd, "configuration", &size,
-					(void **)&temp_platform_config);
-		if (!ret) {
-			dd->platform_config.data = temp_platform_config;
-			dd->platform_config.size = size;
-			return;
-		}
 	}
 	dd_dev_err(dd,
 		   "%s: Failed to get platform config, falling back to sub-optimal default file\n",

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
