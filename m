From: Ralph Campbell <ralph.campbell-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 7/7] IB/qib: completion queue callback needs to be single
	threaded
Date: Thu, 17 Jun 2010 16:14:15 -0700
Message-ID: <20100617231414.8006.57924.stgit@chromite.mv.qlogic.com>
References: <20100617231338.8006.18131.stgit@chromite.mv.qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100617231338.8006.18131.stgit-/vjeY7uYZjrPXfVEPVhPGq6RkeBMCJyt@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Workqueues aren't exactly equivalent to tasklets since the callback
function may be called from multiple CPUs before the callback returns.
This causes completion notification callbacks to have MT bugs since
they weren't expecting this behavior. The fix is to use a single
threaded work queue.

Signed-off-by: Ralph Campbell <ralph.campbell-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
---

 drivers/infiniband/hw/qib/qib_init.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/infiniband/hw/qib/qib_init.c b/drivers/infiniband/hw/qib/qib_init.c
index 1d4db4b..7831ff8 100644
--- a/drivers/infiniband/hw/qib/qib_init.c
+++ b/drivers/infiniband/hw/qib/qib_init.c
@@ -1059,7 +1059,7 @@ static int __init qlogic_ib_init(void)
 		goto bail_dev;
 	}
 
-	qib_cq_wq = create_workqueue("qib_cq");
+	qib_cq_wq = create_singlethread_workqueue("qib_cq");
 	if (!qib_cq_wq) {
 		ret = -ENOMEM;
 		goto bail_wq;

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
