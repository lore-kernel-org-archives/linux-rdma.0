From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] IB/mlx4: Fix CM REQ retries in paravirt mode
Date: Sat, 22 Jul 2017 13:45:15 -0400
Message-ID: <bfa7ff5c-4ce4-6ae9-b4e3-4f820855f2e1@redhat.com>
References: <20170620120750.32268-1-Haakon.Bugge@oracle.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="Hsm8qoLJ2QKe0u3vPK6COnRlVtDGQI0wf"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170620120750.32268-1-Haakon.Bugge-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: =?UTF-8?Q?H=c3=a5kon_Bugge?= <Haakon.Bugge-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--Hsm8qoLJ2QKe0u3vPK6COnRlVtDGQI0wf
Content-Type: multipart/mixed; boundary="FBqie5GTNGwvSFeNORmX67jaqPas3MCOK";
 protected-headers="v1"
From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: =?UTF-8?Q?H=c3=a5kon_Bugge?= <Haakon.Bugge-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>,
 Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Message-ID: <bfa7ff5c-4ce4-6ae9-b4e3-4f820855f2e1-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] IB/mlx4: Fix CM REQ retries in paravirt mode
References: <20170620120750.32268-1-Haakon.Bugge-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
In-Reply-To: <20170620120750.32268-1-Haakon.Bugge-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>

--FBqie5GTNGwvSFeNORmX67jaqPas3MCOK
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 6/20/2017 8:07 AM, H=C3=A5kon Bugge wrote:
> CM REQs cannot be successfully retried, because a new pv_cm_id is
> created for each request, without checking if one already exists.
>=20
> By checking if an id exists before creating one, the bug is fixed.
>=20
> This bug can be provoked by running an RDMA CM user-land application,
> but inserting a five seconds delay before the rdma_accept() call on
> the passive side. This delay is larger than the default CMA timeout,
> and triggers a retry from the active side. The retried REQ will use
> another pv_cm_id (the cm_id on the wire). This confuses the CM
> protocol and two REJs are sent from the passive side.
>=20
> Here is an excerpt from ibdump running without the patch:
>=20
> 3.285092       LID: 4 -> LID: 4       SDP 290 CM: ConnectRequest(SDP He=
llo)
> 7.382711       LID: 4 -> LID: 4       SDP 290 CM: ConnectRequest(SDP He=
llo)
> 7.382861       LID: 4 -> LID: 4       InfiniBand 290 CM: ConnectReject
> 7.387644       LID: 4 -> LID: 4       InfiniBand 290 CM: ConnectReject
>=20
> and here is the same with bug fix applied:
>=20
> 3.251010       LID: 4 -> LID: 4       SDP 290 CM: ConnectRequest(SDP He=
llo)
> 7.349387       LID: 4 -> LID: 4       SDP 290 CM: ConnectRequest(SDP He=
llo)
> 8.258443       LID: 4 -> LID: 4       SDP 290 CM: ConnectReply(SDP Hell=
o)
> 8.259890       LID: 4 -> LID: 4       InfiniBand 290 CM: ReadyToUse
>=20
> Suggested-by: Venkat Venkatsubra <venkat.x.venkatsubra-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> Signed-off-by: H=C3=A5kon Bugge <haakon.bugge-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> Reported-by: Wei Lin Guay <wei.lin.guay-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> Tested-by: Wei Lin Guay <wei.lin.guay-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> Reviewed-by: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>

This was accepted into 4.13-rc, thanks.


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG Key ID: B826A3330E572FDD
    Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FD=
D


--FBqie5GTNGwvSFeNORmX67jaqPas3MCOK--

--Hsm8qoLJ2QKe0u3vPK6COnRlVtDGQI0wf
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJZc48rAAoJELgmozMOVy/dCAEP/ROJH6japQazDzmx0aMFHOKE
Rfr0QMGUqxBe2Np/70GNTXZTVCNjz5AL2RTpetOgWs6dBCjhOSObWV7S5DGxS/9P
r3as1wKXou0rECwqu3Abqsn8X06EAJUCA2c+2jO0WDHRCuRNgzRWhtLn/jHG420L
tnnZSfEIUYzKOWIHzNkfkYPz93BoDieAOOSTWYb/sFFM6HzNaFlJAqmYk4wfclxa
U3YEO8UXCX7PDY7yyYtf17vdgGeP5+BhhKtdSPCj5tz0iRV7e0SJr4V4yyE+SjL8
HImxQv5PxOMXNOQ0Rzry/6NvLzrRRg05TgjlbH93yYLIk4UaNkuuPYC9WxslTRFy
/B1YyN76gg3lL8m6Ru/HY5YrTabUust4WBBUN7RwzF6N5R7cJVi6SkZ7i7Sw0RT/
OnKtoab2wzp6snSWKIO7hUPPZuRRZYotUF9PWts4jqntRM/6YGj6tRyjiy0ekey+
yxii79BysAonjKx5449Zdh5rG6vJViJEYomLeotWRuhBCL/Yy0TUl5KRBXT6Fu9e
d2uNDSRLaGcvVwkpdp/U96XoZPS8RO7NtWC00sZBi2OSK46XbYaAbCzfYxloKG5p
tOwjnd8V8ZQjRSWm3H+hy4PtfGDECNuOmTMwMm2Pm/QULTkIITNxvm7VZNrtH4R7
898RCpHUrwgt03Fh2tkc
=jwNY
-----END PGP SIGNATURE-----

--Hsm8qoLJ2QKe0u3vPK6COnRlVtDGQI0wf--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
