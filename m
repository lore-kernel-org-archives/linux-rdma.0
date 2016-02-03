From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 31/54] staging/rdma/hfi1: Use device file minor to identify
 EPROM
Date: Wed, 03 Feb 2016 14:34:58 -0800
Message-ID: <20160203223454.5923.97221.stgit@scvm10.sc.intel.com>
References: <20160203222512.5923.30980.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160203222512.5923.30980.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mitko Haralanov <mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

When writing to the EPROM, the driver will always use the
"first" device.  This is incorrect for multiple cards.

Use the device file minor to determine the device to use.
Reject the generic device file.

Reviewed-by: Mitko Haralanov <mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/staging/rdma/hfi1/eprom.c    |   15 ++++++++++-----
 drivers/staging/rdma/hfi1/eprom.h    |    2 +-
 drivers/staging/rdma/hfi1/file_ops.c |    2 +-
 3 files changed, 12 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/rdma/hfi1/eprom.c b/drivers/staging/rdma/hfi1/eprom.c
index fb620c9..8104a11 100644
--- a/drivers/staging/rdma/hfi1/eprom.c
+++ b/drivers/staging/rdma/hfi1/eprom.c
@@ -353,21 +353,26 @@ static inline u32 extract_rstart(u32 composite)
  *
  * Return 0 on success, -ERRNO on error
  */
-int handle_eprom_command(const struct hfi1_cmd *cmd)
+int handle_eprom_command(struct file *fp, const struct hfi1_cmd *cmd)
 {
 	struct hfi1_devdata *dd;
 	u32 dev_id;
 	u32 rlen;	/* range length */
 	u32 rstart;	/* range start */
+	int i_minor;
 	int ret = 0;
 
 	/*
-	 * The EPROM is per-device, so use unit 0 as that will always
-	 * exist.
+	 * Map the device file to device data using the relative minor.
+	 * The device file minor number is the unit number + 1.  0 is
+	 * the generic device file - reject it.
 	 */
-	dd = hfi1_lookup(0);
+	i_minor = iminor(file_inode(fp)) - HFI1_USER_MINOR_BASE;
+	if (i_minor <= 0)
+		return -EINVAL;
+	dd = hfi1_lookup(i_minor - 1);
 	if (!dd) {
-		pr_err("%s: cannot find unit 0!\n", __func__);
+		pr_err("%s: cannot find unit %d!\n", __func__, i_minor);
 		return -EINVAL;
 	}
 
diff --git a/drivers/staging/rdma/hfi1/eprom.h b/drivers/staging/rdma/hfi1/eprom.h
index 64a6427..5a61ba3 100644
--- a/drivers/staging/rdma/hfi1/eprom.h
+++ b/drivers/staging/rdma/hfi1/eprom.h
@@ -52,4 +52,4 @@ struct hfi1_cmd;
 struct hfi1_devdata;
 
 int eprom_init(struct hfi1_devdata *dd);
-int handle_eprom_command(const struct hfi1_cmd *cmd);
+int handle_eprom_command(struct file *fp, const struct hfi1_cmd *cmd);
diff --git a/drivers/staging/rdma/hfi1/file_ops.c b/drivers/staging/rdma/hfi1/file_ops.c
index 2de9032..cc681f7 100644
--- a/drivers/staging/rdma/hfi1/file_ops.c
+++ b/drivers/staging/rdma/hfi1/file_ops.c
@@ -409,7 +409,7 @@ static ssize_t hfi1_file_write(struct file *fp, const char __user *data,
 	case HFI1_CMD_EP_ERASE_RANGE:
 	case HFI1_CMD_EP_READ_RANGE:
 	case HFI1_CMD_EP_WRITE_RANGE:
-		ret = handle_eprom_command(&cmd);
+		ret = handle_eprom_command(fp, &cmd);
 		break;
 	}
 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
