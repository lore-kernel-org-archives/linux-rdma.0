From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-next V1 3/5] IB/core: Fix a potential array overrun
 in CMA and SA agent
Date: Fri, 6 May 2016 22:40:44 +0300
Message-ID: <20160506194044.GM29160@leon.nu>
References: <1462540026-12012-1-git-send-email-leon@kernel.org>
 <1462540026-12012-4-git-send-email-leon@kernel.org>
 <20160506182321.GB24503@obsidianresearch.com>
Reply-To: leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="YS7t75H5cNTCpbja"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160506182321.GB24503-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--YS7t75H5cNTCpbja
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, May 06, 2016 at 12:23:21PM -0600, Jason Gunthorpe wrote:
> On Fri, May 06, 2016 at 04:07:04PM +0300, Leon Romanovsky wrote:
> > -static struct ibnl_client_cbs iwcm_nl_cb_table[] =3D {
> > +static struct ibnl_client_cbs iwcm_nl_cb_table[RDMA_NL_IWPM_NUM_OPS] =
=3D {
>=20
> Why keep this hunk instead of using ARRAY_SIZE?

I tried to minimize my changes to original author patch. I'm sending
updated version.

Thanks for review.

>=20
> Jason

--YS7t75H5cNTCpbja
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXLPM7AAoJEORje4g2clinyicQAMAaBDagArMBwZgSceyQcZrT
6URdh4JkhKJubrthW4AVfnSGDatxCXrpb6IHS93QYoeQq3HeGqk8LBqbOfKxumeX
r6+gT/VZI3cZUIMPi4qcYvPVXM7eFSwXWMBVZoPUhVM/auXusrGYNzGUikNkvzTQ
1DvnkgrYUtgL42yEv6hGDz47XJq3IcdTL/+4xIkp+JngfJZ1f/OI8CYgZlY8zHj6
NUq0l1OWU3gMT3lKsVhZv0q1rlq5QBY7lo/WN5nTbcAZIwTA0Uz5S9Xj8fkVbyg8
qaA6/q1FO8J+HzufYSQMhlKoRoEdVGHw6G/ynHG6eL2cExlUEuIg/1awwS9Wmb69
1HoJZp6BGY3WH9Jl7dpQrl2/CEBuUm7jclUOfHYoImamdAt1V9XAdElbKDi6T+Df
cf6NfjNRKUMGEt/bflsudweNvL31Aoi4jjBTC6benAs0tEzHyLCKf0IFGWKxCwuU
XIfgCm4GWp55qrBa92AxnQLBUSgDmpW1zc598KU/zOmDTMkMmrYT8ar8TJZabdCJ
aZ8IF9Oug5DKnSO7x0YXe/dnHDM85ON+MWNOKnW0ahn7c2RFIcaO54XH2EtcHWlQ
lgxvaF0MO1rqQ67Jb4wF71qjqjFgWZyrnPmWC7l1JHvucq/SnLJMnGYaVCDkSIyU
acNK5lRUmHi7M7jDEUco
=Fswg
-----END PGP SIGNATURE-----

--YS7t75H5cNTCpbja--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
