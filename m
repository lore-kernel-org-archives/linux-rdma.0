From: Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-core 5/6] redhat/spec: clean up rsocket packaging
Date: Thu, 22 Dec 2016 02:17:52 -0500
Message-ID: <140dc3aa-6088-c4cf-5a8a-1a0426f55cd3@redhat.com>
References: <20161221220840.36268-1-jarod@redhat.com>
 <20161221220840.36268-6-jarod@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20161221220840.36268-6-jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 2016-12-21 5:08 PM, Jarod Wilson wrote:
> Nothing owned libdir/rsocket, and librdmacm was laying down dangling
> symlinks to librspreload.so, so just put it all in librdmacm.
>
> Signed-off-by: Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
>  redhat/rdma-core.spec | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/redhat/rdma-core.spec b/redhat/rdma-core.spec
> index 1f51720..96a67a4 100644
> --- a/redhat/rdma-core.spec
> +++ b/redhat/rdma-core.spec
> @@ -336,13 +336,11 @@ rm -rf %{buildroot}/%{_initrddir}/
>  %doc %{_docdir}/%{name}-%{version}/MAINTAINERS
>  %{_includedir}/*
>  %{_libdir}/lib*.so
> -%{_libdir}/rsocket/*.so
>  %{_mandir}/man3/ibv_*
>  %{_mandir}/man3/rdma*
>  %{_mandir}/man3/umad*
>  %{_mandir}/man3/*_to_ibv_rate.*
>  %{_mandir}/man7/rdma_cm.*
> -%{_mandir}/man7/rsocket.*
>
>  %files -n libibverbs
>  %dir %{_sysconfdir}/libibverbs.d
> @@ -389,8 +387,10 @@ rm -rf %{buildroot}/%{_initrddir}/
>
>  %files -n librdmacm
>  %{_libdir}/librdmacm*.so.*
> -%{_libdir}/rsocket/*.so.*
> +%dir %{_libdir}/rsocket
> +%{_libdir}/rsocket/*.so

Minor error here, should be rsocket/*.so* to pick up the symlinks too, 
at least until they get neutered.

>  %doc %{_docdir}/%{name}-%{version}/librdmacm.md
> +%{_mandir}/man7/rsocket.*
>
>  %files -n librdmacm-utils
>  %{_bindir}/cmtime
>


-- 
Jarod Wilson
jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
