From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 2/2] ib/cm: Bump reference count on cm_id before invoking
 callback
Date: Wed, 23 Feb 2011 08:17:40 -0800
Message-ID: <CF9C39F99A89134C9CF9C4CCB68B8DDF25CC6C5393@orsmsx501.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

When processing a SIDR REQ, the ib_cm allocates a new cm_id.  The refcount
of the cm_id is initialized to 1.  However, cm_process_work will
decrement the refcount after invoking all callbacks.  The result is that
the cm_id will end up with refcount set to 0 by the end of the sidr req
handler.

If a user tries to destroy the cm_id, the destruction will proceed, under
the incorrect assumption that no other threads are referencing the cm_id.
This can lead to a crash when the cm callback thread tries to access
the cm_id.

This problem was noticed as part of a larger investigation with kernel
crashes in the rdma_cm when running on a real time OS.

Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---

 drivers/infiniband/core/cm.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/infiniband/core/cm.c b/drivers/infiniband/core/cm.c
index 64e0903..1d9616b 100644
--- a/drivers/infiniband/core/cm.c
+++ b/drivers/infiniband/core/cm.c
@@ -2989,6 +2989,7 @@ static int cm_sidr_req_handler(struct cm_work *work)
 		goto out; /* No match. */
 	}
 	atomic_inc(&cur_cm_id_priv->refcount);
+	atomic_inc(&cm_id_priv->refcount);
 	spin_unlock_irq(&cm.lock);
 
 	cm_id_priv->id.cm_handler = cur_cm_id_priv->id.cm_handler;


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
