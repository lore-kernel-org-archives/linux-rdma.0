From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: [PATCH rdma-core 10/21] debian: Set the run directory path to /run/
Date: Mon, 24 Jul 2017 14:00:18 -0600
Message-ID: <1500926429-31822-11-git-send-email-jgunthorpe@obsidianresearch.com>
References: <1500926429-31822-1-git-send-email-jgunthorpe@obsidianresearch.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1500926429-31822-1-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <notifications-9UaJU3cA/F/QT0dZR+AlfA@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

cmake defaults this to /usr/var/run if left alone. This causes srp_daemon to
not work properly on Debian derived.

Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
---
 debian/rules | 1 +
 1 file changed, 1 insertion(+)

diff --git a/debian/rules b/debian/rules
index 6dc8a59bd6a9f1..847194d750845f 100755
--- a/debian/rules
+++ b/debian/rules
@@ -23,6 +23,7 @@ override_dh_auto_configure:
 			-DCMAKE_INSTALL_SYSTEMD_SERVICEDIR:PATH=/lib/systemd/system \
 			-DCMAKE_INSTALL_INITDDIR:PATH=/etc/init.d \
 			-DCMAKE_INSTALL_LIBEXECDIR:PATH=/usr/lib \
+			-DCMAKE_INSTALL_RUNDIR:PATH=/run \
 			-DCMAKE_INSTALL_UDEV_RULESDIR:PATH=/lib/udev/rules.d
 
 override_dh_auto_build:
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
