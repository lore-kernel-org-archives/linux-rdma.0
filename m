From: Dennis Dalessandro <dennis.dalessandro@intel.com>
Subject: [PATCH for-next 0/8] IB/hfi1, core,
 rdmavt: Driver fixes for 10/2/2017
Date: Mon, 02 Oct 2017 11:03:54 -0700
Message-ID: <20171002180204.31117.12254.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <stable-owner@vger.kernel.org>
Sender: stable-owner@vger.kernel.org
To: dledford@redhat.com
Cc: Mike Marciniszyn <mike.marciniszyn@intel.com>, Jan Sokolowski <jan.sokolowski@intel.com>, Jakub Byczkowski <jakub.byczkowski@intel.com>, Andrzej Kacprowski <andrzej.kacprowski@intel.com>, linux-rdma@vger.kernel.org, Ira Weiny <ira.weiny@intel.com>, Stable@vger.kernel.org, Kaike Wan <kaike.wan@intel.com>, "Michael J. Ruhl" <michael.j.ruhl@intel.com>, Don Hiatt <don.hiatt@intel.com>, Niranjana Vishwanathapura <Niranjana.Vishwanathapura@intel.com>, Sebastian Sanchez <sebastian.sanchez@intel.com>
List-Id: linux-rdma@vger.kernel.org

Hi Doug,
There are a couple fixes in here that would have been nice to get into the RC
cycle, including one marked stable. However I think you will find them to be
too many LOC for an rc-4 submission so I have sent them in one series for-next.
Patches 2,3,4 and 5 are the fixes. Patch 2 is small but it's not really that
important to the end user.

There are some clean ups in here from Don from the 16B changes. One takes care
of some sparse warnings and the other two are from a WARN_ON_ONCE that needed
special cased for OPA.

Patches can can also be found in my GitHub repo at:
https://github.com/ddalessa/kernel/tree/for-4.15

---

Don Hiatt (3):
      IB/core: Use __be32 for LIDs in opa_is_extended_lid
      IB/core: Do not warn on lid conversions for OPA
      IB/hfi1: Do not warn on lid conversions for OPA

Jakub Byczkowski (1):
      IB/hfi1: Add parsing for platform configuration format version 4

Michael J. Ruhl (1):
      IB/hfi1: Fix incorrect available receive user context count

Mike Marciniszyn (1):
      IB/hfi1: Fix output trace issues from 16B change

Sebastian Sanchez (2):
      IB/hfi1: Prevent LNI out of sync by resetting host interface version
      IB/rdmavt: Correct issues with read-mostly and send size cache lines


 drivers/infiniband/core/user_mad.c        |   11 +++
 drivers/infiniband/hw/hfi1/chip.c         |  112 +++++++++++++++++++----------
 drivers/infiniband/hw/hfi1/chip.h         |    1 
 drivers/infiniband/hw/hfi1/firmware.c     |   87 ++++++++++++++++++-----
 drivers/infiniband/hw/hfi1/hfi.h          |    3 +
 drivers/infiniband/hw/hfi1/mad.c          |    7 +-
 drivers/infiniband/hw/hfi1/sysfs.c        |    2 -
 drivers/infiniband/hw/hfi1/trace_ibhdrs.h |    5 +
 drivers/infiniband/hw/hfi1/vnic_main.c    |    7 +-
 include/rdma/opa_addr.h                   |    6 +-
 include/rdma/rdmavt_qp.h                  |    6 +-
 11 files changed, 177 insertions(+), 70 deletions(-)
