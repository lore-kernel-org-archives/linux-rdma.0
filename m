From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 0/5] IB/rdmavt,staging/rdma/hfi1: Misc bug fixes for hfi1
Date: Tue, 09 Feb 2016 14:29:02 -0800
Message-ID: <20160209222705.7444.85189.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This series adds some more bug fixes for hfi1. It also adds a performance fix
for qp timeouts that is incorporated into rdmavt.

Series applies on the previously submitted "Dual lock pre-reqs" series and can
be seen in context at: https://github.com/ddalessa/kernel/tree/for-4.6

---

Easwar Hariharan (2):
      staging/rdma/hfi1: Fetch platform configuration data from EFI variable
      staging/rdma/hfi1: Tune for unknown channel if configuration file is absent

Mike Marciniszyn (1):
      staging/rdma/hfi1: actually use new RNR timer API in loopback path

Sebastian Sanchez (1):
      staging/rdma/hfi1: Turning off LED without checking if stepping is Ax

Vennila Megavannan (1):
      IB/rdmavt, staging/rdma/hfi1: use qps to dynamically scale timeout value


 drivers/infiniband/sw/rdmavt/qp.c    |   17 ++++
 drivers/staging/rdma/hfi1/chip.c     |    7 +-
 drivers/staging/rdma/hfi1/chip.h     |    6 +
 drivers/staging/rdma/hfi1/firmware.c |  112 ++++++++++++++++++++++---
 drivers/staging/rdma/hfi1/hfi.h      |    1 
 drivers/staging/rdma/hfi1/init.c     |    1 
 drivers/staging/rdma/hfi1/pcie.c     |    3 -
 drivers/staging/rdma/hfi1/platform.c |  151 ++++++++++++++++++++++------------
 drivers/staging/rdma/hfi1/platform.h |    9 ++
 drivers/staging/rdma/hfi1/qsfp.c     |    1 
 drivers/staging/rdma/hfi1/rc.c       |   14 ++-
 drivers/staging/rdma/hfi1/ruc.c      |    8 +-
 drivers/staging/rdma/hfi1/verbs.h    |    1 
 include/rdma/rdma_vt.h               |    4 +
 include/rdma/rdmavt_qp.h             |    2 
 15 files changed, 255 insertions(+), 82 deletions(-)

-- 
-Denny
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
