From: kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH 0/3] Sending kernel pathrecord query to user cache server
Date: Mon, 18 May 2015 15:00:13 -0400
Message-ID: <1431975616-23529-1-git-send-email-kaike.wan@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Kaike Wan <kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Kaike Wan <kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

A SA cache is undeniably critical for fabric scalability and performance.
In user space, the ibacm application provides a good example of pathrecord
cache for address and route resolution. With the recent implementation of
the provider architecture, ibacm offers more extensibility as a SA cache.
In kernel, ipoib implements its own small cache for pathrecords, which is
however not available for general use. Furthermore, the implementation of
a SA cache in user space offers better flexibility, larger capacity, and
more robustness for the system.

In this patch series, a mechanism is implemented to allow ib_sa to
send pathrecord query to a user application (eg ibacm) through netlink.
Potentially, this mechanism could be easily extended to other SA queries.

With a customized test implemented in rdma_cm module (not included in this
series), it was shown that the time to retrieve 1 million pathrecords
dropped from 46660 jiffies (46.66 seconds) to 16119 jiffies (or 16.119
seconds) on a two-node system, a reduction of more than 60%.

Kaike Wan (3):
  IB/netlink: Add defines for MAD requests through netlink
  IB/core: Check the presence of netlink multicast group listeners
  IB/sa: route SA pathrecord query through netlink

 drivers/infiniband/core/netlink.c  |    8 +
 drivers/infiniband/core/sa_query.c |  334 +++++++++++++++++++++++++++++++++++-
 include/rdma/rdma_netlink.h        |    7 +
 include/uapi/rdma/rdma_netlink.h   |    7 +
 4 files changed, 351 insertions(+), 5 deletions(-)

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
