From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] IB/qib: Change lkey table allocation to support more MRs
Date: Tue, 28 Jul 2015 11:16:00 -0400
Message-ID: <55B79CB0.7040607@redhat.com>
References: <20150721123607.22112.55950.stgit@phlsvslse11.ph.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="hGWLeM9sFjnUHF4ofQvOs52MTwpWVXa4A"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150721123607.22112.55950.stgit-K+u1se/DcYrLESAwzcoQNrvm/XP+8Wra@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--hGWLeM9sFjnUHF4ofQvOs52MTwpWVXa4A
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 07/21/2015 08:36 AM, Mike Marciniszyn wrote:
> The lkey table is allocated with with a get_user_pages() with an
> order based on a number of index bits from a module parameter.
>=20
> The underlying kernel code cannot allocate that many contiguous pages.
>=20
> There is no reason the underlying memory needs to be physically
> contiguous.
>=20
> This patch:
> - switches the allocation/deallocation to vmalloc/vfree
> - caps the number of bits to 23 to insure at least 1 generation bit
>   o this matches the module parameter description
>=20
> Cc: stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Reviewed-by: Vinit Agnihotri <vinit.abhay.agnihotri-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Thanks, I've picked this up for 4.3.


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--hGWLeM9sFjnUHF4ofQvOs52MTwpWVXa4A
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJVt5ywAAoJELgmozMOVy/dcJwP/1B5N62FgDmy8ffaE2tMrVxR
ZcauGsG9coVonAtSNI29kuO3Kaz4nmJuH7hsPpD7cnI0urgEJbNj1yAQ/H1bXbNm
eilru/DfTbE2XsrsfLe2mkVc/YWzJ8lNu+Dg2JaTHLq7MWTN1hUtMlc+ACW5mrnw
hT8CdESX4IPpBOJrNDsdKoluTg+Glxe9NC8MpcsQc5RhdVRIUAbROCO7ag//7jho
5h4bb72iQF1E65mQfI4dKQp1g0T2inze/O2C17QqNa9pZP7Wzc+1QIfFgh8wR61q
SxA/Dro8n4OgODtkSRx8QoJeuCuSEBRV386Btd3R8kM7UQMdLpXX0APbaznqxh7D
dBqLWCWZZXKTPZhi8IR8LfvPKbP9zaVZ8ze0V81FQp2uvaSYel2lGk2M0cbQZMgX
k/3Cm9N5NffMJ/ph65uAczRwklRT166aSinM4I2zVHpCr+1ph41bHD4dAzyf4TJx
mM5CQZFCw24VDzDHBEcT7PQ6N1HnlhjOmz4Q5xV7HOJxfazpw+cIfLCyfRrgDFzH
R82UmLKZcACCaH+1h+UJUdKEEqjkzYSWQaywenP7AGPvkYG48lgCNmjvaCJBTonX
jzN6NvqNzwVFN82LvHU4oI46gbdO7Wwg63usmUXZZ/nv2BOvebcsXMvsBfmhYahz
1wIPkyxiIYT+qtNJ+dEK
=GfIz
-----END PGP SIGNATURE-----

--hGWLeM9sFjnUHF4ofQvOs52MTwpWVXa4A--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
