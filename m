From: Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
Subject: [PATCH 00/12] IB/srpt patches for kernel v4.16
Date: Mon,  8 Jan 2018 11:00:39 -0800
Message-ID: <20180108190051.32008-1-bart.vanassche@wdc.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hello Jason,

This series includes multiple small changes for the SRP target driver. Please
consider these changes for kernel v4.16.

Thanks,

Bart.

Bart Van Assche (12):
  IB/srpt: Remove an unused structure member
  IB/srpt: Fix kernel-doc warnings in ib_srpt.c
  IB/srpt: Document all structure members in ib_srpt.h
  IB/srpt: Rename a local variable, a member variable and a constant
  IB/srpt: Reduce the severity level of a log message
  IB/srpt: Verify port numbers in srpt_event_handler()
  IB/srpt: Use the IPv6 format for GIDs in log messages
  IB/srpt: Convert a warning into a debug message
  IB/srpt: Reduce frequency of receive failure messages
  IB/srpt: Introduce srpt_format_guid()
  IB/srpt: Inline srpt_get_cmd_state()
  IB/srpt: Micro-optimize I/O context state manipulation

 drivers/infiniband/ulp/srpt/ib_srpt.c | 336 ++++++++++++++++++++--------------
 drivers/infiniband/ulp/srpt/ib_srpt.h |  40 ++--
 2 files changed, 221 insertions(+), 155 deletions(-)

-- 
2.15.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
