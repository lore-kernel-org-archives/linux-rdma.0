From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 01/23] IB/hfi1: Read new EPROM format
Date: Wed, 07 Dec 2016 19:32:15 -0800
Message-ID: <20161208033213.21135.71236.stgit@scvm10.sc.intel.com>
References: <20161208032312.21135.66056.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20161208032312.21135.66056.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Easwar Hariharan <easwar.hariharan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Add the ability to read the new EPROM format.

Reviewed-by: Easwar Hariharan <easwar.hariharan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/eprom.c |  211 +++++++++++++++++++++++++++++++++++-
 1 files changed, 203 insertions(+), 8 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/eprom.c b/drivers/infiniband/hw/hfi1/eprom.c
index e70c223..26da124 100644
--- a/drivers/infiniband/hw/hfi1/eprom.c
+++ b/drivers/infiniband/hw/hfi1/eprom.c
@@ -207,6 +207,40 @@ int eprom_init(struct hfi1_devdata *dd)
 /* magic character sequence that trails an image */
 #define IMAGE_TRAIL_MAGIC "egamiAPO"
 
+/* EPROM file types */
+#define HFI1_EFT_PLATFORM_CONFIG 2
+
+/* segment size - 128 KiB */
+#define SEG_SIZE (128 * 1024)
+
+struct hfi1_eprom_footer {
+	u32 oprom_size;		/* size of the oprom, in bytes */
+	u16 num_table_entries;
+	u16 version;		/* version of this footer */
+	u32 magic;		/* must be last */
+};
+
+struct hfi1_eprom_table_entry {
+	u32 type;		/* file type */
+	u32 offset;		/* file offset from start of EPROM */
+	u32 size;		/* file size, in bytes */
+};
+
+/*
+ * Calculate the max number of table entries that will fit within a directory
+ * buffer of size 'dir_size'.
+ */
+#define MAX_TABLE_ENTRIES(dir_size) \
+	(((dir_size) - sizeof(struct hfi1_eprom_footer)) / \
+		sizeof(struct hfi1_eprom_table_entry))
+
+#define DIRECTORY_SIZE(n) (sizeof(struct hfi1_eprom_footer) + \
+	(sizeof(struct hfi1_eprom_table_entry) * (n)))
+
+#define MAGIC4(a, b, c, d) ((d) << 24 | (c) << 16 | (b) << 8 | (a))
+#define FOOTER_MAGIC MAGIC4('e', 'p', 'r', 'm')
+#define FOOTER_VERSION 1
+
 /*
  * Read all of partition 1.  The actual file is at the front.  Adjust
  * the returned size if a trailing image magic is found.
@@ -242,6 +276,167 @@ static int read_partition_platform_config(struct hfi1_devdata *dd, void **data,
 }
 
 /*
+ * The segment magic has been checked.  There is a footer and table of
+ * contents present.
+ *
+ * directory is a u32 aligned buffer of size EP_PAGE_SIZE.
+ */
+static int read_segment_platform_config(struct hfi1_devdata *dd,
+					void *directory, void **data, u32 *size)
+{
+	struct hfi1_eprom_footer *footer;
+	struct hfi1_eprom_table_entry *table;
+	struct hfi1_eprom_table_entry *entry;
+	void *buffer = NULL;
+	void *table_buffer = NULL;
+	int ret, i;
+	u32 directory_size;
+	u32 seg_base, seg_offset;
+	u32 bytes_available, ncopied, to_copy;
+
+	/* the footer is at the end of the directory */
+	footer = (struct hfi1_eprom_footer *)
+			(directory + EP_PAGE_SIZE - sizeof(*footer));
+
+	/* make sure the structure version is supported */
+	if (footer->version != FOOTER_VERSION)
+		return -EINVAL;
+
+	/* oprom size cannot be larger than a segment */
+	if (footer->oprom_size >= SEG_SIZE)
+		return -EINVAL;
+
+	/* the file table must fit in a segment with the oprom */
+	if (footer->num_table_entries >
+			MAX_TABLE_ENTRIES(SEG_SIZE - footer->oprom_size))
+		return -EINVAL;
+
+	/* find the file table start, which precedes the footer */
+	directory_size = DIRECTORY_SIZE(footer->num_table_entries);
+	if (directory_size <= EP_PAGE_SIZE) {
+		/* the file table fits into the directory buffer handed in */
+		table = (struct hfi1_eprom_table_entry *)
+				(directory + EP_PAGE_SIZE - directory_size);
+	} else {
+		/* need to allocate and read more */
+		table_buffer = kmalloc(directory_size, GFP_KERNEL);
+		if (!table_buffer)
+			return -ENOMEM;
+		ret = read_length(dd, SEG_SIZE - directory_size,
+				  directory_size, table_buffer);
+		if (ret)
+			goto done;
+		table = table_buffer;
+	}
+
+	/* look for the platform configuration file in the table */
+	for (entry = NULL, i = 0; i < footer->num_table_entries; i++) {
+		if (table[i].type == HFI1_EFT_PLATFORM_CONFIG) {
+			entry = &table[i];
+			break;
+		}
+	}
+	if (!entry) {
+		ret = -ENOENT;
+		goto done;
+	}
+
+	/*
+	 * Sanity check on the configuration file size - it should never
+	 * be larger than 4 KiB.
+	 */
+	if (entry->size > (4 * 1024)) {
+		dd_dev_err(dd, "Bad configuration file size 0x%x\n",
+			   entry->size);
+		ret = -EINVAL;
+		goto done;
+	}
+
+	/* check for bogus offset and size that wrap when added together */
+	if (entry->offset + entry->size < entry->offset) {
+		dd_dev_err(dd,
+			   "Bad configuration file start + size 0x%x+0x%x\n",
+			   entry->offset, entry->size);
+		ret = -EINVAL;
+		goto done;
+	}
+
+	/* allocate the buffer to return */
+	buffer = kmalloc(entry->size, GFP_KERNEL);
+	if (!buffer) {
+		ret = -ENOMEM;
+		goto done;
+	}
+
+	/*
+	 * Extract the file by looping over segments until it is fully read.
+	 */
+	seg_offset = entry->offset % SEG_SIZE;
+	seg_base = entry->offset - seg_offset;
+	ncopied = 0;
+	while (ncopied < entry->size) {
+		/* calculate data bytes available in this segment */
+
+		/* start with the bytes from the current offset to the end */
+		bytes_available = SEG_SIZE - seg_offset;
+		/* subtract off footer and table from segment 0 */
+		if (seg_base == 0) {
+			/*
+			 * Sanity check: should not have a starting point
+			 * at or within the directory.
+			 */
+			if (bytes_available <= directory_size) {
+				dd_dev_err(dd,
+					   "Bad configuration file - offset 0x%x within footer+table\n",
+					   entry->offset);
+				ret = -EINVAL;
+				goto done;
+			}
+			bytes_available -= directory_size;
+		}
+
+		/* calculate bytes wanted */
+		to_copy = entry->size - ncopied;
+
+		/* max out at the available bytes in this segment */
+		if (to_copy > bytes_available)
+			to_copy = bytes_available;
+
+		/*
+		 * Read from the EPROM.
+		 *
+		 * The sanity check for entry->offset is done in read_length().
+		 * The EPROM offset is validated against what the hardware
+		 * addressing supports.  In addition, if the offset is larger
+		 * than the actual EPROM, it silently wraps.  It will work
+		 * fine, though the reader may not get what they expected
+		 * from the EPROM.
+		 */
+		ret = read_length(dd, seg_base + seg_offset, to_copy,
+				  buffer + ncopied);
+		if (ret)
+			goto done;
+
+		ncopied += to_copy;
+
+		/* set up for next segment */
+		seg_offset = footer->oprom_size;
+		seg_base += SEG_SIZE;
+	}
+
+	/* success */
+	ret = 0;
+	*data = buffer;
+	*size = entry->size;
+
+done:
+	kfree(table_buffer);
+	if (ret)
+		kfree(buffer);
+	return ret;
+}
+
+/*
  * Read the platform configuration file from the EPROM.
  *
  * On success, an allocated buffer containing the data and its size are
@@ -253,6 +448,7 @@ static int read_partition_platform_config(struct hfi1_devdata *dd, void **data,
  *   -EBUSY   - not able to acquire access to the EPROM
  *   -ENOENT  - no recognizable file written
  *   -ENOMEM  - buffer could not be allocated
+ *   -EINVAL  - invalid EPROM contentents found
  */
 int eprom_read_platform_config(struct hfi1_devdata *dd, void **data, u32 *size)
 {
@@ -266,21 +462,20 @@ int eprom_read_platform_config(struct hfi1_devdata *dd, void **data, u32 *size)
 	if (ret)
 		return -EBUSY;
 
-	/* read the last page of P0 for the EPROM format magic */
-	ret = read_length(dd, P1_START - EP_PAGE_SIZE, EP_PAGE_SIZE, directory);
+	/* read the last page of the segment for the EPROM format magic */
+	ret = read_length(dd, SEG_SIZE - EP_PAGE_SIZE, EP_PAGE_SIZE, directory);
 	if (ret)
 		goto done;
 
-	/* last dword of P0 contains a magic indicator */
-	if (directory[EP_PAGE_DWORDS - 1] == 0) {
+	/* last dword of the segment contains a magic value */
+	if (directory[EP_PAGE_DWORDS - 1] == FOOTER_MAGIC) {
+		/* segment format */
+		ret = read_segment_platform_config(dd, directory, data, size);
+	} else {
 		/* partition format */
 		ret = read_partition_platform_config(dd, data, size);
-		goto done;
 	}
 
-	/* nothing recognized */
-	ret = -ENOENT;
-
 done:
 	release_chip_resource(dd, CR_EPROM);
 	return ret;

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
