From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH for-next 00/11] IB/hfi1: Driver fixes for 11/6/2017
Date: Mon, 06 Nov 2017 06:38:07 -0800
Message-ID: <20171106143510.27539.65950.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jan Sokolowski <jan.sokolowski-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jakub Byczkowski <jakub.byczkowski-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Duane McCrory <duane.mccrory-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Alex Estrin <alex.estrin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Michael J. Ruhl" <michael.j.ruhl-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Kamenee Arumugam <kamenee.arumugam-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Grzegorz Morys <grzegorz.morys-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Don Hiatt <don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Niranjana Vishwanathapura <niranjana.vishwanathapura-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Sebastian Sanchez <sebastian.sanchez-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Doug,

More fixes for our drivers. Nothing scary or out of the ordinary here. There
is a core change, but it is for extended lids. This does include a patch
suggested by Dan and is based off of his patch and the ensuing discussion on the
list.

As always patches available for browsing at:
https://github.com/ddalessa/kernel/tree/for-4.15

---

Dennis Dalessandro (1):
      IB/hfi1: Handle initial value of 0 for CCTI setting

Don Hiatt (2):
      IB/core: Convert OPA AH to IB for Extended LIDs only
      IB/hfi1: Mask upper 16Bits of Extended LID prior to rvt_cq_entry

Grzegorz Morys (1):
      IB/hfi1: Prohibit invalid Init to Armed state transition

Jakub Byczkowski (1):
      IB/hfi1: Reduce 8051 command timeout

Jan Sokolowski (3):
      IB/hfi1: Allow MgmtAllowed on B2B setups
      IB/hfi1: Remove unnecessary if check
      IB/hfi1: Send 'reboot' as planned down remote reason

Kamenee Arumugam (1):
      IB/hfi1: Remove wrapper function in mmu_rb

Mike Marciniszyn (1):
      IB/hfi1: Fix a wrapping test to insure the correct timeout

Niranjana Vishwanathapura (1):
      IB/hfi1: Do not allocate PIO send contexts for VNIC


 drivers/infiniband/core/uverbs_marshall.c |    3 +-
 drivers/infiniband/hw/hfi1/chip.c         |   55 +++++------------------------
 drivers/infiniband/hw/hfi1/chip.h         |    2 +
 drivers/infiniband/hw/hfi1/driver.c       |    5 +--
 drivers/infiniband/hw/hfi1/hfi.h          |    3 ++
 drivers/infiniband/hw/hfi1/init.c         |    3 +-
 drivers/infiniband/hw/hfi1/intr.c         |   43 +++++++++++++++++++++++
 drivers/infiniband/hw/hfi1/mad.c          |   44 ++++++++++++++---------
 drivers/infiniband/hw/hfi1/mad.h          |    2 +
 drivers/infiniband/hw/hfi1/mmu_rb.c       |   24 ++++---------
 drivers/infiniband/hw/hfi1/pio.c          |   17 ---------
 drivers/infiniband/hw/hfi1/pio.h          |    6 ---
 drivers/infiniband/hw/hfi1/rc.c           |    4 +-
 drivers/infiniband/hw/hfi1/ruc.c          |    2 +
 drivers/infiniband/hw/hfi1/uc.c           |    2 +
 drivers/infiniband/hw/hfi1/ud.c           |    6 ++-
 drivers/infiniband/hw/hfi1/user_sdma.c    |   30 ++++++++--------
 drivers/infiniband/hw/hfi1/vnic_main.c    |   37 +-------------------
 18 files changed, 118 insertions(+), 170 deletions(-)

--
-Denny
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
