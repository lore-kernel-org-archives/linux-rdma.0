From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: [PATCH] RDMA/cxgb3: iwch_query_port() - handle null inetdev ptr.
Date: Tue, 06 Oct 2009 16:13:22 -0500
Message-ID: <20091006211321.16751.15175.stgit@build.ogc.int>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

in_dev_get() can return NULL.  If it does, iwch_query_port() will crash.
Handle the NULL case by mapping it to rdma state INIT.

Signed-off-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
---

 drivers/infiniband/hw/cxgb3/iwch_provider.c |   11 +++++++----
 1 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/hw/cxgb3/iwch_provider.c b/drivers/infiniband/hw/cxgb3/iwch_provider.c
index 6895523..03cfaec 100644
--- a/drivers/infiniband/hw/cxgb3/iwch_provider.c
+++ b/drivers/infiniband/hw/cxgb3/iwch_provider.c
@@ -1199,11 +1199,14 @@ static int iwch_query_port(struct ib_device *ibdev,
 		props->state = IB_PORT_DOWN;
 	else {
 		inetdev = in_dev_get(netdev);
-		if (inetdev->ifa_list)
-			props->state = IB_PORT_ACTIVE;
-		else
+		if (inetdev) {
+			if (inetdev->ifa_list)
+				props->state = IB_PORT_ACTIVE;
+			else
+				props->state = IB_PORT_INIT;
+			in_dev_put(inetdev);
+		} else
 			props->state = IB_PORT_INIT;
-		in_dev_put(inetdev);
 	}
 
 	props->port_cap_flags =

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
