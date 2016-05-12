From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 13/15] IB/hfi1: Keep SC_USER as the last send context type
Date: Thu, 12 May 2016 10:23:47 -0700
Message-ID: <20160512172346.9741.19872.stgit@scvm10.sc.intel.com>
References: <20160512172050.9741.84190.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160512172050.9741.84190.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jianxin Xiong <jianxin.xiong-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Jianxin Xiong <jianxin.xiong-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

SC_USER needs to be the last send context type to ensure other
send context types get their allocation when num_user_contexts
is set to a large number.

This fixes a panic when the module parameter num_user_contexts
is set to 141 and larger.

Reviewed-by: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Jianxin Xiong <jianxin.xiong-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/staging/rdma/hfi1/pio.h |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/rdma/hfi1/pio.h b/drivers/staging/rdma/hfi1/pio.h
index 53a08ed..464cbd2 100644
--- a/drivers/staging/rdma/hfi1/pio.h
+++ b/drivers/staging/rdma/hfi1/pio.h
@@ -49,10 +49,10 @@
 
 /* send context types */
 #define SC_KERNEL 0
-#define SC_ACK    1
-#define SC_USER   2
-#define SC_VL15   3
-#define SC_MAX    4
+#define SC_VL15   1
+#define SC_ACK    2
+#define SC_USER   3	/* must be the last one: it may take all left */
+#define SC_MAX    4	/* count of send context types */
 
 /* invalid send context index */
 #define INVALID_SCI 0xff

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
