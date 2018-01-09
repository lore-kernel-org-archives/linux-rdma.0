From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next 0/6] Update CMA to use net namespace
Date: Tue,  9 Jan 2018 15:58:53 +0200
Message-ID: <20180109135859.7676-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi,

This series updates several CMA paths to use net namespaces, those
patches don't have Fixes line, because the original code wasn't supposed
to work with namespaces.

Thanks

Parav Pandit (6):
  RDMA/cma: Check existence of netdevice during port validation
  RDMA/cma: Refactor to access multiple fields of rdma_dev_addr
  RDMA/cma: Update cma_validate_port to honor net namespace
  RDMA/cma: Update RoCE multicast routines to use net namespace
  RDMA/cma: Protect ifindex access during IPv6 route lookup
  RDMA/cma: Protect ifindex access during IPv4 route lookup

 drivers/infiniband/core/cma.c | 43 +++++++++++++++++++++++++------------------
 1 file changed, 25 insertions(+), 18 deletions(-)

--
2.15.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
