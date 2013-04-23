From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: [PATCH] iw_cm: Don't touch cmid after dereferencing it.
Date: Tue, 23 Apr 2013 11:17:14 -0500
Message-ID: <20130423161713.28207.60672.stgit@build.ogc.int>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tom-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org, swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Function cm_work_handler() cannot touch the cm_id after it derefs
it because it might be freed on another concurrent thread.  If there
are more work items queued for this cm_id, then we know there must be
more references because they are added when the work items are queued.
So in the while loop inside cm_work_handler(), after derefing, if the
queue is empty, then exit the function.  Otherwise you know its safe to
re-acquire the lock.

Signed-off-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
---

 drivers/infiniband/core/iwcm.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/infiniband/core/iwcm.c b/drivers/infiniband/core/iwcm.c
index 0bb99bb..c47c203 100644
--- a/drivers/infiniband/core/iwcm.c
+++ b/drivers/infiniband/core/iwcm.c
@@ -878,6 +878,8 @@ static void cm_work_handler(struct work_struct *_work)
 			}
 			return;
 		}
+		if (empty)
+			return;
 		spin_lock_irqsave(&cm_id_priv->lock, flags);
 	}
 	spin_unlock_irqrestore(&cm_id_priv->lock, flags);

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
