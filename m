From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: [PATCH rdma-core 07/21] redhat: Fix redhat packaging of /etc/rdma/ibacm_opts.cfg
Date: Mon, 24 Jul 2017 14:00:15 -0600
Message-ID: <1500926429-31822-8-git-send-email-jgunthorpe@obsidianresearch.com>
References: <1500926429-31822-1-git-send-email-jgunthorpe@obsidianresearch.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1500926429-31822-1-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <notifications-9UaJU3cA/F/QT0dZR+AlfA@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

It was ending up in rdma-core.rpm and ibacm.rpm, it belongs in
ibacm only.

Fixes: 0576db26f998 ("redhat spec: Avoid conflict due to implicit directory add")
Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
---
 redhat/rdma-core.spec | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/redhat/rdma-core.spec b/redhat/rdma-core.spec
index 817013bc4905f8..6dbba733fe3236 100644
--- a/redhat/rdma-core.spec
+++ b/redhat/rdma-core.spec
@@ -319,7 +319,9 @@ rm -rf %{buildroot}/%{_initrddir}/
 %dir %{_sysconfdir}/rdma
 %dir %{_docdir}/%{name}-%{version}
 %doc %{_docdir}/%{name}-%{version}/README.md
-%config(noreplace) %{_sysconfdir}/rdma/*
+%config(noreplace) %{_sysconfdir}/rdma/mlx4.conf
+%config(noreplace) %{_sysconfdir}/rdma/rdma.conf
+%config(noreplace) %{_sysconfdir}/rdma/sriov-vfs
 %config(noreplace) %{_sysconfdir}/udev/rules.d/*
 %config(noreplace) %{_sysconfdir}/modprobe.d/mlx4.conf
 %config(noreplace) %{_sysconfdir}/modprobe.d/truescale.conf
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
