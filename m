From: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 1/2] IB/qib: remove redundant setting of any in for-loop
Date: Tue, 14 Nov 2017 16:29:36 -0500
Message-ID: <20171114212936.17403.34341.stgit@phlsvslse11.ph.intel.com>
References: <20171114212905.17403.77778.stgit@phlsvslse11.ph.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171114212905.17403.77778.stgit-K+u1se/DcYrLESAwzcoQNrvm/XP+8Wra@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Colin Ian King <colin.king-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>

The variable all is being set but is never read after this
hence it can be removed from the for loop initialization.
Cleans up clang warning:

drivers/infiniband/hw/qib/qib_file_ops.c:640:7: warning: Value
stored to 'any' is never read

Tested-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Colin Ian King <colin.king-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Signed-off-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/qib/qib_file_ops.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/qib/qib_file_ops.c b/drivers/infiniband/hw/qib/qib_file_ops.c
index 9396c18..b25571f 100644
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
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
