From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: [PATCH rdma-core 18/21] srp_daemon: Call systemctl properly from udev
Date: Mon, 24 Jul 2017 14:00:26 -0600
Message-ID: <1500926429-31822-19-git-send-email-jgunthorpe@obsidianresearch.com>
References: <1500926429-31822-1-git-send-email-jgunthorpe@obsidianresearch.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1500926429-31822-1-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <notifications-9UaJU3cA/F/QT0dZR+AlfA@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Use /bin/ as the call path for systemctl. For some reason Debian
derived distros do not have /usr/bin/systemctl, only /bin/systemctl.
Other distros seem to have both paths.

Also invoke PROGRAM using == which matches what the udev test suite does.

Fixes: d35e5c4f7169 ("srp_daemon.service: Add support for hot-plugging")
Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
---
 srp_daemon/srp_daemon.rules | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/srp_daemon/srp_daemon.rules b/srp_daemon/srp_daemon.rules
index 6780d5421de7b4..4cfeabc762da2a 100644
--- a/srp_daemon/srp_daemon.rules
+++ b/srp_daemon/srp_daemon.rules
@@ -1 +1 @@
-ACTION=="add", SUBSYSTEM=="infiniband_mad", KERNEL=="*umad*", PROGRAM:="/usr/bin/systemctl show srp_daemon -p ActiveState", RESULT=="ActiveState=active", ENV{SYSTEMD_WANTS}+="srp_daemon_port@$attr{ibdev}:$attr{port}.service"
+ACTION=="add", SUBSYSTEM=="infiniband_mad", KERNEL=="*umad*", PROGRAM=="/bin/systemctl show srp_daemon -p ActiveState", RESULT=="ActiveState=active", ENV{SYSTEMD_WANTS}+="srp_daemon_port@$attr{ibdev}:$attr{port}.service"
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
