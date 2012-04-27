From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: [PATCH 2/2] iw_cxgb4: don't BUG_ON if we get an abort with no
	endpoint found.
Date: Fri, 27 Apr 2012 09:59:22 -0500
Message-ID: <20120427145922.27184.74574.stgit@build.ogc.int>
References: <20120427145915.27184.35216.stgit@build.ogc.int>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120427145915.27184.35216.stgit-T4OLL4TyM9aNDNWfRnPdfg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, sbest-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Just log a warning.

Signed-off-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
---

 drivers/infiniband/hw/cxgb4/cm.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/drivers/infiniband/hw/cxgb4/cm.c b/drivers/infiniband/hw/cxgb4/cm.c
index 8f43143..3d0e40a 100644
--- a/drivers/infiniband/hw/cxgb4/cm.c
+++ b/drivers/infiniband/hw/cxgb4/cm.c
@@ -1362,7 +1362,10 @@ static int abort_rpl(struct c4iw_dev *dev, struct sk_buff *skb)
 
 	ep = lookup_tid(t, tid);
 	PDBG("%s ep %p tid %u\n", __func__, ep, ep->hwtid);
-	BUG_ON(!ep);
+	if (!ep) {
+		printk(KERN_WARNING MOD "Abort rpl to freed endpoint\n");
+		return 0;
+	}
 	mutex_lock(&ep->com.mutex);
 	switch (ep->com.state) {
 	case ABORTING:

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
