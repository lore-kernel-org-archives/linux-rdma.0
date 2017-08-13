From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH for-next 0/8] IB/hfi1: patches for next 08/13/2017
Date: Sun, 13 Aug 2017 08:08:15 -0700
Message-ID: <20170813150659.23208.66243.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jakub Byczkowski <jakub.byczkowski-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Brent Rothermel <brent.r.rothermel-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Todd Rimmer <todd.rimmer-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Michael J. Ruhl" <michael.j.ruhl-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Easwar Hariharan <easwar.hariharan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Grzegorz Morys <grzegorz.morys-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Kaike Wan <kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Sebastian Sanchez <sebastian.sanchez-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Kamenee Arumugam <kamenee.arumugam-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Doug,

Here is the next set of patches for our drivers for 4.14. One of these patches
gets rid of a config option that is no longer needed. There are some cleanups
as usual and minor bug fixes. Nothing that I would say needs to go into an RC.
These can all just land in your for-next tree and apply on top of that branch
with the addition of the pending patches still on the list. Everything applied
cleanly.

There is one patch to an OPA header file that addresses a question that Leon
had on the list about OPA physical port states.

Patches can can also be found in my GitHub repo at:
https://github.com/ddalessa/kernel/tree/for-4.14

---

Dennis Dalessandro (1):
      IB/hfi1: Document phys port state bits not used in IB

Grzegorz Morys (1):
      IB/hfi1: Remove HFI1_VERBS_31BIT_PSN option

Jakub Byczkowski (3):
      IB/hfi1: Add flag for platform config scratch register read
      IB/hfi1: Load fallback platform configuration per HFI device
      IB/hfi1: Remove pstate from hfi1_pportdata

Kaike Wan (1):
      IB/hfi1: Add kernel receive context info to debugfs

Kamenee Arumugame (1):
      IB/hfi1: Stricter bounds checking of MAD trap index

Sebastian Sanchez (1):
      IB/hfi1: Check xchg returned value for queuing link down entry


 drivers/infiniband/hw/hfi1/Kconfig      |    7 ---
 drivers/infiniband/hw/hfi1/chip.c       |   72 +++++++++++++++++++------------
 drivers/infiniband/hw/hfi1/chip.h       |    4 --
 drivers/infiniband/hw/hfi1/debugfs.c    |   47 ++++++++++++++++++++
 drivers/infiniband/hw/hfi1/driver.c     |   59 +++++++++++++++++++++++++
 drivers/infiniband/hw/hfi1/firmware.c   |   57 +++----------------------
 drivers/infiniband/hw/hfi1/hfi.h        |   28 ++----------
 drivers/infiniband/hw/hfi1/mad.c        |   15 ++++++
 drivers/infiniband/hw/hfi1/opa_compat.h |   21 ++++++++-
 drivers/infiniband/hw/hfi1/platform.c   |   43 +++++++++++++------
 drivers/infiniband/hw/hfi1/verbs.h      |    5 --
 include/rdma/rdma_vt.h                  |    2 -
 12 files changed, 224 insertions(+), 136 deletions(-)

--
-Denny
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
