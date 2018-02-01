From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH for-next 0/3] IB/hfi1: Fix race conditions and memory leaks
Date: Thu, 01 Feb 2018 10:43:32 -0800
Message-ID: <20180201184229.5205.6194.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: jgg-uk2M96/98Pc@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Michael J. Ruhl" <michael.j.ruhl-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Patel Jay P <jay.p.patel-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Alex Estrin <alex.estrin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Jason and Doug,

Here are some fixes for race conditions and memory leaks including the fix for
the interrupt race [1].

This is a resubmit of my previous patch set [2] broken up into smaller logically
grouped patch sets.

As always my GitHub had these in-tree for context:
https://github.com/ddalessa/kernel/tree/for-4.16

[1] https://marc.info/?l=linux-rdma&m=151394843919393&w=2

[2] https://www.spinics.net/lists/linux-rdma/msg60011.html

---

Alex Estrin (2):
      IB/hfi1: Fix for early release of sdma context
      IB/hfi1: Fix for potential refcount leak in hfi1_open_file()

Michael J. Ruhl (1):
      IB/hfi1: Re-order IRQ cleanup to address driver cleanup race


 drivers/infiniband/hw/hfi1/chip.c     |   18 ++++++++++++------
 drivers/infiniband/hw/hfi1/file_ops.c |    4 +---
 drivers/infiniband/hw/hfi1/hfi.h      |    1 +
 drivers/infiniband/hw/hfi1/init.c     |    5 ++++-
 drivers/infiniband/hw/hfi1/sdma.c     |   13 +++++++------
 drivers/infiniband/hw/hfi1/sdma.h     |    1 +
 6 files changed, 26 insertions(+), 16 deletions(-)

--
-Denny
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
