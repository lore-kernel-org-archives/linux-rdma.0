From: Honggang LI <honli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [rdma-core patch] srp_daemon: srp_daemon.service should be started after network.target
Date: Fri, 29 Dec 2017 18:10:06 +0800
Message-ID: <20171229101006.27861-1-honli@redhat.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org, honli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Honggang Li <honli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

The srp_daemon service will be started at the very beginning state
of systemd when boot/reboot the machine, in case srp_daemon.service
is not after network.target. As result, the srp_daemon.service will
be terminated because of SERVICE_FAILURE_RESOURCES.

Fixes: 1c7fe513e3e9 ("srp_daemon: One systemd service per port")
Signed-off-by: Honggang Li <honli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 srp_daemon/srp_daemon.service.in | 1 +
 1 file changed, 1 insertion(+)

diff --git a/srp_daemon/srp_daemon.service.in b/srp_daemon/srp_daemon.service.in
index 188b7e1a..93e44425 100644
--- a/srp_daemon/srp_daemon.service.in
+++ b/srp_daemon/srp_daemon.service.in
@@ -3,6 +3,7 @@ Description=Daemon that discovers and logs in to SRP target systems
 Documentation=man:srp_daemon file:/etc/srp_daemon.conf
 DefaultDependencies=false
 Conflicts=emergency.target emergency.service
+After=network.target
 Before=remote-fs-pre.target
 
 [Service]
-- 
2.15.GIT

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
