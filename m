From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH rdma-rc 0/2] Add mechanism for ipoib neigh state change notifications
Date: Thu, 17 Sep 2015 13:38:01 +0300
Message-ID: <1442486283-9699-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Patches from Erez, to be used for cleaning up send-only objects and multicast 
group SM registrations.

Or.

Erez Shitrit (2):
  IB/ipoib: Add mechanism for ipoib neigh state change notifications
  IB/ipoib: Add cleanup to sendonly multicast objects

 drivers/infiniband/ulp/ipoib/ipoib.h           | 17 +++++
 drivers/infiniband/ulp/ipoib/ipoib_main.c      |  4 ++
 drivers/infiniband/ulp/ipoib/ipoib_multicast.c | 87 ++++++++++++++++++++++++++
 3 files changed, 108 insertions(+)

-- 
2.3.7

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
