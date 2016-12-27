From: Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH 0/1] ib_srp mr allocation failure
Date: Tue, 27 Dec 2016 20:49:11 +0200
Message-ID: <1482864552-27605-1-git-send-email-maxg@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, bvanassche-HInyCGIudOg@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Israel Rukshin <israelr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Israel Rukshin <israelr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Hi,

While running traffic with multiple jobs I had those errors:
scsi host8: ib_srp: Failed to map data (-12)
scsi host8: ib_srp: Failed to map data (-12)
...

The reason for the map failurs are SG gaps.
This bug happens to me only with CX4 because it supports SG gaps registration.
I fixed this issue by allocating the mr with IB_MR_TYPE_SG_GAPS.

Should it be pushed also to stable kernel code ?

Israel Rukshin (1):
  IB/srp: fix mr allocation when the device supports sg gaps

 drivers/infiniband/ulp/srp/ib_srp.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

-- 
1.8.4.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
