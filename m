From: Leon Romanovsky <leon@kernel.org>
Subject: Re: [PATCH v2] iser-target: fix error return code in
 isert_alloc_login_buf()
Date: Sun, 7 Aug 2016 16:08:06 +0300
Message-ID: <20160807130806.GR27667@leon.nu>
References: <1470404968-17339-1-git-send-email-weiyj.lk@gmail.com>
 <1470572438-12360-1-git-send-email-weiyj.lk@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="DvifzEOEABd5jzbd"
Return-path: <target-devel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1470572438-12360-1-git-send-email-weiyj.lk@gmail.com>
Sender: target-devel-owner@vger.kernel.org
To: Wei Yongjun <weiyj.lk@gmail.com>
Cc: Sagi Grimberg <sagi@grimberg.me>, Doug Ledford <dledford@redhat.com>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, linux-rdma@vger.kernel.org, target-devel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org


--DvifzEOEABd5jzbd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Aug 07, 2016 at 12:20:38PM +0000, Wei Yongjun wrote:
> Fix to return error code -ENOMEM from the alloc error handling
> case instead of 0, as done elsewhere in this function.
>=20
> Signed-off-by: Wei Yongjun <weiyj.lk@gmail.com>
> Acked-by: Sagi Grimberg <sagi@grimberg.me>
> ---
> v1 -> v2: fix with Leon's comment
> ---
>  drivers/infiniband/ulp/isert/ib_isert.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Thanks,
Reviewed-by: Leon Romanovsky <leonro@mellanox.com>

--DvifzEOEABd5jzbd
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXpzK2AAoJEORje4g2clinHuQP/RB8D/BHkEk9YCw2Oxzidluh
gPErv01KTYTGdv993HTSBSt9lgEHd6xqTGN2uDCGGIhj+3mj0pN2ym9E6YrUl8YW
fKV/G6JaUYkb/Aq+k0pk0ien2ABYv06TSAcYRu6ulTHN6ToKgb4wxMU9GvhLYZci
hYPGNN6ojqCMA+R0fKfZ/QNCbgnOFg8Y0hwOzUxTO4nR+WgJ8qYXCzCfdcyjAs4H
wC7ppHIHrdQky8p4EDIjGD1j+nZRA/keQJtLCXTNhVPGTyXkxg7xuyD+4pz8UFZC
2lcchyhwIYt0ocr0Qcf+UZbh8AW2h5nIEJtoy6hSUQtQd1wYHqsHpZqqSiQCuzcF
okUWoOoGZaRKDzTOtrmNrE0lTT9woOm/HHA2viMlBkkjWNkPzmfVNHlsA6S7iEI3
6TSJaDd83fj7nw8ZQj89tyd8zL8DLSKyKYVjb9ATd1Kb6GE3ipWq8kgGRdgzR4o0
eRy7ChVp0I41CgCk8w/bLD1W2JOg0fOLgbDAT3zezqWl5oUrnC3AfbQkZOLo1Ka7
pZ1hqRdaAhRkfSsny9zBgYlrgKkjaVl/epfVrJISz+jxuXQhYO83waShtGS0HdZI
k+z2IF+PKVfImxHCtRZh5wTndqqgy0alO28E+wW3PMvORyxvcfwJ3w8ZQpJBH/E/
+ihSTQ30E8advofPyB4Q
=uulL
-----END PGP SIGNATURE-----

--DvifzEOEABd5jzbd--
