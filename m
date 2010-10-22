From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: [PATCH] [libipathverbs] Fix 32 bit libipathverbs
Date: Fri, 22 Oct 2010 16:43:43 -0600
Message-ID: <20101022224343.GA3573@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ralph Campbell <ralph.campbell-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>, RDMA list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Trying to use a 64 bit kernel with a 32 bit userspace results in
local protection violations reported to the CQ. This is caused by
a difference in padding for ipath_rwe, so make the padding 64 bit
uses explicit.

Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
---
 src/ipathverbs.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/src/ipathverbs.h b/src/ipathverbs.h
index 5ebd79d..e824fd6 100644
--- a/src/ipathverbs.h
+++ b/src/ipathverbs.h
@@ -101,6 +101,7 @@ struct ipath_cq {
 struct ipath_rwqe {
 	uint64_t		wr_id;
 	uint8_t			num_sge;
+	uint8_t                 padding[7];
 	struct ibv_sge		sg_list[0];
 };
 
-- 
1.5.4.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
