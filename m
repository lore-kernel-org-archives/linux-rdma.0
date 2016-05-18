From: Doug Ledford <dledford@redhat.com>
Subject: [PATCH] IB/security: restrict use of the write() interface
Date: Wed, 18 May 2016 12:46:11 -0400
Message-ID: <616598d79c0b8750d74e50cf22f8b61a9ef55c1d.1463589971.git.dledford@redhat.com>
Return-path: <stable-owner@vger.kernel.org>
Sender: stable-owner@vger.kernel.org
To: stable@vger.kernel.org, linux-rdma@vger.kernel.org
Cc: dledford@redhat.com
List-Id: linux-rdma@vger.kernel.org

Upstream commit e6bd18f57aad (IB/security: Restrict use of the write()
interface) handled the cases for all drivers in the current upstream
kernel.  The ipath driver had recently been deprecated and moved to
staging, and then removed entirely.  It had the same security flaw as
the qib driver.  Fix that up with this separate patch.

Note: The ipath driver only supports hardware that ended production
over 10 years ago, so there should be none of this hardware still
present in the wild.

Cc: stable@vger.kernel.org # 4.4.x
Signed-off-by: Doug Ledford <dledford@redhat.com>
---
 drivers/staging/rdma/ipath/ipath_file_ops.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/staging/rdma/ipath/ipath_file_ops.c b/drivers/staging/rdma/ipath/ipath_file_ops.c
index 13c3cd11ab92..f237a2e2a086 100644
--- a/drivers/staging/rdma/ipath/ipath_file_ops.c
+++ b/drivers/staging/rdma/ipath/ipath_file_ops.c
@@ -45,6 +45,8 @@
 #include <linux/uio.h>
 #include <asm/pgtable.h>
 
+#include <rdma/ib.h>
+
 #include "ipath_kernel.h"
 #include "ipath_common.h"
 #include "ipath_user_sdma.h"
@@ -2243,6 +2245,9 @@ static ssize_t ipath_write(struct file *fp, const char __user *data,
 	ssize_t ret = 0;
 	void *dest;
 
+	if (WARN_ON_ONCE(!ib_safe_file_access(fp)))
+		return -EACCESS;
+
 	if (count < sizeof(cmd.type)) {
 		ret = -EINVAL;
 		goto bail;
-- 
2.5.5
