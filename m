From: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v1 rdma-next 0/9] i40iw updates for 4.16
Date: Fri, 22 Dec 2017 14:29:23 -0600
Message-ID: <20171222202932.9324-1-shiraz.saleem@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, jgg-uk2M96/98Pc@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Doug/Jason,
 
This patch set includes bug fixes, code refactoring, 
a new netdev event notifier and misc. improvements.
Please consider it for 4.16.

v0->v1:
* Remove type cast which relaxes const qualifier on 
  private data field of iw_cm_conn_param struct in Patch #9.

Shiraz Saleem (7):
  i40iw: Set MAX_IRD_SIZE to 64
  i40iw: Use utility function roundup_pow_of_two()
  i40iw: Correct Q1/XF object count equation
  i40iw: Add notifier for network device events
  i40iw: Selectively teardown QPs on IP addr change event
  i40iw: Fix sequence number for the first partial FPDU
  i40iw: Ignore LLP_DOUBT_REACHABILITY AE

Tatyana Nikolova (2):
  i40iw: Validate correct IRD/ORD connection parameters
  i40iw: Fix the connection ORD value for loopback

 drivers/infiniband/hw/i40iw/i40iw.h       |  3 ++
 drivers/infiniband/hw/i40iw/i40iw_cm.c    | 61 +++++++++++++++++--------------
 drivers/infiniband/hw/i40iw/i40iw_cm.h    |  3 +-
 drivers/infiniband/hw/i40iw/i40iw_ctrl.c  | 20 ++++------
 drivers/infiniband/hw/i40iw/i40iw_d.h     |  1 +
 drivers/infiniband/hw/i40iw/i40iw_hw.c    |  3 +-
 drivers/infiniband/hw/i40iw/i40iw_main.c  |  8 +++-
 drivers/infiniband/hw/i40iw/i40iw_puda.c  |  2 +-
 drivers/infiniband/hw/i40iw/i40iw_uk.c    | 18 +--------
 drivers/infiniband/hw/i40iw/i40iw_user.h  |  2 +-
 drivers/infiniband/hw/i40iw/i40iw_utils.c | 50 +++++++++++++++++++++++--
 11 files changed, 107 insertions(+), 64 deletions(-)

-- 
2.8.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
