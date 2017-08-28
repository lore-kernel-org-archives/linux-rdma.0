From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-core 1/2] suse: Add spec file for SUSE
Date: Mon, 28 Aug 2017 12:24:06 +0300
Message-ID: <20170828092406.GH12880@mtr-leonro.local>
References: <abf2bc82-824b-a1d9-bc6b-a3a77045d633@suse.de>
 <20170827214704.GC14542@obsidianresearch.com>
 <ecddc225-0dc5-c51f-535b-c2bee252d5ed@suse.de>
 <20170828060758.GD12880@mtr-leonro.local>
 <86a21008-c993-de29-2cb9-845af14c4cd5@suse.de>
 <20170828090537.GG12880@mtr-leonro.local>
 <0754696d-42d5-5083-8ed0-435ab3f189de@suse.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="IvGM3kKqwtniy32b"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <0754696d-42d5-5083-8ed0-435ab3f189de-l3A5Bk7waGM@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Nicolas Morey-Chaisemartin <NMoreyChaisemartin-l3A5Bk7waGM@public.gmane.org>
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--IvGM3kKqwtniy32b
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Aug 28, 2017 at 11:13:07AM +0200, Nicolas Morey-Chaisemartin wrote:
>
>
> Le 28/08/2017 =E0 11:05, Leon Romanovsky a =E9crit=A0:
> > On Mon, Aug 28, 2017 at 10:17:50AM +0200, Nicolas Morey-Chaisemartin wr=
ote:
> >>
> >> Le 28/08/2017 =E0 08:07, Leon Romanovsky a =E9crit :
> >>> On Mon, Aug 28, 2017 at 07:59:29AM +0200, Nicolas Morey-Chaisemartin =
wrote: >> >> >> Le 27/08/2017 =E0 23:47, Jason Gunthorpe a =E9crit : >>> On=
 Thu, Aug 24, 2017 at 04:49:54PM +0200, Nicolas Morey-Chaisemartin wrote: >=
>> >>>> +install -D -m0644 redhat/rdma.conf %{buildroot}/%{_sysconfdir}/rdm=
a/rdma.conf >>>> +sed 's%/usr/libexec%/usr/lib%' redhat/rdma.service > %{bu=
ildroot}%{_unitdir}/rdma.service >>>> +chmod 0644 %{buildroot}%{_unitdir}/r=
dma.service >>>> +install -D -m0644 redhat/rdma.sriov-vfs %{buildroot}/%{_s=
ysconfdir}/rdma/sriov-vfs >>>> +install -D -m0644 redhat/rdma.mlx4.conf %{b=
uildroot}/%{_sysconfdir}/rdma/mlx4.conf >>>> +install -D -m0644 redhat/rdma=
=2Eudev-ipoib-naming.rules %{buildroot}%{_udevrulesdir}/70-persistent-ipoib=
=2Erules >>>> +sed 's%/usr/libexec%/usr/lib%g' redhat/rdma.modules-setup.sh=
 > %{buildroot}%{dracutlibdir}/modules.d/05rdma/module-setup.sh >>>> +chmod=
 0755 %{buildroot}%{dracutlibdir}/modules.d/05rdma/module-setup.sh >>>> +in=
stall -D -m0644 redhat/rdma.udev-rules %{buildroot}%{_udevrulesdir}/98-rdma=
=2Erules >>>> +sed
> >> 's%/usr/libexec%/usr/lib%g' redhat/rdma.mlx4.sys.modprobe > %{buildroo=
t}%{sysmodprobedir}/50-libmlx4.conf >>>> +chmod 0644 %{buildroot}%{sysmodpr=
obedir}/50-libmlx4.conf >>>> +sed 's%/usr/libexec%/usr/lib%g' redhat/rdma.k=
ernel-init > %{buildroot}%{_libexecdir}/rdma-init-kernel >>>> +chmod 0755 %=
{buildroot}%{_libexecdir}/rdma-init-kernel >>>> +install -D -m0755 redhat/r=
dma.sriov-init %{buildroot}%{_libexecdir}/rdma-set-sriov-vf >>>> +install -=
D -m0644 redhat/rdma.fixup-mtrr.awk %{buildroot}%{_libexecdir}/rdma-fixup-m=
trr.awk >>>> +install -D -m0755 redhat/rdma.mlx4-setup.sh %{buildroot}%{_li=
bexecdir}/mlx4-setup.sh >>> Going forward suse may not want to include this=
 boot stuff from RH, >>> unless historical versions of suse used it or some=
thing similar. The >>> new cross-distro stuff in kernel-boot basically does=
 the same thing. >>> >>> I'm hoping RH will discontinue their version in ne=
wer releases. >>> >>> Jason >> Do you mean that all these should not be use=
d anymore? > > I
> >> think so, from the spotted immediately - "fixup-mtrr" - is not needed =
> for sure. > >> The udev rules and the few new services are now sufficient=
 ? > > This was the intention. > > I tried dropping those files from the pa=
ckage and it does not seem to be fully functionnal yet.
> >> I'm running and a very old Mellanox card (mthca driver) and the rdma-l=
oad-modules@infiniband is not started. Thus ipoib and umad modules are miss=
ing.
> >>
> > Can you please resend?
> > It is not readable.
> >
> > Thanks
> >
> Sorry. The latest Thunderbird seems to screw up things regularly now :s
> The current udev system does not load the infiniband modules (ipoib, umad=
) for old mthca cards.

Among us, Doug is the last who has such cards.

>
> I've sent a PR that fixes this on github: https://github.com/linux-rdma/r=
dma-core/pull/193
> I've added a second patch for qib. On my system (and in kernel tree) the =
module is called ib_qib so I think the udev rule as a typo there.

Thanks

>
> Nicolas
>

--IvGM3kKqwtniy32b
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlmj4TYACgkQ5GN7iDZy
WKcfJRAAusX0b38zog0IALDl4OMSNN3kse5vhnaQ33ubHpn7PkdEmlZ5o9EvAot/
adxA8qsRuBw5ODmXVajoVAnK+Rt1psmOsqF6Ufp3FbRGEecTd/1+RZxBiGl+o4oU
35RFp57jx2v+micxIWkOZb0iHcHuEn481u6Vm6KGOdQR4T7MQ3QSdKlgt4TMrA7W
wRx5I+QCsj2O/eoA+LtOCTe21eES8mDuqBCjWR4XRrao/DHk86zbsquUwbU3A+Xw
l8kKnfvCZCLgzNFUDO4HwpBeRkmhYG4sMjkJmjNGfFGYv7yR/NaHxIL7k4ucrnWY
dbc26K1/gEkIsuwh4HMfNM5titttixLKDNyTtSgzeMe5EysAuGFnGNIubMhdNulu
ikA4GpcgKwPM6Kd+Atb44yiVbR/qchBV0fBWHDeelQoJAnCtWUFtA4OVG59VPdCR
c9vNxfdouJIcNoW/Kg0k6li65VEt/LUMfL8yARc7rLj80wI7PTxmpKG+UnfnFTlM
XrldweIVKKCmbeaHZi0JwKTeowiFLusk3NKjB7GD1PeeHy90MXmctqc1umcQ+2Lc
+VD7vZ1h1+vCPYgQ5ZERxPqGFAiM8xUlxL5qKMjWKrDDemNBcm+l+CoxWNI1Pl2U
N9fACbrLn7/T48bJ7AxNsd43YDO7XI+81F7zoRt4J7YG5YaofuI=
=tQKH
-----END PGP SIGNATURE-----

--IvGM3kKqwtniy32b--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
