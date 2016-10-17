From: Dennis Dalessandro <dennis.dalessandro@intel.com>
Subject: [PATCH 00/12] For 4.9 rc
Date: Mon, 17 Oct 2016 04:19:01 -0700
Message-ID: <20161017103326.7934.21558.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <stable-owner@vger.kernel.org>
Sender: stable-owner@vger.kernel.org
To: dledford@redhat.com
Cc: Mike Marciniszyn <mike.marciniszyn@intel.com>, Dean Luick <dean.luick@intel.com>, Jakub Pawlak <jakub.pawlak@intel.com>, Ira Weiny <ira.weiny@intel.com>, Tadeusz Struk <tadeusz.struk@intel.com>, linux-rdma@vger.kernel.org, Tymoteusz Kielan <tymoteusz.kielan@intel.com>, Brian Welty <brian.welty@intel.com>, stable@vger.kernel.org, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, Easwar Hariharan <easwar.hariharan@intel.com>, Krzysztof Blaszkowski <krzysztof.blaszkowski@intel.com>, Sebastian Sanchez <sebastian.sanchez@intel.com>, Jianxin Xiong <jianxin.xiong@intel.com>
List-Id: linux-rdma@vger.kernel.org

Doug,

Here are some more patches for hfi1 and rdmavt. That I didn't bother to send
at the tail end of the merge window based on Linus' recent response on the
list. 

I think these could for the next RC. They build on the most recent patch set
[1] that is pending on the list.

If we need to remove any of these, or from [1] for the RC let me know and I can
respin or you can just drop.

Note there is another stable fix in here.

[1] http://marc.info/?l=linux-rdma&m=147610526924704&w=2

Can also be found in GitHub repo at:
https://github.com/ddalessa/kernel/tree/for-4.9

---

Dennis Dalessandro (1):
      IB/hfi1: Remove leftover snoop references

Easwar Hariharan (3):
      IB/hfi1: Add active channel and backplane support for integrated devices
      IB/hfi1: Clean up unused argument
      IB/hfi1: Delete unused lock

Ira Weiny (1):
      IB/hfi1: Fix rnr_timer addition

Jakub Pawlak (1):
      IB/hfi1: Unify access to GUID entries

Jianxin Xiong (1):
      IB/hfi1: Fix a potential memory leak in hfi1_create_ctxts()

Krzysztof Blaszkowski (1):
      IB/hfi1: Return ENODEV for unsupported PCI device ids.

Mike Marciniszyn (2):
      IB/rdmvat: Organize hot path calldowns into a single cacheline
      IB/hfi1: Optimize pio cachelines

Sebastian Sanchez (1):
      IB/hfi1: Optimize devdata cachelines

Tadeusz Struk (1):
      IB/hfi1: Fix an Oops on pci device force remove


 drivers/infiniband/hw/hfi1/chip.c           |   29 +---
 drivers/infiniband/hw/hfi1/chip_registers.h |    3 
 drivers/infiniband/hw/hfi1/file_ops.c       |    5 +
 drivers/infiniband/hw/hfi1/firmware.c       |  136 ++++++++++++++++---
 drivers/infiniband/hw/hfi1/hfi.h            |  193 +++++++++++++--------------
 drivers/infiniband/hw/hfi1/init.c           |   58 +++++---
 drivers/infiniband/hw/hfi1/mad.c            |   19 +--
 drivers/infiniband/hw/hfi1/pcie.c           |    3 
 drivers/infiniband/hw/hfi1/pio.h            |   10 +
 drivers/infiniband/hw/hfi1/platform.c       |  149 +++++++++++++++++----
 drivers/infiniband/hw/hfi1/platform.h       |  117 ++++++++++++++++
 drivers/infiniband/hw/hfi1/rc.c             |    2 
 drivers/infiniband/hw/hfi1/ruc.c            |   16 --
 drivers/infiniband/hw/hfi1/trace_rx.h       |   60 --------
 drivers/infiniband/hw/hfi1/verbs.c          |   15 +-
 drivers/infiniband/hw/hfi1/verbs.h          |    3 
 include/rdma/rdma_vt.h                      |   46 +++---
 17 files changed, 557 insertions(+), 307 deletions(-)

--
-Denny
