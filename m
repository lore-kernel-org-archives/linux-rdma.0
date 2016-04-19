From: Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-next 0/4] Support SendOnlyFullMember join
Date: Tue, 19 Apr 2016 15:51:23 +0300
Message-ID: <1461070287-13469-1-git-send-email-erezsh@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

There are 4 types of multicast join: FullMember, NonMember,
SendOnlyNonMember and SendOnlyFullMember.

This patch-set introduces the ability to send multicast join requests of
type SendOnlyFullMember (until now only the first three types were
supported).
Host that sends such join request, does not require a multicast
subscription and will still send properly, and in addition will not get
other multicast packets from that group.

It adds a new SA query (for classport_info) to check that the sm
supports sending such requests and it modifies multicast processing in
the IB/core module to handle SendOnlyFullMember multicast join requests.

In addition, the patch set modifies IPoIB so that if the sm does support
SendOnlyFullMember join requests, IPoIB will send such a request when
joining a sendonly multicast group.


Erez Shitrit (4):
  IB/core: Add support for get ClassPortInfo from the SA
  IB/sa: Add support for sa get ClassPortInfo
  IB/core: Support new type of join-state for multicast
  IB/ipoib: Support SendOnlyFullMember MCG for SendOnly join

 drivers/infiniband/core/multicast.c            |  23 +++-
 drivers/infiniband/core/sa_query.c             | 174 +++++++++++++++++++++++++
 drivers/infiniband/hw/qib/qib_mad.c            |   6 +-
 drivers/infiniband/ulp/ipoib/ipoib.h           |   2 +
 drivers/infiniband/ulp/ipoib/ipoib_main.c      |  74 +++++++++++
 drivers/infiniband/ulp/ipoib/ipoib_multicast.c |  33 +++--
 drivers/infiniband/ulp/srpt/ib_srpt.c          |   5 +-
 include/rdma/ib_mad.h                          |   4 +-
 include/rdma/ib_sa.h                           |  12 ++
 9 files changed, 310 insertions(+), 23 deletions(-)

-- 
1.7.11.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
