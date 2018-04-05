From: Dennis Dalessandro <dennis.dalessandro@intel.com>
Subject: [PATCH for-next 00/13] IB/hfi1,core: Driver updates for 4.17
Date: Wed, 04 Apr 2018 20:01:11 -0700
Message-ID: <20180405025915.18766.41569.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <stable-owner@vger.kernel.org>
Sender: stable-owner@vger.kernel.org
To: jgg@ziepe.ca, dledford@redhat.com
Cc: Mike Mariciniszyn <mike.marciniszyn@intel.com>, linux-rdma@vger.kernel.org, Mitko Haralanov <mitko.haralanov@intel.com>, Brian Welty <brian.welty@intel.com>, Alex Estrin <alex.estrin@intel.com>, stable@vger.kernel.org, Ashutosh Dixit <ashutosh.dixit@intel.com>, "Michael J. Ruhl" <michael.j.ruhl@intel.com>, Harish Chegondi <harish.chegondi@intel.com>, Don Hiatt <don.hiatt@intel.com>, Sebastian Sanchez <sebastian.sanchez@intel.com>, Prathap Kumar Valsan <prathap.kumar.valsan@intel.com>
List-Id: linux-rdma@vger.kernel.org

Hi Jason and Doug,

Here are most of our updates for 4.17. I will follow this up with a small
16B series then I still have a few more patches that are waiting on
some more thorough testing. Should be able to get them on the list tomrrow or
Friday at the latest, wanted to get these out now. I don't think anything
is really that scary in here.

These are mostly driver fixes. Patches 4,7,8,11, and 14 are marked stable.
They didn't get sent for the -rc because they fix really old issues.

Patch 5 is a core fix. I should have sent it a bit sooner, sorry about that but
it's pretty trivial so I decided to include it as well rather than wait for
4.18.

---

Alex Estrin (2):
      IB/hfi1: Complete check for locally terminated smp
      IB/{hfi1,qib}: Add handling of kernel restart

Ashutosh Dixit (1):
      IB/core: Fix rkey invalidation from user space into the kernel

Michael J. Ruhl (5):
      IB/hfi1: Return actual error value from program_rcvarray()
      IB/hfi1: Use after free race condition in send context error path
      IB/hfi1 Use correct type for num_user_context
      IB/hfi1: Return correct value for device state
      IB/hfi1: Reorder incorrect send context disable

Mike Marciniszyn (3):
      IB/hfi1: Fix handling of FECN marked multicast packet
      IB/hfi1: Fix fault injection init/exit issues
      IB/hfi1: Fix loss of BECN with AHG

Sebastian Sanchez (2):
      IB/hfi1: Prevent LNI hang when LCB can't obtain lanes
      IB/{hfi1,rdmavt,qib}: Fit kernel completions into single aligned cache-line


 drivers/infiniband/core/uverbs_cmd.c        |    4 +
 drivers/infiniband/hw/hfi1/chip.c           |   59 ++++++++---
 drivers/infiniband/hw/hfi1/chip.h           |   15 ++-
 drivers/infiniband/hw/hfi1/chip_registers.h |    7 +
 drivers/infiniband/hw/hfi1/debugfs.c        |    8 +
 drivers/infiniband/hw/hfi1/driver.c         |   19 +++-
 drivers/infiniband/hw/hfi1/file_ops.c       |    2 
 drivers/infiniband/hw/hfi1/hfi.h            |    9 +-
 drivers/infiniband/hw/hfi1/init.c           |    9 +-
 drivers/infiniband/hw/hfi1/mad.c            |   36 ++++---
 drivers/infiniband/hw/hfi1/pio.c            |   44 ++++++--
 drivers/infiniband/hw/hfi1/rc.c             |    2 
 drivers/infiniband/hw/hfi1/ruc.c            |   54 ++++++++--
 drivers/infiniband/hw/hfi1/uc.c             |    2 
 drivers/infiniband/hw/hfi1/ud.c             |   10 +-
 drivers/infiniband/hw/hfi1/user_exp_rcv.c   |    1 
 drivers/infiniband/hw/qib/qib.h             |    1 
 drivers/infiniband/hw/qib/qib_init.c        |    5 +
 drivers/infiniband/hw/qib/qib_rc.c          |    2 
 drivers/infiniband/hw/qib/qib_ruc.c         |    4 -
 drivers/infiniband/hw/qib/qib_uc.c          |    2 
 drivers/infiniband/hw/qib/qib_ud.c          |    4 -
 drivers/infiniband/sw/rdmavt/cq.c           |  146 ++++++++++++++++++---------
 drivers/infiniband/sw/rdmavt/qp.c           |    4 -
 drivers/infiniband/sw/rdmavt/trace_cq.h     |    6 +
 include/rdma/ib_verbs.h                     |    5 +
 include/rdma/rdmavt_cq.h                    |   35 +++++-
 include/rdma/rdmavt_qp.h                    |    2 
 28 files changed, 344 insertions(+), 153 deletions(-)
