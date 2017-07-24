From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH for-next 00/13] IB/hfi1: patches for next 07/24/2017
Date: Mon, 24 Jul 2017 07:45:25 -0700
Message-ID: <20170724144415.10034.26787.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jan Sokolowski <jan.sokolowski-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jakub Byczkowski <jakub.byczkowski-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Mitko Haralanov <mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Alex Estrin <alex.estrin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Kaike Wan <kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ashutosh Dixit <ashutosh.dixit-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Michael J. Ruhl" <michael.j.ruhl-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Easwar Hariharan <easwar.hariharan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Michael N. Henry" <michael.n.henry-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Bartlomiej Dudek <bartlomiej.dudek-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Sebastian Sanchez <sebastian.sanchez-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Doug,

Here is a set of patches for 4.14. These apply on top of the others I have sent
previously. This fixes some performance centric bugs like using write combining
for bar0 mapping and a fix for not starving an iowait list. There are also a few
patches related to improving the code involving user contexts. A bug to fix
sending MAD traps until repressed is also included as well as some general code
cleanups. 

Patches can can also be found in my GitHub repo at:
https://github.com/ddalessa/kernel/tree/for-4.14

---

Alex Estrin (1):
      IB/hfi1: Verify port data VLs credits on transition to Armed

Bartlomiej Dudek (1):
      IB/hfi1: Move saving PCI values to a separate function

Byczkowski, Jakub (1):
      IB/hfi1: Fix initialization failure for debug firmware

Jan Sokolowski (1):
      IB/hfi1: Fix code consistency for if/else blocks in chip.c

Kaike Wan (1):
      IB/hfi1: Serve the most starved iowait entry first

Michael J. Ruhl (7):
      IB/hfi1: Assign context does not clean up file descriptor correctly on error
      IB/hfi1: Remove unused user context data members
      IB/hfi1: Size rcd array index correctly and consistently
      IB/hfi1: Use context pointer rather than context index
      IB/hfi1: Pass the context pointer rather than the index
      IB/hfi1: Send MAD traps until repressed
      IB/hfi1: Split copy_to_user data copy for better security

Mike Marciniszyn (1):
      IB/hfi1: Fix bar0 mapping to use write combining


 drivers/infiniband/hw/hfi1/aspm.h         |    6 
 drivers/infiniband/hw/hfi1/chip.c         |  227 +++++++++++-------
 drivers/infiniband/hw/hfi1/chip.h         |   15 +
 drivers/infiniband/hw/hfi1/driver.c       |   19 +
 drivers/infiniband/hw/hfi1/exp_rcv.h      |    5 
 drivers/infiniband/hw/hfi1/file_ops.c     |   76 +++---
 drivers/infiniband/hw/hfi1/firmware.c     |    8 +
 drivers/infiniband/hw/hfi1/hfi.h          |   49 +---
 drivers/infiniband/hw/hfi1/init.c         |   23 +-
 drivers/infiniband/hw/hfi1/intr.c         |    3 
 drivers/infiniband/hw/hfi1/iowait.h       |   70 +++++
 drivers/infiniband/hw/hfi1/mad.c          |  373 ++++++++++++++++++++++-------
 drivers/infiniband/hw/hfi1/mad.h          |    3 
 drivers/infiniband/hw/hfi1/pcie.c         |  164 ++++++++-----
 drivers/infiniband/hw/hfi1/pio.c          |   13 +
 drivers/infiniband/hw/hfi1/qp.c           |    9 -
 drivers/infiniband/hw/hfi1/ruc.c          |    5 
 drivers/infiniband/hw/hfi1/sdma.c         |   34 ++-
 drivers/infiniband/hw/hfi1/sdma.h         |    3 
 drivers/infiniband/hw/hfi1/trace_rx.h     |    2 
 drivers/infiniband/hw/hfi1/user_exp_rcv.c |    3 
 drivers/infiniband/hw/hfi1/user_sdma.c    |   19 -
 drivers/infiniband/hw/hfi1/user_sdma.h    |    3 
 drivers/infiniband/hw/hfi1/verbs.c        |   11 +
 drivers/infiniband/hw/hfi1/verbs.h        |    1 
 drivers/infiniband/hw/hfi1/vnic.h         |    1 
 drivers/infiniband/hw/hfi1/vnic_main.c    |    6 
 drivers/infiniband/hw/hfi1/vnic_sdma.c    |   14 +
 include/rdma/rdma_vt.h                    |   17 +
 29 files changed, 795 insertions(+), 387 deletions(-)

--
-Denny
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
