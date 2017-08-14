From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: [PATCH v2 0/2] Autoloading for RDMA netlink modules
Date: Mon, 14 Aug 2017 14:57:37 -0600
Message-ID: <1502744259-16966-1-git-send-email-jgunthorpe@obsidianresearch.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

v2 is rebased/retested against Leon's major changes to the RDMA netlink code.

The module alias name was changed to "rdma-netlink-subsys-%d" for greater
consistency with other examples.

This allows all of RDMA netlink related things to autoload, for instance, on a
system with no module loaded running iwpmd will autoload ib_core.ko and iw_cm.ko,
which are required for iwpmd to run.

The end result is several new items in the modules.alias file related to
RDMA:

alias net-pf-16-proto-20 ib_core
alias rdma-netlink-subsys-1 rdma_cm
alias rdma-netlink-subsys-2 iw_cm
alias rdma-netlink-subsys-4 ib_core
alias rdma-netlink-subsys-5 ib_core

Jason Gunthorpe (2):
  rdma: Allow demand loading of NETLINK_RDMA
  rdma: Autoload netlink client modules

 drivers/infiniband/core/cma.c     |  2 ++
 drivers/infiniband/core/device.c  |  2 ++
 drivers/infiniband/core/iwcm.c    |  2 ++
 drivers/infiniband/core/netlink.c | 12 ++++++++++++
 drivers/infiniband/core/nldev.c   |  3 +++
 include/rdma/rdma_netlink.h       | 12 ++++++++++++
 6 files changed, 33 insertions(+)

-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
