From: Levente Kurusa <levex@linux.com>
Subject: [PATCH 34/38] infiniband: core: add missing put_device call
Date: Thu, 19 Dec 2013 16:06:48 +0100
Message-ID: <1387465612-3673-35-git-send-email-levex@linux.com>
References: <1387465612-3673-33-git-send-email-levex@linux.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1387465612-3673-33-git-send-email-levex@linux.com>
Sender: linux-kernel-owner@vger.kernel.org
To: LKML <linux-kernel@vger.kernel.org>
Cc: Levente Kurusa <levex@linux.com>, Roland Dreier <roland@kernel.org>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, Jeff Squyres <jsquyres@cisco.com>, Andrew Morton <akpm@linux-foundation.org>, Kees Cook <keescook@chromium.org>, linux-rdma@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

This is required so that we give up the last reference to the device.

Signed-off-by: Levente Kurusa <levex@linux.com>
---
 drivers/infiniband/core/sysfs.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/core/sysfs.c b/drivers/infiniband/core/sysfs.c
index faad2ca..bf279ce 100644
--- a/drivers/infiniband/core/sysfs.c
+++ b/drivers/infiniband/core/sysfs.c
@@ -824,8 +824,10 @@ int ib_device_register_sysfs(struct ib_device *device,
 	INIT_LIST_HEAD(&device->port_list);
 
 	ret = device_register(class_dev);
-	if (ret)
+	if (ret) {
+		put_device(class_dev);
 		goto err;
+	}
 
 	for (i = 0; i < ARRAY_SIZE(ib_class_attributes); ++i) {
 		ret = device_create_file(class_dev, ib_class_attributes[i]);
-- 
1.8.3.1
