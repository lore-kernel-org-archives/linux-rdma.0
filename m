From: Kees Cook <keescook@chromium.org>
Subject: [PATCH 28/31] infiniband/rdmavt: Remove redundant timer initialization
Date: Thu, 31 Aug 2017 16:29:40 -0700
Message-ID: <1504222183-61202-29-git-send-email-keescook@chromium.org>
References: <1504222183-61202-1-git-send-email-keescook@chromium.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1504222183-61202-1-git-send-email-keescook@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Kees Cook <keescook@chromium.org>, Dennis Dalessandro <dennis.dalessandro@intel.com>, Doug Ledford <dledford@redhat.com>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

setup_timer() is already called before the open-coded init_timer() and .data
assignment. Remove it.

Cc: Dennis Dalessandro <dennis.dalessandro@intel.com>
Cc: Doug Ledford <dledford@redhat.com>
Cc: Sean Hefty <sean.hefty@intel.com>
Cc: Hal Rosenstock <hal.rosenstock@gmail.com>
Cc: linux-rdma@vger.kernel.org
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/infiniband/sw/rdmavt/qp.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/infiniband/sw/rdmavt/qp.c b/drivers/infiniband/sw/rdmavt/qp.c
index 8876ee7bc326..6b95cdb6c517 100644
--- a/drivers/infiniband/sw/rdmavt/qp.c
+++ b/drivers/infiniband/sw/rdmavt/qp.c
@@ -789,8 +789,6 @@ struct ib_qp *rvt_create_qp(struct ib_pd *ibpd,
 		atomic_set(&qp->refcount, 0);
 		atomic_set(&qp->local_ops_pending, 0);
 		init_waitqueue_head(&qp->wait);
-		init_timer(&qp->s_timer);
-		qp->s_timer.data = (unsigned long)qp;
 		INIT_LIST_HEAD(&qp->rspwait);
 		qp->state = IB_QPS_RESET;
 		qp->s_wq = swq;
-- 
2.7.4
