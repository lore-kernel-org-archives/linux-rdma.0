From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: [PATCH rdma-core 01/21] srp: Fix redhat packaging
Date: Mon, 24 Jul 2017 14:00:09 -0600
Message-ID: <1500926429-31822-2-git-send-email-jgunthorpe@obsidianresearch.com>
References: <1500926429-31822-1-git-send-email-jgunthorpe@obsidianresearch.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1500926429-31822-1-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <notifications-9UaJU3cA/F/QT0dZR+AlfA@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Build fails with:

error: Installed (but unpackaged) file(s) found:
   /usr/sbin/srp_daemon.sh
    Installed (but unpackaged) file(s) found:
   /usr/sbin/srp_daemon.sh

Since we do not install the init.d script for srp on RH, also delete
the srp_daemon.sh, which is now only used by init.d.

Fixes: 1c7fe513e3e9 ("srp_daemon: One systemd service per port")
Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
---
 redhat/rdma-core.spec | 1 +
 1 file changed, 1 insertion(+)

diff --git a/redhat/rdma-core.spec b/redhat/rdma-core.spec
index 817013bc4905f8..80a78265d02bfb 100644
--- a/redhat/rdma-core.spec
+++ b/redhat/rdma-core.spec
@@ -274,6 +274,7 @@ install -D -m0644 ibacm_opts.cfg %{buildroot}%{_sysconfdir}/rdma/
 
 # Delete the package's init.d scripts
 rm -rf %{buildroot}/%{_initrddir}/
+rm -rf %{buildroot}/%{_sbindir}/srp_daemon.sh
 
 # libibverbs
 %post -n libibverbs -p /sbin/ldconfig
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
