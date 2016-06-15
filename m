From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2 01/24] mlx4-ib: Use coherent memory for priv pages
Date: Wed, 15 Jun 2016 07:28:49 +0300
Message-ID: <20160615042849.GR5408@leon.nu>
References: <20160615030626.14794.43805.stgit@manet.1015granger.net>
 <20160615031525.14794.69066.stgit@manet.1015granger.net>
Reply-To: leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="qOEfHYdX8LquYLAx"
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160615031525.14794.69066.stgit-FYjufvaPoItvLzlybtyyYzGyq/o6K9yX@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--qOEfHYdX8LquYLAx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 14, 2016 at 11:15:25PM -0400, Chuck Lever wrote:
> From: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
>=20
> kmalloc doesn't guarantee the returned memory is all on one page.

IMHO, the patch posted by Christoph at that thread is best way to go,
because you changed streaming DMA mappings to be coherent DMA mappings [1].

"The kernel developers recommend the use of streaming mappings over
coherent mappings whenever possible" [1].

[1] http://www.makelinux.net/ldd3/chp-15-sect-4

--qOEfHYdX8LquYLAx
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXYNmBAAoJEORje4g2clinvU4P/RA9KppEE+uFz/T5WPW9qp7M
WAXxrSgK7Clp4YjvPszCBlzRutP8e9vFcst5QIAGZCKpp9FdQ5apHJxgBoPanIIE
0Hn9A+l82hwprXDpfWEu73lFxIXeY4BbK9uKvoiQm8XaFoL9hYazmYcVUI7snEEV
Oz7WmkRkZnpIbkR5agidS7fDmZ1CNHLqWw3fX//LNtX+bACrRl+13ACyZhCNPuO3
Wju1Rxl0+g+eSJ4yW9wCwG3IUvTHItI0gPyKzbH+nvtc+al3nPgoWAWAbEb2EfIm
hmJs8NBKHpJ9+Nq6EUoZ6xhg+Kk/6VYNe8y5p2bIhM3T1mlp/iyvBri9iOm0cDG8
vTxpOsmfj+848L4KBl5xndx8h5G8kgOFQ71jX47AWuAzNQMwxxJKSNvEg0QoEwGQ
SbLUOS/Be8uATBu7xayen3R0Z0c81vouq4wLV9slDG39cjzZ/K6whgZpkBVua/uf
78FSVJZn3CK0OPxirktc/bZL+iVpIwEvCAiwQkhHuicj+m8uBacqwIT4zMdbFT6A
qCzEcxLURauZqhU2DEzlE86GAVcIpcrlBdyXEr5bL2MPA0zpTDzupBnmIqt45Ea0
vzpnZklXw+VX8uiYIxQV9T4hV9KeX5ueyG+4E8OQP7vNsZBlF+E7kzUcPbGiUQTO
tCz1oVpseDJ9g5GEGdeh
=WY9o
-----END PGP SIGNATURE-----

--qOEfHYdX8LquYLAx--
--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
