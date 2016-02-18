From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 0/8] staging/rdma/hfi1,IB/rdmavt: Misc bug fixes
Date: Thu, 18 Feb 2016 11:11:48 -0800
Message-ID: <20160218191005.20983.64127.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

These patches fix a few issues in the hfi1 driver as well as a 0-day build error
that was caught on my public GitHub tree.

Patch series applies on the recent "checkpatch fixes" series for hfi1. It can
also be seen on GitHub at: https://github.com/ddalessa/kernel/tree/for-4.6.

---

Dean Luick (5):
      staging/rdma/hfi1: Fix xmit discard error weight
      staging/rdma/hfi1: Fix debugfs access race
      staging/rdma/hfi1: Disclose more information when i2c fails
      staging/rdma/hfi1: Guard i2c access against cp
      staging/rdma/hfi1: Fix counter read for cp

Easwar Hariharan (1):
      staging/rdma/hfi1: Cleanup comments and logs in PHY code

Mike Marciniszyn (2):
      staging/rdma/hfi1: fix 0-day syntax error
      IB/rdamvt: fix cross build with rdmavt


 drivers/infiniband/sw/rdmavt/vt.c   |    2 +
 drivers/staging/rdma/hfi1/chip.c    |   67 +++++++++++++++++------------------
 drivers/staging/rdma/hfi1/chip.h    |    6 +--
 drivers/staging/rdma/hfi1/debugfs.c |   39 +++++++++++++-------
 drivers/staging/rdma/hfi1/init.c    |    9 +++--
 drivers/staging/rdma/hfi1/qsfp.c    |   46 +++++++++++-------------
 drivers/staging/rdma/hfi1/sdma.c    |    6 ++-
 7 files changed, 91 insertions(+), 84 deletions(-)

-- 
-Denny
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
