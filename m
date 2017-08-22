From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH for-next 00/16] IB/hfi1, qib,
 rdmavt: patches for next 08/21/2017
Date: Mon, 21 Aug 2017 18:26:07 -0700
Message-ID: <20170822011657.32701.22207.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Kaike Wan <kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Michael J. Ruhl" <michael.j.ruhl-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Grzegorz Morys <grzegorz.morys-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Harish Chegondi <harish.chegondi-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Kamenee Arumugam <kamenee.arumugam-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Doug,

Another week another set of patches. I meant to send on Friday but was waiting
for 0-day builds to complete. I still haven't gotten any notification, the
service may be down but I wanted to get these on the list anyway for review.
If I get any bad result I will reply but there is nothing particularly scary
in here.

Content wise this is more clean ups including a patch for rdmavt to use
the put_swqe/clear_mr_ref helpers that support was added for in qib/hfi1
previously. 

We have some minor bug fixes as well. A large portion of the patch set is
a clean up/refactoring exercise by Harish that I took because it makes the code
cleaner and easier to read.

Note, one of the fixes from Mike is marked stable. I don't know if it's something
that you want to take into this late of an RC so it may be best to just go to
next and flow through the stable process.

Patches can can also be found in my GitHub repo at:
https://github.com/ddalessa/kernel/tree/for-4.14

---

Grzegorz Morys (1):
      IB/hfi1: Ratelimit prints from sdma_interrupt

Harish Chegondi (7):
      IB/hfi1: Clean up hfi1_user_exp_rcv_setup function
      IB/hfi1: Clean up user_sdma_send_pkts() function
      IB/hfi1: Clean up pin_vector_pages() function
      IB/hfi1: Fix the bail out code in pin_vector_pages() function
      IB/hfi1: Remove duplicate definitions of num_user_pages() function
      IB/hfi1: Move structure definitions from user_exp_rcv.c to user_exp_rcv.h
      IB/hfi1: Move structure and MACRO definitions in user_sdma.c to user_sdma.h

Kaike Wan (1):
      IB/hfi1: Add received request info to qp_stats

Kamenee Arumugam (3):
      IB/qib: Remove unnecessary memory allocation for boardname
      IB/qib: Stricter bounds checking for copy and array access
      IB/hfi1: Fix whitespace alignment issue for MAD

Michael J. Ruhl (1):
      IB/hfi1: Improve local kmem_cache_alloc performance

Mike Marciniszyn (3):
      IB/rdmavt: Use rvt_put_swqe() in rvt_clear_mr_ref()
      IB/{qib,hfi1}: Avoid flow control testing for RDMA write operation
      IB/hfi1: Add opcode states to qp_stats


 drivers/infiniband/hw/hfi1/chip.c         |    4 
 drivers/infiniband/hw/hfi1/file_ops.c     |    2 
 drivers/infiniband/hw/hfi1/hfi.h          |    6 
 drivers/infiniband/hw/hfi1/mad.c          |    2 
 drivers/infiniband/hw/hfi1/qp.c           |   13 +
 drivers/infiniband/hw/hfi1/rc.c           |    3 
 drivers/infiniband/hw/hfi1/user_exp_rcv.c |  255 ++++++++++-------
 drivers/infiniband/hw/hfi1/user_exp_rcv.h |   34 ++
 drivers/infiniband/hw/hfi1/user_sdma.c    |  434 +++++++++--------------------
 drivers/infiniband/hw/hfi1/user_sdma.h    |  166 +++++++++++
 drivers/infiniband/hw/hfi1/verbs_txreq.c  |   11 -
 drivers/infiniband/hw/hfi1/vnic_sdma.c    |   13 -
 drivers/infiniband/hw/qib/qib_iba6120.c   |   20 -
 drivers/infiniband/hw/qib/qib_iba7220.c   |   22 +
 drivers/infiniband/hw/qib/qib_iba7322.c   |   40 +--
 drivers/infiniband/hw/qib/qib_init.c      |    1 
 drivers/infiniband/hw/qib/qib_mad.c       |    4 
 drivers/infiniband/hw/qib/qib_rc.c        |    4 
 drivers/infiniband/hw/qib/qib_ruc.c       |    6 
 drivers/infiniband/sw/rdmavt/qp.c         |    6 
 20 files changed, 556 insertions(+), 490 deletions(-)

--
-Denny
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
