From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH rdma-core 4/4] glue/redhat/spec: build split rpm packages
Date: Fri, 14 Oct 2016 17:39:04 -0600
Message-ID: <20161014233904.GD16509@obsidianresearch.com>
References: <20161014192136.11731-1-jarod@redhat.com>
 <20161014192136.11731-5-jarod@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20161014192136.11731-5-jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Fri, Oct 14, 2016 at 03:21:36PM -0400, Jarod Wilson wrote:

> Wrote: /home/jwilson/rpmbuild/RPMS/x86_64/iwpmd-11-1.el7.x86_64.rpm

FC used to call this libiwpm for some reason..

> Wrote: /home/jwilson/rpmbuild/RPMS/x86_64/libibcm-11-1.el7.x86_64.rpm

Do you want to try and do as I did with debian and put the SONAME data
into the package version for the libraries? eg

libibcm1_1.0.11-1_amd64.deb

> Wrote: /home/jwilson/rpmbuild/RPMS/x86_64/libcxgb3-11-1.el7.x86_64.rpm
> Wrote: /home/jwilson/rpmbuild/RPMS/x86_64/libcxgb4-11-1.el7.x86_64.rpm
> Wrote: /home/jwilson/rpmbuild/RPMS/x86_64/libhfi1-11-1.el7.x86_64.rpm
> Wrote: /home/jwilson/rpmbuild/RPMS/x86_64/libi40iw-11-1.el7.x86_64.rpm
> Wrote: /home/jwilson/rpmbuild/RPMS/x86_64/libipathverbs-11-1.el7.x86_64.rpm
> Wrote: /home/jwilson/rpmbuild/RPMS/x86_64/libmlx4-11-1.el7.x86_64.rpm
> Wrote: /home/jwilson/rpmbuild/RPMS/x86_64/libmlx5-11-1.el7.x86_64.rpm
> Wrote: /home/jwilson/rpmbuild/RPMS/x86_64/libmthca-11-1.el7.x86_64.rpm
> Wrote: /home/jwilson/rpmbuild/RPMS/x86_64/libnes-11-1.el7.x86_64.rpm
> Wrote: /home/jwilson/rpmbuild/RPMS/x86_64/libocrdma-11-1.el7.x86_64.rpm
> Wrote: /home/jwilson/rpmbuild/RPMS/x86_64/librxe-11-1.el7.x86_64.rpm

Does this mean RH is not going to do a single package for the
providers? You know another 5 or so are coming..

Any feedback if things build on your supported arches? I'd be
interested to see compiler log if it isn't silent.

> +install -D -m0644 Documentation/{ibacm,ibsrpdm,libibcm,libibverbs,librdmacm,rxe}.md %{buildroot}/%{_docdir}/%{name}-%{version}/
> +install -D -m0644 README.md %{buildroot}/%{_docdir}/%{name}-%{version}/

I guess README should go in that patch I sent you..

> +%{buildroot}/%{_bindir}/ib_acme -D . -O
> +# Fixup a multilib conflict in ibacm_opts.cfg:
> +sed -i -e '/^# Specifies the directory of the provider libraries$/ a\
> +# Use /usr/lib64/ibacm on 64bit, /usr/lib/libacm on 32bit.
> +' -e 's%^\(# provider_lib_path
> /usr/\)lib\(64\)\?/ibacm$%\1lib64/ibacm%' ibacm_opts.cfg

Hum? I'm pretty sure this is basically fixed in the code now, was done here
5eebdb9baaaae420a4bb16e586a96807823916a0

Adjusting the comment like that doesn't really make sense, the acm
daemon has a fixed endianness and looks in a single place to load the
plugin. If someone wants to use 32 bit plugins they have to install
the 32 bit acm daemon, which would have the 32 bit path in the sample
conf file...

> +install -D -m0644 ibacm/man/*.1 %{buildroot}/%{_mandir}/man1/
> +install -D -m0644 ibacm/man/*.7 %{buildroot}/%{_mandir}/man7/
> +sed -e 's|@ACM_PROVIDER_DIR@|%{libdir}/%{name}/|g' -e 's|@CMAKE_INSTALL_FULL_LOCALSTATEDIR@|%{_localstatedir}|g' ibacm/man/ibacm_prov.7.in > %{buildroot}/%{_mandir}/man7/ibacm_prov.7

?? cmake is supposed to install these.. Looks like it works. What did
you need done here to open code it?

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
