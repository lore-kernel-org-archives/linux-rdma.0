From: Mike Marciniszyn <mike.marciniszyn-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 0/2] ipath/qib deadlock
Date: Fri, 04 Oct 2013 09:29:01 -0400
Message-ID: <20131004132821.29162.46169.stgit@phlsvslse11.ph.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

These two patches fix flaws that have been
observed in the wild with qib.

The issue has also been code inspected by
Jan Kara in his get_user_pages_unlocked()
patch series.

By using get_user_pages_fast() the dependency
on Jan's patch set has been removed. I can't
find any issue with losing the force in these
use cases.

Jan Kara (2):
      IB/ipath: Convert ipath_user_sdma_pin_pages() to use get_user_pages_fast()
      IB/qib: Convert qib_user_sdma_pin_pages() to use get_user_pages_fast()


 drivers/infiniband/hw/ipath/ipath_user_sdma.c |    7 +------
 drivers/infiniband/hw/qib/qib_user_sdma.c     |    6 +-----
 2 files changed, 2 insertions(+), 11 deletions(-)

-- 
Mike
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
