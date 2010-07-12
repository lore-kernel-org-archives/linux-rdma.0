From: Joe Perches <joe@perches.com>
Subject: [PATCH 09/36] drivers/infiniband: Remove unnecessary casts of private_data
Date: Mon, 12 Jul 2010 13:50:01 -0700
Message-ID: <0074ff36bc27b141d3639e2d516cc6cd48364df6.1278967120.git.joe@perches.com>
References: <cover.1278967120.git.joe@perches.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1278967120.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jiri Kosina <trivial@kernel.org>
Cc: linux-kernel@vger.kernel.org, Ralph Campbell <infinipath@qlogic.com>, Roland Dreier <rolandd@cisco.com>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, linux-rdma@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/infiniband/hw/ipath/ipath_file_ops.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/infiniband/hw/ipath/ipath_file_ops.c b/drivers/infiniband/hw/ipath/ipath_file_ops.c
index 9c5c66d..65eb892 100644
--- a/drivers/infiniband/hw/ipath/ipath_file_ops.c
+++ b/drivers/infiniband/hw/ipath/ipath_file_ops.c
@@ -2055,7 +2055,7 @@ static int ipath_close(struct inode *in, struct file *fp)
 
 	mutex_lock(&ipath_mutex);
 
-	fd = (struct ipath_filedata *) fp->private_data;
+	fd = fp->private_data;
 	fp->private_data = NULL;
 	pd = fd->pd;
 	if (!pd) {
-- 
1.7.1.337.g6068.dirty
