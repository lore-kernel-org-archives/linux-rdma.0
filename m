From: arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH 0/4] DAPL: bug fixes
Date: Mon, 15 Dec 2014 11:58:51 -0800
Message-ID: <1418673535-1464-1-git-send-email-arlin.r.davis@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Arlin Davis <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Arlin Davis <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Arlin Davis (4):
  ucm: RTU not retransmitted in TIMEWAIT state
  dtestx: allow scale up to 1000 EP's
  common: dapl_ep_free must serialize CM object destroy
  ucm: add time wait override capability for CM services

 dapl/common/dapl_ep_free.c          |   21 ++++++++-------
 dapl/openib_common/dapl_ib_common.h |    1 +
 dapl/openib_ucm/cm.c                |   49 +++++++++++++++++------------------
 dapl/openib_ucm/dapl_ib_util.h      |    1 +
 dapl/openib_ucm/device.c            |    9 +++---
 test/dtest/dtestx.c                 |   21 +++++++++-----
 6 files changed, 55 insertions(+), 47 deletions(-)

-- 
1.7.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
