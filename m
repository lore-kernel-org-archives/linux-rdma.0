From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH for-next 00/11] IB/hfi1, rdmavt,
 qib: Driver updates for 12/18/2017
Date: Mon, 18 Dec 2017 19:56:07 -0800
Message-ID: <20171219034753.2126.78386.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: jgg-uk2M96/98Pc@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Patel Jay P <jay.p.patel-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Kaike Wan <kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Michael J. Ruhl" <michael.j.ruhl-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Sebastian Sanchez <sebastian.sanchez-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Jason and Doug,

Here is another set of patches to land fdor 4.16. Just driver changes and a
small change for the MAINTIANERS file. We are getting rid of that ipath email
and ensuring Mike and I both receive direct mails for all our drivers instead.

https://github.com/ddalessa/kernel/tree/for-4.16

---

Dennis Dalessandro (2):
      IB/hfi1: Check return value of strchr before using it
      rdma: Update maintainer contact for Intel RDMA drivers

Kaike Wan (2):
      IB/rdmavt: No need to cancel RNRNAK retry timer when it is running
      IB/rdmavt: Add trace for RNRNAK timer

Michael J. Ruhl (3):
      IB/{rdmavt,hfi1,qib}: Self determine driver name
      IB/{rdmavt,hfi1,qib}: Remove get_card_name() downcall
      IB/{hfi1,qib}: Fix a concurrency issue with device name in logging

Mike Marciniszyn (2):
      IB/rdmavt: Use correct numa node for SRQ allocation
      IB/rdmavt: Allocate CQ memory on the correct node

Patel Jay P (1):
      IB/hfi1: Destroy link_wq workqueue after free_irq()

Sebastian Sanchez (1):
      IB/hfi1: Fix infinite loop in 8051 command error path


 MAINTAINERS                             |    4 +
 drivers/infiniband/hw/hfi1/chip.c       |   98 +++++++++++++------------------
 drivers/infiniband/hw/hfi1/chip.h       |    2 -
 drivers/infiniband/hw/hfi1/driver.c     |   16 -----
 drivers/infiniband/hw/hfi1/firmware.c   |   64 +++++---------------
 drivers/infiniband/hw/hfi1/hfi.h        |   27 +++++----
 drivers/infiniband/hw/hfi1/init.c       |   33 ++++++++--
 drivers/infiniband/hw/hfi1/verbs.c      |   10 ++-
 drivers/infiniband/hw/qib/qib.h         |    8 +--
 drivers/infiniband/hw/qib/qib_driver.c  |   16 -----
 drivers/infiniband/hw/qib/qib_eeprom.c  |    3 -
 drivers/infiniband/hw/qib/qib_init.c    |    2 +
 drivers/infiniband/hw/qib/qib_verbs.c   |    2 -
 drivers/infiniband/sw/rdmavt/cq.c       |   10 ++-
 drivers/infiniband/sw/rdmavt/qp.c       |    9 +--
 drivers/infiniband/sw/rdmavt/srq.c      |   16 +++--
 drivers/infiniband/sw/rdmavt/trace.h    |    4 +
 drivers/infiniband/sw/rdmavt/trace_qp.h |   42 +++++++++++++
 drivers/infiniband/sw/rdmavt/vt.c       |    1 
 drivers/infiniband/sw/rdmavt/vt.h       |    6 +-
 include/rdma/rdma_vt.h                  |   31 ++++++++--
 21 files changed, 204 insertions(+), 200 deletions(-)

--
-Denny
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
