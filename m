From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] IB/security: restrict use of the write() interface
Date: Wed, 18 May 2016 12:41:59 -0400
Message-ID: <1b7a157f0f701f65ee8de1c208df256e860d7b93.1463589719.git.dledford@redhat.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Upstream commit e6bd18f57aad (IB/security: Restrict use of the write()
interface) handled the cases for all drivers in the current upstream
kernel.  The ipath driver had recently been deprecated and moved to
staging, and then removed entirely.  It had the same security flaw as
the qib driver.  Fix that up with this separate patch.

Note: The ipath driver only supports hardware that ended production
over 10 years ago, so there should be none of this hardware still
present in the wild.

Cc: stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org # <= 4.2.x
Signed-off-by: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/hw/ipath/ipath_file_ops.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/infiniband/hw/ipath/ipath_file_ops.c b/drivers/infiniband/hw/ipath/ipath_file_ops.c
index 450d15965005..1f94b560d749 100644
--- a/drivers/infiniband/hw/ipath/ipath_file_ops.c
+++ b/drivers/infiniband/hw/ipath/ipath_file_ops.c
@@ -45,6 +45,8 @@
 #include <linux/uio.h>
 #include <asm/pgtable.h>
 
+#include <rdma/ib.h>
+
 #include "ipath_kernel.h"
 #include "ipath_common.h"
 #include "ipath_user_sdma.h"
@@ -2244,6 +2246,9 @@ static ssize_t ipath_write(struct file *fp, const char __user *data,
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

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
