From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [ANNOUNCE] libfabric release 1.0
Date: Tue, 05 May 2015 14:11:53 -0400
Message-ID: <1430849513.2407.254.camel@redhat.com>
References: <1828884A29C6694DAF28B7E6B8A82373A8FCA6CF@ORSMSX109.amr.corp.intel.com>
	 <20150505144211.GA17097@infradead.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-kxq04FKCrBpoURqbfns2"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150505144211.GA17097-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "ofiwg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org" <ofiwg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--=-kxq04FKCrBpoURqbfns2
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2015-05-05 at 07:42 -0700, Christoph Hellwig wrote:
> Do you have a non-buzzword version of the announcement that says it
> actually does as well?  Mught be better to send that one to development
> lists and leave the BS for social media.

It is a user space library and API for RDMA programming that isn't tied
to any specific form of RDMA hardware.  It abstracts away the things
that are different between, say, IB Verbs and USNIC and iWARP, and
presents a single API that works on them all.

To use an analogy I put forward at the Monterey developer conference, if
libibverbs (and the various extensions) are more or less like assembly
language programming, where the application has to make minor changes to
accomodate all of the various hardware types and extensions, libfabric
is more like the C programming language version of RDMA programming.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD


--=-kxq04FKCrBpoURqbfns2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJVSQfpAAoJELgmozMOVy/dR1EP/1ebTiPF0CdHtT2CjIZGeE7O
CT46i3sQOL+SLefqf7XIHI3WCXKAIopHNqUyQ4iAJHjFu1Pz0GPfgNgsQgdDvCqY
6TRfRsFbjAqUAfHp1k33A+Lmr5gS+/kx7u0ny5dRd1yIP6eXUSBoXnY4H73pNCo+
iPtIl+MGuCtqgDnZOHMRrvOZRQOxtADywsGoJ4Tbplme8CypRCfYKrnasvB9nWsi
MJ1CiW3N2LyOmnFitIIvc/os18kWgbXmOMtjdgsHDVcUX0l5dqNDw7bYXILyAOIV
LBo0O5WMvZmceSe9qhFW7R4bKV6DZTOgmNkIJ+GPWwc++6pznj05JGRCDuEDhLxE
i0fBSIkPVL1fNkfssV9cCvE6kcGXWnOXe558dX3bO7ZTgOcf1rp0OypnMkllyHST
Fe77RdGhK9ML6QBiCmwK1gJy7ZxxYJMGlw+lPBXnwAGQQRbKKfhdFL1rTQb1Ptwl
CcopPjHFmL26m4n+1I9XmOEVnddhUIetVqb2W1+SnDqWZpeLMRSNUVw6k/d0bnVf
XW8j1MioKFoJe6VMa4ulUuoecImrt2JAiWasOxWAqspuyrneLY0KBja/VV5QgP67
uQvaNZvrBvabWhFXUVbWGFQAgkEeyc2convbhpfEaQ6ILLSqK2deuYzjFTSqJc4y
1s/GC86OE17y8tD8Nq8q
=6oCG
-----END PGP SIGNATURE-----

--=-kxq04FKCrBpoURqbfns2--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
