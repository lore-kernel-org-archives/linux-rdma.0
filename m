From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 0/7] IB/hfi1: Another round of fixes
Date: Tue, 25 Oct 2016 13:12:04 -0700
Message-ID: <20161025194241.15765.8903.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jakub Pawlak <jakub.pawlak-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Krzysztof Blaszkowski <krzysztof.blaszkowski-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Tymoteusz Kielan <tymoteusz.kielan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Sebastian Sanchez <sebastian.sanchez-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jianxin Xiong <jianxin.xiong-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Dasaratharaman Chandramouli <dasaratharaman.chandramouli-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Doug,

Here is another set of mostly small fixes. I think it could go in the RC, but if
not I can respin for next.

Can also be found in GitHub repo at:
https://github.com/ddalessa/kernel/tree/for-4.9

---

Dasaratharaman Chandramouli (1):
      IB/hfi1: Fix ECN processing in prescan_rxq

Dennis Dalessandro (1):
      IB/hfi1: Remove incorrect IS_ERR check

Jakub Pawlak (1):
      IB/hfi1: Fix status error code for unsupported packets

Jianxin Xiong (1):
      IB/hfi1: Prevent hardware counter names from being cut off

Krzysztof Blaszkowski (1):
      IB/hfi1: Relocate rcvhdrcnt module parameter check.

Sebastian Sanchez (2):
      IB/hfi1: Get rid of divide in pio buffer allocator
      IB/hfi1: Optimize pio_buf and send_context structs


 drivers/infiniband/hw/hfi1/chip.c      |    2 +
 drivers/infiniband/hw/hfi1/chip.h      |    3 ++
 drivers/infiniband/hw/hfi1/driver.c    |   37 +++++++++++++++++++--------
 drivers/infiniband/hw/hfi1/init.c      |   44 +++++++++++++++++++-------------
 drivers/infiniband/hw/hfi1/pio.c       |   16 +++++++-----
 drivers/infiniband/hw/hfi1/pio.h       |   30 ++++++++++++----------
 drivers/infiniband/hw/hfi1/pio_copy.c  |   22 ++++++++--------
 drivers/infiniband/hw/hfi1/user_sdma.c |    2 +
 8 files changed, 93 insertions(+), 63 deletions(-)

--
-Denny
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
