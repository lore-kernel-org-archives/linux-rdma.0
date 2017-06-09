From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH for-next 00/10] IB/hfi1,qib: patches for next 06/09/2017
Date: Fri, 09 Jun 2017 15:59:19 -0700
Message-ID: <20170609225424.26710.70167.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jan Sokolowski <jan.sokolowski-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jakub Byczkowski <jakub.byczkowski-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mitko Haralanov <mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ashutosh Dixit <ashutosh.dixit-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Michael J. Ruhl" <michael.j.ruhl-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Bartlomiej Dudek <bartlomiej.dudek-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Sebastian Sanchez <sebastian.sanchez-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Doug,

Here is the next set of patches for 4.13. Some bug fixes including a panic
fix. There is also some cleanup of tracing and error messages. Some needed
consolidation of some of the verbs/psm code is included as well.

We also replace our usage of the deprecated PCI functions in favor of the
new API.

Patches can can also be found in my GitHub repo at:
https://github.com/ddalessa/kernel/tree/for-4.13

---

Bartlomiej Dudek (1):
      IB/hfi1: Fix DC 8051 host info flag array

Jan Sokolowski (3):
      IB/hfi1: Set proper logging levels on QSFP cable error events
      IB/hfi1: Remove reading platform configuration from EFI variable
      IB/hfi1: Handle missing magic values in config file

Michael J. Ruhl (3):
      IB/qib: Replace deprecated pci functions with new API
      IB/hfi1: Initialize TID lists to avoid crash on cleanup
      IB/hfi1: Resolve kernel panics by reference counting receive contexts

Mike Marciniszyn (3):
      IB/hfi1: Create common expected receive verbs/PSM code
      IB/hfi1: Use a template for tid reg/unreg
      IB/hfi1: Add traces for TID operations


 drivers/infiniband/hw/hfi1/Makefile       |    2 
 drivers/infiniband/hw/hfi1/chip.c         |   85 ++++++-------
 drivers/infiniband/hw/hfi1/eprom.c        |   11 +-
 drivers/infiniband/hw/hfi1/exp_rcv.c      |  114 ++++++++++++++++++
 drivers/infiniband/hw/hfi1/exp_rcv.h      |  187 +++++++++++++++++++++++++++++
 drivers/infiniband/hw/hfi1/file_ops.c     |   43 ++++---
 drivers/infiniband/hw/hfi1/hfi.h          |   11 +-
 drivers/infiniband/hw/hfi1/init.c         |   62 ++++++++--
 drivers/infiniband/hw/hfi1/platform.c     |   10 --
 drivers/infiniband/hw/hfi1/trace_misc.h   |   20 +++
 drivers/infiniband/hw/hfi1/trace_rx.h     |   81 +++++++------
 drivers/infiniband/hw/hfi1/user_exp_rcv.c |  121 -------------------
 drivers/infiniband/hw/hfi1/user_exp_rcv.h |   23 ----
 drivers/infiniband/hw/hfi1/user_sdma.c    |   38 ------
 drivers/infiniband/hw/hfi1/vnic_main.c    |   11 +-
 drivers/infiniband/hw/qib/qib.h           |    8 +
 drivers/infiniband/hw/qib/qib_iba6120.c   |    6 -
 drivers/infiniband/hw/qib/qib_iba7220.c   |    7 +
 drivers/infiniband/hw/qib/qib_iba7322.c   |   48 ++++---
 drivers/infiniband/hw/qib/qib_pcie.c      |  149 +++++++++--------------
 20 files changed, 602 insertions(+), 435 deletions(-)
 create mode 100644 drivers/infiniband/hw/hfi1/exp_rcv.c
 create mode 100644 drivers/infiniband/hw/hfi1/exp_rcv.h

--
-Denny
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
