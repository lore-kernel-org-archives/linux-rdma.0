From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 0/2] IB/hfi1,qib: Fixes for 4.12-rc
Date: Fri, 12 May 2017 09:01:15 -0700
Message-ID: <20170512155936.27868.7128.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jakub Byczkowski <jakub.byczkowski-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Tadeusz Struk <tadeusz.struk-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Stable <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Doug,

Here are two patches that I think should be RC worthy. One fixes a bug where
packets could be sent before the other side is ready. The other fixes an MR ref
count leak for write-only-with-immediate when the buffer allocation for the
immediate data fails. This one is in both qib and hfi1. Ideally we will move
this code to rdmavt to get rid of the duplication but would like to get this fix
out for RC and the stable kernels.

These apply on top of:
67cf362 : rxe: expose num_possible_cpus() cnum_comp_vectors

Patches can can also be found in my GitHub repo at:
https://github.com/ddalessa/kernel/tree/for-4.12

---

Byczkowski, Jakub (1):
      IB/hfi1: Defer setting VL15 credits to link-up interrupt

Mike Marciniszyn (1):
      IB/qib,IB/hfi1: Fix MR reference count leak on write with immediate


 drivers/infiniband/hw/hfi1/chip.c           |   67 ++++++++++++++++++++-------
 drivers/infiniband/hw/hfi1/chip_registers.h |    2 +
 drivers/infiniband/hw/hfi1/hfi.h            |   11 ++++
 drivers/infiniband/hw/hfi1/intr.c           |    3 +
 drivers/infiniband/hw/hfi1/rc.c             |    5 ++
 drivers/infiniband/hw/qib/qib_rc.c          |    4 +-
 6 files changed, 71 insertions(+), 21 deletions(-)

--
-Denny
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
