From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: [PATCH rdma-core 14/21] Revise the umad SYSTEMD_ALIAS fake path
Date: Mon, 24 Jul 2017 14:00:22 -0600
Message-ID: <1500926429-31822-15-git-send-email-jgunthorpe@obsidianresearch.com>
References: <1500926429-31822-1-git-send-email-jgunthorpe@obsidianresearch.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1500926429-31822-1-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <notifications-9UaJU3cA/F/QT0dZR+AlfA@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

The only other users of SYSTEMD_ALIAS I could find uses the
/sys/subsystem/ prefix, so we should do the same instead of using
a fake /dev/ prefix.

Fixes: 5a6f287a3cdf ("libibumad: Introduce the /dev/infiniband/umad/${ibdev}:${port}.device alias")
Fixes: d35e5c4f7169 ("srp_daemon.service: Add support for hot-plugging")
Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
---
 libibumad/libibumad.udev-rules         | 2 +-
 srp_daemon/srp_daemon_port@.service.in | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/libibumad/libibumad.udev-rules b/libibumad/libibumad.udev-rules
index 8b1ab6b5142009..b9f565eceaf3a3 100644
--- a/libibumad/libibumad.udev-rules
+++ b/libibumad/libibumad.udev-rules
@@ -1 +1 @@
-ACTION=="add", SUBSYSTEM=="infiniband_mad", TAG+="systemd", ENV{SYSTEMD_ALIAS}="/dev/infiniband/umad/$attr{ibdev}:$attr{port}"
+ACTION=="add", SUBSYSTEM=="infiniband_mad", TAG+="systemd", ENV{SYSTEMD_ALIAS}="/sys/subsystem/rdma/devices/$attr{ibdev}:$attr{port}/umad"
diff --git a/srp_daemon/srp_daemon_port@.service.in b/srp_daemon/srp_daemon_port@.service.in
index 0ec966f912aec8..03b9cb9a70119a 100644
--- a/srp_daemon/srp_daemon_port@.service.in
+++ b/srp_daemon/srp_daemon_port@.service.in
@@ -3,8 +3,8 @@ Description=SRP daemon that monitors port %i
 Documentation=man:srp_daemon file:/etc/rdma/rdma.conf file:/etc/srp_daemon.conf
 DefaultDependencies=false
 Conflicts=emergency.target emergency.service
-After=srp_daemon.service dev-infiniband-umad-%i.device network.target
-BindsTo=srp_daemon.service dev-infiniband-umad-%i.device
+After=srp_daemon.service sys-subsystem-rdma-devices-%i-umad.device network.target
+BindsTo=srp_daemon.service sys-subsystem-rdma-devices-%i-umad.device
 Before=remote-fs-pre.target
 
 [Service]
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
