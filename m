From: Jack Wang <jinpu.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Subject: [PATCH 23/28] ibnbd_srv: add abstraction for submit IO to file or block device
Date: Fri, 24 Mar 2017 11:45:38 +0100
Message-ID: <1490352343-20075-24-git-send-email-jinpu.wangl@profitbricks.com>
References: <1490352343-20075-1-git-send-email-jinpu.wangl@profitbricks.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1490352343-20075-1-git-send-email-jinpu.wangl-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, hch-jcswGhMUV9g@public.gmane.org, mail-99BIx50xQYGELgA04lAiVw@public.gmane.org, Milind.dumbare-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, yun.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org, Jack Wang <jinpu.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, Kleber Souza <kleber.souza-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, Danil Kipnis <danil.kipnis-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, Roman Pen <roman.penyaev-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Jack Wang <jinpu.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>

Signed-off-by: Jack Wang <jinpu.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Signed-off-by: Kleber Souza <kleber.souza-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Signed-off-by: Danil Kipnis <danil.kipnis-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Signed-off-by: Roman Pen <roman.penyaev-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
---
 drivers/block/ibnbd_server/ibnbd_dev.c | 436 +++++++++++++++++++++++++++++++++
 drivers/block/ibnbd_server/ibnbd_dev.h | 149 +++++++++++
 2 files changed, 585 insertions(+)
 create mode 100644 drivers/block/ibnbd_server/ibnbd_dev.c
 create mode 100644 drivers/block/ibnbd_server/ibnbd_dev.h

diff --git a/drivers/block/ibnbd_server/ibnbd_dev.c b/drivers/block/ibnbd_server/ibnbd_dev.c
new file mode 100644
index 0000000..5f6b453
--- /dev/null
+++ b/drivers/block/ibnbd_server/ibnbd_dev.c
@@ -0,0 +1,436 @@
+/*
+ * InfiniBand Network Block Driver
+ *
+ * Copyright (c) 2014 - 2017 ProfitBricks GmbH. All rights reserved.
+ * Authors: Fabian Holler < mail-99BIx50xQYGELgA04lAiVw@public.gmane.org>
+ *          Jack Wang <jinpu.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
+ *   	    Kleber Souza <kleber.souza-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
+ * 	    Danil Kipnis <danil.kipnis-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
+ *   	    Roman Pen <roman.penyaev-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
+ *          Milind Dumbare <Milind.dumbare-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
+ *
+ *
+ * Redistribution and use in source and binary forms, with or without
+ * modification, are permitted provided that the following conditions
+ * are met:
+ * 1. Redistributions of source code must retain the above copyright
+ *    notice, this list of conditions, and the following disclaimer,
+ *    without modification.
+ * 2. Redistributions in binary form must reproduce at minimum a disclaimer
+ *    substantially similar to the "NO WARRANTY" disclaimer below
+ *    ("Disclaimer") and any redistribution must be conditioned upon
+ *    including a substantially similar Disclaimer requirement for further
+ *    binary redistribution.
+ * 3. Neither the names of the above-listed copyright holders nor the names
+ *    of any contributors may be used to endorse or promote products derived
+ *    from this software without specific prior written permission.
+ *
+ * Alternatively, this software may be distributed under the terms of the
+ * GNU General Public License ("GPL") version 2 as published by the Free
+ * Software Foundation.
+ *
+ * NO WARRANTY
+ * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
+ * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
+ * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTIBILITY AND FITNESS FOR
+ * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
+ * HOLDERS OR CONTRIBUTORS BE LIABLE FOR SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
+ * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
+ * OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
+ * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
+ * STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING
+ * IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
+ * POSSIBILITY OF SUCH DAMAGES.
+ *
+ */
+
+#include "ibnbd_dev.h"
+#include "ibnbd_srv_log.h"
+
+#define IBNBD_DEV_MAX_FILEIO_ACTIVE_WORKERS 0
+
+struct ibnbd_dev_file_io_work {
+	struct ibnbd_dev	*dev;
+	void			*priv;
+
+	sector_t		sector;
+	void			*data;
+	size_t			len;
+	size_t			bi_size;
+	enum ibnbd_io_flags	flags;
+
+	struct work_struct	work;
+};
+
+struct ibnbd_dev_blk_io {
+	struct ibnbd_dev *dev;
+	void		 *priv;
+};
+
+static struct workqueue_struct *fileio_wq;
+
+int ibnbd_dev_init(void)
+{
+	fileio_wq = alloc_workqueue("%s", WQ_UNBOUND,
+				    IBNBD_DEV_MAX_FILEIO_ACTIVE_WORKERS,
+				    "ibnbd_server_fileio_wq");
+	if (!fileio_wq)
+		return -ENOMEM;
+
+	return 0;
+}
+
+void ibnbd_dev_destroy(void)
+{
+	destroy_workqueue(fileio_wq);
+}
+
+static inline struct block_device *ibnbd_dev_open_bdev(const char *path,
+						       fmode_t flags)
+{
+	return blkdev_get_by_path(path, flags, THIS_MODULE);
+}
+
+static int ibnbd_dev_blk_open(struct ibnbd_dev *dev, const char *path,
+			      fmode_t flags)
+{
+	dev->bdev = ibnbd_dev_open_bdev(path, flags);
+	return PTR_ERR_OR_ZERO(dev->bdev);
+}
+
+static int ibnbd_dev_vfs_open(struct ibnbd_dev *dev, const char *path,
+			      fmode_t flags)
+{
+	int oflags = O_DSYNC; /* enable write-through */
+
+	if (flags & FMODE_WRITE)
+		oflags |= O_RDWR;
+	else if (flags & FMODE_READ)
+		oflags |= O_RDONLY;
+	else
+		return -EINVAL;
+
+	dev->file = filp_open(path, oflags, 0);
+	return PTR_ERR_OR_ZERO(dev->file);
+}
+
+struct ibnbd_dev *ibnbd_dev_open(const char *path, fmode_t flags,
+				 enum ibnbd_io_mode mode, struct bio_set *bs,
+				 ibnbd_dev_io_fn io_cb)
+{
+	struct ibnbd_dev *dev;
+	int ret;
+
+	dev = kzalloc(sizeof(*dev), GFP_KERNEL);
+	if (!dev)
+		return ERR_PTR(-ENOMEM);
+
+	if (mode == IBNBD_BLOCKIO) {
+		dev->blk_open_flags = flags;
+		ret = ibnbd_dev_blk_open(dev, path, dev->blk_open_flags);
+		if (ret)
+			goto err;
+	} else if (mode == IBNBD_FILEIO) {
+		dev->blk_open_flags = FMODE_READ;
+		ret = ibnbd_dev_blk_open(dev, path, dev->blk_open_flags);
+		if (ret)
+			goto err;
+
+		ret = ibnbd_dev_vfs_open(dev, path, flags);
+		if (ret)
+			goto blk_put;
+	}
+
+	dev->blk_open_flags	= flags;
+	dev->mode		= mode;
+	dev->io_cb		= io_cb;
+	bdevname(dev->bdev, dev->name);
+	dev->ibd_bio_set	= bs;
+
+	return dev;
+
+blk_put:
+	blkdev_put(dev->bdev, dev->blk_open_flags);
+err:
+	kfree(dev);
+	return ERR_PTR(ret);
+}
+
+void ibnbd_dev_close(struct ibnbd_dev *dev)
+{
+	flush_workqueue(fileio_wq);
+	blkdev_put(dev->bdev, dev->blk_open_flags);
+	if (dev->mode == IBNBD_FILEIO)
+		filp_close(dev->file, dev->file);
+	kfree(dev);
+}
+
+static void ibnbd_dev_bi_end_io(struct bio *bio)
+{
+	struct ibnbd_dev_blk_io *io = bio->bi_private;
+
+	int error = bio->bi_error;
+
+	io->dev->io_cb(io->priv, error);
+
+	bio_put(bio);
+	kfree(io);
+}
+
+static void bio_map_kern_endio(struct bio *bio)
+{
+	bio_put(bio);
+}
+
+/**
+ *	ibnbd_bio_map_kern	-	map kernel address into bio
+ *	@q: the struct request_queue for the bio
+ *	@data: pointer to buffer to map
+ *	@bs: bio_set to use.
+ *	@len: length in bytes
+ *	@gfp_mask: allocation flags for bio allocation
+ *
+ *	Map the kernel address into a bio suitable for io to a block
+ *	device. Returns an error pointer in case of error.
+ */
+static struct bio *ibnbd_bio_map_kern(struct request_queue *q, void *data,
+				      struct bio_set *bs,
+				      unsigned int len, gfp_t gfp_mask)
+{
+	unsigned long kaddr = (unsigned long)data;
+	unsigned long end = (kaddr + len + PAGE_SIZE - 1) >> PAGE_SHIFT;
+	unsigned long start = kaddr >> PAGE_SHIFT;
+	const int nr_pages = end - start;
+	int offset, i;
+	struct bio *bio;
+
+	bio = bio_alloc_bioset(gfp_mask, nr_pages, bs);
+	if (!bio)
+		return ERR_PTR(-ENOMEM);
+
+	offset = offset_in_page(kaddr);
+	for (i = 0; i < nr_pages; i++) {
+		unsigned int bytes = PAGE_SIZE - offset;
+
+		if (len <= 0)
+			break;
+
+		if (bytes > len)
+			bytes = len;
+
+		if (bio_add_pc_page(q, bio, virt_to_page(data), bytes,
+				    offset) < bytes) {
+			/* we don't support partial mappings */
+			bio_put(bio);
+			return ERR_PTR(-EINVAL);
+		}
+
+		data += bytes;
+		len -= bytes;
+		offset = 0;
+	}
+
+	bio->bi_end_io = bio_map_kern_endio;
+	return bio;
+}
+
+static int ibnbd_dev_blk_submit_io(struct ibnbd_dev *dev, sector_t sector,
+				   void *data, size_t len, u32 bi_size,
+				   enum ibnbd_io_flags flags, void *priv)
+{
+	struct request_queue *q = bdev_get_queue(dev->bdev);
+	struct ibnbd_dev_blk_io *io;
+	struct bio *bio;
+
+	/* check if the buffer is suitable for bdev */
+	if (unlikely(WARN_ON(!blk_rq_aligned(q, (unsigned long)data, len))))
+		return -EINVAL;
+
+	/* Generate bio with pages pointing to the rdma buffer */
+	bio = ibnbd_bio_map_kern(q, data, dev->ibd_bio_set, len, GFP_KERNEL);
+	if (unlikely(IS_ERR(bio)))
+		return PTR_ERR(bio);
+
+	io = kmalloc(sizeof(*io), GFP_KERNEL);
+	if (unlikely(!io)) {
+		bio_put(bio);
+		return -ENOMEM;
+	}
+
+	io->dev		= dev;
+	io->priv	= priv;
+
+	bio->bi_end_io		= ibnbd_dev_bi_end_io;
+	bio->bi_bdev		= dev->bdev;
+	bio->bi_private		= io;
+	bio->bi_opf		= ibnbd_io_flags_to_bi_rw(flags);
+	bio->bi_iter.bi_sector	= sector;
+	bio->bi_iter.bi_size	= bi_size;
+
+	submit_bio(bio);
+
+	return 0;
+}
+
+static int ibnbd_dev_file_handle_flush(struct ibnbd_dev_file_io_work *w,
+				       loff_t start)
+{
+	int ret;
+	loff_t end;
+	int len = w->bi_size;
+
+	if (len)
+		end = start + len - 1;
+	else
+		end = LLONG_MAX;
+
+	ret = vfs_fsync_range(w->dev->file, start, end, 1);
+	if (unlikely(ret))
+		INFO_NP_RL("I/O FLUSH failed on %s, vfs_sync errno: %d\n",
+			   w->dev->name, ret);
+	return ret;
+}
+
+static int ibnbd_dev_file_handle_fua(struct ibnbd_dev_file_io_work *w,
+				     loff_t start)
+{
+	int ret;
+	loff_t end;
+	int len = w->bi_size;
+
+	if (len)
+		end = start + len - 1;
+	else
+		end = LLONG_MAX;
+
+	ret = vfs_fsync_range(w->dev->file, start, end, 1);
+	if (unlikely(ret))
+		INFO_NP_RL("I/O FUA failed on %s, vfs_sync errno: %d\n",
+			   w->dev->name, ret);
+	return ret;
+}
+
+static int ibnbd_dev_file_handle_write_same(struct ibnbd_dev_file_io_work *w)
+{
+	int i;
+
+	if (unlikely(WARN_ON(w->bi_size % w->len)))
+		return -EINVAL;
+
+	for (i = 1; i < w->bi_size / w->len; i++)
+		memcpy(w->data + i * w->len, w->data, w->len);
+
+	return 0;
+}
+
+static void ibnbd_dev_file_submit_io_worker(struct work_struct *w)
+{
+	struct ibnbd_dev_file_io_work *dev_work;
+	loff_t off;
+	int ret;
+	int len;
+	struct file *f;
+
+	dev_work = container_of(w, struct ibnbd_dev_file_io_work, work);
+	off = dev_work->sector * ibnbd_dev_get_logical_bsize(dev_work->dev);
+	f = dev_work->dev->file;
+	len = dev_work->bi_size;
+
+	if (dev_work->flags & IBNBD_RW_REQ_FLUSH) {
+		ret = ibnbd_dev_file_handle_flush(dev_work, off);
+		if (unlikely(ret))
+			goto out;
+	}
+
+	if (dev_work->flags & IBNBD_RW_REQ_WRITE_SAME) {
+		ret = ibnbd_dev_file_handle_write_same(dev_work);
+		if (unlikely(ret))
+			goto out;
+	}
+
+	/* TODO Implement support for DIRECT */
+	if (dev_work->bi_size) {
+		if (dev_work->flags & IBNBD_RW_REQ_WRITE)
+			ret = kernel_write(f, dev_work->data, dev_work->bi_size,
+					   off);
+		else
+			ret = kernel_read(f, off, dev_work->data,
+					  dev_work->bi_size);
+
+		if (unlikely(ret < 0)) {
+			goto out;
+		} else if (unlikely(ret != dev_work->bi_size)) {
+			/* TODO implement support for partial completions */
+			ret = -EIO;
+			goto out;
+		} else {
+			ret = 0;
+		}
+	}
+
+	if (dev_work->flags & IBNBD_RW_REQ_FUA)
+		ret = ibnbd_dev_file_handle_fua(dev_work, off);
+out:
+	dev_work->dev->io_cb(dev_work->priv, ret);
+	kfree(dev_work);
+}
+
+static inline bool ibnbd_dev_file_io_flags_supported(enum ibnbd_io_flags flags)
+{
+	flags &= ~IBNBD_RW_REQ_WRITE;
+	flags &= ~IBNBD_RW_REQ_SYNC;
+	flags &= ~IBNBD_RW_REQ_FUA;
+	flags &= ~IBNBD_RW_REQ_FLUSH;
+	flags &= ~IBNBD_RW_REQ_WRITE_SAME;
+
+	return (!flags);
+}
+
+static int ibnbd_dev_file_submit_io(struct ibnbd_dev *dev, sector_t sector,
+				    void *data, size_t len, size_t bi_size,
+				    enum ibnbd_io_flags flags, void *priv)
+{
+	struct ibnbd_dev_file_io_work *w;
+
+	if (!ibnbd_dev_file_io_flags_supported(flags)) {
+		INFO_NP_RL("Unsupported I/O flags: 0x%x on device %s\n", flags,
+			   dev->name);
+		return -ENOTSUPP;
+	}
+
+	w = kmalloc(sizeof(*w), GFP_KERNEL);
+	if (!w)
+		return -ENOMEM;
+
+	w->dev		= dev;
+	w->priv		= priv;
+	w->sector	= sector;
+	w->data		= data;
+	w->len		= len;
+	w->bi_size	= bi_size;
+	w->flags	= flags;
+	INIT_WORK(&w->work, ibnbd_dev_file_submit_io_worker);
+
+	if (unlikely(!queue_work(fileio_wq, &w->work))) {
+		kfree(w);
+		return -EEXIST;
+	}
+
+	return 0;
+}
+
+int ibnbd_dev_submit_io(struct ibnbd_dev *dev, sector_t sector, void *data,
+			size_t len, u32 bi_size, enum ibnbd_io_flags flags,
+			void *priv)
+{
+	if (dev->mode == IBNBD_FILEIO)
+		return ibnbd_dev_file_submit_io(dev, sector, data, len, bi_size,
+						flags, priv);
+	else if (dev->mode == IBNBD_BLOCKIO)
+		return ibnbd_dev_blk_submit_io(dev, sector, data, len, bi_size,
+					       flags, priv);
+
+	WRN_NP("Submitting I/O to %s failed, dev->mode contains invalid "
+	       "value: '%d', memory corrupted?", dev->name, dev->mode);
+	return -EINVAL;
+}
diff --git a/drivers/block/ibnbd_server/ibnbd_dev.h b/drivers/block/ibnbd_server/ibnbd_dev.h
new file mode 100644
index 0000000..7c73d64
--- /dev/null
+++ b/drivers/block/ibnbd_server/ibnbd_dev.h
@@ -0,0 +1,149 @@
+#ifndef _IBNBD_DEV_H
+#define _IBNBD_DEV_H
+
+#include <linux/fs.h>
+#include "../ibnbd_inc/ibnbd-proto.h"
+
+typedef void ibnbd_dev_io_fn(void *priv, int error);
+
+struct ibnbd_dev {
+	struct block_device	*bdev;
+	struct bio_set		*ibd_bio_set;
+	struct file		*file;
+	fmode_t			blk_open_flags;
+	enum ibnbd_io_mode	mode;
+	char			name[BDEVNAME_SIZE];
+	ibnbd_dev_io_fn		*io_cb;
+};
+
+
+/** ibnbd_dev_init() - Initialize ibnbd_dev
+ *
+ * This functions initialized the ibnbd-dev component.
+ * It has to be called 1x time before ibnbd_dev_open() is used
+ */
+int ibnbd_dev_init(void);
+
+/** ibnbd_dev_destroy() - Destroy ibnbd_dev
+ *
+ * This functions destroys the ibnbd-dev component.
+ * It has to be called after the last device was closed.
+ */
+void ibnbd_dev_destroy(void);
+
+/**
+ * ibnbd_dev_open() - Open a device
+ * @flags:	open flags
+ * @mode:	open via VFS or block layer
+ * @bs:		bio_set to use during block io,
+ * @io_cb:	is called when I/O finished
+ */
+struct ibnbd_dev *ibnbd_dev_open(const char *path, fmode_t flags,
+				 enum ibnbd_io_mode mode, struct bio_set *bs,
+				 ibnbd_dev_io_fn io_cb);
+
+/**
+ * ibnbd_dev_close() - Close a device
+ */
+void ibnbd_dev_close(struct ibnbd_dev *dev);
+
+static inline size_t ibnbd_dev_get_capacity(const struct ibnbd_dev *dev)
+{
+	return get_capacity(dev->bdev->bd_disk);
+}
+
+static inline int ibnbd_dev_get_logical_bsize(const struct ibnbd_dev *dev)
+{
+	return bdev_logical_block_size(dev->bdev);
+}
+
+static inline int ibnbd_dev_get_phys_bsize(const struct ibnbd_dev *dev)
+{
+	return bdev_physical_block_size(dev->bdev);
+}
+
+static inline int ibnbd_dev_get_max_segs(const struct ibnbd_dev *dev)
+{
+	return queue_max_segments(bdev_get_queue(dev->bdev));
+}
+
+static inline int ibnbd_dev_get_max_hw_sects(const struct ibnbd_dev *dev)
+{
+	return queue_max_hw_sectors(bdev_get_queue(dev->bdev));
+}
+
+static inline int
+ibnbd_dev_get_max_write_same_sects(const struct ibnbd_dev *dev)
+{
+	return bdev_write_same(dev->bdev);
+}
+
+static inline int ibnbd_dev_get_secure_discard(const struct ibnbd_dev *dev)
+{
+	if (dev->mode == IBNBD_BLOCKIO)
+		return blk_queue_secure_erase(bdev_get_queue(dev->bdev));
+	return 0;
+}
+
+static inline int ibnbd_dev_get_max_discard_sects(const struct ibnbd_dev *dev)
+{
+	if (!blk_queue_discard(bdev_get_queue(dev->bdev)))
+		return 0;
+
+	if (dev->mode == IBNBD_BLOCKIO)
+		return blk_queue_get_max_sectors(bdev_get_queue(dev->bdev),
+						 REQ_OP_DISCARD);
+	return 0;
+}
+
+static inline int ibnbd_dev_get_discard_zeroes_data(const struct ibnbd_dev *dev)
+{
+	if (dev->mode == IBNBD_BLOCKIO)
+		return bdev_get_queue(dev->bdev)->limits.discard_zeroes_data;
+	return 0;
+}
+
+static inline int ibnbd_dev_get_discard_granularity(const struct ibnbd_dev *dev)
+{
+	if (dev->mode == IBNBD_BLOCKIO)
+		return bdev_get_queue(dev->bdev)->limits.discard_granularity;
+	return 0;
+}
+
+static inline int ibnbd_dev_get_discard_alignment(const struct ibnbd_dev *dev)
+{
+	if (dev->mode == IBNBD_BLOCKIO)
+		return bdev_get_queue(dev->bdev)->limits.discard_alignment;
+	return 0;
+}
+
+
+/**
+ * ibnbd_dev_get_name() - Return the device name
+ * returns:	Device name up to %BDEVNAME_SIZE% long
+ */
+static inline const char *ibnbd_dev_get_name(const struct ibnbd_dev *dev)
+{
+	return dev->name;
+}
+
+static inline struct block_device *
+ibnbd_dev_get_bdev(const struct ibnbd_dev *dev)
+{
+	return dev->bdev;
+}
+
+
+/**
+ * ibnbd_dev_submit_io() - Submit an I/O to the disk
+ * @dev:	device to that the I/O is submitted
+ * @sector:	address to read/write data to
+ * @data:	I/O data to write or buffer to read I/O date into
+ * @len:	length of @data
+ * @bi_size:	Amount of data that will be read/written
+ * @priv:	private data passed to @io_fn
+ */
+int ibnbd_dev_submit_io(struct ibnbd_dev *dev, sector_t sector, void *data,
+			size_t len, u32 bi_size, enum ibnbd_io_flags flags,
+			void *priv);
+#endif
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
