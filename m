From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: [PATCH rdma-core 5/6] ibacm: Adjust systemd service Description
Date: Mon, 31 Jul 2017 14:25:44 -0600
Message-ID: <1501532745-28378-6-git-send-email-jgunthorpe@obsidianresearch.com>
References: <1501532745-28378-1-git-send-email-jgunthorpe@obsidianresearch.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1501532745-28378-1-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This looks odd:

 Jul 28 18:06:05 ib9 systemd[1]: Started Starts the InfiniBand Address Cache Manager daemon.

Drop the 'Starts'

Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
---
 ibacm/ibacm.service.in | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/ibacm/ibacm.service.in b/ibacm/ibacm.service.in
index 7d589b57f59e00..eb74c673552cb4 100644
--- a/ibacm/ibacm.service.in
+++ b/ibacm/ibacm.service.in
@@ -1,5 +1,5 @@
 [Unit]
-Description=Starts the InfiniBand Address Cache Manager daemon
+Description=InfiniBand Address Cache Manager Daemon
 Documentation=man:ibacm file:@CMAKE_INSTALL_SYSCONFDIR@/rdma/ibacm_opts.cfg
 After=opensm.service
 
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
