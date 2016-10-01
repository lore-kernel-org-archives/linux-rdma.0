From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] IB/rxe: impoved debug prints & other code cleanup
Date: Sat, 1 Oct 2016 19:11:19 -0400
Message-ID: <423df9bc-03cf-dcdf-9a6a-8120f86b290d@redhat.com>
References: <1475094386-18449-1-git-send-email-pandit.parav@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="oJUWcjUcUFuF49R0oIsHqL020BgruGS5g"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1475094386-18449-1-git-send-email-pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Parav Pandit <pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--oJUWcjUcUFuF49R0oIsHqL020BgruGS5g
Content-Type: multipart/mixed; boundary="XRDGt4J6nMpo26pKAgPJkfllCjBMgp81N";
 protected-headers="v1"
From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Parav Pandit <pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org,
 linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Message-ID: <423df9bc-03cf-dcdf-9a6a-8120f86b290d-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] IB/rxe: impoved debug prints & other code cleanup
References: <1475094386-18449-1-git-send-email-pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
In-Reply-To: <1475094386-18449-1-git-send-email-pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

--XRDGt4J6nMpo26pKAgPJkfllCjBMgp81N
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 9/28/2016 4:26 PM, Parav Pandit wrote:
> 1. Debugging qp state transitions and qp errors in loopback and
> multiple QP tests is difficult without qp numbers in debug logs.
> This patch adds qp number to important debug logs.
>=20
> 2. Instead of having rxe: prefix in few logs and not having in
> few logs, using uniform module name prefix using pr_fmt macro.
>=20
> 3. Code cleanup for various warnings reported by checkpatch for
> incomplete unsigned data type, line over 80 characters, return
> statements.
>=20
> Signed-off-by: Parav Pandit <pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

Thanks, applied.


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG Key ID: 0E572FDD


--XRDGt4J6nMpo26pKAgPJkfllCjBMgp81N--

--oJUWcjUcUFuF49R0oIsHqL020BgruGS5g
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJX8EKXAAoJELgmozMOVy/dxCoP/RSnGEUl52AWANnv+sLFeVor
z7HVuu7mtrRUKIdpKm716jzRKOK0QGjPQGUUCj7hQK9IHKVSgMow8CzPYXjzwSg2
XNPcHy/59O03LdoO0hjG+FfC5FRiFIhQQ3jdRUzurQJk+5qeX0wpzkLwhioL1mUE
mH/nBVa51p+NbBkT6ow47hNXltV3D0xw2WkhCr8pWDyZ9z8EJA8V8X2WUrEv3Qm4
fsDIiz997PTXJxp0wg4l4YIGBa1FcKZSKpj8HWKRH8IjyUgkLPLD5LoGDv73Be+J
xqsK1mg4l7N955oc9puRGfdPTxtydAeRK3gsEgx5xdTP4zBxRVfe43iqeHQ0nca7
j8hiB7+VqoN0TM0Drk0aooU4swCcv4wbI8xJXvTfWHRkkO6HJrAg9Ry0oKAvcycO
2IFfsgHZogtg1qKRV/jGUsRIZE5Q1M23v1cjomgZpb8kc2w3I0YxZzolaYBowCY+
vXVuvlOAsG38Ms4n02l6spaAdlDUtUhk0zSpWC3CKk4PpDZndEYzHJIC4kgJgmwB
jSppOUH2y2R8yO9tLEyXe/YhdhfYRsz69+sObLjnRc8mdHDGxRwiFj72kQdl/iMP
CHe0pgead68JA3RRYiZ7Zachbr0s2bLEFM24U7T3ppIn6h49kzD9CRp6OsRG34sK
tN1DRpt3vXEuEUgzrI0m
=0iAE
-----END PGP SIGNATURE-----

--oJUWcjUcUFuF49R0oIsHqL020BgruGS5g--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
