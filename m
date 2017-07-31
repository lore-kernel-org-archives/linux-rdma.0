From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: [PATCH rdma-core 4/6] ibacm: Do not fork under systemd
Date: Mon, 31 Jul 2017 14:25:43 -0600
Message-ID: <1501532745-28378-5-git-send-email-jgunthorpe@obsidianresearch.com>
References: <1501532745-28378-1-git-send-email-jgunthorpe@obsidianresearch.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1501532745-28378-1-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This avoids daemonizing the server and forking as systemd does
all of that for us. The notable benefit is to allow stderr to
be routed to the journal in case there is any sort of internal
fault (eg a glibc memory failure)

Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
---
 ibacm/ibacm.service.in | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/ibacm/ibacm.service.in b/ibacm/ibacm.service.in
index fae768faef560b..7d589b57f59e00 100644
--- a/ibacm/ibacm.service.in
+++ b/ibacm/ibacm.service.in
@@ -4,8 +4,7 @@ Documentation=man:ibacm file:@CMAKE_INSTALL_SYSCONFDIR@/rdma/ibacm_opts.cfg
 After=opensm.service
 
 [Service]
-Type=forking
-ExecStart=@CMAKE_INSTALL_FULL_SBINDIR@/ibacm
+ExecStart=@CMAKE_INSTALL_FULL_SBINDIR@/ibacm -P
 
 [Install]
 WantedBy=network.target
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
