From: Tatyana Nikolova <Tatyana.E.Nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH for-4.1 0/3] Enable the iWarp Port Mapper to provide the
 actual address of the connecting peer to its clients
Date: Tue, 21 Apr 2015 16:26:48 -0400
Message-ID: <20150421202648.GA9760@TENIKOLO-MOBL2>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: john.s.lacombe-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This patch series was first submitted for inclusion upstream on 10/13/14,
but it seems to have slipped through the cracks.

When iWARP port mapping is being done, the passive side of a connection only
knows the mapped address/port of the peer. This patch series enables the passive
side port mapper to get the actual (non-mapped) address info of the connecting
peer and provide it to its clients. The port mapper client needs to report the
actual address info to the user space application which isn't aware of the port
mapper service. 

Tatyana Nikolova (2):
  RDMA/core: Add functionality to enable the passive side port mapper to provide the
    actual (non-mapped) ip/tcp address of the connecting peer to its client
  RDMA/nes: Get the actual (non-mapped) ip/tcp address of the connecting
    peer from the port mapper and record it
Steve Wise (1):
  RDMA/cxgb4: Get the actual (non-mapped) ip/tcp address of the connecting
    peer from the port mapper and record it

 drivers/infiniband/core/iwpm_msg.c   |   73 ++++++++++++-
 drivers/infiniband/core/iwpm_util.c  |  208 ++++++++++++++++++++++++++++------
 drivers/infiniband/core/iwpm_util.h  |   15 +++
 drivers/infiniband/hw/cxgb4/cm.c     |   54 ++++++++-
 drivers/infiniband/hw/cxgb4/device.c |    1 +
 drivers/infiniband/hw/nes/nes.c      |    1 +
 drivers/infiniband/hw/nes/nes_cm.c   |   65 ++++++++---
 include/rdma/iw_portmap.h            |   25 ++++
 include/uapi/rdma/rdma_netlink.h     |    1 +
 9 files changed, 388 insertions(+), 55 deletions(-)

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
