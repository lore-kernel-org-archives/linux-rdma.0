From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [rdma:k.o/for-4.11 115/115]
 drivers/infiniband/hw/bnxt_re/main.c:231:18: error:
 'RING_ALLOC_REQ_RING_TYPE_L2_CMPL' undeclared
Date: Thu, 23 Feb 2017 07:39:14 -0500
Message-ID: <42932e22-cf42-a920-ab31-616f16b2983a@redhat.com>
References: <201702230915.2bxOtvc8%fengguang.wu@intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="s84woo06d39tfQpqsNCngU076bBHcEtAJ"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <201702230915.2bxOtvc8%fengguang.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: kbuild test robot <fengguang.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Stephen Rothwell <sfr-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org>
Cc: kbuild-all-JC7UmRfGjtg@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--s84woo06d39tfQpqsNCngU076bBHcEtAJ
Content-Type: multipart/mixed; boundary="8kelRRcAN7qHEN6HCC5SsjesgieDaUIvW";
 protected-headers="v1"
From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: kbuild test robot <fengguang.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>,
 Stephen Rothwell <sfr-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org>
Cc: kbuild-all-JC7UmRfGjtg@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Message-ID: <42932e22-cf42-a920-ab31-616f16b2983a-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [rdma:k.o/for-4.11 115/115]
 drivers/infiniband/hw/bnxt_re/main.c:231:18: error:
 'RING_ALLOC_REQ_RING_TYPE_L2_CMPL' undeclared
References: <201702230915.2bxOtvc8%fengguang.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
In-Reply-To: <201702230915.2bxOtvc8%fengguang.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

--8kelRRcAN7qHEN6HCC5SsjesgieDaUIvW
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 2/22/2017 8:22 PM, kbuild test robot wrote:
> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/dledford/rdma.g=
it k.o/for-4.11
> head:   db690328a7df0b507f7d59de0c7e1bbe8f4b9e6a
> commit: db690328a7df0b507f7d59de0c7e1bbe8f4b9e6a [115/115] RDMA/bnxt_re=
: fix for "bnxt_en: Update to firmware interface spec 1.7.0."
> config: i386-allmodconfig (attached as .config)
> compiler: gcc-6 (Debian 6.2.0-3) 6.2.0 20160901
> reproduce:
>         git checkout db690328a7df0b507f7d59de0c7e1bbe8f4b9e6a
>         # save the attached .config to linux build tree
>         make ARCH=3Di386=20
>=20
> All errors (new ones prefixed by >>):
>=20
>    drivers/infiniband/hw/bnxt_re/main.c: In function 'bnxt_re_net_ring_=
free':
>>> drivers/infiniband/hw/bnxt_re/main.c:231:18: error: 'RING_ALLOC_REQ_R=
ING_TYPE_L2_CMPL' undeclared (first use in this function)
>      req.ring_type =3D RING_ALLOC_REQ_RING_TYPE_L2_CMPL;
>                      ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>    drivers/infiniband/hw/bnxt_re/main.c:231:18: note: each undeclared i=
dentifier is reported only once for each function it appears in
>    drivers/infiniband/hw/bnxt_re/main.c: In function 'bnxt_re_net_ring_=
alloc':
>    drivers/infiniband/hw/bnxt_re/main.c:271:18: error: 'RING_ALLOC_REQ_=
RING_TYPE_L2_CMPL' undeclared (first use in this function)
>      req.ring_type =3D RING_ALLOC_REQ_RING_TYPE_L2_CMPL;
>                      ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

This is an expected failure.  The patch that causes this failure, fixes
the same failure when combined with Dave Miller's net-next tree where
the ring type name has been renamed to match what this patch now uses.

>=20
> vim +/RING_ALLOC_REQ_RING_TYPE_L2_CMPL +231 drivers/infiniband/hw/bnxt_=
re/main.c
>=20
>    225		if (lock_wait) {
>    226			rtnl_lock();
>    227			do_unlock =3D true;
>    228		}
>    229=09
>    230		bnxt_re_init_hwrm_hdr(rdev, (void *)&req, HWRM_RING_FREE, -1, -=
1);
>  > 231		req.ring_type =3D RING_ALLOC_REQ_RING_TYPE_L2_CMPL;
>    232		req.ring_id =3D cpu_to_le16(fw_ring_id);
>    233		bnxt_re_fill_fw_msg(&fw_msg, (void *)&req, sizeof(req), (void *=
)&resp,
>    234				    sizeof(resp), DFLT_HWRM_CMD_TIMEOUT);
>=20
> ---
> 0-DAY kernel test infrastructure                Open Source Technology =
Center
> https://lists.01.org/pipermail/kbuild-all                   Intel Corpo=
ration
>=20


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG Key ID: B826A3330E572FDD
    Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FD=
D


--8kelRRcAN7qHEN6HCC5SsjesgieDaUIvW--

--s84woo06d39tfQpqsNCngU076bBHcEtAJ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJYrtfyAAoJELgmozMOVy/dPSEQAKnNg2DhnTgd+c7zEwSO76Du
uxdP3Sl4xcICDSYQWTfKjWF0JUO+rvhsZCcCwp9NYPjhqvbcCGvQaQfQJxGiu5wP
fDKETNfT0VK9/FasYlnKsDDTv8sh93xXg7my2OoQZoYLySYABBW3XMrdDOBb8vye
h91m32AWx5v2nO+sv0X6f1dQ3GCVCa8KlTvK9hYQdxKSohOLXolgOOowtoledPjL
qS9CKXctYdILwQa90ktWB5UgjYWoWzQhymKR6VbtPQ3a+IG3wZ3FwFpb+7843Eop
M7NQdwekwbUfRcdgthtPjobIJR0XmzY4FBIBsABegY9oUBaEWJcDX/UOIdfu9AIG
5VsvsX+pFUj4gQHhqDkXuRCYKp0Lkd4tRJ3fDZvPtraeY+1acB+kOtbXiqjfe2oL
GyTvrib3eem70GSbnZ9Fkd3yFm9ysquBxWo8fSiG2wYK+6yUAefX5rndLteYbKtm
W3gCxqGWprZd/MmAIVINXwJ3oqi22j89IPOIBdjc6Kz29uFQ3c6kqOg6oKyObubk
cvnlAtGi5o06vopXFLfJUgRcmWIwXGvMb7WoHAV4+pFSZ8nB135en7U9OYsv1ayl
mO/7MuI/tEOSFHUMgYDSFqWysGvf6oGmRN+19LGInG1op7pX80SQOQ3F7sonwgZy
kUIKh/54NboFYf42mGMr
=7Vef
-----END PGP SIGNATURE-----

--s84woo06d39tfQpqsNCngU076bBHcEtAJ--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
