From: Jack Wang <jinpu.wang@profitbricks.com>
Subject: [PATCH 24/28] ibnbd_srv: add log helpers
Date: Fri, 24 Mar 2017 11:45:39 +0100
Message-ID: <1490352343-20075-25-git-send-email-jinpu.wangl@profitbricks.com>
References: <1490352343-20075-1-git-send-email-jinpu.wangl@profitbricks.com>
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <1490352343-20075-1-git-send-email-jinpu.wangl@profitbricks.com>
Sender: linux-block-owner@vger.kernel.org
To: linux-block@vger.kernel.org, linux-rdma@vger.kernel.org
Cc: dledford@redhat.com, axboe@kernel.dk, hch@lst.de, mail@fholler.de, Milind.dumbare@gmail.com, yun.wang@profitbricks.com, Jack Wang <jinpu.wang@profitbricks.com>, Kleber Souza <kleber.souza@profitbricks.com>, Danil Kipnis <danil.kipnis@profitbricks.com>
List-Id: linux-rdma@vger.kernel.org

From: Jack Wang <jinpu.wang@profitbricks.com>

Signed-off-by: Jack Wang <jinpu.wang@profitbricks.com>
Signed-off-by: Kleber Souza <kleber.souza@profitbricks.com>
Signed-off-by: Danil Kipnis <danil.kipnis@profitbricks.com>
---
 drivers/block/ibnbd_server/ibnbd_srv_log.h | 69 ++++++++++++++++++++++++++++++
 1 file changed, 69 insertions(+)
 create mode 100644 drivers/block/ibnbd_server/ibnbd_srv_log.h

diff --git a/drivers/block/ibnbd_server/ibnbd_srv_log.h b/drivers/block/ibnbd_server/ibnbd_srv_log.h
new file mode 100644
index 0000000..9217804
--- /dev/null
+++ b/drivers/block/ibnbd_server/ibnbd_srv_log.h
@@ -0,0 +1,69 @@
+/*
+ * InfiniBand Network Block Driver
+ *
+ * Copyright (c) 2014 - 2017 ProfitBricks GmbH. All rights reserved.
+ * Authors: Fabian Holler < mail@fholler.de>
+ *          Jack Wang <jinpu.wang@profitbricks.com>
+ *   	    Kleber Souza <kleber.souza@profitbricks.com>
+ * 	    Danil Kipnis <danil.kipnis@profitbricks.com>
+ *   	    Roman Pen <roman.penyaev@profitbricks.com>
+ *          Milind Dumbare <Milind.dumbare@gmail.com>
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
+#ifndef __IBNBD_SRV_LOG_H__
+#define __IBNBD_SRV_LOG_H__
+
+#include "../ibnbd_inc/log.h"
+
+#define ERR(dev, fmt, ...) pr_err("ibnbd L%d <%s@%s> ERR: " fmt, \
+				__LINE__, dev->pathname, ibnbd_prefix(dev),\
+				##__VA_ARGS__)
+#define ERR_RL(dev, fmt, ...) pr_err_ratelimited("ibnbd L%d <%s@%s> ERR: " fmt,\
+				__LINE__, dev->pathname, ibnbd_prefix(dev),\
+				##__VA_ARGS__)
+#define WRN(dev, fmt, ...) pr_warn("ibnbd L%d <%s@%s> WARN: " fmt,\
+				__LINE__, dev->pathname, ibnbd_prefix(dev),\
+				##__VA_ARGS__)
+#define WRN_RL(dev, fmt, ...) pr_warn_ratelimited("ibnbd L%d <%s@%s> WARN: " \
+			fmt, __LINE__, dev->pathname, ibnbd_prefix(dev),\
+			##__VA_ARGS__)
+#define INFO(dev, fmt, ...) pr_info("ibnbd <%s@%s>: " \
+			fmt, dev->pathname, ibnbd_prefix(dev), ##__VA_ARGS__)
+#define INFO_RL(dev, fmt, ...) pr_info_ratelimited("ibnbd <%s@%s>: " \
+			fmt, dev->pathname, ibnbd_prefix(dev), ##__VA_ARGS__)
+
+#endif /*__IBNBD_SRV_LOG_H__*/
-- 
2.7.4
