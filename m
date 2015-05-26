From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH for-next 0/2] Export tos field to iwarp providers
Date: Tue, 26 May 2015 08:42:25 -0400
Message-ID: <1432644145.28905.94.camel@redhat.com>
References: <20150518202453.GA17572@TENIKOLO-MOBL2>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-GkTtbE1MVh/6EoudUJjB"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150518202453.GA17572@TENIKOLO-MOBL2>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Tatyana Nikolova <Tatyana.E.Nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, john.s.lacombe-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--=-GkTtbE1MVh/6EoudUJjB
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2015-05-18 at 15:24 -0500, Tatyana Nikolova wrote:
> Subject: [PATCH 0/2] Enable iwarp providers to use the tos field
>=20
> The first patch "RDMA/iw_cm: Export tos field to iwarp providers" is
> resubmitted, following the original submission from Steve Wise.
> The patch was deferred until the tos field is being used by iwarp drivers=
.
> You could see the email thread about the original patch here:
> http://www.mail-archive.com/linux-rdma%40vger.kernel.org/msg20140.html
>=20
> The second patch "RDMA/nes: Enable the use of the tos field in the nes dr=
iver"
> is introducing changes to the nes driver to use the provided tos field.
>=20
> Tatyana Nikolova (2):
>   RDMA/iw_cm: Export tos field to iwarp providers
>   RDMA/nes: Enable the use of the tos field in the nes driver
>=20
>  drivers/infiniband/core/cma.c      |    2 ++
>  drivers/infiniband/hw/nes/nes_cm.c |    7 +++++++
>  drivers/infiniband/hw/nes/nes_cm.h |    2 ++
>  include/rdma/iw_cm.h               |    1 +
>  4 files changed, 12 insertions(+), 0 deletions(-)

Thanks, applied for 4.2.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD


--=-GkTtbE1MVh/6EoudUJjB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJVZGoxAAoJELgmozMOVy/dC8QQAKzONELHSfeYboJWqpfi7vxH
oIt8hT31fJCpSKVX1w45gnnvCnAWoEgq5pwjGYgFRCK2V9HnDsGXEzf9x1Tm7P9r
lJ+mtQ13twjx++9wDIGOU+LWvmEJhhcR3NYetHkytmIXLgD46OyBYwH3V6VZYPCD
URKqDTfQDN00cBZ9BKdf1XvSz7d4uATefTt5friV+TmoefukDbQrLXDbYEU5EOG5
VrIQgBMOK0zd9Kp1I0GZSZuQRywVLGGsbFHUW2FgUI1txMiKgUSF1Dq67od+aY5g
ieiv4SZb9+g8HaJLoY2w01pZm0vutBDj7Pie6UQJJznVjnUpXzRjh1A5vRA2tK8Q
YdzGjmhPF7Q+susAx3ugNV+DcS18yoiz0HdKU+9TWb8cGjnj6I8nGUxPHpiBipDW
8MoX3LpXXlGiH0fL/6IOZ5A7hOop/1c2YIabcAiaJZdpvkzzp7Gq2PMC0z574C1v
5SW8HtpkPQdWURFiv4yaa1MSc3WPTplQxjpPf6YBtolPkU/ndORqSSC5Kjhli+nL
kcaV4H2P9uIL7kRxA7pfbfSnp1q1FnnLNqgCHb59YoiE1LvJCHDa4q5xBXNNbe6C
dTX+J0xrKlp/LMLjcUV3EXjULpkx+0aORLK4vKKOpTgjAFJREQSAWVVSHjXiHd1V
SzMMZkAcb9NHCy8OMC+l
=OcWN
-----END PGP SIGNATURE-----

--=-GkTtbE1MVh/6EoudUJjB--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
