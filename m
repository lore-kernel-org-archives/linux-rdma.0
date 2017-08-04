From: Dennis Dalessandro <dennis.dalessandro@intel.com>
Subject: [PATCH for-next 00/27] IB/hfi1, rdmavt, core,
 etc: patches for next 08/04/2017
Date: Fri, 04 Aug 2017 13:52:07 -0700
Message-ID: <20170804204842.17853.14858.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <stable-owner@vger.kernel.org>
Sender: stable-owner@vger.kernel.org
To: dledford@redhat.com
Cc: Mike Marciniszyn <mike.marciniszyn@intel.com>, Bartlomiej Dudek <bartlomiej.dudek@intel.com>, Jakub Byczkowski <jakub.byczkowski@intel.com>, linux-rdma@vger.kernel.org, Ira Weiny <ira.weiny@intel.com>, Alex Estrin <alex.estrin@intel.com>, stable@vger.kernel.org, "Michael J. Ruhl" <michael.j.ruhl@intel.com>, Don Hiatt <don.hiatt@intel.com>, Sebastian Sanchez <sebastian.sanchez@intel.com>, Dasaratharaman Chandramouli <dasaratharaman.chandramouli@intel.com>
List-Id: linux-rdma@vger.kernel.org

Hi Doug,

Here is the next set of patches for our drivers for 4.14. Along with the usual
fixes and such this includes our extended LID patches which were posted a
while back [1] [2]. Please drop those patch sets as they needed rebased.
Along with those core changes we are now submitting the driver changes that
are needed to make use of extended LIDs. 21 of these 27 patches are related
to that effort. The other 6 are usual fixes.

Also note the first patch we did mark stable. That may be something to consider
for the 4.13-rc.

Patches can can also be found in my GitHub repo at:
https://github.com/ddalessa/kernel/tree/for-4.14

[1] http://marc.info/?l=linux-rdma&m=149694352021933&w=2
[2] http://marc.info/?l=linux-rdma&m=149694355721946&w=2

---

Alex Estrin (1):
      IB/hfi1: Revert egress pkey check enforcement

Bartlomiej Dudek (1):
      IB/hfi1: Use host_link_state to read state when DC is shut down

Byczkowski, Jakub (1):
      IB/hfi1: Remove lstate from hfi1_pportdata

Dasaratharaman Chandramouli (10):
      IB/core: Convert ah_attr from OPA to IB when copying to user
      IB/srpt: Increase lid and sm_lid to 32 bits
      IB/IPoIB: Increase local_lid to 32 bits
      IB/mad: Change slid in RMPP recv from 16 to 32 bits
      IB/core: Change port_attr.lid size from 16 to 32 bits
      IB/core: Change port_attr.sm_lid from 16 to 32 bits
      IB/CM: Create appropriate path records when handling CM request
      IB/CM: Set appropriate slid and dlid when handling CM request
      IB/rdmavt,hfi1,qib: Enhance rdmavt and hfi1 to use 32 bit lids
      IB/hfi1: Enable RDMA_CAP_OPA_AH in hfi driver to support extended LIDs

Don Hiatt (11):
      IB/core: Change wc.slid from 16 to 32 bits
      IB/CM: Add OPA Path record support to CM
      IB/rdmavt,hfi1,qib: Modify check_ah() to account for extended LIDs
      IB/hfi1: Add support to receive 16B bypass packets
      IB/hfi1: Add support to send 16B bypass packets
      IB/hfi1: Add support to process 16B header errors
      IB/hfi1: Determine 9B/16B L2 header type based on Address handle
      IB/hfi1: Add 16B UD support
      IB/hfi1: Add 16B trace support
      IB/hfi1: Add 16B RC/UC support
      IB/hfi1: Enhance PIO/SDMA send for 16B

Michael J. Ruhl (2):
      IB/hfi1: Protect context array set/clear with spinlock
      IB/hf1: User context locking is inconsistent

Sebastian Sanchez (1):
      IB/hfi1: Remove pmtu from the QP structure


 drivers/infiniband/core/cm.c              |  159 +++++++++--
 drivers/infiniband/core/core_priv.h       |    1 
 drivers/infiniband/core/mad_rmpp.c        |    2 
 drivers/infiniband/core/sa_query.c        |   21 +
 drivers/infiniband/core/ucm.c             |    2 
 drivers/infiniband/core/ucma.c            |   10 -
 drivers/infiniband/core/user_mad.c        |    2 
 drivers/infiniband/core/uverbs_cmd.c      |   22 +
 drivers/infiniband/core/uverbs_marshall.c |   48 +++
 drivers/infiniband/hw/hfi1/aspm.h         |   35 ++
 drivers/infiniband/hw/hfi1/chip.c         |  110 +++++--
 drivers/infiniband/hw/hfi1/chip.h         |    3 
 drivers/infiniband/hw/hfi1/common.h       |   10 -
 drivers/infiniband/hw/hfi1/debugfs.c      |   32 +-
 drivers/infiniband/hw/hfi1/driver.c       |  291 +++++++++++++++-----
 drivers/infiniband/hw/hfi1/file_ops.c     |  340 +++++++++++++----------
 drivers/infiniband/hw/hfi1/hfi.h          |  422 ++++++++++++++++++++++++++---
 drivers/infiniband/hw/hfi1/init.c         |  306 ++++++++++++++-------
 drivers/infiniband/hw/hfi1/mad.c          |  108 ++++++-
 drivers/infiniband/hw/hfi1/qp.c           |   28 ++
 drivers/infiniband/hw/hfi1/rc.c           |  389 +++++++++++++++++---------
 drivers/infiniband/hw/hfi1/ruc.c          |  237 ++++++++++++----
 drivers/infiniband/hw/hfi1/trace.c        |  153 ++++++++++
 drivers/infiniband/hw/hfi1/trace_ibhdrs.h |  364 +++++++++++++++++--------
 drivers/infiniband/hw/hfi1/trace_rx.h     |   12 -
 drivers/infiniband/hw/hfi1/uc.c           |   42 ++-
 drivers/infiniband/hw/hfi1/ud.c           |  427 ++++++++++++++++++++++-------
 drivers/infiniband/hw/hfi1/user_sdma.c    |    7 
 drivers/infiniband/hw/hfi1/verbs.c        |  280 +++++++++++++------
 drivers/infiniband/hw/hfi1/verbs.h        |   45 ++-
 drivers/infiniband/hw/hfi1/vnic.h         |   15 -
 drivers/infiniband/hw/hfi1/vnic_main.c    |   32 --
 drivers/infiniband/hw/mlx4/alias_GUID.c   |    2 
 drivers/infiniband/hw/mlx4/mad.c          |    8 -
 drivers/infiniband/hw/mlx5/mad.c          |    2 
 drivers/infiniband/hw/mthca/mthca_cmd.c   |    4 
 drivers/infiniband/hw/mthca/mthca_mad.c   |    4 
 drivers/infiniband/hw/qib/qib_mad.c       |    4 
 drivers/infiniband/hw/qib/qib_verbs.c     |    9 +
 drivers/infiniband/sw/rdmavt/ah.c         |   10 -
 drivers/infiniband/sw/rdmavt/cq.c         |    2 
 drivers/infiniband/sw/rdmavt/qp.c         |   32 ++
 drivers/infiniband/ulp/ipoib/ipoib.h      |    2 
 drivers/infiniband/ulp/srpt/ib_srpt.h     |    4 
 include/rdma/ib_marshall.h                |    6 
 include/rdma/ib_verbs.h                   |   33 ++
 include/rdma/opa_addr.h                   |   42 +++
 include/rdma/opa_vnic.h                   |    3 
 include/rdma/rdma_vt.h                    |    2 
 include/rdma/rdmavt_qp.h                  |    1 
 50 files changed, 2986 insertions(+), 1139 deletions(-)
