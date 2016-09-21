From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: [PATCH 16/23] ibcm: Move documentation to Documentation/
Date: Wed, 21 Sep 2016 16:08:42 -0600
Message-ID: <1474495729-17604-17-git-send-email-jgunthorpe@obsidianresearch.com>
References: <1474495729-17604-1-git-send-email-jgunthorpe@obsidianresearch.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1474495729-17604-1-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>

And drop bits that are outdated or replaced by top-level Documentation.

Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
---
 libibcm/README => Documentation/libibcm.md | 14 +-------------
 1 file changed, 1 insertion(+), 13 deletions(-)
 rename libibcm/README => Documentation/libibcm.md (54%)

diff --git a/libibcm/README b/Documentation/libibcm.md
similarity index 54%
rename from libibcm/README
rename to Documentation/libibcm.md
index 4dda13c185eb..663e7736d2f1 100644
--- a/libibcm/README
+++ b/Documentation/libibcm.md
@@ -1,16 +1,4 @@
-This README is for userspace cm library.
-
-Building
-
-To make this directory, run:
-./autogen.sh && ./configure && make && make install
-
-Typically the autogen and configure steps only need be done the first
-time unless configure.in or Makefile.am changes.
-
-Libraries are installed by default at /usr/local/lib.
-
-Device files
+# Device files
 
 The userspace CM uses a device file per adapter present.
 
-- 
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
