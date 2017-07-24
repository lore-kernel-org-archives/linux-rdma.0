From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: [PATCH rdma-core 4/5] redhat: Remove cxgb3/4.modprobe files
Date: Mon, 24 Jul 2017 14:44:26 -0600
Message-ID: <1500929067-1583-5-git-send-email-jgunthorpe@obsidianresearch.com>
References: <1500929067-1583-1-git-send-email-jgunthorpe@obsidianresearch.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1500929067-1583-1-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <notifications-9UaJU3cA/F/QT0dZR+AlfA@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Ram Amrani <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is now handled by the udev rules in kernel-boot

Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
---
 redhat/rdma-core.spec          | 4 ----
 redhat/rdma.cxgb3.sys.modprobe | 1 -
 redhat/rdma.cxgb4.sys.modprobe | 1 -
 3 files changed, 6 deletions(-)
 delete mode 100644 redhat/rdma.cxgb3.sys.modprobe
 delete mode 100644 redhat/rdma.cxgb4.sys.modprobe

diff --git a/redhat/rdma-core.spec b/redhat/rdma-core.spec
index 901c726037fdfe..1e4aee6a211f33 100644
--- a/redhat/rdma-core.spec
+++ b/redhat/rdma-core.spec
@@ -260,8 +260,6 @@ install -D -m0644 redhat/rdma.udev-ipoib-naming.rules %{buildroot}%{_sysconfdir}
 install -D -m0755 redhat/rdma.modules-setup.sh %{buildroot}%{dracutlibdir}/modules.d/05rdma/module-setup.sh
 install -D -m0644 redhat/rdma.udev-rules %{buildroot}%{_udevrulesdir}/98-rdma.rules
 install -D -m0644 redhat/rdma.mlx4.sys.modprobe %{buildroot}%{sysmodprobedir}/libmlx4.conf
-install -D -m0644 redhat/rdma.cxgb3.sys.modprobe %{buildroot}%{sysmodprobedir}/cxgb3.conf
-install -D -m0644 redhat/rdma.cxgb4.sys.modprobe %{buildroot}%{sysmodprobedir}/cxgb4.conf
 install -D -m0755 redhat/rdma.kernel-init %{buildroot}%{_libexecdir}/rdma-init-kernel
 install -D -m0755 redhat/rdma.sriov-init %{buildroot}%{_libexecdir}/rdma-set-sriov-vf
 install -D -m0644 redhat/rdma.fixup-mtrr.awk %{buildroot}%{_libexecdir}/rdma-fixup-mtrr.awk
@@ -341,8 +339,6 @@ rm -rf %{buildroot}/%{_initrddir}/
 %{_udevrulesdir}/90-rdma-ulp-modules.rules
 %{_udevrulesdir}/98-rdma.rules
 %{sysmodprobedir}/libmlx4.conf
-%{sysmodprobedir}/cxgb3.conf
-%{sysmodprobedir}/cxgb4.conf
 %{_libexecdir}/rdma-init-kernel
 %{_libexecdir}/rdma-set-sriov-vf
 %{_libexecdir}/rdma-fixup-mtrr.awk
diff --git a/redhat/rdma.cxgb3.sys.modprobe b/redhat/rdma.cxgb3.sys.modprobe
deleted file mode 100644
index d5925a715ccee1..00000000000000
diff --git a/redhat/rdma.cxgb4.sys.modprobe b/redhat/rdma.cxgb4.sys.modprobe
deleted file mode 100644
index 44163ab43cf649..00000000000000
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
