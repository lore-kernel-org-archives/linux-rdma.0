From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: [PATCH rdma-core 3/5] mthca: Avoid bogus gcc 4.8 warning -Wmaybe-uninitialized
Date: Fri,  7 Oct 2016 16:36:10 -0600
Message-ID: <1475879772-29458-4-git-send-email-jgunthorpe@obsidianresearch.com>
References: <1475879772-29458-1-git-send-email-jgunthorpe@obsidianresearch.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1475879772-29458-1-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Newer compilers get this right, so use uninitialized_var()

Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
---
 providers/mthca/qp.c | 23 +++++------------------
 1 file changed, 5 insertions(+), 18 deletions(-)

diff --git a/providers/mthca/qp.c b/providers/mthca/qp.c
index 715ca65e9bd6..129e6c74ef53 100644
--- a/providers/mthca/qp.c
+++ b/providers/mthca/qp.c
@@ -37,6 +37,7 @@
 #include <netinet/in.h>
 #include <pthread.h>
 #include <string.h>
+#include <util/compiler.h>
 
 #include "mthca.h"
 #include "doorbell.h"
@@ -107,15 +108,8 @@ int mthca_tavor_post_send(struct ibv_qp *ibqp, struct ibv_send_wr *wr,
 	int size;
 	int size0 = 0;
 	int i;
-	/*
-	 * f0 and op0 cannot be used unless nreq > 0, which means this
-	 * function makes it through the loop at least once.  So the
-	 * code inside the if (!size0) will be executed, and f0 and
-	 * op0 will be initialized.  So any gcc warning about "may be
-	 * used unitialized" is bogus.
-	 */
-	uint32_t f0;
-	uint32_t op0;
+	uint32_t uninitialized_var(f0);
+	uint32_t uninitialized_var(op0);
 
 	pthread_spin_lock(&qp->sq.lock);
 
@@ -449,15 +443,8 @@ int mthca_arbel_post_send(struct ibv_qp *ibqp, struct ibv_send_wr *wr,
 	int size;
 	int size0 = 0;
 	int i;
-	/*
-	 * f0 and op0 cannot be used unless nreq > 0, which means this
-	 * function makes it through the loop at least once.  So the
-	 * code inside the if (!size0) will be executed, and f0 and
-	 * op0 will be initialized.  So any gcc warning about "may be
-	 * used unitialized" is bogus.
-	 */
-	uint32_t f0;
-	uint32_t op0;
+	uint32_t uninitialized_var(f0);
+	uint32_t uninitialized_var(op0);
 
 	pthread_spin_lock(&qp->sq.lock);
 
-- 
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
