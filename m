From: Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
Subject: [PATCH v2 0/8] SRP patches for kernel v4.15
Date: Wed, 11 Oct 2017 10:27:21 -0700
Message-ID: <20171011172729.16984-1-bart.vanassche@wdc.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hello Doug,

This patch series includes several the SRP initiator and target patches I came
up with during the past months. The initiator patches are independent of the
target patches. Please consider these patches for kernel v4.15.

Thanks,

Bart.

Changes compared to v1:
- In patch "IB/srpt: Change default behavior from using SRQ to not using SRQ",
  changed a kernel module parameter into a configfs attribute.
- Added a "Fixes" tag to patch "IB/srp: Avoid that a cable pull can trigger a
  kernel crash".
- Added an eighth patch at the start of this patch series.
- Added Reviewed-by tags for the patches that got a positive review.

Bart Van Assche (8):
  IB/srpt: Do not accept invalid initiator port names
  IB/srpt: Limit the send and receive queue sizes to what the HCA
    supports
  IB/srpt: Cache global L_Key
  IB/srpt: Change default behavior from using SRQ to using RC
  IB/srp: Avoid that a cable pull can trigger a kernel crash
  IB/srp: Remove second argument of srp_destroy_qp()
  IB/srp: Cache global rkey
  IB/srp: Make CM timeout dependent on subnet timeout

 drivers/infiniband/ulp/srp/ib_srp.c   |  88 +++++++++++------
 drivers/infiniband/ulp/srp/ib_srp.h   |   3 +-
 drivers/infiniband/ulp/srpt/ib_srpt.c | 176 +++++++++++++++++++++++++---------
 drivers/infiniband/ulp/srpt/ib_srpt.h |   9 +-
 4 files changed, 201 insertions(+), 75 deletions(-)

-- 
2.14.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
