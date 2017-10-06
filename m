From: Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
Subject: [PATCH 0/7] SRP patches for kernel v4.15
Date: Fri,  6 Oct 2017 14:42:36 -0700
Message-ID: <20171006214243.11296-1-bart.vanassche@wdc.com>
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

Bart Van Assche (7):
  IB/srpt: Limit the send and receive queue sizes to what the HCA
    supports
  IB/srpt: Cache global L_Key
  IB/srpt: Change default behavior from using SRQ to not using SRQ
  IB/srp: Avoid a cable pull can trigger a kernel crash
  IB/srp: Remove second argument of srp_destroy_qp()
  IB/srp: Cache global rkey
  IB/srp: Make CM timeout dependent on subnet timeout

 drivers/infiniband/ulp/srp/ib_srp.c   |  88 ++++++++++++++-------
 drivers/infiniband/ulp/srp/ib_srp.h   |   3 +-
 drivers/infiniband/ulp/srpt/ib_srpt.c | 145 ++++++++++++++++++++++++----------
 drivers/infiniband/ulp/srpt/ib_srpt.h |   7 +-
 4 files changed, 173 insertions(+), 70 deletions(-)

-- 
2.14.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
