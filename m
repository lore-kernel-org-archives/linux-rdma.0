From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: [PATCH 2/7] RDMA/cxgb4: Turn on delayed ACK.
Date: Fri, 11 Mar 2011 16:30:01 -0600
Message-ID: <20110311223000.16418.91359.stgit@build.ogc.int>
References: <20110311222826.16418.43582.stgit@build.ogc.int>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110311222826.16418.43582.stgit-T4OLL4TyM9aNDNWfRnPdfg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Set the default to on.

Signed-off-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
---

 drivers/infiniband/hw/cxgb4/cm.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/cxgb4/cm.c b/drivers/infiniband/hw/cxgb4/cm.c
index 8b00e6c..65d3fe6 100644
--- a/drivers/infiniband/hw/cxgb4/cm.c
+++ b/drivers/infiniband/hw/cxgb4/cm.c
@@ -61,9 +61,9 @@ static char *states[] = {
 	NULL,
 };
 
-static int dack_mode;
+static int dack_mode = 1;
 module_param(dack_mode, int, 0644);
-MODULE_PARM_DESC(dack_mode, "Delayed ack mode (default=0)");
+MODULE_PARM_DESC(dack_mode, "Delayed ack mode (default=1)");
 
 int c4iw_max_read_depth = 8;
 module_param(c4iw_max_read_depth, int, 0644);

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
