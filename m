From: Henry Orosco <henry.orosco-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 0/6] i40iw: Fixes for i40iw
Date: Tue,  6 Dec 2016 15:49:29 -0600
Message-ID: <20161206214935.41584-1-henry.orosco@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, Henry Orosco <henry.orosco-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

The following patch series has fixes for the i40iw driver.

Mustafa Ismail (4):
  i40iw: Fix double free of QP
  i40iw: Fix memory leak in CQP destroy when in reset
  i40iw: Assign MSS only when it is a new MTU
  i40iw: Fix incorrect check for error

Shiraz Saleem (2):
  i40iw: Fix QP flush to not hang on empty queues or failure
  i40iw: Fix race condition in terminate timer's handler

 drivers/infiniband/hw/i40iw/i40iw.h       | 11 +++++++----
 drivers/infiniband/hw/i40iw/i40iw_cm.c    | 22 +++++++++++++++++-----
 drivers/infiniband/hw/i40iw/i40iw_hw.c    | 30 +++++++++++++++++++++++++++---
 drivers/infiniband/hw/i40iw/i40iw_main.c  | 11 +++++------
 drivers/infiniband/hw/i40iw/i40iw_puda.c  |  2 +-
 drivers/infiniband/hw/i40iw/i40iw_utils.c |  5 ++++-
 drivers/infiniband/hw/i40iw/i40iw_verbs.c |  2 +-
 7 files changed, 62 insertions(+), 21 deletions(-)

-- 
2.8.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
