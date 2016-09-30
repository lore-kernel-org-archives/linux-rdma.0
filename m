From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v2 2/3] IB/hfi1: Add ability to read platform config from
 the EPROM
Date: Fri, 30 Sep 2016 04:41:40 -0700
Message-ID: <20160930114139.12716.97279.stgit@scvm10.sc.intel.com>
References: <20160930114009.12716.95241.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160930114009.12716.95241.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Easwar Hariharan <easwar.hariharan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Add a function to read the platform configuration file from
the EPROM.

Reviewed-by: Easwar Hariharan <easwar.hariharan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/eprom.c |   82 ++++++++++++++++++++++++++++++++++++
 drivers/infiniband/hw/hfi1/eprom.h |    2 +
 2 files changed, 84 insertions(+), 0 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/eprom.c b/drivers/infiniband/hw/hfi1/eprom.c
index 30ecd94..e70c223 100644
--- a/drivers/infiniband/hw/hfi1/eprom.c
+++ b/drivers/infiniband/hw/hfi1/eprom.c
@@ -203,3 +203,85 @@ int eprom_init(struct hfi1_devdata *dd)
 done_asic:
 	return ret;
 }
+
+/* magic character sequence that trails an image */
+#define IMAGE_TRAIL_MAGIC "egamiAPO"
+
+/*
+ * Read all of partition 1.  The actual file is at the front.  Adjust
+ * the returned size if a trailing image magic is found.
+ */
+static int read_partition_platform_config(struct hfi1_devdata *dd, void **data,
+					  u32 *size)
+{
+	void *buffer;
+	void *p;
+	u32 length;
+	int ret;
+
+	buffer = kmalloc(P1_SIZE, GFP_KERNEL);
+	if (!buffer)
+		return -ENOMEM;
+
+	ret = read_length(dd, P1_START, P1_SIZE, buffer);
+	if (ret) {
+		kfree(buffer);
+		return ret;
+	}
+
+	/* scan for image magic that may trail the actual data */
+	p = strnstr(buffer, IMAGE_TRAIL_MAGIC, P1_SIZE);
+	if (p)
+		length = p - buffer;
+	else
+		length = P1_SIZE;
+
+	*data = buffer;
+	*size = length;
+	return 0;
+}
+
+/*
+ * Read the platform configuration file from the EPROM.
+ *
+ * On success, an allocated buffer containing the data and its size are
+ * returned.  It is up to the caller to free this buffer.
+ *
+ * Return value:
+ *   0	      - success
+ *   -ENXIO   - no EPROM is available
+ *   -EBUSY   - not able to acquire access to the EPROM
+ *   -ENOENT  - no recognizable file written
+ *   -ENOMEM  - buffer could not be allocated
+ */
+int eprom_read_platform_config(struct hfi1_devdata *dd, void **data, u32 *size)
+{
+	u32 directory[EP_PAGE_DWORDS]; /* aligned buffer */
+	int ret;
+
+	if (!dd->eprom_available)
+		return -ENXIO;
+
+	ret = acquire_chip_resource(dd, CR_EPROM, EPROM_TIMEOUT);
+	if (ret)
+		return -EBUSY;
+
+	/* read the last page of P0 for the EPROM format magic */
+	ret = read_length(dd, P1_START - EP_PAGE_SIZE, EP_PAGE_SIZE, directory);
+	if (ret)
+		goto done;
+
+	/* last dword of P0 contains a magic indicator */
+	if (directory[EP_PAGE_DWORDS - 1] == 0) {
+		/* partition format */
+		ret = read_partition_platform_config(dd, data, size);
+		goto done;
+	}
+
+	/* nothing recognized */
+	ret = -ENOENT;
+
+done:
+	release_chip_resource(dd, CR_EPROM);
+	return ret;
+}
diff --git a/drivers/infiniband/hw/hfi1/eprom.h b/drivers/infiniband/hw/hfi1/eprom.h
index b7ac9ce..e774184 100644
--- a/drivers/infiniband/hw/hfi1/eprom.h
+++ b/drivers/infiniband/hw/hfi1/eprom.h
@@ -48,3 +48,5 @@
 struct hfi1_devdata;
 
 int eprom_init(struct hfi1_devdata *dd);
+int eprom_read_platform_config(struct hfi1_devdata *dd, void **buf_ret,
+			       u32 *size_ret);

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
