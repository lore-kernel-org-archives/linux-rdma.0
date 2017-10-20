From: Colin King <colin.king@canonical.com>
Subject: [PATCH] IB/qib: remove redundant setting of any in for-loop
Date: Fri, 20 Oct 2017 09:21:03 +0200
Message-ID: <20171020072103.10337-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Mike Marciniszyn <infinipath@intel.com>, Doug Ledford <dledford@redhat.com>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, linux-rdma@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

The variable all is being set but is never read after this
hence it can be removed from the for loop initialization.
Cleans up clang warning:

drivers/infiniband/hw/qib/qib_file_ops.c:640:7: warning: Value
stored to 'any' is never read

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/infiniband/hw/qib/qib_file_ops.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/qib/qib_file_ops.c b/drivers/infiniband/hw/qib/qib_file_ops.c
index 2d6a191afec0..b5c2e4223ee7 100644
--- a/drivers/infiniband/hw/qib/qib_file_ops.c
+++ b/drivers/infiniband/hw/qib/qib_file_ops.c
@@ -637,7 +637,7 @@ static int qib_set_part_key(struct qib_ctxtdata *rcd, u16 key)
 		ret = -EBUSY;
 		goto bail;
 	}
-	for (any = i = 0; i < ARRAY_SIZE(ppd->pkeys); i++) {
+	for (i = 0; i < ARRAY_SIZE(ppd->pkeys); i++) {
 		if (!ppd->pkeys[i] &&
 		    atomic_inc_return(&ppd->pkeyrefs[i]) == 1) {
 			rcd->pkeys[pidx] = key;
-- 
2.14.1
