From: arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH 0/3] Add IB UD calls to free resources after EP/AH resolution
Date: Mon, 15 Dec 2014 10:11:36 -0800
Message-ID: <1418667099-32449-1-git-send-email-arlin.r.davis@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Arlin Davis <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Arlin Davis <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Arlin Davis (3):
  extension: add IB UD extensions to reduce CM/AH memory footprint
  openib: add new TIMEWAIT state for CM
  openib: add IB UD cm_free/ah_free extension support in UCM provider

 dapl/openib_cma/cm.c                 |    5 ++
 dapl/openib_cma/dapl_ib_util.h       |    1 +
 dapl/openib_common/dapl_ib_common.h  |    6 ++-
 dapl/openib_common/ib_extensions.c   |   40 +++++++++++++++++
 dapl/openib_mcm/cm.c                 |    5 ++
 dapl/openib_mcm/dapl_ib_util.h       |    1 +
 dapl/openib_scm/cm.c                 |    5 ++
 dapl/openib_scm/dapl_ib_util.h       |    1 +
 dapl/openib_ucm/cm.c                 |   77 +++++++++++++++++++++++++++++++++-
 dapl/openib_ucm/dapl_ib_util.h       |    1 +
 dat/include/dat2/dat_ib_extensions.h |   47 +++++++++++++++++++--
 11 files changed, 181 insertions(+), 8 deletions(-)

-- 
1.7.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
