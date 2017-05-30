From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH for-next 0/9] IB/core, hfi1,
 rdmavt: patches for next 05/29/2017
Date: Mon, 29 May 2017 17:16:41 -0700
Message-ID: <20170530000314.534.72983.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Stuart Summers <john.s.summers-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jakub Byczkowski <jakub.byczkowski-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Tadeusz Struk <tadeusz.struk-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Brian Welty <brian.welty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Andrzej Kotlowski <andrzej.kotlowski-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Michael J. Ruhl" <michael.j.ruhl-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Neel Desai <neel.desai-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Doug,

Here is the next set of patches for our drivers for 4.13. The first couple are
clean up and general improvement patches. The last two are bug fixes. There is
one core change in the mix here. It is to allow QP to transition from reset to
error which according to the spec is supposed to be a valid transition.

Patches can can also be found in my GitHub repo at:
https://github.com/ddalessa/kernel/tree/for-4.13

---

Byczkowski, Jakub (1):
      IB/hfi1: Modify handling of physical link state by Host Driver

Dennis Dalessandro (6):
      IB/rdmavt: Remove duplicated functions
      IB/hfi1: Ensure dd->gi_mask can not be overflowed
      IB/hfi1: Fix spelling mistake in linkdown reason
      IB/hfi1: Use QPN mask to avoid overflow
      IB/hfi1: Remove subtraction of uninitialized value
      IB/hfi1,qib: Do not send QKey trap for UD qps

Neel Desai (1):
      IB/hfi1: Add error checking for buffer overrun in OPA aggregate

Tadeusz Struk (1):
      IB/core: Allow QP state transition from reset to error


 drivers/infiniband/core/verbs.c       |    1 
 drivers/infiniband/hw/hfi1/chip.c     |  111 ++++++++----
 drivers/infiniband/hw/hfi1/chip.h     |    2 
 drivers/infiniband/hw/hfi1/driver.c   |    9 +
 drivers/infiniband/hw/hfi1/hfi.h      |   18 ++
 drivers/infiniband/hw/hfi1/mad.c      |  316 ++++++++++++++++++++-------------
 drivers/infiniband/hw/hfi1/ruc.c      |    8 -
 drivers/infiniband/hw/hfi1/ud.c       |   37 +---
 drivers/infiniband/hw/hfi1/verbs.c    |    2 
 drivers/infiniband/hw/hfi1/verbs.h    |    4 
 drivers/infiniband/hw/qib/qib_mad.c   |   13 +
 drivers/infiniband/hw/qib/qib_ruc.c   |   20 +-
 drivers/infiniband/hw/qib/qib_ud.c    |   43 +---
 drivers/infiniband/hw/qib/qib_verbs.h |    4 
 drivers/infiniband/sw/rdmavt/qp.c     |   37 +---
 15 files changed, 358 insertions(+), 267 deletions(-)

--
-Denny
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
