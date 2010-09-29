From: Steve Wise <swise@opengridcomputing.com>
Subject: [PATCH] RDMA/cxgb4: Add default_llseek to debugfs files.
Date: Wed, 29 Sep 2010 09:11:12 -0500
Message-ID: <20100929141112.26944.21931.stgit@build.ogc.int>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: rdreier@cisco.com, stable@kernel.org
Cc: linux-rdma@vger.kernel.org, linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

This resolves a linux-next merge issue.

Signed-off-by: Steve Wise <swise@opengridcomputing.com>
---

 drivers/infiniband/hw/cxgb4/device.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/infiniband/hw/cxgb4/device.c b/drivers/infiniband/hw/cxgb4/device.c
index 986cfd7..b254357 100644
--- a/drivers/infiniband/hw/cxgb4/device.c
+++ b/drivers/infiniband/hw/cxgb4/device.c
@@ -182,6 +182,7 @@ static const struct file_operations qp_debugfs_fops = {
 	.open    = qp_open,
 	.release = qp_release,
 	.read    = debugfs_read,
+	.llseek  = default_llseek,
 };
 
 static int dump_stag(int id, void *p, void *data)
@@ -255,6 +256,7 @@ static const struct file_operations stag_debugfs_fops = {
 	.open    = stag_open,
 	.release = stag_release,
 	.read    = debugfs_read,
+	.llseek  = default_llseek,
 };
 
 static int setup_debugfs(struct c4iw_dev *devp)
