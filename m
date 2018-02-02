From: Roman Pen <roman.penyaev-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Subject: [PATCH 15/24] ibnbd: client: private header with client structs and functions
Date: Fri,  2 Feb 2018 15:08:55 +0100
Message-ID: <20180202140904.2017-16-roman.penyaev@profitbricks.com>
References: <20180202140904.2017-1-roman.penyaev@profitbricks.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180202140904.2017-1-roman.penyaev-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Roman Pen <roman.penyaev-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, Danil Kipnis <danil.kipnis-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, Jack Wang <jinpu.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This header describes main structs and functions used by ibnbd-client
module, mainly for managing IBNBD sessions and mapped block devices,
creating and destroying sysfs entries.

Signed-off-by: Roman Pen <roman.penyaev-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Signed-off-by: Danil Kipnis <danil.kipnis-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Cc: Jack Wang <jinpu.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
---
 drivers/block/ibnbd/ibnbd-clt.h | 193 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 193 insertions(+)

diff --git a/drivers/block/ibnbd/ibnbd-clt.h b/drivers/block/ibnbd/ibnbd-clt.h
new file mode 100644
index 000000000000..b3d72b2962dd
--- /dev/null
+++ b/drivers/block/ibnbd/ibnbd-clt.h
@@ -0,0 +1,193 @@
+/*
+ * InfiniBand Network Block Driver
+ *
+ * Copyright (c) 2014 - 2017 ProfitBricks GmbH. All rights reserved.
+ * Authors: Fabian Holler <mail-99BIx50xQYGELgA04lAiVw@public.gmane.org>
+ *          Jack Wang <jinpu.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
+ *          Kleber Souza <kleber.souza-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
+ *          Danil Kipnis <danil.kipnis-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
+ *          Roman Penyaev <roman.penyaev-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
+ *          Milind Dumbare <Milind.dumbare-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
+ *
+ * Copyright (c) 2017 - 2018 ProfitBricks GmbH. All rights reserved.
+ * Authors: Danil Kipnis <danil.kipnis-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
+ *          Roman Penyaev <roman.penyaev-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version 2
+ * of the License, or (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, see <http://www.gnu.org/licenses/>.
+ */
+
+#ifndef IBNBD_CLT_H
+#define IBNBD_CLT_H
+
+#include <linux/wait.h>
+#include <linux/in.h>
+#include <linux/inet.h>
+#include <linux/blk-mq.h>
+#include <linux/refcount.h>
+
+#include "ibtrs.h"
+#include "ibnbd-proto.h"
+#include "ibnbd-log.h"
+
+#define BMAX_SEGMENTS 31
+#define RECONNECT_DELAY 30
+#define MAX_RECONNECTS -1
+
+enum ibnbd_clt_dev_state {
+	DEV_STATE_INIT,
+	DEV_STATE_MAPPED,
+	DEV_STATE_MAPPED_DISCONNECTED,
+	DEV_STATE_UNMAPPED,
+};
+
+enum ibnbd_queue_mode {
+	BLK_MQ,
+	BLK_RQ
+};
+
+struct ibnbd_iu_comp {
+	wait_queue_head_t wait;
+	int errno;
+};
+
+struct ibnbd_iu {
+	union {
+		struct request *rq; /* for block io */
+		void *buf; /* for user messages */
+	};
+	struct ibtrs_tag	*tag;
+	union {
+		/* use to send msg associated with a dev */
+		struct ibnbd_clt_dev *dev;
+		/* use to send msg associated with a sess */
+		struct ibnbd_clt_session *sess;
+	};
+	blk_status_t		status;
+	struct scatterlist	sglist[BMAX_SEGMENTS];
+	struct work_struct	work;
+	int			errno;
+	struct ibnbd_iu_comp	*comp;
+};
+
+struct ibnbd_cpu_qlist {
+	struct list_head	requeue_list;
+	spinlock_t		requeue_lock;
+	unsigned int		cpu;
+};
+
+struct ibnbd_clt_session {
+	struct list_head        list;
+	struct ibtrs_clt        *ibtrs;
+	wait_queue_head_t       ibtrs_waitq;
+	bool                    ibtrs_ready;
+	struct ibnbd_cpu_qlist	__percpu
+				*cpu_queues;
+	DECLARE_BITMAP(cpu_queues_bm, NR_CPUS);
+	int	__percpu	*cpu_rr; /* per-cpu var for CPU round-robin */
+	atomic_t		busy;
+	int			queue_depth;
+	u32			max_io_size;
+	struct blk_mq_tag_set	tag_set;
+	struct mutex		lock; /* protects state and devs_list */
+	struct list_head        devs_list; /* list of struct ibnbd_clt_dev */
+	refcount_t		refcount;
+	char			sessname[NAME_MAX];
+	u8			ver; /* protocol version */
+};
+
+/**
+ * Submission queues.
+ */
+struct ibnbd_queue {
+	struct list_head	requeue_list;
+	unsigned long		in_list;
+	struct ibnbd_clt_dev	*dev;
+	struct blk_mq_hw_ctx	*hctx;
+};
+
+struct ibnbd_clt_dev {
+	struct ibnbd_clt_session	*sess;
+	struct request_queue	*queue;
+	struct ibnbd_queue	*hw_queues;
+	struct delayed_work	rq_delay_work;
+	u32			device_id;
+	/* local Idr index - used to track minor number allocations. */
+	u32			clt_device_id;
+	struct mutex		lock;
+	enum ibnbd_clt_dev_state	dev_state;
+	enum ibnbd_queue_mode	queue_mode;
+	enum ibnbd_io_mode	io_mode; /* user requested */
+	enum ibnbd_io_mode	remote_io_mode; /* server really used */
+	char			pathname[NAME_MAX];
+	enum ibnbd_access_mode	access_mode;
+	bool			read_only;
+	bool			rotational;
+	u32			max_hw_sectors;
+	u32			max_write_same_sectors;
+	u32			max_discard_sectors;
+	u32			discard_granularity;
+	u32			discard_alignment;
+	u16			secure_discard;
+	u16			physical_block_size;
+	u16			logical_block_size;
+	u16			max_segments;
+	size_t			nsectors;
+	u64			size;		/* device size in bytes */
+	struct list_head        list;
+	struct gendisk		*gd;
+	struct kobject		kobj;
+	char			blk_symlink_name[NAME_MAX];
+	refcount_t		refcount;
+	struct work_struct	unmap_on_rmmod_work;
+};
+
+static inline const char *ibnbd_queue_mode_str(enum ibnbd_queue_mode mode)
+{
+	switch (mode) {
+	case BLK_RQ:
+		return "rq";
+	case BLK_MQ:
+		return "mq";
+	default:
+		return "unknown";
+	}
+}
+
+/* ibnbd-clt.c */
+
+struct ibnbd_clt_dev *ibnbd_clt_map_device(const char *sessname,
+					   struct ibtrs_addr *paths,
+					   size_t path_cnt,
+					   const char *pathname,
+					   enum ibnbd_access_mode access_mode,
+					   enum ibnbd_queue_mode queue_mode,
+					   enum ibnbd_io_mode io_mode);
+int ibnbd_clt_unmap_device(struct ibnbd_clt_dev *dev, bool force,
+			   const struct attribute *sysfs_self);
+
+int ibnbd_clt_remap_device(struct ibnbd_clt_dev *dev);
+int ibnbd_clt_resize_disk(struct ibnbd_clt_dev *dev, size_t newsize);
+
+/* ibnbd-clt-sysfs.c */
+
+int ibnbd_clt_create_sysfs_files(void);
+
+void ibnbd_clt_destroy_sysfs_files(void);
+void ibnbd_clt_destroy_default_group(void);
+
+void ibnbd_clt_remove_dev_symlink(struct ibnbd_clt_dev *dev);
+void ibnbd_sysfs_remove_file_self(struct kobject *kobj,
+				  const struct attribute *attr);
+
+#endif /* IBNBD_CLT_H */
-- 
2.13.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
