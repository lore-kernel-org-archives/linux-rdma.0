From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH 0/3] IPoIB fixes for 3.9
Date: Tue, 19 Feb 2013 17:40:21 +0200
Message-ID: <1361288424-8376-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Roland, 

Here are two small IPoIB fixes for 3.9 along with Yan's ethtool patch
with which we can happily celebrate the marking of version 1.0.0 for 
IPoIB eight years after your initial push...

Or.

For Shlomo's patch this is V1, where the change from V0, 
http://marc.info/?l=linux-rdma&m=136070131629926&w=2
is to apply Sean/Jason feedback and use (force _u32) instead

Itai Garbi (1):
  IB/ipoib: Don't attempt to release resources on error flow

Shlomo Pongratz (1):
  IB/ipoib: Fix ipoib_neigh hashing to use the correct daddr octets

Yan Burman (1):
  IB/ipoib: Add version and firmware info to ethtool reporting

 drivers/infiniband/ulp/ipoib/ipoib.h         |    4 ++++
 drivers/infiniband/ulp/ipoib/ipoib_ethtool.c |   19 ++++++++++++++++++-
 drivers/infiniband/ulp/ipoib/ipoib_main.c    |   11 +++++++++--
 3 files changed, 31 insertions(+), 3 deletions(-)

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
