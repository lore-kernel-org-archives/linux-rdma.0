From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: [PATCH rdma-core 08/21] redhat: Fix duplicated udev rules in redhat packaging
Date: Mon, 24 Jul 2017 14:00:16 -0600
Message-ID: <1500926429-31822-9-git-send-email-jgunthorpe@obsidianresearch.com>
References: <1500926429-31822-1-git-send-email-jgunthorpe@obsidianresearch.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1500926429-31822-1-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <notifications-9UaJU3cA/F/QT0dZR+AlfA@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

/usr/lib/udev/rules.d/libibumad.rules was claimed by rdma-core and
libibumad.rpm

/usr/lib/udev/rules.d/srp_daemon.rules was claimed by rdma-core and
srp_daemon.rpm

Fixes: 5a6f287a3cd ("libibumad: Introduce the /dev/infiniband/umad/${ibdev}:${port}.device alias")
Fixes: d35e5c4f716 ("srp_daemon.service: Add support for hot-plugging")
Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
---
 redhat/rdma-core.spec | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/redhat/rdma-core.spec b/redhat/rdma-core.spec
index 6dbba733fe3236..f6cf1027e404e4 100644
--- a/redhat/rdma-core.spec
+++ b/redhat/rdma-core.spec
@@ -329,7 +329,8 @@ rm -rf %{buildroot}/%{_initrddir}/
 %{_unitdir}/rdma.service
 %dir %{dracutlibdir}/modules.d/05rdma
 %{dracutlibdir}/modules.d/05rdma/module-setup.sh
-%{_udevrulesdir}/*
+%{_udevrulesdir}/98-rdma.rules
+%{_udevrulesdir}/rdma-ndd.rules
 %{sysmodprobedir}/libmlx4.conf
 %{sysmodprobedir}/cxgb3.conf
 %{sysmodprobedir}/cxgb4.conf
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
