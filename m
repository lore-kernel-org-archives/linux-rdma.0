From: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Subject: RE: Fix IPoIB to conform to ethtool definitions
Date: Mon, 8 Nov 2010 09:41:05 +0200
Message-ID: <E113D394D7C5DB4F8FF691FA7EE9DB443D1BB38721@MTLMAIL.mtl.com>
References: <Pine.LNX.4.64.1011080936200.14213@zuben.voltaire.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <Pine.LNX.4.64.1011080936200.14213-aDiYczhfhVLdX2U7gxhm1tBPR1lH4CV8@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>, Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Sure, I was going to. I will send later today.

-----Original Message-----
From: Or Gerlitz [mailto:ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org] 
Sent: Monday, November 08, 2010 9:38 AM
To: Eli Cohen; Roland Dreier
Cc: linux-rdma
Subject: re: Fix IPoIB to conform to ethtool definitions

Hi Eli, can this patch of yours which you placed in ofed be pushed
upstream? Or.

>From 4237a1fbc1bae6bb86665f81cd93cfac37b216d2 Mon Sep 17 00:00:00 2001
From: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date: Wed, 3 Nov 2010 10:56:38 +0200
Subject: [PATCH] IPoIB: Fix IPoIB to conform to ethtool definitions

Ethtool documentation states that when once of the parameters,
rx_coalesce_usecs or rx_max_coalesced_frames are set to zero while the other
has a none zero value, the none zero parameter should still be operative. For
example, if rx_max_coalesced_frames is set to zero while rx_coalesce_usecs is >
0, the rate of events is limited to not exceed (1 / rx_coalesce_usecs). In the
opposite case, an event is generated only after rx_max_coalesced_frames have
arrived. The documentation also states that setting both to zero is invalid.

Signed-off-by: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
---
 drivers/infiniband/ulp/ipoib/ipoib_ethtool.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/drivers/infiniband/ulp/ipoib/ipoib_ethtool.c b/drivers/infiniband/ulp/ipoib/ipoib_ethtool.c
index e9795f6..e602b7f 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_ethtool.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_ethtool.c
@@ -78,6 +78,13 @@ static int ipoib_set_coalesce(struct net_device *dev,
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
