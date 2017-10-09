From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH for-next 0/7] IB/hfi1,rdmavt: Driver fixes for 10/9/2017
Date: Mon, 09 Oct 2017 12:37:39 -0700
Message-ID: <20171009161736.6965.75352.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jan Sokolowski <jan.sokolowski-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jakub Byczkowski <jakub.byczkowski-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Alex Estrin <alex.estrin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Kaike Wan <kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Grzegorz Morys <grzegorz.morys-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Don Hiatt <don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Doug,

Some more fixes for the 4.15 cycle. Nothing in here really warrants going into
the RC. There is one patch reported by Leon that Don has done. Nothing really
too scary in this set.

Patches can can also be found in my GitHub repo at:
https://github.com/ddalessa/kernel/tree/for-4.15

---

Alex Estrin (1):
      IB/rdmavt: Don't wait for resources in QP reset

Don Hiatt (2):
      IB/hfi1: Mask out A bit from psn trace
      IB/hfi1: Eliminate allocation while atomic

Grzegorz Morys (1):
      IB/hfi1: Correct unnecessary acquisition of HW mutex

Jakub Byczkowski (1):
      IB/hfi1: Allow meta version 4 for platform configuration

Jan Sokolowski (1):
      IB/hfi1: Fix serdes loopback set-up

Kaike Wan (1):
      IB/hfi1: Set hdr_type when tx req is allocated


 drivers/infiniband/hw/hfi1/chip.c        |   42 ++++++++++--------------------
 drivers/infiniband/hw/hfi1/chip.h        |    3 ++
 drivers/infiniband/hw/hfi1/common.h      |    1 +
 drivers/infiniband/hw/hfi1/firmware.c    |   21 +++++++++++++--
 drivers/infiniband/hw/hfi1/rc.c          |    1 -
 drivers/infiniband/hw/hfi1/trace.c       |    4 +--
 drivers/infiniband/hw/hfi1/uc.c          |    1 -
 drivers/infiniband/hw/hfi1/verbs.c       |   22 ++++++----------
 drivers/infiniband/hw/hfi1/verbs_txreq.h |    2 +
 drivers/infiniband/sw/rdmavt/mcast.c     |    2 +
 drivers/infiniband/sw/rdmavt/qp.c        |    2 +
 11 files changed, 50 insertions(+), 51 deletions(-)

--
-Denny
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
