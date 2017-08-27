From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH rdma-core 1/2] suse: Add spec file for SUSE
Date: Sun, 27 Aug 2017 15:47:04 -0600
Message-ID: <20170827214704.GC14542@obsidianresearch.com>
References: <abf2bc82-824b-a1d9-bc6b-a3a77045d633@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <abf2bc82-824b-a1d9-bc6b-a3a77045d633-l3A5Bk7waGM@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Nicolas Morey-Chaisemartin <NMoreyChaisemartin-l3A5Bk7waGM@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, Aug 24, 2017 at 04:49:54PM +0200, Nicolas Morey-Chaisemartin wrote:

> +install -D -m0644 redhat/rdma.conf %{buildroot}/%{_sysconfdir}/rdma/rdma.conf
> +sed 's%/usr/libexec%/usr/lib%' redhat/rdma.service > %{buildroot}%{_unitdir}/rdma.service
> +chmod 0644 %{buildroot}%{_unitdir}/rdma.service
> +install -D -m0644 redhat/rdma.sriov-vfs %{buildroot}/%{_sysconfdir}/rdma/sriov-vfs
> +install -D -m0644 redhat/rdma.mlx4.conf %{buildroot}/%{_sysconfdir}/rdma/mlx4.conf
> +install -D -m0644 redhat/rdma.udev-ipoib-naming.rules %{buildroot}%{_udevrulesdir}/70-persistent-ipoib.rules
> +sed 's%/usr/libexec%/usr/lib%g' redhat/rdma.modules-setup.sh > %{buildroot}%{dracutlibdir}/modules.d/05rdma/module-setup.sh
> +chmod 0755 %{buildroot}%{dracutlibdir}/modules.d/05rdma/module-setup.sh
> +install -D -m0644 redhat/rdma.udev-rules %{buildroot}%{_udevrulesdir}/98-rdma.rules
> +sed 's%/usr/libexec%/usr/lib%g' redhat/rdma.mlx4.sys.modprobe > %{buildroot}%{sysmodprobedir}/50-libmlx4.conf
> +chmod 0644 %{buildroot}%{sysmodprobedir}/50-libmlx4.conf

> +sed 's%/usr/libexec%/usr/lib%g' redhat/rdma.kernel-init > %{buildroot}%{_libexecdir}/rdma-init-kernel
> +chmod 0755 %{buildroot}%{_libexecdir}/rdma-init-kernel
> +install -D -m0755 redhat/rdma.sriov-init %{buildroot}%{_libexecdir}/rdma-set-sriov-vf
> +install -D -m0644 redhat/rdma.fixup-mtrr.awk %{buildroot}%{_libexecdir}/rdma-fixup-mtrr.awk
> +install -D -m0755 redhat/rdma.mlx4-setup.sh %{buildroot}%{_libexecdir}/mlx4-setup.sh

Going forward suse may not want to include this boot stuff from RH,
unless historical versions of suse used it or something similar. The
new cross-distro stuff in kernel-boot basically does the same thing.

I'm hoping RH will discontinue their version in newer releases.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
