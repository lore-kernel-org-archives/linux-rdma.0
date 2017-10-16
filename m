From: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH for-next 00/12] i40iw patches for 4.15
Date: Mon, 16 Oct 2017 15:45:53 -0500
Message-ID: <20171016204605.37512-1-shiraz.saleem@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Doug,

This patch series includes i40iw driver fixes, cleanup and refactoring
targeted for 4.15.

Bob Sharp (1):
  i40iw: Move cqp_cmd_head init to CQP initialization

Christopher Bednarz (1):
  i40iw: Clear CQP Head/Tail during initialization

Ivan Barrera (1):
  i40iw: Remove UDA QP from QoS list if creation fails

Mustafa Ismail (5):
  i40iw: Cleanup AE processing
  i40iw: Ignore AE source field in AEQE for some AEs
  i40iw: Remove unused static_rsrc from i40iw_create_qp_info
  i40iw: Move exception_lan_queue to VSI structure
  i40iw: Remove unused structures

Shiraz Saleem (4):
  i40iw: Account for IPv6 header when setting MSS
  i40iw: Move ceq_valid to i40iw_sc_dev structure
  i40iw: Reinitialize IEQ on MTU change
  i40iw: Refactor queue depth calculation

 drivers/infiniband/hw/i40iw/i40iw.h       |  3 --
 drivers/infiniband/hw/i40iw/i40iw_cm.c    |  3 +-
 drivers/infiniband/hw/i40iw/i40iw_ctrl.c  | 75 +++++++++++++++++++++++++------
 drivers/infiniband/hw/i40iw/i40iw_d.h     | 30 +++++++------
 drivers/infiniband/hw/i40iw/i40iw_hw.c    |  2 +-
 drivers/infiniband/hw/i40iw/i40iw_main.c  | 48 +++++++++++++-------
 drivers/infiniband/hw/i40iw/i40iw_p.h     |  3 +-
 drivers/infiniband/hw/i40iw/i40iw_puda.c  | 18 ++++----
 drivers/infiniband/hw/i40iw/i40iw_puda.h  |  2 -
 drivers/infiniband/hw/i40iw/i40iw_type.h  | 12 +++--
 drivers/infiniband/hw/i40iw/i40iw_uk.c    | 63 ++++++++++++++++++++------
 drivers/infiniband/hw/i40iw/i40iw_user.h  | 22 ++-------
 drivers/infiniband/hw/i40iw/i40iw_verbs.c | 34 ++++----------
 13 files changed, 190 insertions(+), 125 deletions(-)

-- 
2.8.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
