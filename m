From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH] IB/qib: Use memdup_user() rather than duplicating its
 implementation
Date: Fri, 19 Aug 2016 09:06:20 +0200
Message-ID: <620b3961-6e05-6638-4ca8-18766acc91f4@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-rdma@vger.kernel.org, Doug Ledford <dledford@redhat.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, Mike Marciniszyn <infinipath@intel.com>, Sean Hefty <sean.hefty@intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org, Julia Lawall <julia.lawall@lip6.fr>
List-Id: linux-rdma@vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Fri, 19 Aug 2016 08:50:23 +0200

Reuse existing functionality from memdup_user() instead of keeping
duplicate source code.

This issue was detected by using the Coccinelle software.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/infiniband/hw/qib/qib_fs.c | 11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/drivers/infiniband/hw/qib/qib_fs.c b/drivers/infiniband/hw/qib/qib_fs.c
index fcdf3791..910f0d9 100644
--- a/drivers/infiniband/hw/qib/qib_fs.c
+++ b/drivers/infiniband/hw/qib/qib_fs.c
@@ -338,17 +338,12 @@ static ssize_t flash_write(struct file *file, const char __user *buf,
 		goto bail;
 	}
 
-	tmp = kmalloc(count, GFP_KERNEL);
-	if (!tmp) {
-		ret = -ENOMEM;
+	tmp = memdup_user(buf, count);
+	if (IS_ERR(tmp)) {
+		ret = PTR_ERR(tmp);
 		goto bail;
 	}
 
-	if (copy_from_user(tmp, buf, count)) {
-		ret = -EFAULT;
-		goto bail_tmp;
-	}
-
 	dd = private2dd(file);
 	if (qib_eeprom_write(dd, pos, tmp, count)) {
 		ret = -ENXIO;
-- 
2.9.3
