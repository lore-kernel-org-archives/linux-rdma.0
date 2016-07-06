From: Adit Ranadive <aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v1 02/15] IB/pvrdma: Add device command support
Date: Tue, 5 Jul 2016 23:14:35 -0700
Message-ID: <1467785688-23229-3-git-send-email-aditr@vmware.com>
References: <1467785688-23229-1-git-send-email-aditr@vmware.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1467785688-23229-1-git-send-email-aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, pv-drivers-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org
Cc: Adit Ranadive <aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>, jhansen-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org, asarwade-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org, georgezhang-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org, bryantan-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This patch enables posting Verb requests and receiving responses to/from
the backend PVRDMA emulation layer.

Reviewed-by: Jorgen Hansen <jhansen-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
Reviewed-by: George Zhang <georgezhang-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
Reviewed-by: Aditya Sarwade <asarwade-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
Reviewed-by: Bryan Tan <bryantan-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
Signed-off-by: Adit Ranadive <aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/hw/pvrdma/pvrdma_cmd.c | 104 ++++++++++++++++++++++++++++++
 1 file changed, 104 insertions(+)
 create mode 100644 drivers/infiniband/hw/pvrdma/pvrdma_cmd.c

diff --git a/drivers/infiniband/hw/pvrdma/pvrdma_cmd.c b/drivers/infiniband/hw/pvrdma/pvrdma_cmd.c
new file mode 100644
index 0000000..c22debf
--- /dev/null
+++ b/drivers/infiniband/hw/pvrdma/pvrdma_cmd.c
@@ -0,0 +1,104 @@
+/*
+ * Copyright (c) 2012-2016 VMware, Inc.  All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of EITHER the GNU General Public License
+ * version 2 as published by the Free Software Foundation or the BSD
+ * 2-Clause License. This program is distributed in the hope that it
+ * will be useful, but WITHOUT ANY WARRANTY; WITHOUT EVEN THE IMPLIED
+ * WARRANTY OF MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE.
+ * See the GNU General Public License version 2 for more details at
+ * http://www.gnu.org/licenses/old-licenses/gpl-2.0.en.html.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program available in the file COPYING in the main
+ * directory of this source tree.
+ *
+ * The BSD 2-Clause License
+ *
+ *     Redistribution and use in source and binary forms, with or
+ *     without modification, are permitted provided that the following
+ *     conditions are met:
+ *
+ *      - Redistributions of source code must retain the above
+ *        copyright notice, this list of conditions and the following
+ *        disclaimer.
+ *
+ *      - Redistributions in binary form must reproduce the above
+ *        copyright notice, this list of conditions and the following
+ *        disclaimer in the documentation and/or other materials
+ *        provided with the distribution.
+ *
+ * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
+ * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
+ * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
+ * FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE
+ * COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT,
+ * INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
+ * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
+ * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
+ * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
+ * STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
+ * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED
+ * OF THE POSSIBILITY OF SUCH DAMAGE.
+ */
+
+#include <linux/list.h>
+
+#include "pvrdma.h"
+
+#define PVRDMA_CMD_TIMEOUT	10000 /* ms */
+
+static int pvrdma_cmd_recv(struct pvrdma_dev *dev, union pvrdma_cmd_resp *resp)
+{
+	dev_dbg(&dev->pdev->dev, "receive response from device\n");
+
+	spin_lock(&dev->cmd_lock);
+	memcpy(resp, dev->resp_slot, sizeof(*resp));
+	spin_unlock(&dev->cmd_lock);
+
+	return 0;
+}
+
+int
+pvrdma_cmd_post(struct pvrdma_dev *dev, union pvrdma_cmd_req *req,
+		bool expect_resp, union pvrdma_cmd_resp *resp)
+{
+	int err;
+
+	dev_dbg(&dev->pdev->dev, "post request to device\n");
+
+	/* Serializiation */
+	down(&dev->cmd_sema);
+
+	spin_lock(&dev->cmd_lock);
+	memcpy(dev->cmd_slot, req, sizeof(*req));
+	spin_unlock(&dev->cmd_lock);
+
+	init_completion(&dev->cmd_done);
+	pvrdma_write_reg(dev, PVRDMA_REG_REQUEST, 0);
+
+	/* Make sure the request is written before reading status. */
+	mb();
+	err = pvrdma_read_reg(dev, PVRDMA_REG_ERR);
+	if (err == 0) {
+		if (expect_resp) {
+			err = wait_for_completion_interruptible_timeout(
+				&dev->cmd_done,
+				msecs_to_jiffies(PVRDMA_CMD_TIMEOUT));
+			if (err == 0) {
+				dev_warn(&dev->pdev->dev,
+					 "completion timeout\n");
+				err = -ETIMEDOUT;
+			} else {
+				err = pvrdma_cmd_recv(dev, resp);
+			}
+		}
+	} else {
+		dev_warn(&dev->pdev->dev, "failed to write request %d\n", err);
+	}
+
+	up(&dev->cmd_sema);
+
+	return err;
+}
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
