From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] IB/rxe: Avoid scheduling tasklet for userspace QP
Date: Sat, 1 Oct 2016 19:09:25 -0400
Message-ID: <f7a23e79-574d-2bcf-3f9a-a2ca9c60c447@redhat.com>
References: <1475094252-18304-1-git-send-email-pandit.parav@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="4RegtsuooKdTU5VP0STli3c23nSPUF5dg"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1475094252-18304-1-git-send-email-pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Parav Pandit <pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--4RegtsuooKdTU5VP0STli3c23nSPUF5dg
Content-Type: multipart/mixed; boundary="XtMBHne2qu2Iwn5FqXXPLg0L2o9KpO0fN";
 protected-headers="v1"
From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Parav Pandit <pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org,
 linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Message-ID: <f7a23e79-574d-2bcf-3f9a-a2ca9c60c447-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] IB/rxe: Avoid scheduling tasklet for userspace QP
References: <1475094252-18304-1-git-send-email-pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
In-Reply-To: <1475094252-18304-1-git-send-email-pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

--XtMBHne2qu2Iwn5FqXXPLg0L2o9KpO0fN
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 9/28/2016 4:24 PM, Parav Pandit wrote:
> This patch avoids scheduing tasklet for WQE and protocol processing
> for user space QP. It performs the task in calling process context.
>=20
> To improve code readability kernel spacific post_send handling moved to=

> post_send_kernel() function.
>=20
> Signed-off-by: Parav Pandit <pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

Thanks, applied.


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG Key ID: 0E572FDD


--XtMBHne2qu2Iwn5FqXXPLg0L2o9KpO0fN--

--4RegtsuooKdTU5VP0STli3c23nSPUF5dg
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJX8EIlAAoJELgmozMOVy/dFZgP/2cuxOda6xTifuyudCf8LG7p
Nc1qcW0EFVz4KDG28sif/j2VMA6d4v1s/MSrEOHXdNd92DpjUKP0ycp3zRvb6LUb
WRyVcWNwW3eqtmnhYOOf1VcrdI2wApJMtO7c/34RbZPSYqpPPax6riISCMHam7hm
GJ2VkotPj9UGRwHbPIOxBArDrstYkvoSrFNuZyv0y6zDW1J2a13QDv67yXDRVqe/
e58vbNwKSFxnjuNBCqxSXren/XoF928kqWqE4ZGi+olFSxXkmCdvCYPGAsJX3Mln
Qvc+zyDgLVyOdiczMkn1bKZayZqmGzuKqiZ6VNSvTvdC1O4hvKIsaqlzRFXwnwIQ
ZDGDYOQAbkYSRSzaq7mRNKh9ZkbMwcZLkGXfItnJY8d5w93KJ9YvMcuNhxHsFXxU
y+O37za1f8cFm+wKVYFJIjFEQ6TuEo+dRmqHyx3U15/xQcyPprK4yH4DNGPjNOop
HHHqazqa/CxgX1P4vp1DDbKTXSeLShYGjrXoBvTZQ9JbzC+wyYExA4exKR0lvBLr
z+eK6hhaySHtfJlNGQtd5rs4Vayf/d0L2ceQ8NttGeX+n+8vqwrJI0Cok1Yq5x3h
lX1qxsdTrwjtQteUyYh2TW7mGl4LxXHEMlQ22+pZpQX1ikrZ4dl1FSPrQtSlwOL1
ke6c4jYsgjIeYEgXw+56
=XTo+
-----END PGP SIGNATURE-----

--4RegtsuooKdTU5VP0STli3c23nSPUF5dg--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
