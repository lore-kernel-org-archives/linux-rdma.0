From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 0/4] Two fixes for prev 4.9 and two new fixes
Date: Mon, 3 Oct 2016 11:33:29 -0400
Message-ID: <3027d54b-b321-9158-6749-e80c9b821252@redhat.com>
References: <20161001030935.15264.34730.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="dFAgNgts2ovaOCPDncjbWD9pgpkHww4id"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20161001030935.15264.34730.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jianxin Xiong <jianxin.xiong-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--dFAgNgts2ovaOCPDncjbWD9pgpkHww4id
Content-Type: multipart/mixed; boundary="NftDMdUdRA0Sui46JKtNwicSd2InlkT3l";
 protected-headers="v1"
From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mike Marciniszyn
 <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>,
 Jianxin Xiong <jianxin.xiong-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Message-ID: <3027d54b-b321-9158-6749-e80c9b821252-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 0/4] Two fixes for prev 4.9 and two new fixes
References: <20161001030935.15264.34730.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
In-Reply-To: <20161001030935.15264.34730.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>

--NftDMdUdRA0Sui46JKtNwicSd2InlkT3l
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 9/30/2016 11:10 PM, Dennis Dalessandro wrote:
> Doug,
>=20
> The first two patches here are fixes for patches you picked up in your =
hfi1
> branch for 4.9. You may want to squash them. The commit SHAs referrence=
d are
> from your GitHub repo.
>=20
> Pathces 3 and 4 are new fixes for 4.9.

Thanks, I squashed the two fixes in and applied the other two.

> Patches can also be viewed in my repo at:
> https://github.com/ddalessa/kernel/tree/for-4.9
>=20
> ---
>=20
> Ira Weiny (1):
>       IB/hfi1: Fix invalid lockdep assert
>=20
> Jianxin Xiong (1):
>       IB/hfi1: Update SMA ingress checks for response packets
>=20
> Mike Marciniszyn (2):
>       IB/core: Fix atomic regression with ib_hdrs
>       IB/hfi1: Fix trace of atomic ack
>=20
>=20
>  drivers/infiniband/hw/hfi1/qp.c    |    1 -
>  drivers/infiniband/hw/hfi1/trace.c |    4 +--
>  drivers/infiniband/hw/hfi1/ud.c    |   49 ++++++++++++++++++----------=
--------
>  drivers/infiniband/hw/hfi1/verbs.c |    2 +
>  include/rdma/ib_hdrs.h             |    6 ++--
>  5 files changed, 30 insertions(+), 32 deletions(-)
>=20
> --
> -Denny
>=20


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG Key ID: 0E572FDD


--NftDMdUdRA0Sui46JKtNwicSd2InlkT3l--

--dFAgNgts2ovaOCPDncjbWD9pgpkHww4id
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJX8npJAAoJELgmozMOVy/dzkcQAI70DvKa9JCbXXpzRdCvgcq5
XvhM4Ti+UMZXbcMHW4JE57r7bb16uyHoZfCKXZZO3Kt8qQlC/ntnUjOf3LGLn4pT
a14JuKq2GvzNmsxBmsV+PcK04OVQXGs3nF/Pk4PFMoJsDIXZ3pS157F2qw008u3P
S3FynnT42TM03SwmxJ5WyskDwjB3j7q2hpseKRwYZMG9EeAiICUK2wL0tpAt9JOq
rDfa8msNkfccYaPPf3Qg5HnMZniYBV0kP5nKREHDZn1YuQLEeJAdvqGX8EC7w/KX
1Y2hdhDPIiPJPvg8MtmU60QVy5Fip0dN+BULp6jsDtHT+FKYnMRYEkEe6jiUa6wR
tbVIkA56a2wqUTls9V0SjUrXv6KqWOKNuwW335Az/aphfg3Zooaep27nz9HMEEdG
MBPuk2B8JeFKTpEoOz/tp409x32uc94o1gGLKDZKCcb+pTr6rMjSyvU20/ShjjwG
MmaPBbC0gLb07T5A+sjOTd4JTZNc26aZNTtfsZ9tbHK+iT3XO6nPVQYx6VFGlYhs
FCXXHwlYWfaZ0MXmMwOkzrJM2/aPVFPmgs5LU1Zjpg1M4clht3VVZ1Ibf6iFOeV9
b3el+SX+k2RSfHLT3te46hlR/wapsl2qbT+noJ//XNovABpa8SUn73LZUzcUb2X+
ET+X0xxagVhWBS8k6IxK
=kTAC
-----END PGP SIGNATURE-----

--dFAgNgts2ovaOCPDncjbWD9pgpkHww4id--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
