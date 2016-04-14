From: Dennis Dalessandro <dennis.dalessandro@intel.com>
Subject: [PATCH 2/7] IB/hfi1: Remove unused user command
Date: Thu, 14 Apr 2016 08:41:47 -0700
Message-ID: <20160414154147.6387.65502.stgit@scvm10.sc.intel.com>
References: <20160414153727.6387.96381.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20160414153727.6387.96381.stgit@scvm10.sc.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: dledford@redhat.com
Cc: linux-rdma@vger.kernel.org, Ira Weiny <ira.weiny@intel.com>, Mitko Haralanov <mitko.haralanov@intel.com>, linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org, torvalds@linux-foundation.org
List-Id: linux-rdma@vger.kernel.org

The HFI1_CMD_SDMA_STATUS_UPD command was never implemented it has no
reason to live in the driver. Remove it.

Reviewed-by: Mitko Haralanov <mitko.haralanov@intel.com>
Reviewed-by: Ira Weiny <ira.weiny@intel.com>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro@intel.com>
---
 drivers/staging/rdma/hfi1/file_ops.c |    3 ---
 include/uapi/rdma/hfi/hfi1_user.h    |    1 -
 2 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/rdma/hfi1/file_ops.c b/drivers/staging/rdma/hfi1/file_ops.c
index 8396dc5..00d1b34 100644
--- a/drivers/staging/rdma/hfi1/file_ops.c
+++ b/drivers/staging/rdma/hfi1/file_ops.c
@@ -209,7 +209,6 @@ static ssize_t hfi1_file_write(struct file *fp, const char __user *data,
 		copy = sizeof(uinfo);
 		dest = &uinfo;
 		break;
-	case HFI1_CMD_SDMA_STATUS_UPD:
 	case HFI1_CMD_CREDIT_UPD:
 		copy = 0;
 		break;
@@ -284,8 +283,6 @@ static ssize_t hfi1_file_write(struct file *fp, const char __user *data,
 		ret = get_base_info(fp, (void __user *)(unsigned long)
 				    user_val, cmd.len);
 		break;
-	case HFI1_CMD_SDMA_STATUS_UPD:
-		break;
 	case HFI1_CMD_CREDIT_UPD:
 		if (uctxt && uctxt->sc)
 			sc_return_credits(uctxt->sc);
diff --git a/include/uapi/rdma/hfi/hfi1_user.h b/include/uapi/rdma/hfi/hfi1_user.h
index a533cec..46f6caa 100644
--- a/include/uapi/rdma/hfi/hfi1_user.h
+++ b/include/uapi/rdma/hfi/hfi1_user.h
@@ -127,7 +127,6 @@
 #define HFI1_CMD_TID_UPDATE      4	/* update expected TID entries */
 #define HFI1_CMD_TID_FREE        5	/* free expected TID entries */
 #define HFI1_CMD_CREDIT_UPD      6	/* force an update of PIO credit */
-#define HFI1_CMD_SDMA_STATUS_UPD 7      /* force update of SDMA status ring */
 
 #define HFI1_CMD_RECV_CTRL       8	/* control receipt of packets */
 #define HFI1_CMD_POLL_TYPE       9	/* set the kind of polling we want */
