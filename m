From: Henry Orosco <henry.orosco-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 0/8] i40iw: Fixes for i40iw
Date: Fri, 23 Jun 2017 16:03:54 -0500
Message-ID: <20170623210402.19988-1-henry.orosco@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, Henry Orosco <henry.orosco-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

The following patch series has fixes for the i40iw driver.

Henry Orosco (2):
  i40iw: Add missing memory barrier
  i40iw: Update list correctly

Mustafa Ismail (2):
  i40iw: Fix order of cleanup in close
  i40iw: Do not poll CCQ after it is destroyed

Shiraz Saleem (4):
  i40iw: Utilize iwdev->reset during PCI function reset
  i40iw: Release cm_id ref on PCI function reset
  i40iw: Free QP resources on CQP destroy QP failure
  i40iw: Avoid memory leak of CQP request objects

 drivers/infiniband/hw/i40iw/i40iw.h       |  1 +
 drivers/infiniband/hw/i40iw/i40iw_cm.c    |  5 ++-
 drivers/infiniband/hw/i40iw/i40iw_ctrl.c  |  2 ++
 drivers/infiniband/hw/i40iw/i40iw_main.c  | 60 +++++++++++++++----------------
 drivers/infiniband/hw/i40iw/i40iw_puda.c  |  5 ++-
 drivers/infiniband/hw/i40iw/i40iw_utils.c | 60 +++++++++++++++++++++++++++++--
 6 files changed, 99 insertions(+), 34 deletions(-)

-- 
2.8.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
