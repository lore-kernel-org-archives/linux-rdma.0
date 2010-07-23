From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: [PATCH 4/4] RDMA/cxgb4: Add timeouts when waiting for FW responses.
Date: Fri, 23 Jul 2010 14:12:43 -0500
Message-ID: <20100723191242.15832.77852.stgit@build.ogc.int>
References: <20100723191221.15832.79704.stgit@build.ogc.int>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100723191221.15832.79704.stgit-T4OLL4TyM9aNDNWfRnPdfg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Don't hang a host thread if the FW stops responding.

Signed-off-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
---

 drivers/infiniband/hw/cxgb4/cm.c |   22 ++++++++++++++++++----
 1 files changed, 18 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/hw/cxgb4/cm.c b/drivers/infiniband/hw/cxgb4/cm.c
index bc3f9f0..296aa2c 100644
--- a/drivers/infiniband/hw/cxgb4/cm.c
+++ b/drivers/infiniband/hw/cxgb4/cm.c
@@ -2050,8 +2050,15 @@ int c4iw_create_listen(struct iw_cm_id *cm_id, int backlog)
 		goto fail3;
 
 	/* wait for pass_open_rpl */
-	wait_event(ep->com.waitq, ep->com.rpl_done);
-	err = ep->com.rpl_err;
+	wait_event_timeout(ep->com.waitq, ep->com.rpl_done, C4IW_WR_TO);
+	if (ep->com.rpl_done)
+		err = ep->com.rpl_err;
+	else {
+		printk(KERN_ERR MOD "Device %s not responding!\n",
+		       pci_name(ep->com.dev->rdev.lldi.pdev));
+		ep->com.dev->rdev.flags = T4_FATAL_ERROR;
+		err = -EIO;
+	}
 	if (!err) {
 		cm_id->provider_data = ep;
 		goto out;
@@ -2080,10 +2087,17 @@ int c4iw_destroy_listen(struct iw_cm_id *cm_id)
 	err = listen_stop(ep);
 	if (err)
 		goto done;
-	wait_event(ep->com.waitq, ep->com.rpl_done);
+	wait_event_timeout(ep->com.waitq, ep->com.rpl_done, C4IW_WR_TO);
+	if (ep->com.rpl_done)
+		err = ep->com.rpl_err;
+	else {
+		printk(KERN_ERR MOD "Device %s not responding!\n",
+		       pci_name(ep->com.dev->rdev.lldi.pdev));
+		ep->com.dev->rdev.flags = T4_FATAL_ERROR;
+		err = -EIO;
+	}
 	cxgb4_free_stid(ep->com.dev->rdev.lldi.tids, ep->stid, PF_INET);
 done:
-	err = ep->com.rpl_err;
 	cm_id->rem_ref(cm_id);
 	c4iw_put_ep(&ep->com);
 	return err;

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
