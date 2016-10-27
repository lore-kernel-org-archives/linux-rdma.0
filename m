From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH rdma-core v2 4/4] redhat/spec: build split rpm packages
Date: Thu, 27 Oct 2016 15:10:59 -0600
Message-ID: <20161027211059.GA7224@obsidianresearch.com>
References: <20161014192136.11731-1-jarod@redhat.com>
 <20161020153357.27286-1-jarod@redhat.com>
 <20161020153357.27286-5-jarod@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20161020153357.27286-5-jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, Oct 20, 2016 at 11:33:57AM -0400, Jarod Wilson wrote:
> @@ -7,10 +7,11 @@ Summary: RDMA core userspace libraries and daemons
>  #  providers/ipathverbs/ Dual licensed using a BSD license with an extra patent clause
>  #  providers/rxe/ Incorporates code from ipathverbs and contains the patent clause
>  #  providers/hfi1verbs Uses the 3 Clause BSD license
> -License: (GPLv2 or BSD) and (GPLv2 or PathScale-BSD)
> +License: GPLv2 or BSD

Is this Ok? The Fedora guidelines I read suggested the PathScale
license would need to be assigned a short tag, and I'd be surprised if
'BSD' is the right tag due to the patent stuff..

>  Url: http://openfabrics.org/

I guess we should change this url to
https://github.com/linux-rdma/rdma-core ?

>  Source: rdma-core-%{version}.tgz
> -BuildRoot: %{_tmppath}/%{name}-%{version}-%{release}-root
> +# https://github.com/linux-rdma/rdma-core
> +BuildRoot: %(mktemp -ud %{_tmppath}/%{name}-%{version}-%{release}-XXXXXX)

I always wondered why there was so much variability in spec files
here.. I followed the Fedora guidelines, should we copy the above into
the other spec file?

> @@ -19,20 +20,15 @@ BuildRequires: pkgconfig
>  BuildRequires: pkgconfig(libnl-3.0)
>  BuildRequires: pkgconfig(libnl-route-3.0)
>  BuildRequires: valgrind-devel
> +BuildRequires: libnl3-devel

?

Isn't pkgconfig(libnl-3.0) the same thing?

>%define systemd_dep systemd-units
>%if 0%{?fedora} >= 18
>%define systemd_dep systemd
>%endif

The source package probably doesn't even build on FC 18.. can probably
remove this

> +Summary: InfiniBand Communication Manager Assistant
> +Requires(post): %{systemd_dep}
> +Requires(preun): %{systemd_dep}
> +Requires(postun): %{systemd_dep}

I suppose we need these and related in the other spec file too?
Looks like this spec file isn't going to work on C6, so you can
probably drop the other systemd compat stuff:

--- a/redhat/rdma-core.spec
+++ b/redhat/rdma-core.spec
@@ -202,13 +202,6 @@ discover and use SCSI devices via the SCSI RDMA Protocol over InfiniBand.
 
 %build
 
-# Detect if systemd is supported on this system
-%if 0%{?_unitdir:1}
-%define my_unitdir %{_unitdir}
-%else
-%define my_unitdir /tmp/
-%endif
-
 # New RPM defines _rundir, usually as /run
 %if 0%{?_rundir:1}
 %else
@@ -228,7 +221,7 @@ discover and use SCSI devices via the SCSI RDMA Protocol over InfiniBand.
          -DCMAKE_INSTALL_INFODIR:PATH=%{_infodir} \
          -DCMAKE_INSTALL_MANDIR:PATH=%{_mandir} \
          -DCMAKE_INSTALL_SYSCONFDIR:PATH=%{_sysconfdir} \
-        -DCMAKE_INSTALL_SYSTEMD_SERVICEDIR:PATH=%{my_unitdir} \
+        -DCMAKE_INSTALL_SYSTEMD_SERVICEDIR:PATH=%{_unitdir} \
         -DCMAKE_INSTALL_INITDDIR:PATH=%{_initrddir} \
         -DCMAKE_INSTALL_RUNDIR:PATH=%{_rundir} \
         -DCMAKE_INSTALL_DOCDIR:PATH=%{_docdir}/%{name}-%{version}
@@ -276,8 +269,6 @@ install -D -m0644 redhat/srp_daemon.service %{buildroot}%{_unitdir}/
 
 %if 0%{?_unitdir:1}
 rm -rf %{buildroot}/%{_initrddir}/
-%else
-rm -rf %{buildroot}/%{my_unitdir}/
 %endif
 
 %post -p /sbin/ldconfig

> +%package -n librdmacm-utils
> +Summary: Examples for the librdmacm library
> +Requires: librdmacm%{?_isa} = %{version}-%{release}

Why the requires? Shouldn't auto shlib dependencies take care of that?

Anyhow, this all looks fine to me, I put a branch here, with one
change to make the debian packaging work after the README.md change:

https://github.com/jgunthorpe/rdma-plumbing/tree/redhat-packaging

If you want to make any final adjustments let me know, otherwise I
will send this on..

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
