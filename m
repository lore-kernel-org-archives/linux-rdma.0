From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: [PATCH rdma-core 4/4] ibacm: Use sd_notify to synchronize bootup
Date: Thu,  3 Aug 2017 16:04:06 -0600
Message-ID: <1501797846-8228-5-git-send-email-jgunthorpe@obsidianresearch.com>
References: <1501797846-8228-1-git-send-email-jgunthorpe@obsidianresearch.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1501797846-8228-1-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Tell systemd that ibacm is ready once the RDMA_NL_GROUP_LS socket is
opened. This is the point where ibacm is able to respond to kernel and
user queries for paths.

Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
---
 ibacm/ibacm.service.in | 1 +
 ibacm/src/acm.c        | 3 +++
 2 files changed, 4 insertions(+)

diff --git a/ibacm/ibacm.service.in b/ibacm/ibacm.service.in
index 7f31ba673da979..88fb751c7f0d76 100644
--- a/ibacm/ibacm.service.in
+++ b/ibacm/ibacm.service.in
@@ -5,6 +5,7 @@ After=opensm.service
 Wants=ibacm.socket
 
 [Service]
+Type=notify
 ExecStart=@CMAKE_INSTALL_FULL_SBINDIR@/ibacm --systemd
 
 [Install]
diff --git a/ibacm/src/acm.c b/ibacm/src/acm.c
index 3f28f04d8777b9..aba0deaa6de37f 100644
--- a/ibacm/src/acm.c
+++ b/ibacm/src/acm.c
@@ -1721,6 +1721,9 @@ static void acm_server(bool systemd)
 	if (ret)
 		acm_log(1, "Warn - Netlink init failed\n");
 
+	if (systemd)
+		sd_notify(0, "READY=1");
+
 	while (1) {
 		n = (int) listen_socket;
 		FD_ZERO(&readfds);
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
