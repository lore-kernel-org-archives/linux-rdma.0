From: Dmitry Vyukov <dvyukov@google.com>
Subject: [PATCH] infiniband: remove WARN that is not kernel bug
Date: Fri, 18 Nov 2016 12:24:37 +0100
Message-ID: <1479468277-50798-1-git-send-email-dvyukov@google.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: dledford@redhat.com, sean.hefty@intel.com, hal.rosenstock@gmail.com, leon@kernel.org
Cc: Dmitry Vyukov <dvyukov@google.com>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, syzkaller@googlegroups.com
List-Id: linux-rdma@vger.kernel.org

WARNINGs mean kernel bugs.
The one in ucma_write() points to user programming error
or a malicious attempt. This is not a kernel bug, remove it.

BUG/WARNs that are not kernel bugs hinder automated testing effots.

Signed-off-by: Dmitry Vyukov <dvyukov@google.com>
Cc: Doug Ledford <dledford@redhat.com>
Cc: Sean Hefty <sean.hefty@intel.com>
Cc: Hal Rosenstock <hal.rosenstock@gmail.com>
Cc: Leon Romanovsky <leon@kernel.org>
Cc: linux-rdma@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: syzkaller@googlegroups.com
---
 drivers/infiniband/core/ucma.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/core/ucma.c b/drivers/infiniband/core/ucma.c
index 9520154..ff60373 100644
--- a/drivers/infiniband/core/ucma.c
+++ b/drivers/infiniband/core/ucma.c
@@ -1584,7 +1584,7 @@ static ssize_t ucma_write(struct file *filp, const char __user *buf,
 	struct rdma_ucm_cmd_hdr hdr;
 	ssize_t ret;
 
-	if (WARN_ON_ONCE(!ib_safe_file_access(filp)))
+	if (!ib_safe_file_access(filp))
 		return -EACCES;
 
 	if (len < sizeof(hdr))
-- 
2.8.0.rc3.226.g39d4020
