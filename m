From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 05/10] IB/hfi1: Remove unused user command
Date: Thu, 19 May 2016 05:26:17 -0700
Message-ID: <20160519122615.22041.58230.stgit@scvm10.sc.intel.com>
References: <20160519122318.22041.58871.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160519122318.22041.58871.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org, Mitko Haralanov <mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

The HFI1_CMD_SDMA_STATUS_UPD command was never implemented it has no
reason to live in the driver. Remove it.

Reviewed-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Reviewed-by: Mitko Haralanov <mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/staging/rdma/hfi1/file_ops.c |    3 ---
 include/uapi/rdma/hfi/hfi1_user.h    |    1 -
 2 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/rdma/hfi1/file_ops.c b/drivers/staging/rdma/hfi1/file_ops.c
index 4287c80..322e55f 100644
--- a/drivers/staging/rdma/hfi1/file_ops.c
+++ b/drivers/staging/rdma/hfi1/file_ops.c
@@ -213,7 +213,6 @@ static ssize_t hfi1_file_write(struct file *fp, const char __user *data,
 		copy = sizeof(uinfo);
 		dest = &uinfo;
 		break;
-	case HFI1_CMD_SDMA_STATUS_UPD:
 	case HFI1_CMD_CREDIT_UPD:
 		copy = 0;
 		break;
@@ -273,8 +272,6 @@ static ssize_t hfi1_file_write(struct file *fp, const char __user *data,
 		ret = get_base_info(fp, (void __user *)(unsigned long)
 				    user_val, cmd.len);
 		break;
-	case HFI1_CMD_SDMA_STATUS_UPD:
-		break;
 	case HFI1_CMD_CREDIT_UPD:
 		if (uctxt && uctxt->sc)
 			sc_return_credits(uctxt->sc);
diff --git a/include/uapi/rdma/hfi/hfi1_user.h b/include/uapi/rdma/hfi/hfi1_user.h
index 3e3680d..aa48fbe 100644
--- a/include/uapi/rdma/hfi/hfi1_user.h
+++ b/include/uapi/rdma/hfi/hfi1_user.h
@@ -114,7 +114,6 @@
 #define HFI1_CMD_TID_UPDATE      4	/* update expected TID entries */
 #define HFI1_CMD_TID_FREE        5	/* free expected TID entries */
 #define HFI1_CMD_CREDIT_UPD      6	/* force an update of PIO credit */
-#define HFI1_CMD_SDMA_STATUS_UPD 7      /* force update of SDMA status ring */
 
 #define HFI1_CMD_RECV_CTRL       8	/* control receipt of packets */
 #define HFI1_CMD_POLL_TYPE       9	/* set the kind of polling we want */

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
