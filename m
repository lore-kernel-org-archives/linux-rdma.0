From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: [PATCH RESEND 2.6.37 1/2] RDMA/cxgb4: export T4 TCP MIB.
Date: Mon, 18 Oct 2010 10:16:40 -0500
Message-ID: <20101018151640.32196.78946.stgit@build.ogc.int>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dm-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org, shemminger-ZtmgI6mnKB3QT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Signed-off-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
---

 drivers/infiniband/hw/cxgb4/provider.c |   12 +++++++++++-
 1 files changed, 11 insertions(+), 1 deletions(-)

diff --git a/drivers/infiniband/hw/cxgb4/provider.c b/drivers/infiniband/hw/cxgb4/provider.c
index 81e1277..f66dd8b 100644
--- a/drivers/infiniband/hw/cxgb4/provider.c
+++ b/drivers/infiniband/hw/cxgb4/provider.c
@@ -391,7 +391,17 @@ static ssize_t show_board(struct device *dev, struct device_attribute *attr,
 static int c4iw_get_mib(struct ib_device *ibdev,
 			union rdma_protocol_stats *stats)
 {
-	return -ENOSYS;
+	struct tp_tcp_stats v4, v6;
+	struct c4iw_dev *c4iw_dev = to_c4iw_dev(ibdev);
+
+	cxgb4_get_tcp_stats(c4iw_dev->rdev.lldi.pdev, &v4, &v6);
+	memset(stats, 0, sizeof *stats);
+	stats->iw.tcpInSegs = v4.tcpInSegs + v6.tcpInSegs;
+	stats->iw.tcpOutSegs = v4.tcpOutSegs + v6.tcpOutSegs;
+	stats->iw.tcpRetransSegs = v4.tcpRetransSegs + v6.tcpRetransSegs;
+	stats->iw.tcpOutRsts = v4.tcpOutRsts + v6.tcpOutSegs;
+
+	return 0;
 }
 
 static DEVICE_ATTR(hw_rev, S_IRUGO, show_rev, NULL);

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
