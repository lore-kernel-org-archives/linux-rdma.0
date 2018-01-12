From: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH rdma-next 0/5] i40iw: more updates for 4.16
Date: Thu, 11 Jan 2018 18:10:49 -0600
Message-ID: <20180112001054.15572-1-shiraz.saleem@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, jgg-uk2M96/98Pc@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Doug & Jason,

This patch set includes a few bug fixes and clean-up for i40iw.
Please consider it for 4.16.

Shiraz

Mustafa Ismail (2):
  i40iw: Remove setting of rem_addr.len
  i40iw: Free IEQ resources

Shiraz Saleem (2):
  i40iw: Remove extra call to i40iw_est_sd()
  i40iw: Zero-out consumer key on allocate stag for FMR

Sindhu Devale (1):
  i40iw: Remove limit on re-posting AEQ entries to HW

 drivers/infiniband/hw/i40iw/i40iw_ctrl.c  | 4 ----
 drivers/infiniband/hw/i40iw/i40iw_puda.c  | 3 +--
 drivers/infiniband/hw/i40iw/i40iw_puda.h  | 1 +
 drivers/infiniband/hw/i40iw/i40iw_user.h  | 1 -
 drivers/infiniband/hw/i40iw/i40iw_verbs.c | 5 ++---
 5 files changed, 4 insertions(+), 10 deletions(-)

-- 
2.8.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
