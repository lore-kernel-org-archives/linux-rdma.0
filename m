From: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-next 0/3] IB/core kobject cleanup
Date: Sun, 18 May 2014 11:12:23 +0300
Message-ID: <1400400746-9030-1-git-send-email-haggaie@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi,

These patches clean up the kobject destruction code in IB/core, and fix a
memory leak.

Best regards,
Haggai

Haggai Eran (3):
  IB/core: remove unneeded kobject_get/put calls
  IB/core: fix port kobject deletion during error flow
  IB/core: fix kobject leak on device register error flow

 drivers/infiniband/core/sysfs.c | 85 ++++++++++++++++++++++-------------------
 1 file changed, 45 insertions(+), 40 deletions(-)

-- 
1.7.11.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
