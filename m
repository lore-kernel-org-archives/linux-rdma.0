From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH for-next 0/9] IB/core, hfi1,
 rdmavt: patches for next 05/19/2017
Date: Fri, 26 May 2017 05:35:05 -0700
Message-ID: <20170526123257.8158.23943.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Mitko Haralanov <mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Michael J. Ruhl" <michael.j.ruhl-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Michael N. Henry" <michael.n.henry-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Niranjana Vishwanathapura <niranjana.vishwanathapura-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Sebastian Sanchez <sebastian.sanchez-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Doug,

Another set of patches for 4.13. These apply on top of the last submitted
series: http://marc.info/?l=linux-rdma&m=149460607918479&w=2. I wanted to
submit this last week but 0-day build service and my GitHub weren't seeing
eye to eye. Things are working now and these have passed 0-day builds.

These are mostly fixes for the hfi1 driver, but there is a core change and one
for rdmavt as well which adds the ability to send OPA cap_mask3 in a trap.

Patches can can also be found in my GitHub repo at:
https://github.com/ddalessa/kernel/tree/for-4.13

---

Ira Weiny (1):
      IB/hfi1: Fix up sdma_init function comment

Michael J. Ruhl (2):
      IB/hfi1: Name function prototype parameters for affinity module
      IB/hfi1: Replace deprecated pci functions with new API

Michael N. Henry (1):
      IB/core,rdmavt,hfi1: Send OPA cap_mask3 in trap

Sebastian Sanchez (5):
      IB/hfi1: Don't remove RB entry when not needed.
      IB/hfi1: Optimize cachelines for user SDMA request structure
      IB/hfi1: Remove atomic SDMA_REQ_SEND_DONE bit operation
      IB/hfi1: Remove atomic SDMA_REQ_HAS_ERROR bit operation
      IB/hfi1: Reclassify type of messages printed for platform config logic


 drivers/infiniband/hw/hfi1/affinity.c  |   18 ++--
 drivers/infiniband/hw/hfi1/affinity.h  |   14 ++-
 drivers/infiniband/hw/hfi1/chip.c      |  105 ++++++++++-----------
 drivers/infiniband/hw/hfi1/hfi.h       |    6 -
 drivers/infiniband/hw/hfi1/mad.c       |    7 -
 drivers/infiniband/hw/hfi1/mad.h       |    2 
 drivers/infiniband/hw/hfi1/mmu_rb.c    |   14 ++-
 drivers/infiniband/hw/hfi1/mmu_rb.h    |    5 +
 drivers/infiniband/hw/hfi1/pcie.c      |   80 +++-------------
 drivers/infiniband/hw/hfi1/platform.c  |   20 ++--
 drivers/infiniband/hw/hfi1/sdma.c      |    6 -
 drivers/infiniband/hw/hfi1/user_sdma.c |  159 +++++++++++++++++---------------
 drivers/infiniband/hw/hfi1/verbs.c     |    7 +
 drivers/infiniband/sw/rdmavt/vt.c      |    9 +-
 include/rdma/ib_verbs.h                |    3 -
 include/rdma/rdma_vt.h                 |    1 
 16 files changed, 215 insertions(+), 241 deletions(-)

--
-Denny
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
