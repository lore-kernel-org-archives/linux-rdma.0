From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: [PATCH 05/23] ipathverbs: Recognize bashisms in truescale-serdes.cmds
Date: Wed, 21 Sep 2016 16:08:31 -0600
Message-ID: <1474495729-17604-6-git-send-email-jgunthorpe@obsidianresearch.com>
References: <1474495729-17604-1-git-send-email-jgunthorpe@obsidianresearch.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1474495729-17604-1-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "open list:IPATH/QIB USERSPACE PROVIDER for
        ib_qib.ko" <ibsupport-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Debian's Lintian remarks:

E: rdma-plumbing: shell-script-fails-syntax-check usr/lib/truescale-serdes.cmds

And indeed:

$ sh -n providers/ipathverbs/truescale-serdes.cmds
providers/ipathverbs/truescale-serdes.cmds: 100: providers/ipathverbs/truescale-serdes.cmds: Syntax error: "(" unexpected (expecting "}")

This is a bashism, change the script to require bash.

Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
---
 libipathverbs/truescale-serdes.cmds | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/libipathverbs/truescale-serdes.cmds b/libipathverbs/truescale-serdes.cmds
index 345813dbfef5..0f8933765efe 100755
--- a/libipathverbs/truescale-serdes.cmds
+++ b/libipathverbs/truescale-serdes.cmds
@@ -1,4 +1,4 @@
-#!/bin/sh
+#!/bin/bash
 # Copyright (c) 2013 Intel Corporation. All rights reserved.
 # Copyright (c) 2010 QLogic Corporation.
 # All rights reserved.
-- 
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
