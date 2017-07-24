From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: [PATCH 0/3] Autoloading for RDMA netlink modules
Date: Mon, 24 Jul 2017 16:26:41 -0600
Message-ID: <1500935204-6505-1-git-send-email-jgunthorpe@obsidianresearch.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <notifications-9UaJU3cA/F/QT0dZR+AlfA@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This provides the necessary infrastructure for the kernel to automatically
load RDMA associated netlink modules when users space sends messages to them.

This is at least enough support for the kernel to autoload everything required
for iwpmd to run.

Jason Gunthorpe (3):
  rdma: Allow demand loading of NETLINK_RDMA
  rdma: Autoload netlink client modules
  iwpmd: Suppress expected kernel message

 drivers/infiniband/core/cma.c     |  2 +
 drivers/infiniband/core/device.c  |  2 +
 drivers/infiniband/core/iwcm.c    |  9 ++++
 drivers/infiniband/core/netlink.c | 99 +++++++++++++++++++++++----------------
 include/rdma/rdma_netlink.h       | 12 +++++
 5 files changed, 83 insertions(+), 41 deletions(-)

-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
