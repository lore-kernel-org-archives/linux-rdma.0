From: Leon Romanovsky <leon@kernel.org>
Subject: Re: [PATCH rdma-rc v2] IB/core: Only enforce security for InfiniBand
Date: Wed, 29 Nov 2017 07:11:15 +0200
Message-ID: <20171129051115.GS29104@mtr-leonro.local>
References: <20171127112554.29666-1-leon@kernel.org>
 <bd207403-a03f-5ced-7f44-6294c5a3ac8e@redhat.com>
 <47653af5-68af-0aa1-e811-0d6d42935648@mellanox.com>
 <16d5d4c2-ea9e-765a-b0b7-a867c6a757d6@redhat.com>
 <71158cbc-030c-41f7-5ee9-d930bb6c4849@redhat.com>
 <69c9bc09-7d95-3fef-f1c9-487b34af8300@mellanox.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="e8/wErwm0bqugfcz"
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <69c9bc09-7d95-3fef-f1c9-487b34af8300@mellanox.com>
Sender: stable-owner@vger.kernel.org
To: Daniel Jurgens <danielj@mellanox.com>
Cc: Don Dutile <ddutile@redhat.com>, Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>, linux-rdma@vger.kernel.org, Paul Moore <paul@paul-moore.com>, stable@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org


--e8/wErwm0bqugfcz
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 28, 2017 at 03:03:39PM -0600, Daniel Jurgens wrote:
> On 11/28/2017 2:38 PM, Don Dutile wrote:
> > On 11/27/2017 06:28 PM, Don Dutile wrote:
> >> On 11/27/2017 05:58 PM, Daniel Jurgens wrote:
> >>> On 11/27/2017 4:03 PM, Don Dutile wrote:
> >>>> On 11/27/2017 06:25 AM, Leon Romanovsky wrote:
> >>>>> From: Daniel Jurgens <danielj@mellanox.com>
> >>>>>
> >>>>>
> >>>>> -=A0=A0=A0 if (pps_change && !special_qp) {
> >>>>> +=A0=A0=A0 if (pps_change && !special_qp && real_qp->qp_sec) {
> >>>>> =A0=A0=A0=A0=A0=A0=A0=A0 mutex_lock(&real_qp->qp_sec->mutex);
> >>>>> =A0=A0=A0=A0=A0=A0=A0=A0 new_pps =3D get_new_pps(real_qp,
> >>>>> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 =
qp_attr,
> >>>>> @@ -600,7 +627,7 @@ int ib_security_modify_qp(struct ib_qp *qp,
> >>>>> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0 qp_attr_mask,
> >>>>> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0 udata);
> >>>>>
> >>>>> -=A0=A0=A0 if (pps_change && !special_qp) {
> >>>>> +=A0=A0=A0 if (pps_change && !special_qp && real_qp->qp_sec) {
> >>>>> =A0=A0=A0=A0=A0=A0=A0=A0 /* Clean up the lists and free the appropr=
iate
> >>>>> =A0=A0=A0=A0=A0=A0=A0=A0=A0 * ports_pkeys structure.
> >>>>> =A0=A0=A0=A0=A0=A0=A0=A0=A0 */
> >>>>>
> >>>> This patch breaks the kernel build on RHEL b/c it generates
> >>>> a warning in the second if (pps_change && !special_qp && real_qp->qp=
_sec) {}
> >>>> that new_pps may not be assigned. ... build warnings in RHEL kernel =
=3D=3D build failure (on x86).
> >>>>
> >>>> That's b/c the patch adds real_qp->qp_sec to if's conditions,
> >>>> and=A0 the compiler cannot determine if real_qp->qp_sec cannot be mo=
dified
> >>>> between the first check like it, above, which sets the value of new_=
pps,
> >>>> and the second check that uses it, because real_qp is passed into th=
e device->modify()
> >>>> function call btwn those two if() check's.
> >>>>
> >>>> The code needs to do something like this in the first if-check:
> >>>> =A0=A0 .....
> >>>> bool new_pps_gotten =3D false;
> >>>> =A0=A0 ....
> >>>>
> >>>> if (pps_change && !special_qp && real_qp->qp_sec) {
> >>>> =A0=A0=A0 mutex_lock(&real_qp->qp_sec->mutex);
> >>>> =A0=A0=A0 new_pps =3D get_new_pps(real_qp,
> >>>> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 qp_attr,
> >>>> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 qp_attr_mask);
> >>>> =A0=A0=A0 new_pps_gotten =3D true;
> >>>> =A0=A0=A0=A0=A0=A0=A0 ....
> >>>> }
> >>>> =A0=A0=A0=A0 ....
> >>>>
> >>>> and change the second if check to be:
> >>>>
> >>>> if (new_pps_gotten) {
> >>>> =A0=A0=A0 * Clean up the lists and free the appropriate
> >>>> =A0=A0=A0=A0 .....
> >>>>
> >>>
> >>> Thanks Don, I think it's better to initialize new_pps to NULL, vs int=
roducing a new variable. Also, there needs to be a check of new_pps after g=
etting it.
> >>>
> >> yup, I considered that as well.
> >> wasn't sure if lockdep checking code would not like the fact that a mu=
tex_lock() could be taken,
> >> but if new_pps =3D=3D NULL after the get call(it may always succeed, b=
ut an analyzer may not conclude the same),
> >> that the mutex_unlock() wouldn't be called.
> >>
> >> the double, same-condition if-check with the fcn call in btwn seems li=
ke it ought to be
> >> restructured differently so the mutex lock/unlock pairs are contained =
neatly in a single if-clause,
> >> and the new_pps alloc & use would be similarly containted.
> >>
> >> -dd
> >>
> >> -
> > Is someone doing a v3? I didn't see an email today w/another patch vers=
ion.
> > ... at least I wasn't directly cc'd on one anyhow... off to check linux=
-rdma folder...
> > nothing there... and I don't find a v3 in Leon's tree either.
> >
> >
> I sent a fix-up patch to Leon, but it seems he didn't get to it today. I'=
ll resend this afternoon.

Thanks Daniel for handling this.

>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--e8/wErwm0bqugfcz
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAloeQXIACgkQ5GN7iDZy
WKcfYQ/9E+O4UpTFR9rinkFTb2oYv8fX9xZvd2tsR/CwcSHHnRIL5PbCS58S7a9x
UYr34XYeDI45iIi8FZv4Mz7HEbknIduSqlBIb7EwyV5+TpIi0xiicT21uUhCz5qy
jAe6CssbPQug3ZDP+xEYX+atijKAn9/5zyz+N3NzV6IciEdmkGW/dwD3WB1tcjVE
s7Y4b9AEhp8g/biq18jNssDqpQp6heeYuQXzkU408T3CyuNfDrC5BODz0D1H5bF4
NJDsToWDjeIZ7BMlcyBDQacK896FoOBKWFTyQs9pa6w9M1THyf2zM0HeAmj3sa4O
SPNvH8OCRVnnw2/a/y6snTSGChiC727MeOs1zNCdtxH0xwV2J6fQ/GzfALZUf53m
MDfoVYPIBUexhAeSq+tRbzflXBJanr0RS9j0SVFPxcbg22haIaKUJdF06hIkzbdd
97/u4rrs3YpZ+HlvuDJyUiuC1FqwclBTFWj9/I7mby8JWCBke7/k6adjU5RznwkZ
CmK1yqVQZvkXkTY+T/WfqZOLakpO3OheS1HQQ25LybrfmvcnlNi727ba0q7lCn8L
7r9Ez/PXs+QZk7spbf4gMdk5nbw+7nXpmvwDwF+7GYMdXWzLTA1jiW+ravqEJ0lx
mtQRXs/ZpomoKHf34iormgBQm6SFtWD4EvvwOsQMmMFFXJWsBlM=
=kLj5
-----END PGP SIGNATURE-----

--e8/wErwm0bqugfcz--
