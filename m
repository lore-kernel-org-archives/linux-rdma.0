From: Tom Tucker <tom-/Yg/VP3ZvrM@public.gmane.org>
Subject: [RFC PATCH 0/2] IB/uverbs: Add support for registering mmapped memory
Date: Thu, 02 Dec 2010 13:02:19 -0600
Message-ID: <20101202190157.13657.58176.stgit@build.ogc.int>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: tom-/Yg/VP3ZvrM@public.gmane.org, garlick-i2BcT+NCU+M@public.gmane.org, acook-osxm6dDZNBBZx8iatJs59jGjJy/sRE9J@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This patch series adds the ability for a user-mode program to register
mmapped memory.  The capability was developed to support the sharing of
device memory, for example PCI-E static/flash ram devices, on the network
with RDMA.  It is also useful for sharing kernel resident data with distributed
system monitoring applications (e.g. vmstats) at zero overhead to the
monitored host.

---

Tom Tucker (2):
      IB/uverbs: Add support for user registration of mmap memory
      IB/uverbs: Add memory type to ib_umem structure


 drivers/infiniband/core/umem.c |  272 +++++++++++++++++++++++++++++++++++++---
 include/rdma/ib_umem.h         |    6 +
 2 files changed, 259 insertions(+), 19 deletions(-)

-- 
Signed-off-by: Tom Tucker <tom-/Yg/VP3ZvrM@public.gmane.org>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
