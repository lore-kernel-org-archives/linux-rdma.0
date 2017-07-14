From: Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Subject: Re: [PATCH] mlx4: Add copyright holder to man pages
Date: Fri, 14 Jul 2017 17:48:49 +0200
Message-ID: <1500047329.3563.38.camel@profitbricks.com>
References: <20170714143425.2002-1-benjamin.drung@profitbricks.com>
         <20170714152123.GD1528@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-E7Iip0pz2hgT1sZMA9k+"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170714152123.GD1528-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--=-E7Iip0pz2hgT1sZMA9k+
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Am Freitag, den 14.07.2017, 18:21 +0300 schrieb Leon Romanovsky:
> On Fri, Jul 14, 2017 at 04:34:25PM +0200, Benjamin Drung wrote:
> > Maor Gottlieb added the mlx4dv.7 and mlx4dv_init_obj.3 man pages,
> > but
> > did not state the copyright owner of these files.
> >=20
> > Signed-off-by: Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
> > ---
> > =C2=A0providers/mlx4/man/mlx4dv.7=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0| 1 +
> > =C2=A0providers/mlx4/man/mlx4dv_init_obj.3 | 1 +
> > =C2=A02 files changed, 2 insertions(+)
>=20
> Do we really need copyright owner for man pages?

Yes. If the file contains a license statement, it should also contain
the copyright line. This answer the question: Who grants the specified
rights? Is the copyright already expired?

> P.S. Can you please add rdma-core to your subject?
> Something like [PATCH rdma-core]

Yes. Done:
$ git config format.subjectprefix "PATCH rdma-core"

We might want to adjust the documentation to recommend these settings:

$ git config sendmail.to linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
$ git config format.subjectprefix "PATCH rdma-core"

--=20
Benjamin Drung
System Developer
Debian & Ubuntu Developer

ProfitBricks GmbH
Greifswalder Str. 207
D - 10405 Berlin

Email: benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org
Web:=C2=A0https://www.profitbricks.com

Sitz der Gesellschaft: Berlin.
Registergericht: Amtsgericht Charlottenburg, HRB 125506B.
Gesch=C3=A4ftsf=C3=BChrer: Achim Weiss.

--=-E7Iip0pz2hgT1sZMA9k+
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIcBAABCAAGBQJZaOfhAAoJEN2M1aXejH56mroQAIuMPtRSqRm6LfieNxvDfFAH
PelIbUcS9jxkatLwomAQNhxX55luqUBQYhcwoI6SwiCyae8aQx47yYASinjB1TGB
twRGNmHN8fzwVOk5CSE8nvFJQhj9jX2pNcZrpolOPcFedOsGo2YbH6U4bUm1be6o
tV7XF6enRBUUVEnWbo+pog7VEx+1VvtsdXg8QX0FNaScJcxn/eTcliNnTKhgTsT/
gH1uVdK55kgqUV4AIMMadYhrF+kx8hUX4QIoYmDnCWzDcX7m7LTRt95lOmNXG4Qn
d8EzOfZvc0aGDrfVZigba2K7TcQcL4aAAglIhyeOsgzdxpYG3GDzahBzo5xSNZeR
asykZrFUQmJqRzvnxzpsuGhA7BnH10vFmQy1lo/dfK+z+yherbtN9SH/JxnAzoR1
5fcX+qH6o3ckbqzJX2ymKpDhChjwWv5/PoJQoKFQTnbSj+S7m74QyTdgMySWDbju
riEqUxkkOEVinvPzX+Qw7ppuktlNEQQDKl3PNVbPC32Kma+yYzn+hjzwKS+NUddu
VeyPH0ymaKU8LDxbRq1uaJPLT3/1eBP7Z+ElvqcPxqrt8ryKNcO3LZG5zuDeYsbm
L3WeHuHFQGibBRWopEGEWJqOnXuGMk9KlvqDZ870XbHuUGC6iuUeGe6bRNE9orGM
GQYDlAj+jqcGKMnGPuWL
=2Bep
-----END PGP SIGNATURE-----

--=-E7Iip0pz2hgT1sZMA9k+--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
