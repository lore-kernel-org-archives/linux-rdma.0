From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: [PATCH 20/23] iwpmd: Remove syslog.target from service file
Date: Wed, 21 Sep 2016 16:08:46 -0600
Message-ID: <1474495729-17604-21-git-send-email-jgunthorpe@obsidianresearch.com>
References: <1474495729-17604-1-git-send-email-jgunthorpe@obsidianresearch.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1474495729-17604-1-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Tatyana Nikolova <Tatyana.E.Nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Debian's Lintian remarks:

W: rdma-plumbing: systemd-service-file-refers-to-obsolete-target lib/systemd/system/iwpmd.service syslog.target

Apparently systemd stopped recommending this in version 35, socket activation
eliminates the need.

Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
---
 iwpmd/iwpmd.service | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/iwpmd/iwpmd.service b/iwpmd/iwpmd.service
index 97f6cf982889..96a3aec20fde 100644
--- a/iwpmd/iwpmd.service
+++ b/iwpmd/iwpmd.service
@@ -1,6 +1,6 @@
 [Unit]
 Description=iWarp Port Mapper
-After=syslog.target network.target
+After=network.target
 
 [Service]
 ExecStart=/usr/bin/iwpmd
-- 
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
