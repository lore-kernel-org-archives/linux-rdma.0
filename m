From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 09/13] IB/hfi1: Act on external device timeout
Date: Sun, 25 Sep 2016 07:41:53 -0700
Message-ID: <20160925144151.10261.87080.stgit@scvm10.sc.intel.com>
References: <20160925143656.10261.85231.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160925143656.10261.85231.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Add missing external device timeout notification.  Recognize
it as a failed LNI signal from the 8051 firmware.

Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/chip.c |    4 +++-
 drivers/infiniband/hw/hfi1/chip.h |    4 +++-
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/chip.c b/drivers/infiniband/hw/hfi1/chip.c
index eaa3a9f..26c5ee5 100644
--- a/drivers/infiniband/hw/hfi1/chip.c
+++ b/drivers/infiniband/hw/hfi1/chip.c
@@ -971,7 +971,9 @@ static struct flag_table dc8051_info_err_flags[] = {
 	FLAG_ENTRY0("Failed LNI(VerifyCap_1)", FAILED_LNI_VERIFY_CAP1),
 	FLAG_ENTRY0("Failed LNI(VerifyCap_2)", FAILED_LNI_VERIFY_CAP2),
 	FLAG_ENTRY0("Failed LNI(ConfigLT)",    FAILED_LNI_CONFIGLT),
-	FLAG_ENTRY0("Host Handshake Timeout",  HOST_HANDSHAKE_TIMEOUT)
+	FLAG_ENTRY0("Host Handshake Timeout",  HOST_HANDSHAKE_TIMEOUT),
+	FLAG_ENTRY0("External Device Request Timeout",
+		    EXTERNAL_DEVICE_REQ_TIMEOUT),
 };
 
 /*
diff --git a/drivers/infiniband/hw/hfi1/chip.h b/drivers/infiniband/hw/hfi1/chip.h
index 35a7855..92f2485 100644
--- a/drivers/infiniband/hw/hfi1/chip.h
+++ b/drivers/infiniband/hw/hfi1/chip.h
@@ -254,12 +254,14 @@
 #define FAILED_LNI_VERIFY_CAP2		BIT(10)
 #define FAILED_LNI_CONFIGLT		BIT(11)
 #define HOST_HANDSHAKE_TIMEOUT		BIT(12)
+#define EXTERNAL_DEVICE_REQ_TIMEOUT	BIT(13)
 
 #define FAILED_LNI (FAILED_LNI_POLLING | FAILED_LNI_DEBOUNCE \
 			| FAILED_LNI_ESTBCOMM | FAILED_LNI_OPTEQ \
 			| FAILED_LNI_VERIFY_CAP1 \
 			| FAILED_LNI_VERIFY_CAP2 \
-			| FAILED_LNI_CONFIGLT | HOST_HANDSHAKE_TIMEOUT)
+			| FAILED_LNI_CONFIGLT | HOST_HANDSHAKE_TIMEOUT \
+			| EXTERNAL_DEVICE_REQ_TIMEOUT)
 
 /* DC_DC8051_DBG_ERR_INFO_SET_BY_8051.HOST_MSG - host message flags */
 #define HOST_REQ_DONE		BIT(0)

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
