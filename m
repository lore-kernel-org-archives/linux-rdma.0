From: Nicolas Morey-Chaisemartin <NMoreyChaisemartin-l3A5Bk7waGM@public.gmane.org>
Subject: [PATCH rdma-core] suse: switch fully to the new udev mechanism
Date: Mon, 28 Aug 2017 17:05:33 +0200
Message-ID: <71835edf-cb2a-d4f8-627e-0f60ee772fb7@suse.de>
References: <20170827214704.GC14542@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170827214704.GC14542-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Content-Language: fr-xx-classique+reforme1990
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Do not use redhat services and scripts and use the new udev system

Signed-off-by: Nicolas Morey-Chaisemartin <NMoreyChaisemartin-IBi9RG/b67k@public.gmane.org>
---
Also sent as a PR on github: https://github.com/linux-rdma/rdma-core/pull/195

 suse/rdma-core.spec | 42 ------------------------------------------
 1 file changed, 42 deletions(-)

diff --git a/suse/rdma-core.spec b/suse/rdma-core.spec
index 76ca7286..64d43b23 100644
--- a/suse/rdma-core.spec
+++ b/suse/rdma-core.spec
@@ -356,24 +356,6 @@ mkdir -p %{buildroot}%{dracutlibdir}/modules.d/05rdma
 mkdir -p %{buildroot}%{sysmodprobedir}
 mkdir -p %{buildroot}%{_unitdir}
 
-install -D -m0644 redhat/rdma.conf %{buildroot}/%{_sysconfdir}/rdma/rdma.conf
-sed 's%/usr/libexec%/usr/lib%' redhat/rdma.service > %{buildroot}%{_unitdir}/rdma.service
-chmod 0644 %{buildroot}%{_unitdir}/rdma.service
-install -D -m0644 redhat/rdma.sriov-vfs %{buildroot}/%{_sysconfdir}/rdma/sriov-vfs
-install -D -m0644 redhat/rdma.mlx4.conf %{buildroot}/%{_sysconfdir}/rdma/mlx4.conf
-install -D -m0644 redhat/rdma.udev-ipoib-naming.rules %{buildroot}%{_udevrulesdir}/70-persistent-ipoib.rules
-sed 's%/usr/libexec%/usr/lib%g' redhat/rdma.modules-setup.sh > %{buildroot}%{dracutlibdir}/modules.d/05rdma/module-setup.sh
-chmod 0755 %{buildroot}%{dracutlibdir}/modules.d/05rdma/module-setup.sh
-install -D -m0644 redhat/rdma.udev-rules %{buildroot}%{_udevrulesdir}/98-rdma.rules
-sed 's%/usr/libexec%/usr/lib%g' redhat/rdma.mlx4.sys.modprobe > %{buildroot}%{sysmodprobedir}/50-libmlx4.conf
-chmod 0644 %{buildroot}%{sysmodprobedir}/50-libmlx4.conf
-
-sed 's%/usr/libexec%/usr/lib%g' redhat/rdma.kernel-init > %{buildroot}%{_libexecdir}/rdma-init-kernel
-chmod 0755 %{buildroot}%{_libexecdir}/rdma-init-kernel
-install -D -m0755 redhat/rdma.sriov-init %{buildroot}%{_libexecdir}/rdma-set-sriov-vf
-install -D -m0644 redhat/rdma.fixup-mtrr.awk %{buildroot}%{_libexecdir}/rdma-fixup-mtrr.awk
-install -D -m0755 redhat/rdma.mlx4-setup.sh %{buildroot}%{_libexecdir}/mlx4-setup.sh
-
 mv %{buildroot}%{_sysconfdir}/modprobe.d/truescale.conf %{buildroot}%{_sysconfdir}/modprobe.d/50-truescale.conf
 %if 0%{?dma_coherent}
 mv %{buildroot}%{_sysconfdir}/modprobe.d/mlx4.conf %{buildroot}%{_sysconfdir}/modprobe.d/50-mlx4.conf
@@ -410,18 +392,6 @@ rm -rf %{buildroot}/%{_sbindir}/srp_daemon.sh
 %post -n %rdmacm_lname -p /sbin/ldconfig
 %postun -n %rdmacm_lname -p /sbin/ldconfig
 
-%pre
-%service_add_pre rdma.service
-
-%post
-%service_add_post rdma.service
-
-%preun
-%service_del_preun -n rdma.service
-
-%postun
-%service_del_postun -n rdma.service
-
 #
 # ibacm
 #
@@ -491,36 +461,24 @@ rm -rf %{buildroot}/%{_sbindir}/srp_daemon.sh
 %dir %{_libexecdir}/udev/rules.d
 %dir %{_sysconfdir}/modprobe.d
 %doc %{_docdir}/%{name}-%{version}/README.md
-%config(noreplace) %{_sysconfdir}/rdma/mlx4.conf
 %config(noreplace) %{_sysconfdir}/rdma/modules/infiniband.conf
 %config(noreplace) %{_sysconfdir}/rdma/modules/iwarp.conf
 %config(noreplace) %{_sysconfdir}/rdma/modules/opa.conf
 %config(noreplace) %{_sysconfdir}/rdma/modules/rdma.conf
 %config(noreplace) %{_sysconfdir}/rdma/modules/roce.conf
-%config(noreplace) %{_sysconfdir}/rdma/rdma.conf
-%config(noreplace) %{_sysconfdir}/rdma/sriov-vfs
 %if 0%{?dma_coherent}
 %config(noreplace) %{_sysconfdir}/modprobe.d/50-mlx4.conf
 %endif
 %config(noreplace) %{_sysconfdir}/modprobe.d/50-truescale.conf
 %{_unitdir}/rdma-hw.target
 %{_unitdir}/rdma-load-modules@.service
-%{_unitdir}/rdma.service
 %dir %{dracutlibdir}
 %dir %{dracutlibdir}/modules.d
 %dir %{dracutlibdir}/modules.d/05rdma
-%{dracutlibdir}/modules.d/05rdma/module-setup.sh
-%{_udevrulesdir}/70-persistent-ipoib.rules
 %{_udevrulesdir}/75-rdma-description.rules
 %{_udevrulesdir}/90-rdma-hw-modules.rules
 %{_udevrulesdir}/90-rdma-ulp-modules.rules
 %{_udevrulesdir}/90-rdma-umad.rules
-%{_udevrulesdir}/98-rdma.rules
-%config %{sysmodprobedir}/50-libmlx4.conf
-%{_libexecdir}/rdma-init-kernel
-%{_libexecdir}/rdma-set-sriov-vf
-%{_libexecdir}/rdma-fixup-mtrr.awk
-%{_libexecdir}/mlx4-setup.sh
 %{_libexecdir}/truescale-serdes.cmds
 %license COPYING.*
 %{_sbindir}/rcrdma
-- 
2.14.1.252.gf15771ee3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
