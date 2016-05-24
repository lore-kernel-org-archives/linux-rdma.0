From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [RFC ABI 1/8] IB/core: Export RDMA IOCTL declarations
Date: Tue, 24 May 2016 22:49:37 +0300
Message-ID: <20160524194937.GJ25500@leon.nu>
References: <1464100526-31730-1-git-send-email-leonro@mellanox.com>
 <1464100526-31730-2-git-send-email-leonro@mellanox.com>
 <1828884A29C6694DAF28B7E6B8A82373AB05008A@ORSMSX109.amr.corp.intel.com>
Reply-To: leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="CxDuMX1Cv2n9FQfo"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1828884A29C6694DAF28B7E6B8A82373AB05008A-P5GAC/sN6hkd3b2yrw5b5LfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--CxDuMX1Cv2n9FQfo
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, May 24, 2016 at 07:46:32PM +0000, Hefty, Sean wrote:
> > Place all external RDMA IOCTL declarations into one UAPI exported
> > header file and move all legacy MAD commands to that file.
>=20
> Are you expecting umad ioctl's to come through the same file as uverbs?

No, just wanted to export one common file.

> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--CxDuMX1Cv2n9FQfo
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXRLBRAAoJEORje4g2clin25MP/3AQKGBNwfvmpc4Gg7o6D4hh
k0Wbghwzhb7OZNKLJxfVjGSEcAqYN9HtVbTcvaUSPJhX6gK215rge61tkt0GbDCi
ZEcYIBNSdd0eD3PBxdHfUOgA+fbGZYpLNk/cfyuXhHKUBW83CrdquYV7T7SHm55U
J1g4UexrNZgT0TlYTD7rxkXzeGxuZZ+YJJEQoedEJKUXFHZ1tMVcM6ioypke8ekF
1L0JrZixTertavF2WWUzLfB5jtCqrT0sUENAA0txbBOg3bE882jegV6YDn6B5KGo
aGz5204tHDJihRXpW9AmQww62YjfdUBZE2hF5aEuDIa16+qgG83g/vcZ+sF9NN+M
uZdQun5sLyYIVzqNuNf0Nh8GzCfZcbj7yYqKMKhBHg7YLV++E1ORobkw90GkGeiT
QnVYDhuLorDZSfXgDcjD5axxCmVChET6FXz6pVUdK1hCtvAsqW4Ia3y0otWBxRtk
PAj9I1E+Bv5G5r8K7c4rcH+36URY9yyny7oO/Qi11ggdk/m9/cZ9RWdhAEm+eEfL
OAWbCQ8ID4M/I9uztzA4Y2EG1QsMiSs+JdaK0RDbSQkgK1EMQ8P1Byw/5whVImaS
3SXHfYH/GzlkjkFcCRv+4z1oeSRcnM6ACuf30Ezf5s0exRxsA2pnK/Qgn4ZIxAjc
6isHp0GQAnNo3XjWvVZH
=Hag1
-----END PGP SIGNATURE-----

--CxDuMX1Cv2n9FQfo--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
