From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH for-next v2 00/16] IB/hfi1,
 core: Driver updates for 1/26/2018
Date: Fri, 26 Jan 2018 13:28:48 -0800
Message-ID: <20180126211126.12097.47410.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: jgg-uk2M96/98Pc@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Bartlomiej Dudek <bartlomiej.dudek-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Mitko Haralanov <mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Patel Jay P <jay.p.patel-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Alex Estrin <alex.estrin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Michael J. Ruhl" <michael.j.ruhl-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Don Hiatt <don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Sebastian Sanchez <sebastian.sanchez-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Kamenee Arumugam <kamenee.arumugam-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Jason and Doug,

For the most part this is the usual sort of fixes and clean ups with some things
that help optmize performance thrown in. There are three patches that may be of
a broader interest. There is a change to core header files for iWARP AH as well
as a fix to ipoib for a scenario where we can wind up in no-carrier state.

The other patch by Mike R comes out of the discussion [1] from a previous
submission.

As always my GitHub had these in-tree for context:
https://github.com/ddalessa/kernel/tree/for-4.16

[1] https://marc.info/?l=linux-rdma&m=151394843919393&w=2

---

changes since v1
----------------
Moved kobj get in patch 6, also changed patch one-line desc
Moved iWARP undef AH to be 0 instead of 3

---

Alex Estrin (3):
      IB/hfi1: Fix for early release of sdma context
      IB/hfi1: Fix for potential refcount leak in hfi1_open_file()
      IB/ipoib: Fix for potential no-carrier state

Bartlomiej Dudek (1):
      IB/hfi1: Do not override given pcie_pset value

Don Hiatt (1):
      IB/core: Map iWarp AH type to undefined in rdma_ah_find_type

Kamenee Arumugam (1):
      IB/hfi1: Convert PortXmitWait/PortVLXmitWait counters to flit times

Michael J. Ruhl (1):
      IB/hfi1: Re-order IRQ cleanup to address driver cleanup race

Mike Marciniszyn (1):
      IB/hfi1: Remove blind constants from 16B update

Mitko Haralanov (2):
      IB/hfi1: Remove dependence on qp->s_hdrwords
      IB/hfi1: Show fault stats in both TX and RX directions

Sebastian Sanchez (6):
      IB/hfi1: Prevent LNI hang when LCB can't obtain lanes
      IB/hfi1: Compute BTH only for RDMA_WRITE_LAST/SEND_LAST packet
      IB/hfi1: Optimize packet type comparison using 9B and bypass code paths
      IB/hfi1: Look up ibport using a pointer in receive path
      IB/hfi1: Remove unnecessary fecn and becn fields
      IB/hfi1: Optimize process_receive_ib()


 drivers/infiniband/hw/hfi1/chip.c           |  133 +++++++++++++++++++++------
 drivers/infiniband/hw/hfi1/chip.h           |   19 +++-
 drivers/infiniband/hw/hfi1/chip_registers.h |    7 +
 drivers/infiniband/hw/hfi1/debugfs.c        |    9 ++
 drivers/infiniband/hw/hfi1/driver.c         |   49 +++++-----
 drivers/infiniband/hw/hfi1/file_ops.c       |    4 -
 drivers/infiniband/hw/hfi1/hfi.h            |   26 +++--
 drivers/infiniband/hw/hfi1/init.c           |   14 +++
 drivers/infiniband/hw/hfi1/iowait.h         |    9 ++
 drivers/infiniband/hw/hfi1/mad.c            |  127 ++++++++++++++++++++++++--
 drivers/infiniband/hw/hfi1/mad.h            |   47 +++++++++-
 drivers/infiniband/hw/hfi1/pcie.c           |   23 ++---
 drivers/infiniband/hw/hfi1/qp.c             |    4 -
 drivers/infiniband/hw/hfi1/qp.h             |   13 +++
 drivers/infiniband/hw/hfi1/rc.c             |   51 +++++-----
 drivers/infiniband/hw/hfi1/ruc.c            |   47 +++-------
 drivers/infiniband/hw/hfi1/sdma.c           |   13 +--
 drivers/infiniband/hw/hfi1/sdma.h           |    1 
 drivers/infiniband/hw/hfi1/trace.c          |    8 +-
 drivers/infiniband/hw/hfi1/trace_ibhdrs.h   |   16 ++-
 drivers/infiniband/hw/hfi1/trace_rx.h       |   28 ++----
 drivers/infiniband/hw/hfi1/uc.c             |    9 --
 drivers/infiniband/hw/hfi1/ud.c             |   39 ++++----
 drivers/infiniband/hw/hfi1/verbs.c          |   10 +-
 drivers/infiniband/hw/hfi1/verbs.h          |   24 ++---
 drivers/infiniband/hw/hfi1/verbs_txreq.h    |    7 +
 drivers/infiniband/hw/qib/qib_rc.c          |    3 -
 drivers/infiniband/hw/qib/qib_uc.c          |    3 -
 drivers/infiniband/hw/qib/qib_ud.c          |    3 -
 drivers/infiniband/ulp/ipoib/ipoib_main.c   |    3 +
 include/rdma/ib_hdrs.h                      |   19 +++-
 include/rdma/ib_verbs.h                     |   12 ++
 32 files changed, 529 insertions(+), 251 deletions(-)

--
-Denny
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
