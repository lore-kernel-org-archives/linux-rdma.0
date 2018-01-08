From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next 0/2] Increase number of char devices in RDMA
Date: Mon,  8 Jan 2018 12:15:36 +0200
Message-ID: <20180108101538.16451-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Huy Nguyen <huyn-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi,

The following two patches from Huy with a nice diffstat (more removed than
added) increases upto 1024 the maximum number of available in RDMA stack
char devices, so it will be possible to use in large SR-IOV instances.

Thanks

Huy Nguyen (2):
  IB/core: Remove the locking for character device bitmap
  IB/core: Refactor allocation code to increase number of char device

 drivers/infiniband/core/core_priv.h   |   3 +
 drivers/infiniband/core/ucm.c         |  73 +++++++++--------------
 drivers/infiniband/core/user_mad.c    | 108 +++++++++++++++-------------------
 drivers/infiniband/core/uverbs_main.c |  95 +++++++++++-------------------
 4 files changed, 113 insertions(+), 166 deletions(-)

--
2.15.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
