From: Dennis Dalessandro <dennis.dalessandro@intel.com>
Subject: [PATCH for-next 00/14] IB/hfi1: Updates for-next 5/2/2018
Date: Wed, 02 May 2018 06:42:11 -0700
Message-ID: <20180502133831.20730.42677.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <stable-owner@vger.kernel.org>
Sender: stable-owner@vger.kernel.org
To: jgg@ziepe.ca, dledford@redhat.com
Cc: Mike Mariciniszyn <mike.marciniszyn@intel.com>, linux-rdma@vger.kernel.org, Mitko Haralanov <mitko.haralanov@intel.com>, Brian Welty <brian.welty@intel.com>, Alex Estrin <alex.estrin@intel.com>, stable@vger.kernel.org, "Michael J. Ruhl" <michael.j.ruhl@intel.com>, Harish Chegondi <harish.chegondi@intel.com>, Don Hiatt <don.hiatt@intel.com>, Sebastian Sanchez <sebastian.sanchez@intel.com>, Kamenee Arumugam <kamenee.arumugam@intel.com>
List-Id: linux-rdma@vger.kernel.org

Hi Doug and Jason,

Here are some patches to go to for-next. These include the couple patches that
needed rework that were posted before the OFA conf. Well actually those patches
that had issues were just dropped with the exception of the one from Alex, to
add handling of kernel restart to hfi1 and qib. Patch 8 is his V2.

Nothing else too scary or exciting in here. Well OK so that's not quite right
the CQ completion vector patch is rather interesting. This adds support
for compeltion vectors for hfi1 and helps improve performance in things like
IPoIB.

There is a signifianct patch from Mitko that redoes a lof our fault injection
stuff. It's a big patch but I'm not sure it lends itself to being broken up
further.

One other thing of note is the "Create common functions" patch from Sebastian
depends on one of the patches that I sent for the -rc. It won't apply cleanly
without that.

---

Alex Estrin (2):
      IB/hfi1: Complete check for locally terminated smp
      IB/{hfi1,qib}: Add handling of kernel restart

Brian Welty (1):
      IB/{hfi1,qib,rdmavt}: Move logic to allocate receive WQE into rdmavt

Kamenee Arumugam (1):
      IB/Hfi1: Read CCE Revision register to verify the device is responsive

Michael J. Ruhl (4):
      IB/hfi1: Return actual error value from program_rcvarray()
      IB/hfi1: Use after free race condition in send context error path
      IB/hfi1: Return correct value for device state
      IB/hfi1: Reorder incorrect send context disable

Mike Marciniszyn (1):
      IB/hfi1: Fix fault injection init/exit issues

Mitko Haralanov (1):
      IB/hfi1: Rework fault injection machinery

Sebastian Sanchez (4):
      IB/hfi1: Prevent LNI hang when LCB can't obtain lanes
      IB/hfi1: Optimize kthread pointer locking when queuing CQ entries
      IB/hfi1: Create common functions for affinity CPU mask operations
      IB/{hfi1,rdmavt,qib}: Implement CQ completion vector support


 drivers/infiniband/hw/hfi1/Makefile         |   10 -
 drivers/infiniband/hw/hfi1/affinity.c       |  497 +++++++++++++++++++++++++--
 drivers/infiniband/hw/hfi1/affinity.h       |   10 -
 drivers/infiniband/hw/hfi1/chip.c           |   74 +++-
 drivers/infiniband/hw/hfi1/chip.h           |   15 +
 drivers/infiniband/hw/hfi1/chip_registers.h |    7 
 drivers/infiniband/hw/hfi1/debugfs.c        |  292 ----------------
 drivers/infiniband/hw/hfi1/debugfs.h        |   93 +++--
 drivers/infiniband/hw/hfi1/driver.c         |   20 +
 drivers/infiniband/hw/hfi1/fault.c          |  375 ++++++++++++++++++++
 drivers/infiniband/hw/hfi1/fault.h          |  109 ++++++
 drivers/infiniband/hw/hfi1/file_ops.c       |    2 
 drivers/infiniband/hw/hfi1/hfi.h            |   14 +
 drivers/infiniband/hw/hfi1/init.c           |   28 +-
 drivers/infiniband/hw/hfi1/mad.c            |   36 +-
 drivers/infiniband/hw/hfi1/pcie.c           |    8 
 drivers/infiniband/hw/hfi1/pio.c            |   44 ++
 drivers/infiniband/hw/hfi1/rc.c             |    8 
 drivers/infiniband/hw/hfi1/ruc.c            |  154 --------
 drivers/infiniband/hw/hfi1/trace.c          |    3 
 drivers/infiniband/hw/hfi1/trace_dbg.h      |    3 
 drivers/infiniband/hw/hfi1/uc.c             |    4 
 drivers/infiniband/hw/hfi1/ud.c             |    4 
 drivers/infiniband/hw/hfi1/user_exp_rcv.c   |    1 
 drivers/infiniband/hw/hfi1/verbs.c          |   20 -
 drivers/infiniband/hw/hfi1/verbs.h          |    8 
 drivers/infiniband/hw/qib/qib.h             |    1 
 drivers/infiniband/hw/qib/qib_init.c        |   13 +
 drivers/infiniband/hw/qib/qib_rc.c          |    8 
 drivers/infiniband/hw/qib/qib_ruc.c         |  154 --------
 drivers/infiniband/hw/qib/qib_uc.c          |    4 
 drivers/infiniband/hw/qib/qib_ud.c          |    4 
 drivers/infiniband/hw/qib/qib_verbs.c       |    6 
 drivers/infiniband/hw/qib/qib_verbs.h       |    2 
 drivers/infiniband/sw/rdmavt/cq.c           |   74 ++--
 drivers/infiniband/sw/rdmavt/cq.h           |    6 
 drivers/infiniband/sw/rdmavt/qp.c           |  149 ++++++++
 drivers/infiniband/sw/rdmavt/trace_cq.h     |   35 ++
 drivers/infiniband/sw/rdmavt/vt.c           |   35 +-
 include/rdma/rdma_vt.h                      |    7 
 include/rdma/rdmavt_cq.h                    |    5 
 include/rdma/rdmavt_qp.h                    |    1 
 42 files changed, 1491 insertions(+), 852 deletions(-)
 create mode 100644 drivers/infiniband/hw/hfi1/fault.c
 create mode 100644 drivers/infiniband/hw/hfi1/fault.h
