From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v2 0/3] IB/hfi1: Read platform configuration file from EPROM
Date: Fri, 30 Sep 2016 04:41:29 -0700
Message-ID: <20160930114009.12716.95241.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Easwar Hariharan <easwar.hariharan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Doug,

This series adds the capability to read configuration information used to init
the link from the EPROM.

It partially undoes some of the work that was removed when we removed the
user access. This is not done though in support of user access. This is only so
the driver can read the EPROM. All user access is still only through resource0.

Series applies on previously submitted patches and should apply cleanly to your
for-4.9 branch. Can also be seen in GitHub at:
https://github.com/ddalessa/kernel/tree/for-4.9

Changes from v1:
Squash the first two patches per Jason's request

---

Dean Luick (3):
      IB/hfi1: Restore EPROM read ability
      IB/hfi1: Add ability to read platform config from the EPROM
      IB/hfi1: Use EPROM platform configuration read


 drivers/infiniband/hw/hfi1/chip.c     |    9 +-
 drivers/infiniband/hw/hfi1/eprom.c    |  185 +++++++++++++++++++++++++++++++++
 drivers/infiniband/hw/hfi1/eprom.h    |    4 -
 drivers/infiniband/hw/hfi1/file_ops.c |    1 
 drivers/infiniband/hw/hfi1/platform.c |   32 ++++--
 5 files changed, 213 insertions(+), 18 deletions(-)

--
-Denny
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
