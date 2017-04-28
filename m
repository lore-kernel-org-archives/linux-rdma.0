From: Dennis Dalessandro <dennis.dalessandro@intel.com>
Subject: [PATCH v2 00/19] IB/hfi1,rdmavt,core: Patches for-next
Date: Fri, 28 Apr 2017 10:38:49 -0700
Message-ID: <20170428173443.23960.32602.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <stable-owner@vger.kernel.org>
Sender: stable-owner@vger.kernel.org
To: dledford@redhat.com
Cc: Mike Marciniszyn <mike.marciniszyn@intel.com>, Stuart Summers <john.s.summers@intel.com>, linux-rdma@vger.kernel.org, Ira Weiny <ira.weiny@intel.com>, Mitko Haralanov <mitko.haralanov@intel.com>, Tadeusz Struk <tadeusz.struk@intel.com>, stable@vger.kernel.org, "Michael J. Ruhl" <michael.j.ruhl@intel.com>, Easwar Hariharan <easwar.hariharan@intel.com>, Don Hiatt <don.hiatt@intel.com>, Neel Desai <neel.desai@intel.com>, Leon Romanovsky <leonro@mellanox.com>, Sebastian Sanchez <sebastian.sanchez@intel.com>, Dasaratharaman Chandramouli <dasaratharaman.chandramouli@intel.com>
List-Id: linux-rdma@vger.kernel.org

Doug,

Here are some patches for the next release. It includes the core fix that did
not apply from my last series. Other than that this is the usual bug fixes
and some minor clean ups.

Patches apply on top of your for-4.12 branch and can also be found in my
GitHub repo at: https://github.com/ddalessa/kernel/tree/for-4.12

---

Changes since V1:
* Dropped: [02/20] IB/hfi1: Remove hyper-thread siblings by walking CPU mask
* Fixed a scheduling while atomic bug in update_synth_timer

---

Dasaratharaman Chandramouli (1):
      IB/hfi1: Rename hdr2sc to hfi1_9B_get_sc5

Dennis Dalessandro (4):
      IB/hfi1: Fix misspelling in comment
      IB/hfi1: Convert %Lx to %llx
      IB/hfi1: Fix unbalanced braces around else
      IB/hfi1: Use bool in process_ecn

Don Hiatt (2):
      IB/hfi1: Add functions to parse 9B headers
      IB/hfi1: Use defines from common headers

Ira Weiny (1):
      IB/hfi: Protect against writable mmap

Michael J. Ruhl (5):
      IB/core: If the MGID/MLID pair is not on the list return an error
      IB/hfi1: Correct MulticastMask/CollectiveMask info to SMA output
      IB/core: For multicast functions, verify that LIDs are multicast LIDs
      IB/rdmavt/hfi1/qib: Use the MGID and MLID for multicast addressing
      IB/hfi1: Validate the TID count before using it

Mike Marciniszyn (1):
      IB/hfi1: Prevent kernel QP post send hard lockups

Neel Desai (2):
      IB/hfi1: Adjust high temperature warning for QSFP cable
      IB/hfi1: Permanently enable P_Key checking in HFI

Sebastian Sanchez (1):
      IB/hfi1: Return SC2VL mappings to FM with VL15 instead of ILLEGAL_VL

Stuart Summers (1):
      IB/hfi1: Cache neighbor secure data after link up

Tadeusz Struk (1):
      IB/hfi1: Fix softlockup issue


 drivers/infiniband/core/uverbs_cmd.c      |   13 ++-
 drivers/infiniband/core/verbs.c           |    8 +-
 drivers/infiniband/hw/hfi1/chip.c         |  121 ++++++++++++++---------------
 drivers/infiniband/hw/hfi1/common.h       |   15 ++--
 drivers/infiniband/hw/hfi1/driver.c       |   28 +++----
 drivers/infiniband/hw/hfi1/file_ops.c     |    4 +
 drivers/infiniband/hw/hfi1/hfi.h          |   27 ++++--
 drivers/infiniband/hw/hfi1/init.c         |   11 ++-
 drivers/infiniband/hw/hfi1/intr.c         |   27 ++++--
 drivers/infiniband/hw/hfi1/mad.c          |   56 +++++++------
 drivers/infiniband/hw/hfi1/pcie.c         |    2 
 drivers/infiniband/hw/hfi1/rc.c           |   19 ++---
 drivers/infiniband/hw/hfi1/ruc.c          |   52 +++++++-----
 drivers/infiniband/hw/hfi1/trace.c        |    5 -
 drivers/infiniband/hw/hfi1/trace_ibhdrs.h |    8 +-
 drivers/infiniband/hw/hfi1/uc.c           |    8 +-
 drivers/infiniband/hw/hfi1/ud.c           |   18 ++--
 drivers/infiniband/hw/hfi1/user_exp_rcv.c |    3 +
 drivers/infiniband/hw/hfi1/verbs.c        |   16 ++--
 drivers/infiniband/hw/hfi1/verbs.h        |    6 +
 drivers/infiniband/hw/qib/qib_verbs.c     |    2 
 drivers/infiniband/sw/rdmavt/mcast.c      |   61 +++++++++++----
 include/rdma/ib_hdrs.h                    |   66 ++++++++++++++++
 include/rdma/rdma_vt.h                    |    3 -
 include/rdma/rdmavt_qp.h                  |    7 +-
 25 files changed, 363 insertions(+), 223 deletions(-)
