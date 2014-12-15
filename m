From: arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH 0/3] DAPL: SRQ support for ofa providers
Date: Mon, 15 Dec 2014 10:35:55 -0800
Message-ID: <1418668558-695-1-git-send-email-arlin.r.davis@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Arlin Davis <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Arlin Davis <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Amir Hanania (2):
  common: add srq support for openib verbs providers
  dtest: add dtestsrq for SRQ example and provider testing

Arlin Davis (1):
  dtestx: update IB extension example test with new v2.0.9 features

 Makefile.am                                 |    4 +
 dapl/common/dapl_adapter_util.h             |   13 +
 dapl/common/dapl_cr_callback.c              |    2 +-
 dapl/common/dapl_ep_create.c                |    2 +-
 dapl/common/dapl_ep_create_with_srq.c       |   53 +-
 dapl/common/dapl_ep_free.c                  |    5 +
 dapl/common/dapl_ep_post_recv.c             |    5 +
 dapl/common/dapl_ep_util.c                  |   29 +-
 dapl/common/dapl_ep_util.h                  |    3 +-
 dapl/common/dapl_evd_qp_async_error_callb.c |   15 +-
 dapl/common/dapl_evd_util.c                 |   49 +-
 dapl/common/dapl_srq_create.c               |   23 +-
 dapl/common/dapl_srq_free.c                 |   36 +-
 dapl/common/dapl_srq_post_recv.c            |    6 +-
 dapl/common/dapl_srq_query.c                |    6 +-
 dapl/common/dapl_srq_resize.c               |    9 +-
 dapl/common/dapl_srq_set_lw.c               |    4 +-
 dapl/common/dapl_srq_util.c                 |    2 -
 dapl/include/dapl.h                         |    2 +
 dapl/openib_common/cq.c                     |    3 +-
 dapl/openib_common/dapl_ib_common.h         |    1 +
 dapl/openib_common/dapl_ib_dto.h            |   48 +
 dapl/openib_common/qp.c                     |    5 +
 dapl/openib_common/srq.c                    |  147 +++
 dapl/openib_common/util.c                   |    9 +-
 dat/include/dat2/dat.h                      |    3 +-
 dat/include/dat2/dat_error.h                |    1 +
 test/dtest/Makefile.am                      |    6 +-
 test/dtest/dtestsrq.c                       | 1605 +++++++++++++++++++++++++++
 test/dtest/dtestx.c                         |  581 ++++++++---
 30 files changed, 2444 insertions(+), 233 deletions(-)
 create mode 100644 dapl/openib_common/srq.c
 create mode 100644 test/dtest/dtestsrq.c

-- 
1.7.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
