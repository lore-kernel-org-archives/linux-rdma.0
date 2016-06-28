From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: Upcoming libibverbs release
Date: Tue, 28 Jun 2016 19:22:42 +0300
Message-ID: <20160628162242.GD3584@leon.nu>
References: <3b89c411-72be-ddc5-5ebf-009eeee29692@redhat.com>
 <4ec1d8e6-a908-bb49-a137-415856ec6faa@dev.mellanox.co.il>
 <20160627181758.GD23540@obsidianresearch.com>
 <20160628050246.GB3584@leon.nu>
 <1467129133.8638.75.camel@oracle.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="7DO5AaGCk89r4vaK"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1467129133.8638.75.camel-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Knut Omang <knut.omang-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--7DO5AaGCk89r4vaK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 28, 2016 at 05:52:13PM +0200, Knut Omang wrote:
> On Tue, 2016-06-28 at 08:02 +0300, Leon Romanovsky wrote:
> > On Mon, Jun 27, 2016 at 12:17:58PM -0600, Jason Gunthorpe wrote:
> > > Doug and I have both stated we don't want to see so many
> > > single-provider APIs and churn in libibverbs. This was designed to
> > > be
> > > a generic API that all providers can implement.
> > >=20
> > > The responsibility falls on you to make sure that it works
> > > universally. Compat is one option.
> > >=20
> > > This is also why it is necessary to get the other provider authors
> > > to
> > > say this works on their hardware, because they *all* ultimately
> > > have
> > > to implement it.
> > >=20
> > > I don't think many people realize this yet.
> > >=20
> >=20
> > Jason,
> > You are over-estimating the number of other providers who are
> > interesting in libibverbs in 2014-2016.
> >=20
> > According to git log [1] in these years, I see only one major
> > contributor to this library.
>=20
> I appreciate Jason's concern for other providers, I can assure we both
> use libibverbs for the new Oracle HCAs and also have changes/fixes to
> it. I want to get them out here, just a matter of getting enough time
> set aside to catch up (with the recent churn on both sides of the
> kernel/user boundary)

It is great and we all be happy to see more players in that field.
However it is not enough to use this library, Jason wants to see commitment
=66rom other vendors to be ready to implement new proposed features.

>=20
> > [1] https://git.kernel.org/cgit/libs/infiniband/libibverbs.git/log/
>=20
> Thanks,
>=20
> Knut
>=20
> --=20
> Knut Omang, Ph.D
> Principal Software Engineer
> Oracle NSN Europe Design Center
>=20
>=20
>=20

--7DO5AaGCk89r4vaK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXcqRSAAoJEORje4g2clino3IQAKx4XjupALlKC10HYPOtQ8X+
1KIbckg7mXbeCtYAUxsg3gNiJ+jengogde3BCner9XP9azhEPcjrDcTYTSkoT++9
s8VzDyKzJfWk3rCtwdkda+Lj+wiarUx/SQG9mRGyYthS+D957boikrrBYzVuIj9E
682HbPOm2+4FVLztQq5jwoXMcVs1j/QzUMOMhDjCsziIWffkCIr4jliwnGzfCDcK
hsdLAoV093r2rxfY9IGkeLTsnm187XKWI9bQ88c2oHowC0wsg6lMbswncrW5tKxY
oC3p6GoCWWYYZtlD6ug8LJSu9C4GNaiIQyBSwDkYOBEm1bxjVl0xWc3mDeJMh1I/
3dc/vghMYxaLsIxHgehhnNTDyw4aiK2vAg6VCEfOiKDkR7IqRrll2MUPQOhZgP8D
AQh68JUrzyRUVOu0h7p/QV0gnDFjoPN+v/u1Q25rYMaSW/8ebEzA8O4meyJZgy74
CqvOeE0Raa+YC+CU0WeRNHobxG9U0MIRcYdTTZBLqxrxXImai/33DfvBb5X/2Feb
F+pYRov/nNlRYsGXGH5DH2hWwf9jce49VW0MvgoUiIhK+pVQ/t5oAPZazOEkT5va
ZKTt5YBtl8yHxNLbpri+MwKBDrVTAYmtuI8vLZj/PlmrwfWFXEC3YQFlNSs8VyL8
TaU+AZ7MNO4GuIOq5Xls
=3AEk
-----END PGP SIGNATURE-----

--7DO5AaGCk89r4vaK--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
