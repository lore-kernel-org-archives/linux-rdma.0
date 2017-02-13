From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH V1 rdma-core 7/7] mlx5: Export mlx5 direct verbs interface
Date: Mon, 13 Feb 2017 09:49:44 -0700
Message-ID: <20170213164944.GB25430@obsidianresearch.com>
References: <1486909012-15064-1-git-send-email-yishaih@mellanox.com>
 <1486909012-15064-8-git-send-email-yishaih@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1486909012-15064-8-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Sun, Feb 12, 2017 at 04:16:52PM +0200, Yishai Hadas wrote:
> diff --git a/debian/ibverbs-providers.install b/debian/ibverbs-providers.install
> index 70244ee..7bacc2e 100644
> +++ b/debian/ibverbs-providers.install
> @@ -1,8 +1,12 @@
> +usr/include/infiniband/mlx5dv.h
>  etc/libibverbs.d/
>  etc/modprobe.d/truescale.conf
>  usr/bin/rxe_cfg
>  usr/lib/*/libibverbs/lib*-rdmav2.so
> +usr/lib/*/libmlx5.*
>  usr/lib/truescale-serdes.cmds
>  usr/share/doc/rdma-core/rxe.md usr/share/doc/ibverbs-providers/
> +usr/share/man/man3/mlx5dv_*.3
> +usr/share/man/man7/mlx5dv.7

These need to go in libibverbs-dev, as does the libmlx5*.so.

Someone needs to figure out if Debian policy requires a dedicated
package for the now linkable libmlx5

> diff --git a/redhat/rdma-core.spec b/redhat/rdma-core.spec
> index 9bdfdff..ade4b4a 100644
> +++ b/redhat/rdma-core.spec
> @@ -359,12 +359,15 @@ rm -rf %{buildroot}/%{_initrddir}/
>  %dir %{_libdir}/libibverbs
>  %{_libdir}/libibverbs*.so.*
>  %{_libdir}/libibverbs/*.so
> +%{_libdir}/libmlx5.so*
>  %config(noreplace) %{_sysconfdir}/libibverbs.d/*.driver
>  %doc %{_docdir}/%{name}-%{version}/libibverbs.md
>  %doc %{_docdir}/%{name}-%{version}/rxe.md
>  %{_bindir}/rxe_cfg
>  %{_mandir}/man7/rxe*
>  %{_mandir}/man8/rxe*
> +%{_mandir}/man3/mlx5dv*
> +%{_mandir}/man7/mlx5dv*

Same comment here, the devel items should be in rdma-core-devel for rpm.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
