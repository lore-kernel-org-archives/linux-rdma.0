From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH for-next 4/8] IB/hfi1: Disambiguate corruption and
 uninitialized error cases
Date: Sat, 29 Jul 2017 08:43:37 -0700
Message-ID: <20170729154337.21487.19161.stgit@scvm10.sc.intel.com>
References: <20170729154124.21487.53119.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170729154124.21487.53119.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Easwar Hariharan <easwar.hariharan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jan Sokolowski <jan.sokolowski-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jakub Byczkowski <jakub.byczkowski-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Jan Sokolowski <jan.sokolowski-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

The error messages when checksum validation of the platform
configuration fields populated into the ASIC scratch registers fails are
ambiguous. Disambiguate them.

Reviewed-by: Jakub Byczkowski <jakub.byczkowski-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Easwar Hariharan <easwar.hariharan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Jan Sokolowski <jan.sokolowski-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/platform.c |   14 ++++++++------
 1 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/platform.c b/drivers/infiniband/hw/hfi1/platform.c
index 41307e4..5c38a24 100644
--- a/drivers/infiniband/hw/hfi1/platform.c
+++ b/drivers/infiniband/hw/hfi1/platform.c
@@ -58,8 +58,13 @@ static int validate_scratch_checksum(struct hfi1_devdata *dd)
 	version = (temp_scratch & BITMAP_VERSION_SMASK) >> BITMAP_VERSION_SHIFT;
 
 	/* Prevent power on default of all zeroes from passing checksum */
-	if (!version)
+	if (!version) {
+		dd_dev_err(dd, "%s: Config bitmap uninitialized\n", __func__);
+		dd_dev_err(dd,
+			   "%s: Please update your BIOS to support active channels\n",
+			   __func__);
 		return 0;
+	}
 
 	/*
 	 * ASIC scratch 0 only contains the checksum and bitmap version as
@@ -84,6 +89,8 @@ static int validate_scratch_checksum(struct hfi1_devdata *dd)
 
 	if (checksum + temp_scratch == 0xFFFF)
 		return 1;
+
+	dd_dev_err(dd, "%s: Configuration bitmap corrupted\n", __func__);
 	return 0;
 }
 
@@ -144,11 +151,6 @@ void get_platform_config(struct hfi1_devdata *dd)
 			save_platform_config_fields(dd);
 			return;
 		}
-		dd_dev_err(dd, "%s: Config bitmap corrupted/uninitialized\n",
-			   __func__);
-		dd_dev_err(dd,
-			   "%s: Please update your BIOS to support active channels\n",
-			   __func__);
 	} else {
 		ret = eprom_read_platform_config(dd,
 						 (void **)&temp_platform_config,

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
