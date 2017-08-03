From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: [PATCH rdma-core 3/4] iwpmd: Use sd_notify to synchronize bootup
Date: Thu,  3 Aug 2017 16:04:05 -0600
Message-ID: <1501797846-8228-4-git-send-email-jgunthorpe@obsidianresearch.com>
References: <1501797846-8228-1-git-send-email-jgunthorpe@obsidianresearch.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1501797846-8228-1-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Tatyana Nikolova <Tatyana.E.Nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Tell systemd that iwpmd is ready once it established all threads and
netlink sockets.

This perhaps should be pushed a little later, after the message sent
by send_iwpm_mapinfo_request is responded to by the kernel?

Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
---
 iwpmd/CMakeLists.txt    | 1 +
 iwpmd/iwarp_pm_server.c | 5 +++++
 iwpmd/iwpmd.service.in  | 1 +
 3 files changed, 7 insertions(+)

diff --git a/iwpmd/CMakeLists.txt b/iwpmd/CMakeLists.txt
index 6fd36e47bbbc54..bf538034ea5333 100644
--- a/iwpmd/CMakeLists.txt
+++ b/iwpmd/CMakeLists.txt
@@ -4,6 +4,7 @@ rdma_sbin_executable(iwpmd
   iwarp_pm_server.c
   )
 target_link_libraries(iwpmd LINK_PRIVATE
+  ${SYSTEMD_LIBRARIES}
   ${NL_LIBRARIES}
   ${CMAKE_THREAD_LIBS_INIT}
   )
diff --git a/iwpmd/iwarp_pm_server.c b/iwpmd/iwarp_pm_server.c
index 637f2344d98402..ebed6f9d28ee59 100644
--- a/iwpmd/iwarp_pm_server.c
+++ b/iwpmd/iwarp_pm_server.c
@@ -32,6 +32,7 @@
  */
 
 #include "config.h"
+#include <systemd/sd-daemon.h>
 #include <getopt.h>
 #include "iwarp_pm.h"
 
@@ -1447,6 +1448,10 @@ int main(int argc, char *argv[])
 
 	known_clients = init_iwpm_clients(&iwarp_clients[0]);
 	send_iwpm_mapinfo_request(netlink_sock, &iwarp_clients[0], known_clients);
+
+	if (systemd)
+		sd_notify(0, "READY=1");
+
 	iwarp_port_mapper(); /* start iwarp port mapper process */
 
 	free_iwpm_mapped_ports();
diff --git a/iwpmd/iwpmd.service.in b/iwpmd/iwpmd.service.in
index 4e4b49738fa29d..3451e7e50923af 100644
--- a/iwpmd/iwpmd.service.in
+++ b/iwpmd/iwpmd.service.in
@@ -5,6 +5,7 @@ Requires=rdma-load-modules-r79FGtN6zq8c5CkaFG5UGg@public.gmane.org
 After=network.target rdma-load-modules-r79FGtN6zq8c5CkaFG5UGg@public.gmane.org
 
 [Service]
+Type=notify
 ExecStart=@CMAKE_INSTALL_FULL_SBINDIR@/iwpmd --systemd
 LimitNOFILE=102400
 
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
