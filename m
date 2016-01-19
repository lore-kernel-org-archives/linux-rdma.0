From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] IB/qib: Improve ipoib UD performance
Date: Tue, 19 Jan 2016 15:41:47 -0500
Message-ID: <569E9F8B.8090700@redhat.com>
References: <20151224161923.9544.79119.stgit@phlsvslse11.ph.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="4LPSJu5WCbLita4AsILQCaONKGp5snQNi"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20151224161923.9544.79119.stgit-K+u1se/DcYrLESAwzcoQNrvm/XP+8Wra@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--4LPSJu5WCbLita4AsILQCaONKGp5snQNi
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 12/24/2015 11:19 AM, Mike Marciniszyn wrote:
> Based on profiling, UD performance drops in case of processes
> in a single client due to excess context switches when
> the progress workqueue is scheduled.
>=20
> This is solved by modifying the heuristic to select the
> direct progress instead of the scheduling progress via
> the workqueue when UD-like situations are detected in
> the heuristic.
>=20
> Reviewed-by: Vinit Agnihotri <vinit.abhay.agnihotri-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Thanks, applied.


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--4LPSJu5WCbLita4AsILQCaONKGp5snQNi
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJWnp+LAAoJELgmozMOVy/dUhMP/jIOA1hq61L5DK6qLhV5I2yw
e2TYqev+yiq/y0p2bbuGl7DTpXQyjaw+/dXgip0aJR/MB0pieQUSt4gZEwPIc+We
ICCT1r9oN9ClV7UpH6DaP0jGWrQxqRTLHvAZNwzbgx4qGsueOxRLeXZcoC3NaFaz
t4rQqVYNDwrjQ7coX8l3va+3LoKW9AMM7Sy0DqJwEZHvYO2LdO0exBwKwmblyTUm
8y8g7iI+zsrrDYKUAtGorAEPNuRINHDGr2qCG24Fq4UvT7lvFp0vvXbkf9JGLuUd
Y5cWodCVbnHQx7bdKxndi6FrsZIjFnNCbjKY7IwZCHFYfmubmwBMF7GZUgDl1LCJ
DaAxH54pC+edeCQU52L+atGzCqktI5PF9ERgms3mZLLBwRSDUysI961mIMBRkmoE
LIYX9TkGkfU55xOGwh0ZQVVg2L0mX4ir7LNr66rxFj8buaAtw88SxXva3Sp5YnL/
9WxEF7bAXEU4RzOIa/zn5KxuHXwa6t7p7f6sq2/wftx2fBmlz+9i6GeDjXz7ZGQM
749NqRmU8MledcQ10KQ5slKASE4mQrv4hUqYT2IbwSiwOYmfWm34sGh+Jk8qbRE0
o8YRRNIsoMAdZWDWGM/UJ7k9p7ysQAGM8EVU12sRmuxDc236dEzkfiuC5yvyYlad
Fts0y0PBDPxeFzOlT/Rm
=z9JB
-----END PGP SIGNATURE-----

--4LPSJu5WCbLita4AsILQCaONKGp5snQNi--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
