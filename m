From: Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH] IPoIB: Fix IPoIB to conform to ethtool definitions
Date: Mon, 8 Nov 2010 12:42:44 +0200
Message-ID: <20101108104244.GA7521@mtldesk30>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: RDMA list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Ethtool documentation states that when one of the parameters, rx_coalesce_usecs
or rx_max_coalesced_frames is set to zero while the other has a none zero
value, the none zero parameter should still be operative. For example, if
rx_max_coalesced_frames is set to zero while rx_coalesce_usecs is > 0, the rate
of events is limited to not exceed (1 / rx_coalesce_usecs). In the opposite
case, an event is generated only after rx_max_coalesced_frames have arrived.
The documentation also states that setting both to zero is invalid.

Signed-off-by: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
---
 drivers/infiniband/ulp/ipoib/ipoib_ethtool.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/drivers/infiniband/ulp/ipoib/ipoib_ethtool.c b/drivers/infiniband/ulp/ipoib/ipoib_ethtool.c
index 1a1657c..c7efba3 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_ethtool.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_ethtool.c
@@ -93,6 +93,13 @@ static int ipoib_set_coalesce(struct net_device *dev,
 	    coal->rx_max_coalesced_frames > 0xffff)
 		return -EINVAL;
 
+	if (coal->rx_max_coalesced_frames | coal->rx_coalesce_usecs) {
+		if (!coal->rx_max_coalesced_frames)
+			coal->rx_max_coalesced_frames = 0xffff;
+		else if (!coal->rx_coalesce_usecs)
+			coal->rx_coalesce_usecs = 0xffff;
+	}
+
 	ret = ib_modify_cq(priv->recv_cq, coal->rx_max_coalesced_frames,
 			   coal->rx_coalesce_usecs);
 	if (ret && ret != -ENOSYS) {
-- 
1.7.3.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
