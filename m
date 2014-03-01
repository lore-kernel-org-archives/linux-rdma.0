From: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 0/2] qib percpu counters
Date: Sat, 01 Mar 2014 10:29:36 -0500
Message-ID: <20140301152917.23347.64976.stgit@phlsvslse11.ph.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

The following series implements percpu counters
for high frequency counts.

---

Mike Marciniszyn (2):
      IB/qib: Add percpu counter replacing qib_devdata int_counter
      IB/qib: Modify software pma counters to use percpu variables


 drivers/infiniband/hw/qib/qib.h         |   12 ++++-
 drivers/infiniband/hw/qib/qib_fs.c      |    1 
 drivers/infiniband/hw/qib/qib_iba6120.c |   11 +++--
 drivers/infiniband/hw/qib/qib_iba7220.c |   12 +++--
 drivers/infiniband/hw/qib/qib_iba7322.c |   37 ++++++-----------
 drivers/infiniband/hw/qib/qib_init.c    |   68 ++++++++++++++++++++++++++-----
 drivers/infiniband/hw/qib/qib_mad.c     |   44 ++++++++++++++++----
 drivers/infiniband/hw/qib/qib_rc.c      |    2 -
 drivers/infiniband/hw/qib/qib_ruc.c     |    1 
 drivers/infiniband/hw/qib/qib_ud.c      |    6 +--
 drivers/infiniband/hw/qib/qib_verbs.c   |    4 +-
 drivers/infiniband/hw/qib/qib_verbs.h   |   16 +++++--
 12 files changed, 149 insertions(+), 65 deletions(-)

-- 
Mike
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
