From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 0/5] IB/hfi1: For 4.8 rc 5
Date: Wed, 31 Aug 2016 07:24:12 -0700
Message-ID: <20160831141841.27232.61621.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mitko Haralanov <mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Easwar Hariharan <easwar.hariharan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Harish Chegondi <harish.chegondi-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Sebastian Sanchez <sebastian.sanchez-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Doug,

Here are five patches which fix bugs that we think would be appropraite for
the next RC. This should apply cleanly on top of your GitHub 4.8 rc tree. 

Patches can also be seen in my repo and have passed 0day builds at:
https://github.com/ddalessa/kernel/tree/for-4.8

---

Dean Luick (1):
      IB/hfi1: Add QSFP sanity pre-check

Dennis Dalessandro (1):
      IB/hfi1: Fix AHG KDETH Intr shift

Harish Chegondi (1):
      IB/hfi1: Make n_krcvqs be an unsigned long integer

Mike Marciniszyn (1):
      IB/hfi1: Rework debugfs to use SRCU

Sebastian Sanchez (1):
      IB/hfi1: Fix SGE length for misaligned PIO copy


 drivers/infiniband/hw/hfi1/chip.c      |   92 ++++++++++++++++++++--
 drivers/infiniband/hw/hfi1/chip.h      |    1 
 drivers/infiniband/hw/hfi1/debugfs.c   |  132 +++++++++++++-------------------
 drivers/infiniband/hw/hfi1/hfi.h       |    4 +
 drivers/infiniband/hw/hfi1/init.c      |    3 -
 drivers/infiniband/hw/hfi1/pio_copy.c  |   12 +++
 drivers/infiniband/hw/hfi1/user_sdma.c |    5 +
 7 files changed, 155 insertions(+), 94 deletions(-)

--
-Denny
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
