From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-core 1/2] suse: Add spec file for SUSE
Date: Mon, 28 Aug 2017 09:07:58 +0300
Message-ID: <20170828060758.GD12880@mtr-leonro.local>
References: <abf2bc82-824b-a1d9-bc6b-a3a77045d633@suse.de>
 <20170827214704.GC14542@obsidianresearch.com>
 <ecddc225-0dc5-c51f-535b-c2bee252d5ed@suse.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="WplhKdTI2c8ulnbP"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <ecddc225-0dc5-c51f-535b-c2bee252d5ed-l3A5Bk7waGM@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Nicolas Morey-Chaisemartin <NMoreyChaisemartin-l3A5Bk7waGM@public.gmane.org>
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--WplhKdTI2c8ulnbP
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Aug 28, 2017 at 07:59:29AM +0200, Nicolas Morey-Chaisemartin wrote:
>
>
> Le 27/08/2017 =E0 23:47, Jason Gunthorpe a =E9crit=A0:
> > On Thu, Aug 24, 2017 at 04:49:54PM +0200, Nicolas Morey-Chaisemartin wr=
ote:
> >
> >> +install -D -m0644 redhat/rdma.conf %{buildroot}/%{_sysconfdir}/rdma/r=
dma.conf
> >> +sed 's%/usr/libexec%/usr/lib%' redhat/rdma.service > %{buildroot}%{_u=
nitdir}/rdma.service
> >> +chmod 0644 %{buildroot}%{_unitdir}/rdma.service
> >> +install -D -m0644 redhat/rdma.sriov-vfs %{buildroot}/%{_sysconfdir}/r=
dma/sriov-vfs
> >> +install -D -m0644 redhat/rdma.mlx4.conf %{buildroot}/%{_sysconfdir}/r=
dma/mlx4.conf
> >> +install -D -m0644 redhat/rdma.udev-ipoib-naming.rules %{buildroot}%{_=
udevrulesdir}/70-persistent-ipoib.rules
> >> +sed 's%/usr/libexec%/usr/lib%g' redhat/rdma.modules-setup.sh > %{buil=
droot}%{dracutlibdir}/modules.d/05rdma/module-setup.sh
> >> +chmod 0755 %{buildroot}%{dracutlibdir}/modules.d/05rdma/module-setup.=
sh
> >> +install -D -m0644 redhat/rdma.udev-rules %{buildroot}%{_udevrulesdir}=
/98-rdma.rules
> >> +sed 's%/usr/libexec%/usr/lib%g' redhat/rdma.mlx4.sys.modprobe > %{bui=
ldroot}%{sysmodprobedir}/50-libmlx4.conf
> >> +chmod 0644 %{buildroot}%{sysmodprobedir}/50-libmlx4.conf
> >> +sed 's%/usr/libexec%/usr/lib%g' redhat/rdma.kernel-init > %{buildroot=
}%{_libexecdir}/rdma-init-kernel
> >> +chmod 0755 %{buildroot}%{_libexecdir}/rdma-init-kernel
> >> +install -D -m0755 redhat/rdma.sriov-init %{buildroot}%{_libexecdir}/r=
dma-set-sriov-vf
> >> +install -D -m0644 redhat/rdma.fixup-mtrr.awk %{buildroot}%{_libexecdi=
r}/rdma-fixup-mtrr.awk
> >> +install -D -m0755 redhat/rdma.mlx4-setup.sh %{buildroot}%{_libexecdir=
}/mlx4-setup.sh
> > Going forward suse may not want to include this boot stuff from RH,
> > unless historical versions of suse used it or something similar. The
> > new cross-distro stuff in kernel-boot basically does the same thing.
> >
> > I'm hoping RH will discontinue their version in newer releases.
> >
> > Jason
> Do you mean that all these should not be used anymore?

I think so, from the spotted immediately - "fixup-mtrr" - is not needed
for sure.

> The udev rules and the few new services are now sufficient ?

This was the intention.

>
> Nicolas
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--WplhKdTI2c8ulnbP
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlmjsz4ACgkQ5GN7iDZy
WKf61BAAhH8Haq98ZVRApOu0TgWLN0piB09yyAdVpwCRBuLwvtav+r/QEZm48kNv
i0VdfPQakxPK6mE49o6+5MwtQ6J30PfeEC2KT7wAAANl+i8FVkDagedf9oIMjbL1
w9XIzSnt80MxuKX3pQUQtWuT9vuLlE+2xWzZBaX2BN4C5H+OuhBsjjlwFASTX/nT
CjEBOfF+uLl9/nxgc1V4Qw7k5JbzfN0Lqp/g7+HAzYDTfkx9+8Ma0SQ3WG3DAxYS
NuF/tRSQnnRmPWylExolXbJMgNKfPbI2fBbN2WxYvcgbLw5Ugcz95TSxocT8UTaz
CFWpGRfPwUbl+q+Di3+hoEe227kgb6qv6Muks8uUL9ReM/0uvbdCOwQQPT6PC7O9
Y2WOFU/jQEEhbECnF6JRFDwyGCaxS9EBVEZRTiYWXHi6lWHEwX9m16VOvVQwC362
UAjernXrEHyF5d/JkXy8zaBGYDDbHdiOCP8Xfc306lSiMZ4fbjXZhewEFe2bNxDK
XA+/tHbxSK4DedoiSF0YQrY/HsxzhsX2wHOrX+1wbKiWC9OokuyPh//s1YDYEPsx
vievV6PEpnI7Dn8TZmOO7aZupxKyx/GChPXT2QcwcdvLx8amzWdyQ1zZ/ctDVk+v
lHscdDIlZ+7DBKCOtHzbocKt4RPQDcweClUZXKYTQeyIgR8JRw8=
=tMNo
-----END PGP SIGNATURE-----

--WplhKdTI2c8ulnbP--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
