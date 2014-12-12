From: arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH 0/4] Bug Fixes, new provider attributes
Date: Fri, 12 Dec 2014 08:50:39 -0800
Message-ID: <1418403043-2221-1-git-send-email-arlin.r.davis@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Arlin Davis <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Arlin Davis <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>


Arlin Davis (4):
  common: return appropriate handles with affiliated EP/EVD async events
  add provider and proxy support for GUID across platform
  mpxyd: log warning if running in COMPAT mode
  mpxyd/mcm: add provider specific attribute DAT_IB_PROXY_VERSION

 dapl/common/dapl_evd_cq_async_error_callb.c |    4 +--
 dapl/common/dapl_evd_qp_async_error_callb.c |   33 +------------------------
 dapl/openib_common/util.c                   |   35 +++++++++++++++++----------
 dapl/openib_mcm/dapl_ib_util.h              |    1 +
 dapl/openib_mcm/device.c                    |   19 ++++++++------
 dapl/openib_scm/device.c                    |   27 +++++++++++---------
 dapl/openib_ucm/device.c                    |   20 +++++++++------
 dapl/svc/mcm.c                              |    5 ++-
 dapl/svc/mpxyd.c                            |   17 +++++++------
 9 files changed, 75 insertions(+), 86 deletions(-)

-- 
1.7.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
