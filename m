From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: rdmacm-utils: Missing man pages for cmtime and udpong
Date: Thu, 27 Apr 2017 07:00:18 +0300
Message-ID: <20170427040018.GY14088@mtr-leonro.local>
References: <1493040510.17795.3.camel@profitbricks.com>
 <20170425180423.GT14088@mtr-leonro.local>
 <1493198562.3837.2.camel@profitbricks.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="cGn0fZIJon5R7R2H"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1493198562.3837.2.camel-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--cGn0fZIJon5R7R2H
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 26, 2017 at 11:22:42AM +0200, Benjamin Drung wrote:
> Am Dienstag, den 25.04.2017, 21:04 +0300 schrieb Leon Romanovsky:
> > On Mon, Apr 24, 2017 at 03:28:30PM +0200, Benjamin Drung wrote:
> > > Hi,
> > >
> > > the rdmacm-utils binaries cmtime and udpong do not have a
> > > corresponding
> > > =A0man page. Please add some since Debian recommends to ship man
> > > pages
> > > for all binaries.
> >
> > Is it requirement or recommendation?
>
> I looked it up. It's considered a bug. The Debian policy says in =A712.1:

I understand, I just don't see many volunteers :( to write it.

>
> "Each program, utility, and function should have an associated manual
> page included in the same package. It is suggested that all
> configuration files also have a manual page included as well. Manual
> pages for protocols and other auxiliary things are optional.
>
> If no manual page is available, this is considered as a bug and should
> be reported to the Debian Bug Tracking System (the maintainer of the
> package is allowed to write this bug report themselves, if they so
> desire). Do not close the bug report until a proper man page is
> available."
>
> See https://www.debian.org/doc/debian-policy/ch-docs.html
>
> --
> Benjamin Drung
> System Developer
> Debian & Ubuntu Developer
>
> ProfitBricks GmbH
> Greifswalder Str. 207
> D - 10405 Berlin
>
> Email: benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org
> Web:=A0https://www.profitbricks.com
>
> Sitz der Gesellschaft: Berlin.
> Registergericht: Amtsgericht Charlottenburg, HRB 125506B.
> Gesch=E4ftsf=FChrer: Achim Weiss.



--cGn0fZIJon5R7R2H
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlkBbNEACgkQ5GN7iDZy
WKddGQ/9F2C2xJtPQq9JSb5axSrw9Vy3hNHkbNz5GQCMBoyMWq79cJ5UD40cGl3y
h/Pq4NjjkIp1wk9Eko9mwbgvwK0cupsDkvXmQhGZbBvBcwc9q395vyLxnYk77oV5
d0vp4Nks0BRZuU8wkXZ2g86MSfEDHv7H7RNYxpp5lOkq4tT9qppf22ErVFfNmg1h
S6gzvyMNGf/r6wtxXXZj4U081qZ0uTtrbShbBwkpdwNSqFjg0t+/fD+LH7Wwsxbp
GTo3PdhHnmOW99Elv2dC7Cdt+bfbCgG0nKj8rMgPwm/KcKvi52ZRxfFCnwu33WcQ
QorN5Gq5KM8kf22hojR922En9x3HskmPzW9rzaNUiuLZE8gI3ND6Y8PyLmbRl+VQ
WM1JV+zroQSWlJ3jUoHYh9fqqSdMzxgsQTv57hXubnECw56PJ4iTvxy68XKiW03a
MZ1GmamFMCW8p8Gt0IHSFdah0lDfonrsa3YnBWOdJE1ekINkl4WweKu3TfT89P7t
5GsTtfnbKsIDHVQhoYDaFTqvFU++VMCCG1iR/sT7oL8uyGxiYfOzY+eknmjkBg0s
KwsMTUVi2AlT8HVZ3PC4DntEK0ARGwcPKj15RMNT8ia3jDoaF2hToAvu9rS2KnrX
hnbg12hawX/H66m7dMpza/l0OfdcgPNwjLOqqtryPMKJU68p6gY=
=5+R/
-----END PGP SIGNATURE-----

--cGn0fZIJon5R7R2H--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
