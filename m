From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: Stepping down as maintainer (was Re: [PATCH for-next 0/9] mlx4
 changes in virtual GID management)
Date: Wed, 22 Apr 2015 10:43:29 -0400
Message-ID: <1429713809.45956.105.camel@redhat.com>
References: <1428858993.3470.12.camel@dworkin>
	 <20150413164238.GB17521@obsidianresearch.com>
	 <4EC214DA-97F8-4BCD-AEA6-6FB539E820F1@redhat.com>
	 <20150414234258.GA25810@phlsvsds.ph.intel.com>
	 <232BEA5DF26EF54583B8B332938DD0B84BB8E335@CMEXMB1.ad.emulex.com>
	 <F6B0F954-1E60-4CE9-AF39-7A6E8C8EC47B@redhat.com>
	 <20150416201310.GA24838@obsidianresearch.com>
	 <CAJ3xEMizgYb2DfbJxTCb2=zYQA60p5LfeJQ+TJuBa6HnWKvMCQ@mail.gmail.com>
	 <20150416213726.GA26437@obsidianresearch.com>
	 <1429221799.2980.488.camel@redhat.com>
	 <20150416221853.GA26834@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-acjFmgLHo/PklK4+5xyI"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150416221853.GA26834-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--=-acjFmgLHo/PklK4+5xyI
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2015-04-16 at 16:18 -0600, Jason Gunthorpe wrote:
> On Thu, Apr 16, 2015 at 06:03:19PM -0400, Doug Ledford wrote:
> > > AFAIK, capturing provided tags is considered best practice as a way t=
o
> > > recognize and retain contributors.
> >=20
> > Agreed.  I'll double check them tomorrow.
>=20
> These are two I noticed from memory:
>=20
> http://permalink.gmane.org/gmane.linux.drivers.rdma/24423
> https://lkml.org/lkml/2015/4/15/9=20
>=20
> Jason

Those have been fixed, and a few additional items have been added to the
overall set and pushed to my github.

New items since the last push:

Jason's fix to the CMA for IPv4/IPv6 canonization
Hariprasad's series to iw_cxgb4
Tatyana's and Steve's series for iWARP portmapper address resolution

git://github.com/dledford/linux.git for-4.1

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--=-acjFmgLHo/PklK4+5xyI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABAgAGBQJVN7ORAAoJELgmozMOVy/dsVcP/jl0CCT9f2klkYoosZPlufv5
KOCSVtnT/FC/o3Sp+DjAVJ1Iwn4uCgOuz69yPpdO5l/U8dQtraQa8YCpmGYqV4Qc
/PoVc12lio/+5KJSCRqSANxj/GExVQUt3qbr9wxE1jeYoO65gvZPsR0rsvpJNynm
t02xysI7tTKeXydy9LjC7X/wWcNEApmNKf3PEYc5RdRjRBp8bNjln8IPbvxRyoPK
JP2LRJR4HnyPhuI8vtJN5fp/KJcBuWMaKp3De7GnG3U/r3Uc2zx/bB9YwRRAgG5p
KJD6Ptk4UbWCqD53ad0lpkOC18cf38J5ft5F3Ss8Mnaa9V8kP/3KXc1vE9AbNkoA
eA5RwwpHe0hqSWP0KQcg8yRxtX/oykU4G5jIoIcuemoSLhbzcMLpWY9KLMhqg4az
9H4+r+v/i2ada71NgFYkWbKSAihLOZMYsYVsP5ZiLaLl5psqAAKqVQ6IcbLadjvH
0CQYAy9FP8jqQkUJX8Lvx/tUTKz5yTU4ryPbmvdoDP9qlT5oI44UW8zDbEushoud
F6U7ZUuPBhUFkb4lEtfh+7WhlgNKp9ZRduwfc5RSDCOrK+Xd/6MM39QLivz6B1fs
wHLma2E2uUEFkJbs2zPxS94/a0aTzrF4+bu2dTDTBakRY5o4kcxjXNjuws0l7B+Y
tR2m4PMUCPpMYDc/pwag
=cV7X
-----END PGP SIGNATURE-----

--=-acjFmgLHo/PklK4+5xyI--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
