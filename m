From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: [PATCH rdma-core 0/5] Small fixes for verbs
Date: Thu, 31 Aug 2017 14:50:54 -0600
Message-ID: <1504212659-9674-1-git-send-email-jgunthorpe@obsidianresearch.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is a precursor to a larger series reworking how the providers
are loaded.

The big item is switching verbs fully to use ccan lists and using the new
ccan functions to rework how the sysfs list is merged into the device list.

Jason Gunthorpe (5):
  verbs: Remove diagnostic ignored "-Wmissing-prototypes"
  util: Fix check_snprintf to use __rc__ for local
  verbs: Use ccan list.h instead of open coding lists
  verbs: Tidy up ibverbs_get_device_list
  ocrdma: Remove ocrdma_dev_list

 libibverbs/init.c              | 145 ++++++++++++++++++++---------------------
 providers/ocrdma/ocrdma_main.c |   7 --
 providers/ocrdma/ocrdma_main.h |   1 -
 util/util.h                    |   4 +-
 4 files changed, 73 insertions(+), 84 deletions(-)

-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
