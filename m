From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: [PATCH 01/16] Fix bogus executable file permissions
Date: Tue, 20 Sep 2016 16:10:10 -0600
Message-ID: <1474409425-15769-2-git-send-email-jgunthorpe@obsidianresearch.com>
References: <1474409425-15769-1-git-send-email-jgunthorpe@obsidianresearch.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1474409425-15769-1-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

- cm.c is a source file and should not be executable
- truescale-serdes.cmds is a script and should be executable

Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
---
 libibcm/src/cm.c                    | 0
 libipathverbs/truescale-serdes.cmds | 0
 2 files changed, 0 insertions(+), 0 deletions(-)
 mode change 100755 => 100644 libibcm/src/cm.c
 mode change 100644 => 100755 libipathverbs/truescale-serdes.cmds

diff --git a/libibcm/src/cm.c b/libibcm/src/cm.c
old mode 100755
new mode 100644
diff --git a/libipathverbs/truescale-serdes.cmds b/libipathverbs/truescale-serdes.cmds
old mode 100644
new mode 100755
-- 
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
