From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: [PATCH 2.6.37 11/11] RDMA/cxgb4: Set the default TCP send window to
	128KB.
Date: Fri, 10 Sep 2010 11:15:41 -0500
Message-ID: <20100910161541.6829.95566.stgit@build.ogc.int>
References: <20100910161442.6829.91594.stgit@build.ogc.int>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100910161442.6829.91594.stgit-T4OLL4TyM9aNDNWfRnPdfg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This helps with large IO throughput.

Signed-off-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
---

 drivers/infiniband/hw/cxgb4/cm.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/cxgb4/cm.c b/drivers/infiniband/hw/cxgb4/cm.c
index 3e6234c..89c6762 100644
--- a/drivers/infiniband/hw/cxgb4/cm.c
+++ b/drivers/infiniband/hw/cxgb4/cm.c
@@ -117,9 +117,9 @@ static int rcv_win = 256 * 1024;
 module_param(rcv_win, int, 0644);
 MODULE_PARM_DESC(rcv_win, "TCP receive window in bytes (default=256KB)");
 
-static int snd_win = 32 * 1024;
+static int snd_win = 128 * 1024;
 module_param(snd_win, int, 0644);
-MODULE_PARM_DESC(snd_win, "TCP send window in bytes (default=32KB)");
+MODULE_PARM_DESC(snd_win, "TCP send window in bytes (default=128KB)");
 
 static struct workqueue_struct *workq;
 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
