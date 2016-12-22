From: Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-core] redhat/spec: further cleanups to depdendencies,
 descriptions, formatting
Date: Thu, 22 Dec 2016 13:13:39 -0500
Message-ID: <59b95b72-110a-e822-3c50-3c0270643b80@redhat.com>
References: <20161222180220.49558-1-jarod@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20161222180220.49558-1-jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 2016-12-22 1:02 PM, Jarod Wilson wrote:
> These are numerous additional little fixups for the Fedora/Red Hat spec
> file, stemming from Fedora package review.
>
> - Per https://fedoraproject.org/wiki/Packaging:Systemd it seems we need to
>   have systemd as a BuildRequires for %{_unitdir} to evaluate properly.
>
> - Add explicit dependencies on kmod, initscripts and systemd, as there
>   are container and vm cases where there might not be a kernel installed
>
> - Add missing Requires to rdma-core-devel on each sub-package it provides
>   devel headers and libs for
>
> - Update summary of libibverbs to mention RoCE too
>
> - Add requirement on logrotate to srp_daemon
>
> - Make -DCMAKE_* spaces/tabs indentation consistent
>
> - Make sure srp_daemon.sh is executable
>
> - Fix librdmacm files list so librsocket.so.* is included as well
>
> Signed-off-by: Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
...
> @@ -263,6 +271,7 @@ install -D -m0644 redhat/ibacm.service %{buildroot}%{_unitdir}/
>
>  # srp_daemon
>  install -D -m0644 redhat/srp_daemon.service %{buildroot}%{_unitdir}/
> +chmod a+x %{buildroot}%{_sbindir}/srp_daemon.sh
>
>  # Delete the package's init.d scripts
>  rm -rf %{buildroot}/%{_initrddir}/
> @@ -389,7 +398,7 @@ rm -rf %{buildroot}/%{_initrddir}/
>  %files -n librdmacm
>  %{_libdir}/librdmacm*.so.*
>  %dir %{_libdir}/rsocket
> -%{_libdir}/rsocket/*.so
> +%{_libdir}/rsocket/librsocket.so*
>  %doc %{_docdir}/%{name}-%{version}/librdmacm.md
>  %{_mandir}/man7/rsocket.*

This is what I get for trying to rush things out the door right before 
holiday shutdown. That's librspreload, not librsocket. v2 coming in a sec.

-- 
Jarod Wilson
jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
