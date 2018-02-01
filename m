From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH for-next 0/4] IB/hfi1: Minor and misc bug fixes
Date: Thu, 01 Feb 2018 10:52:11 -0800
Message-ID: <20180201184921.7300.11118.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: jgg-uk2M96/98Pc@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Bartlomiej Dudek <bartlomiej.dudek-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mitko Haralanov <mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Patel Jay P <jay.p.patel-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Michael J. Ruhl" <michael.j.ruhl-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Don Hiatt <don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Kamenee Arumugam <kamenee.arumugam-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Jason and Doug,

Here are some fixes for minor issues. Minor in terms of severity, not
necessarily in terms of complexity. The diffstat for mad.c in particular looks
pretty bad but it's basically changing the units being used from cycle time to
flit time.

This is a resubmit of my previous patch set [1] broken up into smaller logically
grouped patch sets.

As always my GitHub had these in-tree for context:
https://github.com/ddalessa/kernel/tree/for-4.16

[1] https://www.spinics.net/lists/linux-rdma/msg60011.html

---

Bartlomiej Dudek (1):
      IB/hfi1: Do not override given pcie_pset value

Kamenee Arumugam (1):
      IB/hfi1: Convert PortXmitWait/PortVLXmitWait counters to flit times

Mike Marciniszyn (1):
      IB/hfi1: Remove blind constants from 16B update

Mitko Haralanov (1):
      IB/hfi1: Show fault stats in both TX and RX directions


 drivers/infiniband/hw/hfi1/chip.c    |   64 ++++++++++++++++-
 drivers/infiniband/hw/hfi1/chip.h    |    4 +
 drivers/infiniband/hw/hfi1/debugfs.c |    9 ++
 drivers/infiniband/hw/hfi1/driver.c  |    6 +-
 drivers/infiniband/hw/hfi1/hfi.h     |    7 ++
 drivers/infiniband/hw/hfi1/init.c    |    9 ++
 drivers/infiniband/hw/hfi1/mad.c     |  127 +++++++++++++++++++++++++++++++---
 drivers/infiniband/hw/hfi1/mad.h     |   47 ++++++++++++-
 drivers/infiniband/hw/hfi1/pcie.c    |   23 +++---
 drivers/infiniband/hw/hfi1/ruc.c     |   13 ++-
 drivers/infiniband/hw/hfi1/ud.c      |   15 +++-
 drivers/infiniband/hw/hfi1/verbs.h   |    5 +
 12 files changed, 284 insertions(+), 45 deletions(-)

--
-Denny
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
