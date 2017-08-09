From: Henry Orosco <henry.orosco-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [pull request][PATCH v2 0/6] i40iw: Fixes for i40iw
Date: Tue,  8 Aug 2017 20:38:42 -0500
Message-ID: <20170809013848.29080-1-henry.orosco@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, Henry Orosco <henry.orosco-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

The following patch series has fixes for the i40iw driver.

V2 - Removed 1 patch from series

--------------------------------------------------------

Git Repo to pull from:
        https://github.com/horosco/linux.git

tag:
        for-v4.13-08-07-2017-v2

Commits of interest:

commit 08bc3c4ee4c759655b2250b59ddec80950772f6a
Date:   Wed Jul 5 13:33:54 2017 -0500
i40iw: Fix potential fcn_id_array out of bounds

to

commit a18153f9af05c1f03ee449cc881fd63e9f83d7fc
Date:   Mon Jul 3 15:45:32 2017 -0500
i40iw: Fix parsing of query/commit FPM buffers

--------------------------------------------------------

Chien Tin Tung (1):
  i40iw: Fix parsing of query/commit FPM buffers

Christopher N Bednarz (2):
  i40iw: Use correct alignment for CQ0 memory
  i40iw: Fix potential fcn_id_array out of bounds

Mustafa Ismail (2):
  i40iw: Correct variable names
  i40iw: Fix typecast of tcp_seq_num

Shiraz Saleem (1):
  i40iw: Improve CQP timeout logic

 drivers/infiniband/hw/i40iw/i40iw_ctrl.c   | 134 ++++++++++++++++++++---------
 drivers/infiniband/hw/i40iw/i40iw_d.h      |   4 +-
 drivers/infiniband/hw/i40iw/i40iw_p.h      |  14 +--
 drivers/infiniband/hw/i40iw/i40iw_puda.c   |   2 +-
 drivers/infiniband/hw/i40iw/i40iw_status.h |   2 +-
 drivers/infiniband/hw/i40iw/i40iw_type.h   |   5 ++
 drivers/infiniband/hw/i40iw/i40iw_uk.c     |   8 +-
 drivers/infiniband/hw/i40iw/i40iw_utils.c  |  22 +++--
 8 files changed, 129 insertions(+), 62 deletions(-)

-- 
2.8.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
