From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: rdma-core stable releases
Date: Mon, 13 Nov 2017 09:41:12 +0200
Message-ID: <20171113074112.GC18825@mtr-leonro.local>
References: <CY1PR0701MB2012C57AB3FDE0232D72F70688500@CY1PR0701MB2012.namprd07.prod.outlook.com>
 <20171106182756.GD18802@ziepe.ca>
 <6012d1c3-cd18-25e8-c5ae-3d678142177b@suse.de>
 <54347E5A035A054EAE9D05927FB467F9B61778A9@ORSMSX101.amr.corp.intel.com>
 <20171110202455.GP18825@mtr-leonro.local>
 <20171110211448.GF17451@ziepe.ca>
 <1eba9063-80a4-ad9d-4adf-93770b9ed7c9@suse.de>
 <20171113070856.GZ18825@mtr-leonro.local>
 <5d8ea61a-2b48-ef39-a617-c0cc75066bc0@suse.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="vdyjigDobekge4RG"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <5d8ea61a-2b48-ef39-a617-c0cc75066bc0-l3A5Bk7waGM@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Nicolas Morey-Chaisemartin <NMoreyChaisemartin-l3A5Bk7waGM@public.gmane.org>
Cc: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>, "Davis, Arlin R" <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Kalderon, Michal" <Michal.Kalderon-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Elior, Ariel" <Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, "Rahman, Ameen" <Ameen.Rahman-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, "Amrani, Ram" <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, "Radzi, Amit" <Amit.Radzi-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--vdyjigDobekge4RG
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 13, 2017 at 08:18:02AM +0100, Nicolas Morey-Chaisemartin wrote:
>
>
> Le 13/11/2017 =E0 08:08, Leon Romanovsky a =E9crit :
> > On Mon, Nov 13, 2017 at 08:01:48AM +0100, Nicolas Morey-Chaisemartin wr=
ote: >> >> >> Le 10/11/2017 =E0 22:14, Jason Gunthorpe a =E9crit : >>> On F=
ri, Nov 10, 2017 at 10:24:55PM +0200, Leon Romanovsky wrote: >>>> More or l=
ess, you wrote everything that I expected, just need to post it >>>> as a p=
atch so I can apply it to rdma-core. >>> Also please describe how to get pa=
tches into -stable, eg similar to >>> the kernel, mark with fixes and cc th=
e stable maintainer. >>> >>> There should also be absolutely no ABI changes=
 in the -stable branchs. >> >> Agreed. Ideally we would add something to CI=
 so that it detects ABI breake on stable branches. >> I know SUSE has somet=
hing like this for maintenance fixes. I'll look into it. > > DPDK runs ABI =
compliance checker. > http://ispras.linuxbase.org/index.php/ABI_compliance_=
checker > > I would love to see it running for rdma-core. > > Thanks > >
> The only issue I can foresee with these is that we need to run the ABI ch=
ecker on both the "old" and "new" versions.
> We would probably need to do something at release time to generate and pu=
blish the ABI xml file somewhere (either in the repo, or github) so that we=
 can check against it later without recompiling it.

We can publish it together with released files in github release section.

Thanks

>
> Nicolas
>

--vdyjigDobekge4RG
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAloJTJgACgkQ5GN7iDZy
WKePRxAAgOgBwZVdoy76X6SkUyEE601wEqQpSrHbhvJLFLRIrEEk6Q0QFHNsgbP4
HX0iQ2j7w1lo247tmc81UyreGaJEDizUODPoUUdGJ3tuKorSa6GWFQsKiM7rOSWH
yoH3j4EGxwFGQeNYPybQCshCsAeF7rSRFjsXIWjqzb235zN+rpvbFFvMXa2MzxhW
j+Fii8+kMKxRjuoxrY4YY++AQx+gaoVbD3/8ty61156Kl2OB+fE5uDL6Qtcw+QsN
JzkxuM/aziGi+w4NfHWFSO/7/gtX2UXMChGQhG393Slg0wITCjtSarFYvsI+FFpT
HcHWdGRB6RM3wQsW/qVUXwfR5+yhPpWnQG7plo4GIbr0T2Ca9cVJM4vTe1vDjZno
ALp/RYDalBglUrhzX3+Pu76HacI1q0HitGa6XbvMtTh6GDmTE5OCw+ffGpFE2mbF
4kxY7E3QdsVY6HtSuGtXygv9AMJHe9vfU9ESfOZFW9pFUEdEShZ4U6Mr+p8ycabJ
ldM3AibYIiPCki3MA77rg4Xo8+3DKGxEfdbaCuB3CAZa/OQ4KtzlK12/Jh4KHzDp
QzGRTdA+KdhLlEkR6dsWsTKLeJTA9BGKzf+eiuUn+f12rLZdYlDhKIGwDegEw7zB
hJIwHqoJXOv0tFURclN42EWBoUsilyYNM8o5vEe75znu5opDVaI=
=M2+L
-----END PGP SIGNATURE-----

--vdyjigDobekge4RG--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
