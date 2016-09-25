From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 0/5] IB/hfi1: sdma engine affinity improvements
Date: Sun, 25 Sep 2016 07:44:15 -0700
Message-ID: <20160925144248.12088.71489.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Sebastian Sanchez <sebastian.sanchez-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jianxin Xiong <jianxin.xiong-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Tadeusz Struk <tadeusz.struk-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This patch series is a set of performance improvements that deal with handling
the affinity of sdma engines. This allows users more control over which CPU
cores are used by the driver for sdma engines. It includes a way to dump out the
current values and a handler for when the user changes irq affinity. The changes
to sysfs are also documented.

This applies on top of the last series submitted and can be seen in my GitHub:
https://github.com/ddalessa/kernel/tree/for-4.9

---

Tadeusz Struk (5):
      IB/hfi1: Add sysfs interface for affinity setup
      IB/hfi1: Add a new VL sysfs attribute for sdma engines
      IB/hfi1: Add irq affinity notification handler
      IB/hfi1: Add new debugfs sdma_cpu_list file
      IB/hfi1: Document new sysfs entries for hfi1 driver


 Documentation/infiniband/sysfs.txt     |   30 +++
 drivers/infiniband/hw/hfi1/affinity.c  |  112 +++++++++-
 drivers/infiniband/hw/hfi1/debugfs.c   |   38 +++
 drivers/infiniband/hw/hfi1/hfi.h       |    3 
 drivers/infiniband/hw/hfi1/sdma.c      |  353 ++++++++++++++++++++++++++++++++
 drivers/infiniband/hw/hfi1/sdma.h      |   10 +
 drivers/infiniband/hw/hfi1/sysfs.c     |  103 +++++++++
 drivers/infiniband/hw/hfi1/user_sdma.c |    9 -
 8 files changed, 641 insertions(+), 17 deletions(-)

--
-Denny
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
