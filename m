From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 08/10] IB/hfi1: Add trace message in user IOCTL handling
Date: Thu, 19 May 2016 05:26:37 -0700
Message-ID: <20160519122636.22041.10969.stgit@scvm10.sc.intel.com>
References: <20160519122318.22041.58871.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160519122318.22041.58871.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Add a trace message to HFI1s user IOCTL handling. This allows debugging
of which IOCTLs are being handled by the driver.

Reviewed-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/staging/rdma/hfi1/file_ops.c |    1 +
 drivers/staging/rdma/hfi1/trace.c    |    1 +
 drivers/staging/rdma/hfi1/trace.h    |    1 +
 3 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/rdma/hfi1/file_ops.c b/drivers/staging/rdma/hfi1/file_ops.c
index c46eada..1139170 100644
--- a/drivers/staging/rdma/hfi1/file_ops.c
+++ b/drivers/staging/rdma/hfi1/file_ops.c
@@ -188,6 +188,7 @@ static long hfi1_file_ioctl(struct file *fp, unsigned int cmd,
 	unsigned long ul_uval = 0;
 	u16 uval16 = 0;
 
+	hfi1_cdbg(IOCTL, "IOCTL recv: 0x%x", cmd);
 	if (cmd != HFI1_IOCTL_ASSIGN_CTXT &&
 	    cmd != HFI1_IOCTL_GET_VERS &&
 	    !uctxt)
diff --git a/drivers/staging/rdma/hfi1/trace.c b/drivers/staging/rdma/hfi1/trace.c
index 8b62fef..caddb2a 100644
--- a/drivers/staging/rdma/hfi1/trace.c
+++ b/drivers/staging/rdma/hfi1/trace.c
@@ -233,3 +233,4 @@ __hfi1_trace_fn(FIRMWARE);
 __hfi1_trace_fn(RCVCTRL);
 __hfi1_trace_fn(TID);
 __hfi1_trace_fn(MMU);
+__hfi1_trace_fn(IOCTL);
diff --git a/drivers/staging/rdma/hfi1/trace.h b/drivers/staging/rdma/hfi1/trace.h
index 42bcfc3..a6c1adf 100644
--- a/drivers/staging/rdma/hfi1/trace.h
+++ b/drivers/staging/rdma/hfi1/trace.h
@@ -1341,6 +1341,7 @@ __hfi1_trace_def(FIRMWARE);
 __hfi1_trace_def(RCVCTRL);
 __hfi1_trace_def(TID);
 __hfi1_trace_def(MMU);
+__hfi1_trace_def(IOCTL);
 
 #define hfi1_cdbg(which, fmt, ...) \
 	__hfi1_trace_##which(__func__, fmt, ##__VA_ARGS__)

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
