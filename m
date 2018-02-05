From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: Re: [PATCH] redhat/spec: Don't include ifup/ifdown-ib
Date: Sun, 4 Feb 2018 20:40:51 -0700
Message-ID: <20180205034051.GA22389@ziepe.ca>
References: <7ebed9d65a53d04dd7e0d1f3d56f104937c956a4.1517795159.git.dledford@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <7ebed9d65a53d04dd7e0d1f3d56f104937c956a4.1517795159.git.dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Sun, Feb 04, 2018 at 08:46:05PM -0500, Doug Ledford wrote:
> When the original Red Hat spec file was created, many things that we
> used to do in the old rdma package were brought over.  One of the things
> brought over were the ifup-ib and ifdown-ib network scripts.  However,
> those scripts are meaningless without the SysV-initscripts package which
> includes all of the sysv network startup infrastructure.  The new
> rdma-core was intended to be a systemd only service, and so we skipped
> the Requirements: initscripts that we should have had in order to
> support these scripts.  So, remove the scripts as they are old baggage.
> 
> Fixes: dac219f1da8b ("redhat/spec: build split rpm packages")
> Signed-off-by: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>  redhat/rdma-core.spec | 4 ----
>  1 file changed, 4 deletions(-)
> 
> diff --git a/redhat/rdma-core.spec b/redhat/rdma-core.spec
> index fd9a95ee1f87..896849b8679e 100644
> +++ b/redhat/rdma-core.spec
> @@ -236,7 +236,6 @@ mkdir -p %{buildroot}/%{_sysconfdir}/rdma
>  # Red Hat specific glue
>  %global dracutlibdir %{_prefix}/lib/dracut
>  %global sysmodprobedir %{_prefix}/lib/modprobe.d
> -mkdir -p %{buildroot}/%{_sysconfdir}/sysconfig/network-scripts
>  mkdir -p %{buildroot}%{_sysconfdir}/udev/rules.d
>  mkdir -p %{buildroot}%{_libexecdir}
>  mkdir -p %{buildroot}%{_udevrulesdir}
> @@ -245,8 +244,6 @@ mkdir -p %{buildroot}%{sysmodprobedir}
>  install -D -m0644 redhat/rdma.conf %{buildroot}/%{_sysconfdir}/rdma/rdma.conf
>  install -D -m0644 redhat/rdma.sriov-vfs %{buildroot}/%{_sysconfdir}/rdma/sriov-vfs
>  install -D -m0644 redhat/rdma.mlx4.conf %{buildroot}/%{_sysconfdir}/rdma/mlx4.conf
> -install -D -m0755 redhat/rdma.ifup-ib %{buildroot}/%{_sysconfdir}/sysconfig/network-scripts/ifup-ib
> -install -D -m0755 redhat/rdma.ifdown-ib %{buildroot}/%{_sysconfdir}/sysconfig/network-scripts/ifdown-ib

Looks like we should delete these two files in this commit as well..

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
