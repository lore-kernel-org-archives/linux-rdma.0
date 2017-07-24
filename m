From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: [PATCH rdma-core 15/21] umad: Match only umad kernel devices in the udev rule
Date: Mon, 24 Jul 2017 14:00:23 -0600
Message-ID: <1500926429-31822-16-git-send-email-jgunthorpe@obsidianresearch.com>
References: <1500926429-31822-1-git-send-email-jgunthorpe@obsidianresearch.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1500926429-31822-1-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <notifications-9UaJU3cA/F/QT0dZR+AlfA@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Otherwise udev matches issm and umad for each resulting in systemd
warnings:

 systemd[1]: sys-subsystem-rdma-devices-mlx4_0:1-umad.device: Dev sys-subsystem-rdma-devices-mlx4_0:1-umad.device appeared twice with different sysfs paths /sys/devices/pci0000:00/0000:00:04.0/infiniband_mad/issm0 and /sys/devices/pci0000:00/0000:00:04.0/infiniband_mad/umad0

Fixes: d35e5c4f7169 ("srp_daemon.service: Add support for hot-plugging")
Fixes: 5a6f287a3cdf ("libibumad: Introduce the /dev/infiniband/umad/${ibdev}:${port}.device alias")
Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
---
 libibumad/libibumad.udev-rules | 2 +-
 srp_daemon/srp_daemon.rules    | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/libibumad/libibumad.udev-rules b/libibumad/libibumad.udev-rules
index b9f565eceaf3a3..cfb790e051ced7 100644
--- a/libibumad/libibumad.udev-rules
+++ b/libibumad/libibumad.udev-rules
@@ -1 +1 @@
-ACTION=="add", SUBSYSTEM=="infiniband_mad", TAG+="systemd", ENV{SYSTEMD_ALIAS}="/sys/subsystem/rdma/devices/$attr{ibdev}:$attr{port}/umad"
+ACTION=="add", SUBSYSTEM=="infiniband_mad", KERNEL=="*umad*", TAG+="systemd", ENV{SYSTEMD_ALIAS}="/sys/subsystem/rdma/devices/$attr{ibdev}:$attr{port}/umad"
diff --git a/srp_daemon/srp_daemon.rules b/srp_daemon/srp_daemon.rules
index 1210adef5b592b..6780d5421de7b4 100644
--- a/srp_daemon/srp_daemon.rules
+++ b/srp_daemon/srp_daemon.rules
@@ -1 +1 @@
-ACTION=="add", SUBSYSTEM=="infiniband_mad", PROGRAM:="/usr/bin/systemctl show srp_daemon -p ActiveState", RESULT=="ActiveState=active", ENV{SYSTEMD_WANTS}+="srp_daemon_port@$attr{ibdev}:$attr{port}.service"
+ACTION=="add", SUBSYSTEM=="infiniband_mad", KERNEL=="*umad*", PROGRAM:="/usr/bin/systemctl show srp_daemon -p ActiveState", RESULT=="ActiveState=active", ENV{SYSTEMD_WANTS}+="srp_daemon_port@$attr{ibdev}:$attr{port}.service"
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
