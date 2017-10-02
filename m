From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH for-next 1/8] IB/hfi1: Add parsing for platform
 configuration format version 4
Date: Mon, 02 Oct 2017 11:04:03 -0700
Message-ID: <20171002180359.31117.36632.stgit@scvm10.sc.intel.com>
References: <20171002180204.31117.12254.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171002180204.31117.12254.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jan Sokolowski <jan.sokolowski-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jakub Byczkowski <jakub.byczkowski-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Andrzej Kacprowski <andrzej.kacprowski-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Jakub Byczkowski <jakub.byczkowski-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Platform configuration format version 4, that didn't use the file
size field, is not parsed by the host driver. Only version 5 is
supported. Add logic in parsing procedure to determine what format
is being used and allow to read data from version 4 files.

Reviewed-by: Jan Sokolowski <jan.sokolowski-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Andrzej Kacprowski <andrzej.kacprowski-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Jakub Byczkowski <jakub.byczkowski-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/firmware.c |   24 ++++++++++++++++++++++--
 1 files changed, 22 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/firmware.c b/drivers/infiniband/hw/hfi1/firmware.c
index 5aea8f4..9471c40 100644
--- a/drivers/infiniband/hw/hfi1/firmware.c
+++ b/drivers/infiniband/hw/hfi1/firmware.c
@@ -113,6 +113,12 @@ struct css_header {
 #define MU_SIZE		8
 #define EXPONENT_SIZE	4
 
+/* size of platform configuration partition */
+#define MAX_PLATFORM_CONFIG_FILE_SIZE 4096
+
+/* size of file of plaform configuration encoded in format version 4 */
+#define PLATFORM_CONFIG_FORMAT_4_FILE_SIZE 528
+
 /* the file itself */
 struct firmware_file {
 	struct css_header css_header;
@@ -1774,7 +1780,20 @@ int parse_platform_config(struct hfi1_devdata *dd)
 
 	/* Field is file size in DWORDs */
 	file_length = (*ptr) * 4;
-	ptr++;
+
+	/*
+	 * Length can't be larger than partition size. Assume platform
+	 * config format version 4 is being used. Interpret the file size
+	 * field as header instead by not moving the pointer.
+	 */
+	if (file_length > MAX_PLATFORM_CONFIG_FILE_SIZE) {
+		dd_dev_info(dd,
+			    "%s:File length out of bounds, using alternative format\n",
+			    __func__);
+		file_length = PLATFORM_CONFIG_FORMAT_4_FILE_SIZE;
+	} else {
+		ptr++;
+	}
 
 	if (file_length > dd->platform_config.size) {
 		dd_dev_info(dd, "%s:File claims to be larger than read size\n",
@@ -1789,7 +1808,8 @@ int parse_platform_config(struct hfi1_devdata *dd)
 
 	/*
 	 * In both cases where we proceed, using the self-reported file length
-	 * is the safer option
+	 * is the safer option. In case of old format a predefined value is
+	 * being used.
 	 */
 	while (ptr < (u32 *)(dd->platform_config.data + file_length)) {
 		header1 = *ptr;

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
