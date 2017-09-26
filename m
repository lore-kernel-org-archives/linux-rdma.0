From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH for-next 00/12] IB/hfi1,qib: Driver updates 9/26/2017
Date: Tue, 26 Sep 2017 06:59:57 -0700
Message-ID: <20170926135843.15601.95865.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jan Sokolowski <jan.sokolowski-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jakub Byczkowski <jakub.byczkowski-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Michael J. Ruhl" <michael.j.ruhl-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Harish Chegondi <harish.chegondi-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Don Hiatt <don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Sebastian Sanchez <sebastian.sanchez-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Doug,

This is the first of our new content for 4.15. There are some cleanups and
general code improvements here. This includes two patches, one for each driver
that were askied for by Christoph.

Patches can can also be found in my GitHub repo at:
https://github.com/ddalessa/kernel/tree/for-4.15

---

Harish Chegondi (2):
      IB/hfi1: Convert the macro AHG_HEADER_SET into an inline function
      IB/hfi1: Remove the debug trace message in pin_sdma_pages()

Ira Weiny (2):
      IB/hfi1: Set default_desc1 just one time
      IB/hfi1: Remove unused link_default variable

Jakub Byczkowski (1):
      IB/hfi1: Add new state complete decodes for LNI failures

Jan Sokolowski (2):
      IB/hfi1: Remove unnecessary error messages on alloc failures
      IB/hfi1: Remove unused hfi1_cpulist variables

Michael J. Ruhl (4):
      IB/qib: Update QIB to use the latest PCI API
      IB/hfi1: Update HFI to use the latest PCI API
      IB/hfi1: Inline common calculation
      IB/hfi1: Add a safe wrapper for _rcd_get_by_index

Mike Marciniszyn (1):
      IB/hfi1: Extend input hdr tracing for packet type


 drivers/infiniband/hw/hfi1/chip.c         |   70 +++++--------
 drivers/infiniband/hw/hfi1/debugfs.c      |    4 -
 drivers/infiniband/hw/hfi1/driver.c       |    4 -
 drivers/infiniband/hw/hfi1/file_ops.c     |   21 +---
 drivers/infiniband/hw/hfi1/hfi.h          |   18 ++-
 drivers/infiniband/hw/hfi1/init.c         |   43 ++++----
 drivers/infiniband/hw/hfi1/sdma.c         |   14 +--
 drivers/infiniband/hw/hfi1/trace.c        |   23 ++--
 drivers/infiniband/hw/hfi1/trace.h        |   10 ++
 drivers/infiniband/hw/hfi1/trace_ibhdrs.h |   44 ++++----
 drivers/infiniband/hw/hfi1/trace_rx.h     |   11 --
 drivers/infiniband/hw/hfi1/user_exp_rcv.c |    6 -
 drivers/infiniband/hw/hfi1/user_sdma.c    |   62 +++++++----
 drivers/infiniband/hw/hfi1/user_sdma.h    |   29 ++++-
 drivers/infiniband/hw/qib/qib.h           |    8 -
 drivers/infiniband/hw/qib/qib_7220.h      |    1 
 drivers/infiniband/hw/qib/qib_iba6120.c   |   35 ++----
 drivers/infiniband/hw/qib/qib_iba7220.c   |   52 +++-------
 drivers/infiniband/hw/qib/qib_iba7322.c   |  158 +++++++++++------------------
 drivers/infiniband/hw/qib/qib_pcie.c      |  125 ++++++-----------------
 20 files changed, 305 insertions(+), 433 deletions(-)

--
-Denny
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
