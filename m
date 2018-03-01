From: Colin King <colin.king@canonical.com>
Subject: [PATCH] infiniband: remove redundant assignment to pointer 'rdi'
Date: Thu,  1 Mar 2018 16:23:54 +0000
Message-ID: <20180301162354.17420-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Dennis Dalessandro <dennis.dalessandro@intel.com>, Mike Marciniszyn <mike.marciniszyn@intel.com>, Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>, linux-rdma@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

The pointer rdi is being initialized with a value that is never read
and re-assigned immediately after, hence the initialization is redundant
and can be removed.

Cleans up clang warning:
drivers/infiniband/sw/rdmavt/vt.c:94:23: warning: Value stored to 'rdi'
during its initialization is never read

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/infiniband/sw/rdmavt/vt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/sw/rdmavt/vt.c b/drivers/infiniband/sw/rdmavt/vt.c
index a4553b2b3696..a67b0ddc2230 100644
--- a/drivers/infiniband/sw/rdmavt/vt.c
+++ b/drivers/infiniband/sw/rdmavt/vt.c
@@ -91,7 +91,7 @@ module_exit(rvt_cleanup);
  */
 struct rvt_dev_info *rvt_alloc_device(size_t size, int nports)
 {
-	struct rvt_dev_info *rdi = ERR_PTR(-ENOMEM);
+	struct rvt_dev_info *rdi;
 
 	rdi = (struct rvt_dev_info *)ib_alloc_device(size);
 	if (!rdi)
-- 
2.15.1
