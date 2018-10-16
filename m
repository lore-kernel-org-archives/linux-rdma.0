From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: [PATCH] RDMA/ucma: Fix Spectre v1 vulnerability
Date: Tue, 16 Oct 2018 16:59:01 +0200
Message-ID: <20181016145901.GA8811@embeddedor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, "Gustavo A. R. Silva" <gustavo@embeddedor.com>
List-Id: linux-rdma@vger.kernel.org

hdr.cmd can be indirectly controlled by user-space, hence leading to
a potential exploitation of the Spectre variant 1 vulnerability.

This issue was detected with the help of Smatch:

drivers/infiniband/core/ucma.c:1686 ucma_write() warn: potential
spectre issue 'ucma_cmd_table' [r] (local cap)

Fix this by sanitizing hdr.cmd before using it to index
ucm_cmd_table.

Notice that given that speculation windows are large, the policy is
to kill the speculation on the first load and not worry if it can be
completed with a dependent load/store [1].

[1] https://marc.info/?l=linux-kernel&m=152449131114778&w=2

Cc: stable@vger.kernel.org
Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
---
 drivers/infiniband/core/ucma.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/infiniband/core/ucma.c b/drivers/infiniband/core/ucma.c
index 21863dd..01d68ed 100644
--- a/drivers/infiniband/core/ucma.c
+++ b/drivers/infiniband/core/ucma.c
@@ -44,6 +44,8 @@
 #include <linux/module.h>
 #include <linux/nsproxy.h>
 
+#include <linux/nospec.h>
+
 #include <rdma/rdma_user_cm.h>
 #include <rdma/ib_marshall.h>
 #include <rdma/rdma_cm.h>
@@ -1676,6 +1678,7 @@ static ssize_t ucma_write(struct file *filp, const char __user *buf,
 
 	if (hdr.cmd >= ARRAY_SIZE(ucma_cmd_table))
 		return -EINVAL;
+	hdr.cmd = array_index_nospec(hdr.cmd, ARRAY_SIZE(ucma_cmd_table));
 
 	if (hdr.in + sizeof(hdr) > len)
 		return -EINVAL;
-- 
2.7.4
