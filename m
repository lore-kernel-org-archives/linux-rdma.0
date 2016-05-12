From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 02/15] IB/hfi1: Wait for QSFP modules to initialize
Date: Thu, 12 May 2016 10:22:39 -0700
Message-ID: <20160512172238.9741.77547.stgit@scvm10.sc.intel.com>
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

The function level reset in init_chip() and subsequent write of all 1s
to the ASIC_QSFP registers effectively resets attached active and
optical QSFP modules that pay attention to the RESET_N pin.

We subsequently try to access the QSFP management interface to qualify
and tune the channel and fabric SerDes before enough time (2 seconds
per SFF 8679 spec for QSFP28 modules) has elapsed for the module to
finish initialization. This fails and causes the failure of the channel
tuning algorithm, preventing us from bringing the link up.

This patch checks the port type prior to beginning channel and SerDes
tuning, and if found to be QSFP, watches for the QSFP initialization
complete interrupt, with a maximum timeout of 2 seconds, to allow the
initialization to complete.

Reviewed-by: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Easwar Hariharan <easwar.hariharan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/staging/rdma/hfi1/chip.c     |   10 +++++++++-
 drivers/staging/rdma/hfi1/platform.c |   17 +++++++++++------
 drivers/staging/rdma/hfi1/platform.h |    1 +
 3 files changed, 21 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/rdma/hfi1/chip.c b/drivers/staging/rdma/hfi1/chip.c
index f6ae0ba..ce4c275 100644
--- a/drivers/staging/rdma/hfi1/chip.c
+++ b/drivers/staging/rdma/hfi1/chip.c
@@ -9485,7 +9485,15 @@ int bringup_serdes(struct hfi1_pportdata *ppd)
 			return ret;
 	}
 
-	/* tune the SERDES to a ballpark setting for
+	get_port_type(ppd);
+	if (ppd->port_type == PORT_TYPE_QSFP) {
+		set_qsfp_int_n(ppd, 0);
+		wait_for_qsfp_init(ppd);
+		set_qsfp_int_n(ppd, 1);
+	}
+
+	/*
+	 * Tune the SerDes to a ballpark setting for
 	 * optimal signal and bit error rate
 	 * Needs to be done before starting the link
 	 */
diff --git a/drivers/staging/rdma/hfi1/platform.c b/drivers/staging/rdma/hfi1/platform.c
index 8fe8a20..dfa413c 100644
--- a/drivers/staging/rdma/hfi1/platform.c
+++ b/drivers/staging/rdma/hfi1/platform.c
@@ -87,6 +87,17 @@ void free_platform_config(struct hfi1_devdata *dd)
 	 */
 }
 
+void get_port_type(struct hfi1_pportdata *ppd)
+{
+	int ret;
+
+	ret = get_platform_config_field(ppd->dd, PLATFORM_CONFIG_PORT_TABLE, 0,
+					PORT_TABLE_PORT_TYPE, &ppd->port_type,
+					4);
+	if (ret)
+		ppd->port_type = PORT_TYPE_UNKNOWN;
+}
+
 int set_qsfp_tx(struct hfi1_pportdata *ppd, int on)
 {
 	u8 tx_ctrl_byte = on ? 0x0 : 0xF;
@@ -784,12 +795,6 @@ void tune_serdes(struct hfi1_pportdata *ppd)
 		return;
 	}
 
-	ret = get_platform_config_field(ppd->dd, PLATFORM_CONFIG_PORT_TABLE, 0,
-					PORT_TABLE_PORT_TYPE, &ppd->port_type,
-					4);
-	if (ret)
-		ppd->port_type = PORT_TYPE_UNKNOWN;
-
 	switch (ppd->port_type) {
 	case PORT_TYPE_DISCONNECTED:
 		ppd->offline_disabled_reason =
diff --git a/drivers/staging/rdma/hfi1/platform.h b/drivers/staging/rdma/hfi1/platform.h
index 19620cf..e2c2161 100644
--- a/drivers/staging/rdma/hfi1/platform.h
+++ b/drivers/staging/rdma/hfi1/platform.h
@@ -298,6 +298,7 @@ enum link_tuning_encoding {
 /* platform.c */
 void get_platform_config(struct hfi1_devdata *dd);
 void free_platform_config(struct hfi1_devdata *dd);
+void get_port_type(struct hfi1_pportdata *ppd);
 int set_qsfp_tx(struct hfi1_pportdata *ppd, int on);
 void tune_serdes(struct hfi1_pportdata *ppd);
 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
