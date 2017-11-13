From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: rdma-core stable releases
Date: Mon, 13 Nov 2017 09:08:56 +0200
Message-ID: <20171113070856.GZ18825@mtr-leonro.local>
References: <CY1PR0701MB2012C57AB3FDE0232D72F70688500@CY1PR0701MB2012.namprd07.prod.outlook.com>
 <20171106182756.GD18802@ziepe.ca>
 <6012d1c3-cd18-25e8-c5ae-3d678142177b@suse.de>
 <54347E5A035A054EAE9D05927FB467F9B61778A9@ORSMSX101.amr.corp.intel.com>
 <20171110202455.GP18825@mtr-leonro.local>
 <20171110211448.GF17451@ziepe.ca>
 <1eba9063-80a4-ad9d-4adf-93770b9ed7c9@suse.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="44EoV7tf2AX9r8hV"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1eba9063-80a4-ad9d-4adf-93770b9ed7c9-l3A5Bk7waGM@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Nicolas Morey-Chaisemartin <NMoreyChaisemartin-l3A5Bk7waGM@public.gmane.org>
Cc: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>, "Davis, Arlin R" <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Kalderon, Michal" <Michal.Kalderon-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Elior, Ariel" <Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, "Rahman, Ameen" <Ameen.Rahman-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, "Amrani, Ram" <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, "Radzi, Amit" <Amit.Radzi-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--44EoV7tf2AX9r8hV
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 13, 2017 at 08:01:48AM +0100, Nicolas Morey-Chaisemartin wrote:
>
>
> Le 10/11/2017 =E0 22:14, Jason Gunthorpe a =E9crit=A0:
> > On Fri, Nov 10, 2017 at 10:24:55PM +0200, Leon Romanovsky wrote:
> >> More or less, you wrote everything that I expected, just need to post =
it
> >> as a patch so I can apply it to rdma-core.
> > Also please describe how to get patches into -stable, eg similar to
> > the kernel, mark with fixes and cc the stable maintainer.
> >
> > There should also be absolutely no ABI changes in the -stable branchs.
>
> Agreed. Ideally we would add something to CI so that it detects ABI break=
e on stable branches.
> I know SUSE has something like this for maintenance fixes. I'll look into=
 it.

DPDK runs ABI compliance checker.
http://ispras.linuxbase.org/index.php/ABI_compliance_checker

I would love to see it running for rdma-core.

Thanks

>
> Nicolas

--44EoV7tf2AX9r8hV
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAloJRQgACgkQ5GN7iDZy
WKdktw/+N+kW9OA6eMwR7z0/0mOFdZTQuYhsWOZBFg/h20NbcF3znIAbIG0zHjC+
+AObfKaMdjxwt/wLxY3PgBqBEmrxgCDmaRnpBO6pH9GLaD/siMZ+LRqO+b8f7Gnh
Ahe6sOHCdZ77huuIK2uCVekgUu+9uFjMvJs1SuURFDPUKeBevUbeFFH3Liy3povt
YwXHH6lqv2MUr2b9rMPDcOz+FLUspupR+L6sOOemVBrlqPX0nJ3tuds6bZw/9k3U
dzZ02a33R/bQZUA94b3AdkXcTDW5qibdVL7rfq9y5GN/il1LiqtKfMrizLpZCnO+
FpcRKIDpDFYQ6w2oEAGH8E+b8vA/0A154n0ISKtMSYuBf1e3/RJWy67q+qWbcif6
MDLZnnHNCNYuWUb42jNM2XJdTTmbHbaU2EBEEoC/yLlzCtDS+9tMtSONGX0fcPeB
JMj0h+O0Y0hEf8r3TaFeW2HNzDab4LmufNki8cuBncDHRv3EKj3Vm0+/Gj6dOS0W
yV8HGfmeUoW3+u6soSgDzWetyavDsxF5kX1x0HPGqmehsdFGWlbi7YrDYfwW2dAX
rlJl6VS5eoERzUs1R4H7QuzX2lyFt230x9RX9ub/FpGHuR5Li+D2eghEWwJY8HTS
kzJr/K2dgz2V0NWESCU/va7Ih7Hi7JVkmmMEaujKxS7cTzUedTQ=
=gJhn
-----END PGP SIGNATURE-----

--44EoV7tf2AX9r8hV--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
