From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 0/5] IB/hfi1: Fix link and other issues
Date: Thu, 14 Apr 2016 08:31:23 -0700
Message-ID: <20160414152929.3322.38247.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

These patches fix some link issues as well as two other minor issues. These
are being submitted for 4.7 and apply on top of the previous: "First round of
fixes for 4.7".

Patches can also be viewed on GitHub at:
https://github.com/ddalessa/kernel/tree/for-4.7

---

Dean Luick (4):
      IB/hfi1: Ignore link downgrade with 0 lanes
      IB/hfi1: Use the neighbor link down reason only when valid
      IB/hfi1: Correctly report neighbor link down reason
      IB/hfi1: Fix MAD port poll for active cables

Jubin John (1):
      IB/hfi1: Serialize hrtimer function calls


 drivers/staging/rdma/hfi1/chip.c |  162 ++++++++++++++++++++++++++++++++------
 drivers/staging/rdma/hfi1/chip.h |    6 +
 drivers/staging/rdma/hfi1/init.c |   20 ++---
 drivers/staging/rdma/hfi1/mad.c  |   16 ++++
 drivers/staging/rdma/hfi1/rc.c   |    7 +-
 5 files changed, 171 insertions(+), 40 deletions(-)

-- 
-Denny
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
