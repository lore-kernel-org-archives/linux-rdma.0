From: Julia Lawall <Julia.Lawall@lip6.fr>
Subject: [PATCH 8/16] drivers/infiniband/hw/cxgb3/iwch_cm.c: use WARN
Date: Sat,  3 Nov 2012 11:58:29 +0100
Message-ID: <1351940317-14812-9-git-send-email-Julia.Lawall@lip6.fr>
References: <1351940317-14812-1-git-send-email-Julia.Lawall@lip6.fr>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1351940317-14812-1-git-send-email-Julia.Lawall@lip6.fr>
Sender: linux-kernel-owner@vger.kernel.org
To: Steve Wise <swise@chelsio.com>
Cc: kernel-janitors@vger.kernel.org, Roland Dreier <roland@kernel.org>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

Use WARN rather than printk followed by WARN_ON(1), for conciseness.

A simplified version of the semantic patch that makes this transformation
is as follows: (http://coccinelle.lip6.fr/)

// <smpl>
@@
expression list es;
@@

-printk(
+WARN(1,
  es);
-WARN_ON(1);
// </smpl>

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
 drivers/infiniband/hw/cxgb3/iwch_cm.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/hw/cxgb3/iwch_cm.c b/drivers/infiniband/hw/cxgb3/iwch_cm.c
index aaf88ef..8baaf0d 100644
--- a/drivers/infiniband/hw/cxgb3/iwch_cm.c
+++ b/drivers/infiniband/hw/cxgb3/iwch_cm.c
@@ -128,9 +128,8 @@ static void stop_ep_timer(struct iwch_ep *ep)
 {
 	PDBG("%s ep %p\n", __func__, ep);
 	if (!timer_pending(&ep->timer)) {
-		printk(KERN_ERR "%s timer stopped when its not running!  ep %p state %u\n",
+		WARN(1, KERN_ERR "%s timer stopped when its not running!  ep %p state %u\n",
 			__func__, ep, ep->com.state);
-		WARN_ON(1);
 		return;
 	}
 	del_timer_sync(&ep->timer);
@@ -1756,9 +1755,8 @@ static void ep_timeout(unsigned long arg)
 		__state_set(&ep->com, ABORTING);
 		break;
 	default:
-		printk(KERN_ERR "%s unexpected state ep %p state %u\n",
+		WARN(1, KERN_ERR "%s unexpected state ep %p state %u\n",
 			__func__, ep, ep->com.state);
-		WARN_ON(1);
 		abort = 0;
 	}
 	spin_unlock_irqrestore(&ep->com.lock, flags);
