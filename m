From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 0/2] Series short description
Date: Thu, 20 Feb 2014 11:02:42 -0500
Message-ID: <20140220160126.18021.69712.stgit@phlsvslse11.ph.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi Roalnd,

Please apply the following patch series. It fixes buffer overruns in sending
diag packets for the qib and ipath drivers.

This applies on top of commit 38dbfb59d

---

Dennis Dalessandro (2):
      IB/qib: Fix potential buffer overrun in sending diag packet routine.
      IB/ipath: Fix potential buffer overrun in sending diag packet routine.


 drivers/infiniband/hw/ipath/ipath_diag.c |   66 +++++++++++-------------------
 drivers/infiniband/hw/qib/qib_diag.c     |   27 +++++++-----
 2 files changed, 41 insertions(+), 52 deletions(-)

-- 
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
