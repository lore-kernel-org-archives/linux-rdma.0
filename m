From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 00/20] IB/hfi1,rdmavt,core: Patches for-next
Date: Sun, 09 Apr 2017 10:15:25 -0700
Message-ID: <20170409171329.10579.92775.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Stuart Summers <john.s.summers-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Mitko Haralanov <mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Tadeusz Struk <tadeusz.struk-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Michael J. Ruhl" <michael.j.ruhl-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Easwar Hariharan <easwar.hariharan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Don Hiatt <don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Neel Desai <neel.desai-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sebastian Sanchez <sebastian.sanchez-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Dasaratharaman Chandramouli <dasaratharaman.chandramouli-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Doug,

Here are some patches for the next release. It includes the core fix that did
not apply from my last series. Other than that this is the usual bug fixes
and some minor clean ups.

Patches apply on top of your for-4.12 branch and can also be found in my
GitHub repo at: https://github.com/ddalessa/kernel/tree/for-4.12

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

Sebastian Sanchez (2):
      IB/hfi1: Remove hyper-thread siblings by walking CPU mask
      IB/hfi1: Return SC2VL mappings to FM with VL15 instead of ILLEGAL_VL

Stuart Summers (1):
      IB/hfi1: Cache neighbor secure data after link up

Tadeusz Struk (1):
      IB/hfi1: Fix softlockup issue


 drivers/infiniband/core/uverbs_cmd.c      |   13 +++-
 drivers/infiniband/core/verbs.c           |    8 ++
 drivers/infiniband/hw/hfi1/affinity.c     |   52 +++++++--------
 drivers/infiniband/hw/hfi1/affinity.h     |    4 -
 drivers/infiniband/hw/hfi1/chip.c         |   98 +++++++++++------------------
 drivers/infiniband/hw/hfi1/common.h       |   15 +++-
 drivers/infiniband/hw/hfi1/driver.c       |   28 ++++----
 drivers/infiniband/hw/hfi1/file_ops.c     |    4 +
 drivers/infiniband/hw/hfi1/hfi.h          |   23 ++++---
 drivers/infiniband/hw/hfi1/init.c         |   11 ++-
 drivers/infiniband/hw/hfi1/intr.c         |   27 +++++---
 drivers/infiniband/hw/hfi1/mad.c          |   56 +++++++++--------
 drivers/infiniband/hw/hfi1/pcie.c         |    2 -
 drivers/infiniband/hw/hfi1/rc.c           |   19 +++---
 drivers/infiniband/hw/hfi1/ruc.c          |   52 +++++++++------
 drivers/infiniband/hw/hfi1/trace.c        |    5 +
 drivers/infiniband/hw/hfi1/trace_ibhdrs.h |    8 +-
 drivers/infiniband/hw/hfi1/uc.c           |    8 +-
 drivers/infiniband/hw/hfi1/ud.c           |   18 ++---
 drivers/infiniband/hw/hfi1/user_exp_rcv.c |    3 +
 drivers/infiniband/hw/hfi1/verbs.c        |   16 ++---
 drivers/infiniband/hw/hfi1/verbs.h        |    6 +-
 drivers/infiniband/hw/qib/qib_verbs.c     |    2 -
 drivers/infiniband/sw/rdmavt/mcast.c      |   61 +++++++++++++-----
 include/rdma/ib_hdrs.h                    |   66 ++++++++++++++++++++
 include/rdma/rdma_vt.h                    |    3 +
 include/rdma/rdmavt_qp.h                  |    7 ++
 27 files changed, 365 insertions(+), 250 deletions(-)

--
-Denny
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
