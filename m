From: Upinder Malhi <umalhi-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH for-next 0/2] Fix kbuild robot warnings and errs
Date: Wed, 15 Jan 2014 17:02:19 -0800
Message-ID: <1389834141-16587-1-git-send-email-umalhi@cisco.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: Upinder Malhi <umalhi-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This patchset fixes the following kbuild robot warnings and errs:
https://lists.01.org/pipermail/kbuild-all/2014-January/002670.html
https://lists.01.org/pipermail/kbuild-all/2014-January/002672.html
https://lists.01.org/pipermail/kbuild-all/2014-January/002678.html

Upinder Malhi (2):
  IB/usnic: Fix endianness related warnings
  IB/usnic: Add dependency on CONFIG_INET

 drivers/infiniband/hw/usnic/Kconfig             | 2 +-
 drivers/infiniband/hw/usnic/usnic_common_util.h | 2 +-
 drivers/infiniband/hw/usnic/usnic_transport.c   | 3 +--
 3 files changed, 3 insertions(+), 4 deletions(-)

--
1.8.2.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
