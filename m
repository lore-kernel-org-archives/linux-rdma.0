From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 0/4] hfi1/rdmavt: For 4.8 rc
Date: Tue, 16 Aug 2016 13:23:38 -0700
Message-ID: <20160816202133.24004.31487.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mitko Haralanov <mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Easwar Hariharan <easwar.hariharan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Doug,

Here are four patches that we'd like to get into the rc cycle.

These apply on top of the last set of patches Ira sent (including the v2 of
[1]).

[1] http://marc.info/?l=linux-rdma&m=147116491910005&w=2

Patches can also be viewed in my repo at:
https://github.com/ddalessa/kernel/tree/for-4.8

---

Easwar Hariharan (1):
      IB/hfi1: Return invalid field for non-QSFP CableInfo queries

Ira Weiny (1):
      IB/hfi1: Fix mm_struct use after free

Mike Marciniszyn (1):
      IB/rdmvat: Fix double vfree() in rvt_create_qp() error path

Mitko Haralanov (1):
      IB/hfi1: Improve J_KEY generation


 drivers/infiniband/hw/hfi1/file_ops.c |    2 ++
 drivers/infiniband/hw/hfi1/hfi.h      |   19 ++++++++++++++++++-
 drivers/infiniband/hw/hfi1/mad.c      |    5 +++++
 drivers/infiniband/sw/rdmavt/qp.c     |    3 ++-
 4 files changed, 27 insertions(+), 2 deletions(-)

--
-Denny
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
