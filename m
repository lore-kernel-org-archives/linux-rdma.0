From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2] infiniband: mthca: Replace pci_pool_alloc by
 pci_pool_zalloc
Date: Wed, 14 Dec 2016 14:03:42 -0500
Message-ID: <43932699-023c-044f-1a54-619bd718247c@redhat.com>
References: <20161201184159.GA2949@jordon-HP-15-Notebook-PC>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="q1kILWGwu3NuF4bWjFr1hWKwXOJnbmXgJ"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20161201184159.GA2949@jordon-HP-15-Notebook-PC>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Souptick Joarder <jrdr.linux-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, sahu.rameshwar73-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--q1kILWGwu3NuF4bWjFr1hWKwXOJnbmXgJ
Content-Type: multipart/mixed; boundary="HVp3ukPTpOon0XrqWf8gfIh1OAuA4vRfV";
 protected-headers="v1"
From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Souptick Joarder <jrdr.linux-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org,
 sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, sahu.rameshwar73-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Message-ID: <43932699-023c-044f-1a54-619bd718247c-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2] infiniband: mthca: Replace pci_pool_alloc by
 pci_pool_zalloc
References: <20161201184159.GA2949@jordon-HP-15-Notebook-PC>
In-Reply-To: <20161201184159.GA2949@jordon-HP-15-Notebook-PC>

--HVp3ukPTpOon0XrqWf8gfIh1OAuA4vRfV
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 12/1/2016 1:41 PM, Souptick Joarder wrote:
> In mthca_create_ah(), pci_pool_alloc() followed by memset will be
> replaced by pci_pool_zalloc()
>=20
> Signed-off-by: Souptick joarder <jrdr.linux-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> ---
> v2:
>   - Alignment changes
>   - Remove empty lines
>=20
>  drivers/infiniband/hw/mthca/mthca_av.c | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)

Thanks, applied.


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG Key ID: 0E572FDD


--HVp3ukPTpOon0XrqWf8gfIh1OAuA4vRfV--

--q1kILWGwu3NuF4bWjFr1hWKwXOJnbmXgJ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJYUZeOAAoJELgmozMOVy/dJzkP/iCBTPa7IROF/YyWv5sZ68Si
Dz8lW9ebs+057SXzM3Mq4uRCCzM/CjxHkmsn5DQ89sqci3Y8WINN8KIl8/EMrUxl
7McmfxgGD68sREcl0DDC6sQg6ih2kXO/K+uQpEE3N4/Fz6rpb9DFNe2z8kgDj/t/
ljF5hAnnwKlqycw2eNKHgrnSicPPSVCZwP0weREN5wY531QX+nbVLu0E2mSeSCkU
V3I1XCO9/omzo+gkbghNhIsCgYVmT6Me8Q+Kg4/5CUySh9ehq0MPl2Lg0921Gkfi
d1u3gFn0L47eXvqYHjb70QewPOw8hJQGyVMfXliB5jrMME0Bgfb+BsFrg+jPsBfw
lx7opOyz50cYGLNZDwdVV8o5yiRK3NW02OoSsCC0ZFrKpDcPy1f3jpxk4xUlgXdP
SvbxdbzEEc86fAEmn3L8cts8iIBjHFT8iWjGlYlKI7SCtuQnuSfe1YgotS8lFwNl
23L8vwNFYOSX9+dyO7iJB8hC1h5VtUeHHEyTmERK6spyoUgAZw+4XcE9SdJG1JA/
vU3zQx2CZPoe9ivx5k/k/7j7FjIgoSxsorv07Mk18H1PqZMGZvpww+SCVA0Q0XZr
M8NDOIBjNFBxJbe/upANUByBZXcYKEFj96DXnQeTlftVFnr1PwWXe7gVNyoRte8+
WJza6lVvaxYSqvdw8alU
=qUiU
-----END PGP SIGNATURE-----

--q1kILWGwu3NuF4bWjFr1hWKwXOJnbmXgJ--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
