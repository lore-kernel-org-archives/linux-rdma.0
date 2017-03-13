From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH rdma_core] redhat spec: Avoid conflict due to implicit
 directory add
Date: Mon, 13 Mar 2017 11:08:29 -0600
Message-ID: <20170313170829.GD25664@obsidianresearch.com>
References: <9707bd97229b67fe04d29affcb37f61b80e20dca.1484143751.git-series.knut.omang@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <9707bd97229b67fe04d29affcb37f61b80e20dca.1484143751.git-series.knut.omang-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Knut Omang <knut.omang-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wed, Jan 11, 2017 at 03:19:34PM +0100, Knut Omang wrote:
> If *-notation is used to include subdirectories, they
> seem to end as explicit file additions. This causes conflicts
> with other packages that provides the same
> directories, in this case rdma_core-devel conflicts
> with filesystem and kernel-headers.
> 
> Using %dir did not seem to help
> avoiding the issue but rather cause duplicate warnings, eg.
> 
> warning: File listed twice: /usr/include/infiniband
> 
> This should be considered a bug in rpmbuild but
> probably needs to be fixed here anyway:
> 
> List each individual directory with wildcards
> to avoid the issue.
> 
> Signed-off-by: Knut Omang <knut.omang-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
>  redhat/rdma-core.spec | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)

Did this ever get settled?

Jarod? Yes/No?

> diff --git a/redhat/rdma-core.spec b/redhat/rdma-core.spec
> index 4271e7c..72d6f3b 100644
> +++ b/redhat/rdma-core.spec
> @@ -343,7 +343,8 @@ rm -rf %{buildroot}/%{_initrddir}/
>  
>  %files devel
>  %doc %{_docdir}/%{name}-%{version}/MAINTAINERS
> -%{_includedir}/*
> +%{_includedir}/infiniband/*
> +%{_includedir}/rdma/*
>  %{_libdir}/lib*.so
>  %{_mandir}/man3/ibv_*
>  %{_mandir}/man3/rdma*
> 
> base-commit: b1c9b6aa22fb91507fb1a63df99566da7720315f
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
