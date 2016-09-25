From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 00/13] IB/hfi1,qib: Round 2 of hfi1/qib fixes for 4.9
Date: Sun, 25 Sep 2016 07:40:49 -0700
Message-ID: <20160925143656.10261.85231.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jakub Pawlak <jakub.pawlak-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Harish Chegondi <harish.chegondi-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Sebastian Sanchez <sebastian.sanchez-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jianxin Xiong <jianxin.xiong-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Here is the next round of fixes and clean ups for hfi1/qib for 4.9. Mostly minor
fixes but there is a fix for stable in here. It is marked to Cc the stable list
in the commit message so no special handling should be needed on your part.

Patches should apply on your GitHub hfi1 branch and are availabe in my GitRepo as
well:
https://github.com/ddalessa/kernel/tree/for-4.9

---

Dean Luick (2):
      IB/hfi1: Extend i2c timeout
      IB/hfi1: Act on external device timeout

Dennis Dalessandro (3):
      IB/qib: Remove qpt_mask global
      IB/hfi1: Cleanup tasklet refs in comments
      IB/hfi1: Remove unused variable from devdata

Harish Chegondi (1):
      IB/hfi1: Adjust hardware buffering parameter

Jakub Pawlak (1):
      IB/hfi1: Fix resource release in context allocation

Jianxin Xiong (1):
      IB/hfi1: Increase default settings of max_cqes and max_qps

Mike Marciniszyn (2):
      IB/hfi1: Consolidate pio control masks into single definition
      IB/hfi1: Fix defered ack race with qp destroy

Sebastian Sanchez (3):
      IB/hfi1: Remove filtering of Set(PkeyTable) in HFI SMA
      IB/hfi1: Do not read more than a SGE length
      IB/hfi1: Combine shift copy and byte copy for SGE reads


 drivers/infiniband/hw/hfi1/chip.c     |    8 +
 drivers/infiniband/hw/hfi1/chip.h     |    6 +
 drivers/infiniband/hw/hfi1/file_ops.c |   17 ++
 drivers/infiniband/hw/hfi1/hfi.h      |    2 
 drivers/infiniband/hw/hfi1/init.c     |    1 
 drivers/infiniband/hw/hfi1/mad.c      |    6 -
 drivers/infiniband/hw/hfi1/pio_copy.c |  246 ++++++++-------------------------
 drivers/infiniband/hw/hfi1/qsfp.c     |    2 
 drivers/infiniband/hw/hfi1/rc.c       |   33 ++--
 drivers/infiniband/hw/hfi1/ruc.c      |    6 -
 drivers/infiniband/hw/hfi1/uc.c       |    9 -
 drivers/infiniband/hw/hfi1/verbs.c    |   40 ++++-
 drivers/infiniband/hw/hfi1/verbs.h    |    3 
 drivers/infiniband/hw/qib/qib.h       |    1 
 drivers/infiniband/hw/qib/qib_qp.c    |   13 --
 drivers/infiniband/hw/qib/qib_verbs.c |    2 
 16 files changed, 136 insertions(+), 259 deletions(-)

--
-Denny
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
