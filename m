From: Colin King <colin.king@canonical.com>
Subject: [PATCH] iw_cxgb4: make pointer reg_workq static
Date: Thu, 30 Nov 2017 13:30:06 +0000
Message-ID: <20171130133006.19699-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Steve Wise <swise@chelsio.com>, Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>, linux-rdma@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

The pointer reg_workq is local to the source and does not need to be
in global scope, so make it static.

Cleans up sparse warning:
drivers/infiniband/hw/cxgb4/device.c:69:25: warning: symbol 'reg_workq'
was not declared. Should it be static?

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/infiniband/hw/cxgb4/device.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/cxgb4/device.c b/drivers/infiniband/hw/cxgb4/device.c
index af77d128d242..91cbe3aae32e 100644
--- a/drivers/infiniband/hw/cxgb4/device.c
+++ b/drivers/infiniband/hw/cxgb4/device.c
@@ -66,7 +66,7 @@ MODULE_PARM_DESC(c4iw_wr_log_size_order,
 
 static LIST_HEAD(uld_ctx_list);
 static DEFINE_MUTEX(dev_mutex);
-struct workqueue_struct *reg_workq;
+static struct workqueue_struct *reg_workq;
 
 #define DB_FC_RESUME_SIZE 64
 #define DB_FC_RESUME_DELAY 1
-- 
2.14.1
