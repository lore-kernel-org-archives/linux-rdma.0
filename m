From: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 0/5] i40iw fixes
Date: Tue, 19 Sep 2017 09:19:08 -0500
Message-ID: <20170919141913.10172-1-shiraz.saleem@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This series includes a few fixes for i40iw driver to be
considered for 4.14-rc.

Mustafa Ismail (1):
  i40iw: Add missing VLAN priority

Shiraz Saleem (4):
  i40iw: Fail open if there are no available MSI-X vectors
  i40iw: Prevent multiple netdev event notifier registrations
  i40iw: Call i40iw_cm_disconn on modify QP to disconnect
  i40iw: Add support for port reuse on active side connections

 drivers/infiniband/hw/i40iw/i40iw.h       |   1 -
 drivers/infiniband/hw/i40iw/i40iw_cm.c    | 154 +++++++++++++++---------------
 drivers/infiniband/hw/i40iw/i40iw_cm.h    |   5 +
 drivers/infiniband/hw/i40iw/i40iw_main.c  |  39 ++++----
 drivers/infiniband/hw/i40iw/i40iw_utils.c |   6 +-
 drivers/infiniband/hw/i40iw/i40iw_verbs.c |  12 +++
 6 files changed, 120 insertions(+), 97 deletions(-)

-- 
2.8.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
