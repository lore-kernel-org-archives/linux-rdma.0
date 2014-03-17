From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] Fix memory leak of recv context array during failed init
Date: Mon, 17 Mar 2014 14:07:10 -0400
Message-ID: <20140317180457.25881.47937.stgit@phlsvslse11.ph.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi Roland,

The following patch fixes a small memory leak during a failed init. It is based
on change 2dea9094.


---

Dennis Dalessandro (1):
      IB/qib: Fix memory leak of recv context when driver fails to initialize.


 drivers/infiniband/hw/qib/qib_init.c |   13 +++++--------
 1 files changed, 5 insertions(+), 8 deletions(-)

-- 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
