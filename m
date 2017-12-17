From: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH rdma-next 0/2] Minor cleanup in i40iw/nes
Date: Sun, 17 Dec 2017 12:21:37 -0600
Message-ID: <20171217182139.17096-1-shiraz.saleem@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, jgg-uk2M96/98Pc@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This patch set includes a minor cleanup in i40iw and nes driver.

The i40iw patch is spun against fo-rc and is dependent on a 4.15 -rc patch
a7c6dfe215a7 ("i40iw: Notify user of established connection after QP in RTS")

Henry Orosco (1):
  i40iw: Change accelerated flag to bool

Shiraz Saleem (1):
  nes: Change accelerated flag to bool

 drivers/infiniband/hw/i40iw/i40iw_cm.c | 4 ++--
 drivers/infiniband/hw/i40iw/i40iw_cm.h | 2 +-
 drivers/infiniband/hw/nes/nes_cm.c     | 2 +-
 drivers/infiniband/hw/nes/nes_cm.h     | 2 +-
 4 files changed, 5 insertions(+), 5 deletions(-)

-- 
2.8.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
