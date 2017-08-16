From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [rdma-next v2 07/23] RDMA/core: Remove unimplemented node_types
 and node transport
Date: Wed, 16 Aug 2017 19:21:03 +0300
Message-ID: <20170816162103.GT24282@mtr-leonro.local>
References: <20170815085452.3546-1-leon@kernel.org>
 <20170815085452.3546-8-leon@kernel.org>
 <SN1PR0301MB2127376FC9B3D170C878A47BDE8D0@SN1PR0301MB2127.namprd03.prod.outlook.com>
 <20170816053744.GD24282@mtr-leonro.local>
 <SN1PR0301MB21274177B67EE02B96F14424DE820@SN1PR0301MB2127.namprd03.prod.outlook.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="xYEba/cIt2nZJmCG"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <SN1PR0301MB21274177B67EE02B96F14424DE820-VLIetriUNob/KlJXleiaIJwN6zqB+hSMnBOFsp37pqbUKgpGm//BTAC/G2K4zDHf@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Suri Shelvapille <suri-lFb5ksp6isWhEniVeURVKkEOCMrvLtNR@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--xYEba/cIt2nZJmCG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 16, 2017 at 02:30:05PM +0000, Suri Shelvapille wrote:
> Leon:
> Our Drivers are not in Kernel (being a small company we don't have resour=
ces to make it in-kernel). When I and Hal worked on adding the switch capab=
ility into the kernel, we thought it would be useful for the community (as =
there was interest in a few others besides us). Philosophically, since SWIT=
CH and ROUTER definitions are part of the IB spec, don't you think having t=
hese definitions makes the kernel close to spec and hence useful? I know th=
ese definitions can be easily added into our drivers.
> Just treat this as a request, if it is not an onus to the community, plea=
se keep the SWITCH and ROUTER (only) definitions. If you have strong reason=
s I have no objections to your patches.

It looks like I need to explain the rationale why I did this patch.

RDMAtool presents various information from the kernel, one of such info
is the node_type. In order to correctly present it, I was asked to expose
possible node_types through UAPI files.

These files are done with extra care and my goal was to provide the minimal
set and the most cleanest exposure, so I cleaned everything in those paths,
=66rom the lowest possible layer to highest possible layer.

One of such cleanups were removal of node_types fields, which don't have
in-kernel users and against software development principles - don't
leave dead code.

So for now, I'm leaving this patch as is.

It is far below my lowest quality bar to leave those fields in place,
but if members of RDMA community prefer to go such low, they should
speak and explain publicly why RDMA subsystem is different from the
rest of the kernel.

Thanks

--xYEba/cIt2nZJmCG
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlmUcO8ACgkQ5GN7iDZy
WKfDYQ/+NXUiT0Mx96LoX7JjfeanRFTpqRAd8udfEDcN+uLVXxDN5unuXzgxGY/U
hspaRWBSm9JC2hsRPjMFrQNO3m6MxBOxNG+G1SKmkGGr7hBKDnwcoeLjA/J4AAiJ
0b/eAg5eAhHw/bysB10oUUY1MZoawxo1a3IKJC6NF+vxh40+QhU/GCTHoV5TelE8
HCmOWxlxXOjD75miCDa+IQbJn197gbFxsE1/PcD8tFm1bOLsj9bU4Ou2ld8wBwt4
lDgkxP2X7kf135sLP1eus3pCD8srdWc5qBGMlQelIkblsAaLxkWATleVgZM8+h00
CJBkYUxm3c2Py41sko1KhSOGF2LlICPga1w/1wcbtFFFMTW0Cx6SiGk7rt2GJyw9
jF64DGwPrXbYaDoh9h5T41X1VwwU4/od9LrRjWJJvkvAhyTQJbN4ibKFK5UFrxnL
q8TNwDOvFuiTRMwNLcKi2oF7GQn9ufQDl+EtmN2pFhvPKLQxtCPvLB+COVSGHHk2
b3RMZejBu6yi5GGl/iP8pXhUkR/POcp9wuXqM9SFH6ozjAIce5emdadxuzYFv1wo
96+e3UKlDupo6NgGCQWqRXebxl03NmfzUt/A8+pYnprTtla+/hGEMxcibjLObCp4
ijRx+x4MlJEbbjhN3YoGB3QJ+7EF4pJKL9XaOZgRAwSOYCzo7Aw=
=PFJH
-----END PGP SIGNATURE-----

--xYEba/cIt2nZJmCG--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
