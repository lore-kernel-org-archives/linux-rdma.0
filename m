From: Tatyana Nikolova <tatyana.e.nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 0/7] RDMA/i40iw: Fixes for i40iw driver
Date: Fri, 22 Apr 2016 14:14:22 -0500
Message-ID: <1461352469-16504-1-git-send-email-tatyana.e.nikolova@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This patch series includes a few fixes for the original
Intel X722 iWARP driver i40iw.

It is based on Doug Ledford's https://github.com/dledford/linux.git
branch: k.o/for-4.6-rc. 

It needs to be applied after the patch series submitted by Mustafa Ismail - 
"[PATCH V3 00/16] RDMA/Intel X722 iWARP driver update"

Chien Tin Tung (1):
  RDMA/i40iw: Correct STag mask to min of 14 bits

Mohammad Khan (1):
  RDMA/i40iw: Fix for a NOP WQE size

Shiraz Saleem (3):
  RDMA/i40iw: Fixes for WQE alignment
  RDMA/i40iw: Fix for the size of kernel mode SQ
  RDMA/i40iw: Fix for using one sge for RDMA READ

Tatyana Nikolova (2):
  RDMA/i40iw: Fix for checking if the QP is destroyed
  RDMA/i40iw: Fix for removing quad hash entries

 drivers/infiniband/hw/i40iw/i40iw_cm.c     |  4 +++-
 drivers/infiniband/hw/i40iw/i40iw_d.h      |  2 ++
 drivers/infiniband/hw/i40iw/i40iw_hw.c     |  3 ++-
 drivers/infiniband/hw/i40iw/i40iw_status.h |  1 +
 drivers/infiniband/hw/i40iw/i40iw_uk.c     | 26 ++++++++++++++++++++++++--
 drivers/infiniband/hw/i40iw/i40iw_verbs.c  | 10 +++++++---
 6 files changed, 39 insertions(+), 7 deletions(-)

-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
