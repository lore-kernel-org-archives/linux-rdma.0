From: Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Subject: Re: daily Ubuntu PPA builds for rdma-core
Date: Tue, 07 Nov 2017 13:02:09 +0100
Message-ID: <1510056129.25086.14.camel@profitbricks.com>
References: <1510052419.25086.12.camel@profitbricks.com>
         <20171107113857.GG18825@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-p4hwatUbnBAQz2vGU0yk"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171107113857.GG18825-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--=-p4hwatUbnBAQz2vGU0yk
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Am Dienstag, den 07.11.2017, 13:38 +0200 schrieb Leon Romanovsky:
> On Tue, Nov 07, 2017 at 12:00:19PM +0100, Benjamin Drung wrote:
> > Hi,
> >=20
> > are you interested in having daily Ubuntu PPA [1] builds for the
> > rdma-
> > core master branch on Launchpad? I could set them up easily and
> > they
> > would produce usable .deb packages for all Ubuntu distributions.
>=20
> Yes, together with Nicholas's openbuild setup, it saves from me to
> setup packagecloud.io.

Okay. I will do the setup. Following steps are needed:

1) Convert https://launchpad.net/~linux-rdma into a Launchpad group
2) Setup a git import of the rdma-core github repository
3) Write a build recipe (very simple)

If you have Launchpad account, you can join the linux-rdma group (once
created).

--=20
Benjamin Drung
System Developer
Debian & Ubuntu Developer

ProfitBricks GmbH
Greifswalder Str. 207
D - 10405 Berlin

Email: benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org
URL: https://www.profitbricks.de

Sitz der Gesellschaft: Berlin
Registergericht: Amtsgericht Charlottenburg, HRB 125506 B
Gesch=C3=A4ftsf=C3=BChrer: Achim Weiss, Matthias Steinberg
--=-p4hwatUbnBAQz2vGU0yk
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIcBAABCAAGBQJaAaDBAAoJEN2M1aXejH568mAP/0ZUGvWH3gZleGzaRr8lIjT1
kTArxVdnGD0QXxQn1AdmNoNE9+0RICW5DmXKVDQzQE9aY4Rwr3eK2KbUBhjuZVAy
F+JqbF6Cejz9L0vjkgG3kdFTjPPe9lXIgNIdnJnmqfpHMGi2vQCj50yH4VkRsOVq
zBLW0DbWvwfHfOqpO/5NPHDQCb/LVIeWAXReuJ4Wm1jKWvEHPWIzOrChakv5CA93
LhjnX/LtPl7zxc4PeEdGo1ZgleocK+wh6TxUZyfowBoULW6mCfXjjCOifaltsp/D
JoXVyBufRBX7tz6c0rGOUHiDoRdvOVupNK6/VMpyWtSPDmlkXgNIn01HuNDPTXxs
6q9O5Sqbjp/vY3zIGdlqURIRoSxjWPpSXI57idezjUVtwAU/2ofE4A5eV+6VXpIO
DTiSOBKpMSgA/YumMZEyKjXQpAQchgEOtHLNchvoaW6JQ6TDQPCRzf5y3sRVOFA4
fFsdyYI5lYWaTvT0HqczvwpYEWe/kHWeUpHdWWoA1ZREnl9wBUi0j0DGbS5dvlcy
015gGwvhO5PXR1VWgF5Y1DQ0vRqRRRwmqc0CW/JsWgUwrcZtSDSSgmOrOGNwFObG
R6ytOfSEB4K7hWO0+vvplKl8Pf97FxVEUZu67DE/EJBeIegd7QKe6HkX0NU8grcC
AFEiaMyCUyW4bQ2KOyFc
=VkwF
-----END PGP SIGNATURE-----

--=-p4hwatUbnBAQz2vGU0yk--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
