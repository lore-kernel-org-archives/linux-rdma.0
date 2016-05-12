From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 03/15] IB/hfi1: Correct external device configuration shift
Date: Thu, 12 May 2016 10:22:45 -0700
Message-ID: <20160512172244.9741.17985.stgit@scvm10.sc.intel.com>
References: <20160512172050.9741.84190.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160512172050.9741.84190.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Easwar Hariharan <easwar.hariharan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Easwar Hariharan <easwar.hariharan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

The external device configuration was incorrectly shifted to byte 3 of
the 32 bit DC_HOST_COMM_SETTINGS instead of byte 0. This patch corrects
the shift and provides the cable capability information in byte 0.

Reviewed-by: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Easwar Hariharan <easwar.hariharan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/staging/rdma/hfi1/platform.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/rdma/hfi1/platform.c b/drivers/staging/rdma/hfi1/platform.c
index dfa413c..ae0e498 100644
--- a/drivers/staging/rdma/hfi1/platform.c
+++ b/drivers/staging/rdma/hfi1/platform.c
@@ -575,8 +575,8 @@ static void apply_tunings(
 		ret = read_8051_config(ppd->dd, DC_HOST_COMM_SETTINGS,
 				       GENERAL_CONFIG, &config_data);
 		/* Clear, then set the external device config field */
-		config_data &= ~(0xFF << 24);
-		config_data |= (external_device_config << 24);
+		config_data &= ~(u32)0xFF;
+		config_data |= external_device_config;
 		ret = load_8051_config(ppd->dd, DC_HOST_COMM_SETTINGS,
 				       GENERAL_CONFIG, config_data);
 		if (ret != HCMD_SUCCESS)

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
