From: Mike Marciniszyn <mike.marciniszyn-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 0/2] serdes interoperabilty fixes
Date: Wed, 19 Oct 2011 18:46:32 -0400
Message-ID: <20111019224632.24717.17782.stgit@kop-dev-sles11-04.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

The following series implements serdes fixes
for interoperabilty.

---

Mitko Haralanov (2):
      IB/qib: Hold links until tuning data is available
      IB/qib: Fix issue with link states and QSFP cables


 drivers/infiniband/hw/qib/qib_iba7322.c |  128 +++++++++++++++++++++----------
 drivers/infiniband/hw/qib/qib_init.c    |    4 -
 drivers/infiniband/hw/qib/qib_qsfp.c    |   25 ++++--
 drivers/infiniband/hw/qib/qib_qsfp.h    |    3 +
 4 files changed, 103 insertions(+), 57 deletions(-)

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
