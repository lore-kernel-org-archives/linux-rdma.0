From: Dennis Dalessandro <dennis.dalessandro@intel.com>
Subject: [PATCH v2 5/5] IB/hfi1: Add trace message in user IOCTL handling
Date: Thu, 12 May 2016 10:18:59 -0700
Message-ID: <20160512171858.6198.55326.stgit@scvm10.sc.intel.com>
References: <20160512171115.6198.77458.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20160512171115.6198.77458.stgit@scvm10.sc.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: dledford@redhat.com
Cc: linux-rdma@vger.kernel.org, linux-fsdevel@vger.kernel.org, Ira Weiny <ira.weiny@intel.com>, linux-kernel@vger.kernel.org, jgunthorpe@obsidianresearch.com
List-Id: linux-rdma@vger.kernel.org

Add a trace message to HFI1s user IOCTL handling. This allows debugging
of which IOCTLs are being handled by the driver.

Reviewed-by: Ira Weiny <ira.weiny@intel.com>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro@intel.com>
---
 drivers/staging/rdma/hfi1/file_ops.c |    2 ++
 drivers/staging/rdma/hfi1/trace.c    |    1 +
 drivers/staging/rdma/hfi1/trace.h    |    1 +
 3 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/rdma/hfi1/file_ops.c b/drivers/staging/rdma/hfi1/file_ops.c
index 120b680..bfcf1a2 100644
--- a/drivers/staging/rdma/hfi1/file_ops.c
+++ b/drivers/staging/rdma/hfi1/file_ops.c
@@ -195,6 +195,8 @@ static long hfi1_file_ioctl(struct file *fp, unsigned int cmd,
 	if (ret)
 		return ret;
 
+	hfi1_cdbg(IOCTL, "IOCTL recv: 0x%x", cmd);
+
 	switch (cmd) {
 	case HFI1_IOCTL_ASSIGN_CTXT:
 		uctxt_required = 0; /* assigned user context not required */
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
index 963dc94..3cb0391 100644
--- a/drivers/staging/rdma/hfi1/trace.h
+++ b/drivers/staging/rdma/hfi1/trace.h
@@ -1341,6 +1341,7 @@ __hfi1_trace_def(FIRMWARE);
 __hfi1_trace_def(RCVCTRL);
 __hfi1_trace_def(TID);
 __hfi1_trace_def(MMU);
+__hfi1_trace_def(IOCTL);
 
 #define hfi1_cdbg(which, fmt, ...) \
 	__hfi1_trace_##which(__func__, fmt, ##__VA_ARGS__)
