From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH for-rc 3/7] IB/hfi1: Check eeprom config partition validity
Date: Tue, 26 Sep 2017 06:06:09 -0700
Message-ID: <20170926130608.31476.58540.stgit@scvm10.sc.intel.com>
References: <20170926130434.31476.81826.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170926130434.31476.81826.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jan Sokolowski <jan.sokolowski-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jakub Byczkowski <jakub.byczkowski-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Jan Sokolowski <jan.sokolowski-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Relying on a trailing magic value is incorrect. There are instances where
this is not present as trailing magic value has a specific purpose which is
not partition validation. Instead use the header magic value which is
present in all variants of the platform configuration and is intended for
validation. This is also used in other locations in the driver.

Fixes: bc5214ee2922 (IB/hfi1: Handle missing magic values in config file)
Reviewed-by: Jakub Byczkowski <jakub.byczkowski-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Jan Sokolowski <jan.sokolowski-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/eprom.c |   20 +++++++++++++++-----
 1 files changed, 15 insertions(+), 5 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/eprom.c b/drivers/infiniband/hw/hfi1/eprom.c
index d46b171..1613af1 100644
--- a/drivers/infiniband/hw/hfi1/eprom.c
+++ b/drivers/infiniband/hw/hfi1/eprom.c
@@ -204,7 +204,10 @@ int eprom_init(struct hfi1_devdata *dd)
 	return ret;
 }
 
-/* magic character sequence that trails an image */
+/* magic character sequence that begins an image */
+#define IMAGE_START_MAGIC "APO="
+
+/* magic character sequence that might trail an image */
 #define IMAGE_TRAIL_MAGIC "egamiAPO"
 
 /* EPROM file types */
@@ -250,6 +253,7 @@ static int read_partition_platform_config(struct hfi1_devdata *dd, void **data,
 {
 	void *buffer;
 	void *p;
+	u32 length;
 	int ret;
 
 	buffer = kmalloc(P1_SIZE, GFP_KERNEL);
@@ -262,15 +266,21 @@ static int read_partition_platform_config(struct hfi1_devdata *dd, void **data,
 		return ret;
 	}
 
-	/* scan for image magic that may trail the actual data */
-	p = strnstr(buffer, IMAGE_TRAIL_MAGIC, P1_SIZE);
-	if (!p) {
+	/* config partition is valid only if it starts with IMAGE_START_MAGIC */
+	if (memcmp(buffer, IMAGE_START_MAGIC, strlen(IMAGE_START_MAGIC))) {
 		kfree(buffer);
 		return -ENOENT;
 	}
 
+	/* scan for image magic that may trail the actual data */
+	p = strnstr(buffer, IMAGE_TRAIL_MAGIC, P1_SIZE);
+	if (p)
+		length = p - buffer;
+	else
+		length = P1_SIZE;
+
 	*data = buffer;
-	*size = p - buffer;
+	*size = length;
 	return 0;
 }
 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
