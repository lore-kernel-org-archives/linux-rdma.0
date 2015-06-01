From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH for-next V2 0/9] Add completion timestamping support
Date: Mon, 01 Jun 2015 12:39:47 -0400
Message-ID: <1433176787.114391.193.camel@redhat.com>
References: <1433074457-26437-1-git-send-email-ogerlitz@mellanox.com>
	 <1433098827.114391.179.camel@redhat.com>
	 <CAAKD3BBo9A5AV9Uv-q1TgSQ6hs-oSUn5QsUT+5+6mk1RwW7AUA@mail.gmail.com>
	 <1433157904.114391.188.camel@redhat.com>
	 <alpine.DEB.2.11.1506010852360.26845@east.gentwo.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-1Xt2wRopu7GBn+OUs6tg"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.DEB.2.11.1506010852360.26845-wcBtFHqTun5QOdAKl3ChDw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Cc: Matan Barak <matanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Amir Vadai <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--=-1Xt2wRopu7GBn+OUs6tg
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2015-06-01 at 08:58 -0500, Christoph Lameter wrote:
> On Mon, 1 Jun 2015, Doug Ledford wrote:
>=20
> > What's the point?  If it's raw, it's raw.  It's not coordinated between
> > adapters.  Whether it's in ns or ps or flipflops doesn't matter, it's a
> > flat number that has no reference to anything else, so the only thing
> > that matters is < another version of itself or not.
>=20
> It can be coordinated between different adapter through the use of time
> software that can work with cycles and frequencies to scale the value of
> the cycles to realtime.

And that is precisely what the cooked values should be.

>  Software like that is available in ptpd,
> timekeeper etc. Each NIC basically has its own clock and the timekeeping
> software would have to track the scaling and the aberration factor over
> time in order to come up with accurate absolute time values derived from
> the cycle counters of these NICs. Since we are dealing here with values
> that need to be accurate to within less than 100ns this is not trivial an=
d
> one can easily get a ns value that is absolutely useless.

Agreed.  The cooked value is not going to be a simple thing.  I fail to
see how this is making a case that we should duplicate that code in
every app that uses a timestamp versus getting it right once in
libibverbs.

> Since it is not trivial its better kept out of the timestamp support in
> the RDMA API. If the app developer wants a trivial conversion then they
> can opencode a simple multiplication by the frequency. At that point it
> should be clear though that this raw time value is of limited use given
> its inaccuracy  and the dependence on the NIC clock.

The raw value is just that: raw.  And it *is* of limited use unless you
only have one adapter.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD


--=-1Xt2wRopu7GBn+OUs6tg
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJVbIrTAAoJELgmozMOVy/d+w4P/RcUiXI34CFT0C2YMNMShSqa
gL3S8PNk2W6lFL8pDWlYO78K+GM6LQTvufpCbCLkyR8cJxUTcKhq3lT49gEz5Dvo
GINiEeAJAn0OUfzPZ0eRXhS5BMvrqkHT9W8b0HzxS/s2jqNS6UKqb4X5ByN2wWbz
G1hIKHiLo8R2ysnHVoAARp2Ycxztf/hlBgo7bL6IaK8xTylXi8xFmcoQxYrDHqM7
I11qstfjh9XQGZT9FXlOKSdFu9sWfXUEM+oV1F4ErIkTBjWrCPsNgbUqc/DUurf9
57CZOJT2d4fqhsdggzlVFsfKsJdBXbdTunRHF6RWUtbsKy7FMbzadbER3Ps1trBG
98sff5ICiReXf1TuCnUjb+QNcl2+Sa2qQSCQOq7+OWojYwSFrKLFtY5QiFfyPnlK
d+Oed3nzX7kfVOhMuABCvlFI3R3UfnXBKXNVLtSQLjRorJ9B7/a1Sjmh+uhuJMhg
k8CwUkuYTNUVot8o+AO0fNS6Cyin4D16c0h4GkNro7Zr4YTWugo+jlwVuzNegoOC
Wb/DdI/NL/N1miOb9S6gDn7S8PgBQFTuM3o6Ss11qsPIe3XDD1i4eyv/xYr9TAQK
eMJunk1b21kJP+B8XI/9mHmOwsv5Ab1y5kyP1MMemN7qUfgQv80UlYbxWxApfUhy
pJ21Os6Fdn6K7lr7r+NP
=ZquL
-----END PGP SIGNATURE-----

--=-1Xt2wRopu7GBn+OUs6tg--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
