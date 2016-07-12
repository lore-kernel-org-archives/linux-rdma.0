From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v3 2/2] IB/hfi1: Fix sleep inside atomic issue in
 init_asic_data
Date: Tue, 12 Jul 2016 10:51:27 -0400
Message-ID: <730b9e44-07e3-1be9-7d17-41c611af330d@redhat.com>
References: <20160706211335.24572.34137.stgit@phlsvslse11.ph.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="wBOa8tjwtN1T6r45oJLTbIiSeNqP3preL"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160706211335.24572.34137.stgit-K+u1se/DcYrLESAwzcoQNrvm/XP+8Wra@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--wBOa8tjwtN1T6r45oJLTbIiSeNqP3preL
Content-Type: multipart/mixed; boundary="50Il0CmMI7TS0fbgDmicoj0bUklWu3GeP"
From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Message-ID: <730b9e44-07e3-1be9-7d17-41c611af330d-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v3 2/2] IB/hfi1: Fix sleep inside atomic issue in
 init_asic_data
References: <20160706211335.24572.34137.stgit-K+u1se/DcYrLESAwzcoQNrvm/XP+8Wra@public.gmane.org>
In-Reply-To: <20160706211335.24572.34137.stgit-K+u1se/DcYrLESAwzcoQNrvm/XP+8Wra@public.gmane.org>

--50Il0CmMI7TS0fbgDmicoj0bUklWu3GeP
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 7/6/2016 5:14 PM, Mike Marciniszyn wrote:
> From: Tadeusz Struk <tadeusz.struk-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>=20
> The critical section should protect only the list traversal
> and dd->asic_data modification, not the memory allocation.
> The fix pulls the allocation out of the critical section.
>=20
> Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Reviewed-by: Sebastian Sanchez <sebastian.sanchez-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Reviewed-by: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Tadeusz Struk <tadeusz.struk-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> ---
>  v3 - adjust summary line for series
>  v2 - fix syntax error due to bad conflict resolution

Thanks, applied.


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG Key ID: 0E572FDD


--50Il0CmMI7TS0fbgDmicoj0bUklWu3GeP--

--wBOa8tjwtN1T6r45oJLTbIiSeNqP3preL
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJXhQPvAAoJELgmozMOVy/dsXkP/35VNy8t2HvEQ29ckcTgxiZi
Q5ulvxi+vYGCImgNpYduoWW9iNZgEppzkIarE7TYdjnLqvuM4gKrvpIwHpTekWlR
l+8J5YIWmCIeSHVao4guWzbe9BmYrwtMzUgO09MxZT22WGrmixAa0+UKzGt5nUgZ
YVslgdQn9G/rmZ4kD71PMRfZsbmsOIJ8TATokIGHvnZnivCCpC3cLHojxecIJEn5
Zv6EZmu+jtd4zQxjLY9K9dKx3jGwwzYIVgCxdZ4hVaDY1OnNp1qKiCfESo12SOzO
2fJcxttC4LmYImvJe4ZytsDuGi9YAfDgg+KfzX17hSh+/Tf0Nf56S2O9UjXEHfE+
Ms9vVxskP07KpffU2WJePSSRTbN9pyRrXYXSUimYnbryTp3MBk9kk2uFJfCDTHVa
iG8HAklICJk2mbyd7tIFL4QDFnCD1Ieonlcy176V6Hx9m4IB/7t8X1OEXKRdd9QC
FCz/BH8wkOUv3k0QbdEPyLJwdT/3BxNbw5bVTN3W+E8CMCUCvL2GsHmHnlVI25cc
S8Gp53tJVsS8E7E+YFI7dIYEKkbaBx7jpZfvCsTemRGONhMPIv/v3d1JTXFLAC7N
NG63Ji8PAIAnjsfmHboIfJ6svaIpV98H4kxeIYglrMGM+ZW4IvnO2cgL5/vmFYNX
0x2gIv/Tf1rYmwiVdgbb
=29c2
-----END PGP SIGNATURE-----

--wBOa8tjwtN1T6r45oJLTbIiSeNqP3preL--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
