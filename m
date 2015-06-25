From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: [PATCH RFC 0/2] iSER support for iWARP
Date: Thu, 25 Jun 2015 10:39:12 -0500
Message-ID: <20150625153754.13272.432.stgit@build.ogc.int>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, orgerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, raid-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

The following series implements support for iWARP transpors
in the iSER initiator and target.  This is based on 
Doug's k.o/for-4.2 branch.

---

Steve Wise (2):
      RDMA/iser: limit sg tablesize on device fastreg max depth
      RDMA/isert: Support iWARP transport


 drivers/infiniband/ulp/iser/iscsi_iser.c |    7 ++++
 drivers/infiniband/ulp/isert/ib_isert.c  |   55 ++++++++++++++++++++++++++----
 drivers/infiniband/ulp/isert/ib_isert.h  |    1 +
 3 files changed, 55 insertions(+), 8 deletions(-)

--
Steve
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
