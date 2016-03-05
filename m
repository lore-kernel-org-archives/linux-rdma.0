From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 15/17] IB/hfi1: Handle host handshake timeout
Date: Sat, 05 Mar 2016 08:50:38 -0800
Message-ID: <20160305165038.32025.1011.stgit@scvm10.sc.intel.com>
References: <20160305164725.32025.99686.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160305164725.32025.99686.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Easwar Hariharan <easwar.hariharan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Host handshake timeout can occur during the verify capability
state. This is a LNI related failure and should be
handled in the same way as other LNI failures.

Reviewed-by: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Easwar Hariharan <easwar.hariharan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/chip.c |    3 ++-
 drivers/infiniband/hw/hfi1/chip.h |    3 ++-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/chip.c b/drivers/infiniband/hw/hfi1/chip.c
index ac03452..c29860c 100644
--- a/drivers/infiniband/hw/hfi1/chip.c
+++ b/drivers/infiniband/hw/hfi1/chip.c
@@ -963,7 +963,8 @@ static struct flag_table dc8051_info_err_flags[] = {
 	FLAG_ENTRY0("Failed LNI(OptEq)",       FAILED_LNI_OPTEQ),
 	FLAG_ENTRY0("Failed LNI(VerifyCap_1)", FAILED_LNI_VERIFY_CAP1),
 	FLAG_ENTRY0("Failed LNI(VerifyCap_2)", FAILED_LNI_VERIFY_CAP2),
-	FLAG_ENTRY0("Failed LNI(ConfigLT)",    FAILED_LNI_CONFIGLT)
+	FLAG_ENTRY0("Failed LNI(ConfigLT)",    FAILED_LNI_CONFIGLT),
+	FLAG_ENTRY0("Host Handshake Timeout",  HOST_HANDSHAKE_TIMEOUT)
 };
 
 /*
diff --git a/drivers/infiniband/hw/hfi1/chip.h b/drivers/infiniband/hw/hfi1/chip.h
index 9313963..4f3b878 100644
--- a/drivers/infiniband/hw/hfi1/chip.h
+++ b/drivers/infiniband/hw/hfi1/chip.h
@@ -253,12 +253,13 @@
 #define FAILED_LNI_VERIFY_CAP1		BIT(9)
 #define FAILED_LNI_VERIFY_CAP2		BIT(10)
 #define FAILED_LNI_CONFIGLT		BIT(11)
+#define HOST_HANDSHAKE_TIMEOUT		BIT(12)
 
 #define FAILED_LNI (FAILED_LNI_POLLING | FAILED_LNI_DEBOUNCE \
 			| FAILED_LNI_ESTBCOMM | FAILED_LNI_OPTEQ \
 			| FAILED_LNI_VERIFY_CAP1 \
 			| FAILED_LNI_VERIFY_CAP2 \
-			| FAILED_LNI_CONFIGLT)
+			| FAILED_LNI_CONFIGLT | HOST_HANDSHAKE_TIMEOUT)
 
 /* DC_DC8051_DBG_ERR_INFO_SET_BY_8051.HOST_MSG - host message flags */
 #define HOST_REQ_DONE		BIT(0)

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
