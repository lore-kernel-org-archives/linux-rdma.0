From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next 0/4] Another round of exported properties for RDMAtool
Date: Wed, 28 Jun 2017 16:34:41 +0300
Message-ID: <20170628133445.16550-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

hi Doug,

This patch set is based on previously sent RDMA netlink work.

!!! Important to note, that LIDs and SM_LIDS are exported as u32,
to support OmniPath natively.

Thanks

Leon Romanovsky (4):
  RDMA/netlink: Export guid and sys_image_guid
  RDMA/netlink: Advertise IB subnet prefix
  RDMA/netink: Export lids and sm_lids
  RDMA/netlink: Export LID mask counter (LMC)

 drivers/infiniband/core/nldev.c  | 21 ++++++++++++++++++++-
 include/uapi/rdma/rdma_netlink.h | 31 +++++++++++++++++++++++++++++++
 2 files changed, 51 insertions(+), 1 deletion(-)

--
2.13.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
