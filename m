From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v3] IB core: Add port_xmit_wait counter
Date: Tue, 12 Jul 2016 11:29:44 -0400
Message-ID: <af52cfdd-15e2-65c3-2899-fcedd4ff4f4e@redhat.com>
References: <alpine.DEB.2.20.1607081026550.5092@east.gentwo.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="HNoeoTp3injRARcGRrsTanOLhHjXAU5Dt"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.DEB.2.20.1607081026550.5092-wcBtFHqTun5QOdAKl3ChDw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Colin Ian King <colin.king-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Eran Ben Elisha <eranbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--HNoeoTp3injRARcGRrsTanOLhHjXAU5Dt
Content-Type: multipart/mixed; boundary="O0aOeG3IsFu2dlIGNtUF8GfbfawJOJVDL"
From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>,
 Colin Ian King <colin.king-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>,
 Eran Ben Elisha <eranbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>,
 Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Message-ID: <af52cfdd-15e2-65c3-2899-fcedd4ff4f4e-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v3] IB core: Add port_xmit_wait counter
References: <alpine.DEB.2.20.1607081026550.5092-wcBtFHqTun5QOdAKl3ChDw@public.gmane.org>
In-Reply-To: <alpine.DEB.2.20.1607081026550.5092-wcBtFHqTun5QOdAKl3ChDw@public.gmane.org>

--O0aOeG3IsFu2dlIGNtUF8GfbfawJOJVDL
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 7/8/2016 11:27 AM, Christoph Lameter wrote:
> Add the missing port_xmit_wait counter. This counter is displayed throu=
gh
> some tools like perfquery but is not available via sysfs.
>=20
> For the PORT_PMA_ATTR macro the _counter field is set to zero
> allowing us to specify the offset directly like with PORT_PMA_ATTR_EXT
>=20
> See also the earlier work in 2008 by Vladimir Skolovsky
>=20
> https://www.mail-archive.com/general-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org/msg20313.htm=
l
>=20
> Signed-off-by: Vladimir Sokolvsky <vlad-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Signed-off-by: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>

Thanks, applied.


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG Key ID: 0E572FDD


--O0aOeG3IsFu2dlIGNtUF8GfbfawJOJVDL--

--HNoeoTp3injRARcGRrsTanOLhHjXAU5Dt
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJXhQzoAAoJELgmozMOVy/deM0P/3o/P4Gb5csPulmx5ayAq3OX
AaIlqgQ7zMJVy1J2Ks0g/MiyGPDxk//YbVpTHb2vrQ2WJH0QaLdEcEuySbXk/NW1
9ltsubxDH6w1kTmMH94cnW77dYbADyhjH8GPRPkoqysPPZn2DlIh6baY5YY1Gw3L
xnOoBt2LZkcG1Oi6f/7LavTGYIEOPzw+r+gLq/OZEyKMBRTPiQdFMyy/rc2CdDk6
wi327w5GQvOMdZ8glrhcMLK4BfP+BLdURloydjTZAnfQlucHPLe1PgrIyeSXoq5h
Zuhd6921/AzVoQKSk0Msmc3ee7RTeLmaU3AkqflK+w9xJvszxqv17Fv8ant9U6qp
23+cyQjk2V/OpixeZ2hY7O1kBDWwh23zSxE9mLvM1Miwkcd7SL46btuBUPq/IhNl
2gMoJfjlYTejjaEQ8R/R3IUu+UguxLj8C27wZToRXcJir9FExHL9jEaF2vy02MjI
Ue4zZLtqiuFAUaaqRIh6/5T8x98aKM9sN5L/uYkfCbNZ81644J0YucOyK+7Vs6Gx
RRGTW4uR1jhpmm7PpUZU5IWHIdcnYHTB5HHLx+MJcb236MxB1bv1T66WKAli1THU
CLEsVyMoWdXdnOITVyehPz+dpDUmPtjv8NW8W6y1LiODH9jsyz5LR/Iev8dBInjN
4lQ9KbO50oWkVZPEfeYn
=eUPK
-----END PGP SIGNATURE-----

--HNoeoTp3injRARcGRrsTanOLhHjXAU5Dt--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
