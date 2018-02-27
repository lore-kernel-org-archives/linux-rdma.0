From: =?UTF-8?q?Hern=C3=A1n=20Gonzalez?= <hernan@vanguardiasur.com.ar>
Subject: [PATCH] IB/rxe: Remove unused variable (char *rxe_qp_state_name[])
Date: Tue, 27 Feb 2018 19:07:58 -0300
Message-ID: <1519769278-20094-1-git-send-email-hernan@vanguardiasur.com.ar>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: monis@mellanox.com, dledford@redhat.com, jgg@ziepe.ca, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: =?UTF-8?q?Hern=C3=A1n=20Gonzalez?= <hernan@vanguardiasur.com.ar>
List-Id: linux-rdma@vger.kernel.org

Note: This is compile only tested as I have no access to the hw.
This variable was not used anywhere in the code. Removing it saves 24 bytes.

add/remove: 0/1 grow/shrink: 0/0 up/down: 0/-24 (-24)
Function                                     old     new   delta
rxe_qp_state_name                             24       -     -24
Total: Before=3348732, After=3348708, chg -0.00%

Signed-off-by: Hernán Gonzalez <hernan@vanguardiasur.com.ar>
---
 drivers/infiniband/sw/rxe/rxe_qp.c    | 9 ---------
 drivers/infiniband/sw/rxe/rxe_verbs.h | 2 --
 2 files changed, 11 deletions(-)

diff --git a/drivers/infiniband/sw/rxe/rxe_qp.c b/drivers/infiniband/sw/rxe/rxe_qp.c
index 137d6c0..ba4652f 100644
--- a/drivers/infiniband/sw/rxe/rxe_qp.c
+++ b/drivers/infiniband/sw/rxe/rxe_qp.c
@@ -40,15 +40,6 @@
 #include "rxe_queue.h"
 #include "rxe_task.h"
 
-char *rxe_qp_state_name[] = {
-	[QP_STATE_RESET]	= "RESET",
-	[QP_STATE_INIT]		= "INIT",
-	[QP_STATE_READY]	= "READY",
-	[QP_STATE_DRAIN]	= "DRAIN",
-	[QP_STATE_DRAINED]	= "DRAINED",
-	[QP_STATE_ERROR]	= "ERROR",
-};
-
 static int rxe_qp_chk_cap(struct rxe_dev *rxe, struct ib_qp_cap *cap,
 			  int has_srq)
 {
diff --git a/drivers/infiniband/sw/rxe/rxe_verbs.h b/drivers/infiniband/sw/rxe/rxe_verbs.h
index 1019f5e..af1470d 100644
--- a/drivers/infiniband/sw/rxe/rxe_verbs.h
+++ b/drivers/infiniband/sw/rxe/rxe_verbs.h
@@ -139,8 +139,6 @@ enum rxe_qp_state {
 	QP_STATE_ERROR
 };
 
-extern char *rxe_qp_state_name[];
-
 struct rxe_req_info {
 	enum rxe_qp_state	state;
 	int			wqe_index;
-- 
2.7.4
