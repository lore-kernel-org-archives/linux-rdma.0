From: Tatyana Nikolova <Tatyana.E.Nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH for-next 0/2] Export tos field to iwarp providers
Date: Mon, 18 May 2015 15:24:53 -0500
Message-ID: <20150518202453.GA17572@TENIKOLO-MOBL2>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: john.s.lacombe-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Subject: [PATCH 0/2] Enable iwarp providers to use the tos field

The first patch "RDMA/iw_cm: Export tos field to iwarp providers" is
resubmitted, following the original submission from Steve Wise.
The patch was deferred until the tos field is being used by iwarp drivers.
You could see the email thread about the original patch here:
http://www.mail-archive.com/linux-rdma%40vger.kernel.org/msg20140.html

The second patch "RDMA/nes: Enable the use of the tos field in the nes driver"
is introducing changes to the nes driver to use the provided tos field.

Tatyana Nikolova (2):
  RDMA/iw_cm: Export tos field to iwarp providers
  RDMA/nes: Enable the use of the tos field in the nes driver

 drivers/infiniband/core/cma.c      |    2 ++
 drivers/infiniband/hw/nes/nes_cm.c |    7 +++++++
 drivers/infiniband/hw/nes/nes_cm.h |    2 ++
 include/rdma/iw_cm.h               |    1 +
 4 files changed, 12 insertions(+), 0 deletions(-)

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
