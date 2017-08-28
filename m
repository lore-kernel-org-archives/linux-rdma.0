From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-core 1/2] suse: Add spec file for SUSE
Date: Mon, 28 Aug 2017 12:05:37 +0300
Message-ID: <20170828090537.GG12880@mtr-leonro.local>
References: <abf2bc82-824b-a1d9-bc6b-a3a77045d633@suse.de>
 <20170827214704.GC14542@obsidianresearch.com>
 <ecddc225-0dc5-c51f-535b-c2bee252d5ed@suse.de>
 <20170828060758.GD12880@mtr-leonro.local>
 <86a21008-c993-de29-2cb9-845af14c4cd5@suse.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="k3qmt+ucFURmlhDS"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <86a21008-c993-de29-2cb9-845af14c4cd5-l3A5Bk7waGM@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Nicolas Morey-Chaisemartin <NMoreyChaisemartin-l3A5Bk7waGM@public.gmane.org>
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--k3qmt+ucFURmlhDS
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Aug 28, 2017 at 10:17:50AM +0200, Nicolas Morey-Chaisemartin wrote:
>
>
> Le 28/08/2017 =E0 08:07, Leon Romanovsky a =E9crit :
> > On Mon, Aug 28, 2017 at 07:59:29AM +0200, Nicolas Morey-Chaisemartin wr=
ote: >> >> >> Le 27/08/2017 =E0 23:47, Jason Gunthorpe a =E9crit : >>> On T=
hu, Aug 24, 2017 at 04:49:54PM +0200, Nicolas Morey-Chaisemartin wrote: >>>=
 >>>> +install -D -m0644 redhat/rdma.conf %{buildroot}/%{_sysconfdir}/rdma/=
rdma.conf >>>> +sed 's%/usr/libexec%/usr/lib%' redhat/rdma.service > %{buil=
droot}%{_unitdir}/rdma.service >>>> +chmod 0644 %{buildroot}%{_unitdir}/rdm=
a.service >>>> +install -D -m0644 redhat/rdma.sriov-vfs %{buildroot}/%{_sys=
confdir}/rdma/sriov-vfs >>>> +install -D -m0644 redhat/rdma.mlx4.conf %{bui=
ldroot}/%{_sysconfdir}/rdma/mlx4.conf >>>> +install -D -m0644 redhat/rdma.u=
dev-ipoib-naming.rules %{buildroot}%{_udevrulesdir}/70-persistent-ipoib.rul=
es >>>> +sed 's%/usr/libexec%/usr/lib%g' redhat/rdma.modules-setup.sh > %{b=
uildroot}%{dracutlibdir}/modules.d/05rdma/module-setup.sh >>>> +chmod 0755 =
%{buildroot}%{dracutlibdir}/modules.d/05rdma/module-setup.sh >>>> +install =
-D -m0644 redhat/rdma.udev-rules %{buildroot}%{_udevrulesdir}/98-rdma.rules=
 >>>> +sed
> 's%/usr/libexec%/usr/lib%g' redhat/rdma.mlx4.sys.modprobe > %{buildroot}%=
{sysmodprobedir}/50-libmlx4.conf >>>> +chmod 0644 %{buildroot}%{sysmodprobe=
dir}/50-libmlx4.conf >>>> +sed 's%/usr/libexec%/usr/lib%g' redhat/rdma.kern=
el-init > %{buildroot}%{_libexecdir}/rdma-init-kernel >>>> +chmod 0755 %{bu=
ildroot}%{_libexecdir}/rdma-init-kernel >>>> +install -D -m0755 redhat/rdma=
=2Esriov-init %{buildroot}%{_libexecdir}/rdma-set-sriov-vf >>>> +install -D=
 -m0644 redhat/rdma.fixup-mtrr.awk %{buildroot}%{_libexecdir}/rdma-fixup-mt=
rr.awk >>>> +install -D -m0755 redhat/rdma.mlx4-setup.sh %{buildroot}%{_lib=
execdir}/mlx4-setup.sh >>> Going forward suse may not want to include this =
boot stuff from RH, >>> unless historical versions of suse used it or somet=
hing similar. The >>> new cross-distro stuff in kernel-boot basically does =
the same thing. >>> >>> I'm hoping RH will discontinue their version in new=
er releases. >>> >>> Jason >> Do you mean that all these should not be used=
 anymore? > > I
> think so, from the spotted immediately - "fixup-mtrr" - is not needed > f=
or sure. > >> The udev rules and the few new services are now sufficient ? =
> > This was the intention. > > I tried dropping those files from the packa=
ge and it does not seem to be fully functionnal yet.
> I'm running and a very old Mellanox card (mthca driver) and the rdma-load=
-modules@infiniband is not started. Thus ipoib and umad modules are missing.
>

Can you please resend?
It is not readable.

Thanks

> Nicolas
>
>

--k3qmt+ucFURmlhDS
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlmj3OEACgkQ5GN7iDZy
WKcJmQ/5AU6JLxt/5z0x3FGqPpt26iJURpA+CRILWcR/9DU3n3uyiZa9DrDwUVWz
sGD+5Hpt04HpKBzXRSTVsHTKEeY4TpS6u9z+49/PSv8P94dG9WLGwAQ6DmB6qSjY
YFgPmjvRYTaWS8WBgwLpYojH/7uDqqhH4pMiHYRXLFhv4hm06gCrruj3uQykAPQV
n4CU2/HkCPdcuZNU6nG9A95ud534JD19r6W+XvZrHy+RLJnnrhLiHWyeFfySwerh
VCIViKBqi5FUyB/qz6ibsG5FdirtnxE6zVid3ZJNismPxvXJuHKehdyDcYMm1Djw
RrZpQ3fElEnz/X1MavFSdnelyxGpyNZqWsJc2jCf9Ocwxe2LMhpX1gBe1ZAbmAeZ
8U7RtAGYIEaT+9URdxA1eCs17N2VmSvIw7MH8n3Reo2SBCm3C3leQAyKUmzH41zV
l6iPgc2IYGsTVH88+beyi7O7rQCbg9yORODXnRT0RtD43gYSrM0ZHL0/rtYoxOfI
RBCL64yg2lWFHCOma0lMXJWn33iWGzh/bv7Xim1jyqsuZEUv0JjsZhA1fT14rBvA
daVztYF0BDgBMXmgIqGgxPubun6UjZxCWCO8X6QjzSljn1NaJqCGWwDs3rV5ryEM
/WkHLptsRWR8Fdh5/yKXZtJtJu+QrXVIt81ZS17i4ZQF8H3eu+I=
=qpt/
-----END PGP SIGNATURE-----

--k3qmt+ucFURmlhDS--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
