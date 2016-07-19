From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH V2] Use smaller 512 byte messages for portmapper messages
Date: Tue, 19 Jul 2016 08:35:05 +0300
Message-ID: <20160719053505.GE20674@leon.nu>
References: <1468869709-66592-1-git-send-email-shiraz.saleem@intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="n+lFg1Zro7sl44OB"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1468869709-66592-1-git-send-email-shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org, e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, Mustafa Ismail <mustafa.ismail-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--n+lFg1Zro7sl44OB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 18, 2016 at 02:21:49PM -0500, Shiraz Saleem wrote:
> From: Mustafa Ismail <mustafa.ismail-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>=20
> Portmapper messages are short and do not occupy more than 512 bytes.
> Lower portmapper message size to 512 bytes. This change significantly
> reduces the amount of memory needed when trying to establish a large
> number of connections simultaneously. The old value is based on page
> size.=20

The old value was minimal between PAGE_SIZE and 8K.

Reviewed-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

--n+lFg1Zro7sl44OB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXjbwJAAoJEORje4g2clinWSkP/2M1PeqOoWKo7HBAc3EbhCRi
uleZ00GdCYkl5uYoDt45y5XeRZ9uw7ya7As004o5B6nnf4fQdHGTGjSV/WqHdV7b
TbYxOoi+BCPBVSrFrQsiHMa3UFdWw96fUvoch7eTG5pFtClk9ulfWdXgme30+Osw
xja3gcIIQ68gjuIy6nQKh0ZRYyjwWqPux5aPrIaAoHWDUCsCq+6KGoX010WdOplc
R56oj6U12XdQ6A2fZpnY/q3FC416n1qXkOx4XpkQVHtntlgchDrtVlhQAklV3OUT
dFymDxTGo/fGTAkBUHleJFsHmRzFr7MSUJ+mj6cfEctKlWkiYjBdNvjCRKNdMsvI
6Gy9vEIg8Is+74o1AnZP7350iIvTsAEiDq7jyCeVzoxGQtjF5Uc7hzdnIiJs8X2Z
w5sdxfgyGlgnowV4AhSrTKqq7KgEBHREmlGLz5nxYBPPNZxVnRMI2ZNi8feHWVsr
1wC/Wt8Y05K2bAPdnZG0yAZl/7hdiCkQCedjDG/38rDrpnHz7Z/GyLMeS4OQmQoh
KJkCgNdBaSxV3kAOQqQnJ3vXRv9cDFyaeYDRL6XUqD8RDBX8gmCkXoGkolKpflPz
UIvKhkN9ltqtaZrIEBMRrnu4Cx+mxiiTURC7MqC20ngT7Cd8104ORVyilxqal9x+
IGUdqzb0cT3eK8RvkANt
=j/fT
-----END PGP SIGNATURE-----

--n+lFg1Zro7sl44OB--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
