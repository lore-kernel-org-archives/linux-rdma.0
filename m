From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 1/4] IB/hfi1: Restore EPROM read ability
Date: Sun, 25 Sep 2016 07:49:29 -0700
Message-ID: <20160925144926.13602.47716.stgit@scvm10.sc.intel.com>
References: <20160925144724.13602.38549.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160925144724.13602.38549.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Easwar Hariharan <easwar.hariharan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Partially revert commit d07903174202 ("IB/hfi1: Remove
EPROM functionality from data device"), bringing back
the ability to read from the EPROM.

This code will be used for driver-only acccess to the EPROM.

Reviewed-by: Easwar Hariharan <easwar.hariharan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/eprom.c |   59 ++++++++++++++++++++++++++++++++++++
 1 files changed, 59 insertions(+), 0 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/eprom.c b/drivers/infiniband/hw/hfi1/eprom.c
index 36b7794..5a11bee 100644
--- a/drivers/infiniband/hw/hfi1/eprom.c
+++ b/drivers/infiniband/hw/hfi1/eprom.c
@@ -49,7 +49,25 @@
 #include "common.h"
 #include "eprom.h"
 
+/*
+ * The EPROM is logically divided into three partitions:
+ *	partition 0: the first 128K, visible from PCI ROM BAR
+ *	partition 1: 4K config file (sector size)
+ *	partition 2: the rest
+ */
+#define P0_SIZE (128 * 1024)
+#define P1_SIZE   (4 * 1024)
+#define P1_START P0_SIZE
+#define P2_START (P0_SIZE + P1_SIZE)
+
+/* controller page size, in bytes */
+#define EP_PAGE_SIZE 256
+#define EEP_PAGE_MASK (EP_PAGE_SIZE - 1)
+
+/* controller commands */
 #define CMD_SHIFT 24
+#define CMD_NOP			    (0)
+#define CMD_READ_DATA(addr)	    ((0x03 << CMD_SHIFT) | addr)
 #define CMD_RELEASE_POWERDOWN_NOID  ((0xab << CMD_SHIFT))
 
 /* controller interface speeds */
@@ -61,6 +79,47 @@
  * Double it for safety.
  */
 #define EPROM_TIMEOUT 80000 /* ms */
+
+/*
+ * Read a 256 byte (64 dword) EPROM page.
+ * All callers have verified the offset is at a page boundary.
+ */
+static void read_page(struct hfi1_devdata *dd, u32 offset, u32 *result)
+{
+	int i;
+
+	write_csr(dd, ASIC_EEP_ADDR_CMD, CMD_READ_DATA(offset));
+	for (i = 0; i < EP_PAGE_SIZE / sizeof(u32); i++)
+		result[i] = (u32)read_csr(dd, ASIC_EEP_DATA);
+	write_csr(dd, ASIC_EEP_ADDR_CMD, CMD_NOP); /* close open page */
+}
+
+/*
+ * Read length bytes starting at offset.  Copy to user address addr.
+ */
+static int read_length(struct hfi1_devdata *dd, u32 start, u32 len, u64 addr)
+{
+	u32 offset;
+	u32 buffer[EP_PAGE_SIZE / sizeof(u32)];
+	int ret = 0;
+
+	/* reject anything not on an EPROM page boundary */
+	if ((start & EEP_PAGE_MASK) || (len & EEP_PAGE_MASK))
+		return -EINVAL;
+
+	for (offset = 0; offset < len; offset += EP_PAGE_SIZE) {
+		read_page(dd, start + offset, buffer);
+		if (copy_to_user((void __user *)(addr + offset),
+				 buffer, EP_PAGE_SIZE)) {
+			ret = -EFAULT;
+			goto done;
+		}
+	}
+
+done:
+	return ret;
+}
+
 /*
  * Initialize the EPROM handler.
  */

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
