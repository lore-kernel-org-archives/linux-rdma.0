From: Nicolas Iooss <nicolas.iooss_linux@m4x.org>
Subject: [PATCH] staging/rdma/hfi1: do not use u8 to store a 32-bit integer
Date: Sun, 20 Sep 2015 16:07:15 +0200
Message-ID: <1442758035-1056-1-git-send-email-nicolas.iooss_linux@m4x.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Mike Marciniszyn <infinipath@intel.com>, Doug Ledford <dledford@redhat.com>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-rdma@vger.kernel.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org, Nicolas Iooss <nicolas.iooss_linux@m4x.org>
List-Id: linux-rdma@vger.kernel.org

hfi1_rc_hdrerr() stores the result of be32_to_cpu() into opcode, which
is a local variable declared as u8.  Later this variable is used in a
24-bit logical right shift, which makes clang complains (when building
an allmodconfig kernel with LLVMLinux patches):

    drivers/staging/rdma/hfi1/rc.c:2399:9: warning: shift count >= width
    of type [-Wshift-count-overflow]
        opcode >>= 24;
               ^   ~~

All of this lead to the point that opcode may have been designed to be
a 32-bit integer instead of an 8-bit one.  Therefore make this variable
u32.

Signed-off-by: Nicolas Iooss <nicolas.iooss_linux@m4x.org>
---
 drivers/staging/rdma/hfi1/rc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/rdma/hfi1/rc.c b/drivers/staging/rdma/hfi1/rc.c
index 632dd5ba7dfd..1e9caebb0281 100644
--- a/drivers/staging/rdma/hfi1/rc.c
+++ b/drivers/staging/rdma/hfi1/rc.c
@@ -2383,7 +2383,7 @@ void hfi1_rc_hdrerr(
 	struct hfi1_other_headers *ohdr;
 	struct hfi1_ibport *ibp = to_iport(qp->ibqp.device, qp->port_num);
 	int diff;
-	u8 opcode;
+	u32 opcode;
 	u32 psn;
 
 	/* Check for GRH */
-- 
2.5.2
