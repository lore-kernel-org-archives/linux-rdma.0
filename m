From: Roman Pen <roman.penyaev@profitbricks.com>
Subject: [PATCH 18/24] ibnbd: server: private header with server structs and functions
Date: Fri,  2 Feb 2018 15:08:58 +0100
Message-ID: <20180202140904.2017-19-roman.penyaev@profitbricks.com>
References: <20180202140904.2017-1-roman.penyaev@profitbricks.com>
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20180202140904.2017-1-roman.penyaev@profitbricks.com>
Sender: linux-block-owner@vger.kernel.org
To: linux-block@vger.kernel.org, linux-rdma@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@infradead.org>, Sagi Grimberg <sagi@grimberg.me>, Bart Van Assche <bart.vanassche@sandisk.com>, Or Gerlitz <ogerlitz@mellanox.com>, Roman Pen <roman.penyaev@profitbricks.com>, Danil Kipnis <danil.kipnis@profitbricks.com>, Jack Wang <jinpu.wang@profitbricks.com>
List-Id: linux-rdma@vger.kernel.org

This header describes main structs and functions used by ibnbd-server
module, namely structs for managing sessions from different clients
and mapped (opened) devices.

Signed-off-by: Roman Pen <roman.penyaev@profitbricks.com>
Signed-off-by: Danil Kipnis <danil.kipnis@profitbricks.com>
Cc: Jack Wang <jinpu.wang@profitbricks.com>
---
 drivers/block/ibnbd/ibnbd-srv.h | 100 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 100 insertions(+)

diff --git a/drivers/block/ibnbd/ibnbd-srv.h b/drivers/block/ibnbd/ibnbd-srv.h
new file mode 100644
index 000000000000..191a1650bc1d
--- /dev/null
+++ b/drivers/block/ibnbd/ibnbd-srv.h
@@ -0,0 +1,100 @@
+/*
+ * InfiniBand Network Block Driver
+ *
+ * Copyright (c) 2014 - 2017 ProfitBricks GmbH. All rights reserved.
+ * Authors: Fabian Holler <mail@fholler.de>
+ *          Jack Wang <jinpu.wang@profitbricks.com>
+ *          Kleber Souza <kleber.souza@profitbricks.com>
+ *          Danil Kipnis <danil.kipnis@profitbricks.com>
+ *          Roman Penyaev <roman.penyaev@profitbricks.com>
+ *          Milind Dumbare <Milind.dumbare@gmail.com>
+ *
+ * Copyright (c) 2017 - 2018 ProfitBricks GmbH. All rights reserved.
+ * Authors: Danil Kipnis <danil.kipnis@profitbricks.com>
+ *          Roman Penyaev <roman.penyaev@profitbricks.com>
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
+#ifndef IBNBD_SRV_H
+#define IBNBD_SRV_H
+
+#include <linux/types.h>
+#include <linux/idr.h>
+#include <linux/kref.h>
+
+#include "ibtrs.h"
+#include "ibnbd-proto.h"
+#include "ibnbd-log.h"
+
+struct ibnbd_srv_session {
+	/* Entry inside global sess_list */
+	struct list_head        list;
+	struct ibtrs_srv	*ibtrs;
+	char			sessname[NAME_MAX];
+	int			queue_depth;
+	struct bio_set		*sess_bio_set;
+
+	rwlock_t                index_lock ____cacheline_aligned;
+	struct idr              index_idr;
+	/* List of struct ibnbd_srv_sess_dev */
+	struct list_head        sess_dev_list;
+	struct mutex		lock;
+	u8			ver;
+};
+
+struct ibnbd_srv_dev {
+	/* Entry inside global dev_list */
+	struct list_head                list;
+	struct kobject                  dev_kobj;
+	struct kobject                  dev_sessions_kobj;
+	struct kref                     kref;
+	char				id[NAME_MAX];
+	/* List of ibnbd_srv_sess_dev structs */
+	struct list_head		sess_dev_list;
+	struct mutex			lock;
+	int				open_write_cnt;
+	enum ibnbd_io_mode		mode;
+};
+
+/* Structure which binds N devices and N sessions */
+struct ibnbd_srv_sess_dev {
+	/* Entry inside ibnbd_srv_dev struct */
+	struct list_head		dev_list;
+	/* Entry inside ibnbd_srv_session struct */
+	struct list_head		sess_list;
+	struct ibnbd_dev		*ibnbd_dev;
+	struct ibnbd_srv_session        *sess;
+	struct ibnbd_srv_dev		*dev;
+	struct kobject                  kobj;
+	struct completion		*sysfs_release_compl;
+	u32                             device_id;
+	fmode_t                         open_flags;
+	struct kref			kref;
+	struct completion               *destroy_comp;
+	char				pathname[NAME_MAX];
+};
+
+/* ibnbd-srv-sysfs.c */
+
+int ibnbd_srv_create_dev_sysfs(struct ibnbd_srv_dev *dev,
+			       struct block_device *bdev,
+			       const char *dir_name);
+void ibnbd_srv_destroy_dev_sysfs(struct ibnbd_srv_dev *dev);
+int ibnbd_srv_create_dev_session_sysfs(struct ibnbd_srv_sess_dev *sess_dev);
+void ibnbd_srv_destroy_dev_session_sysfs(struct ibnbd_srv_sess_dev *sess_dev);
+int ibnbd_srv_create_sysfs_files(void);
+void ibnbd_srv_destroy_sysfs_files(void);
+
+#endif /* IBNBD_SRV_H */
-- 
2.13.1
