From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 0/4] hfi1/rdmavt: For 4.8 rc
Date: Mon, 22 Aug 2016 14:41:12 -0400
Message-ID: <46938952-7613-634f-eb5e-8d566d97fbfe@redhat.com>
References: <20160816202133.24004.31487.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="O9JvVqREEFnm4jSIQ5HhuURLPFH4xKMkL"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160816202133.24004.31487.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mitko Haralanov <mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Easwar Hariharan <easwar.hariharan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--O9JvVqREEFnm4jSIQ5HhuURLPFH4xKMkL
Content-Type: multipart/mixed; boundary="BhvT9iki5JVJVcmESersxPKfhF5pqsHg6"
From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>,
 Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
 Mitko Haralanov <mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>,
 Easwar Hariharan <easwar.hariharan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>,
 Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Message-ID: <46938952-7613-634f-eb5e-8d566d97fbfe-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 0/4] hfi1/rdmavt: For 4.8 rc
References: <20160816202133.24004.31487.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
In-Reply-To: <20160816202133.24004.31487.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>

--BhvT9iki5JVJVcmESersxPKfhF5pqsHg6
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 8/16/2016 4:23 PM, Dennis Dalessandro wrote:
> Doug,
>=20
> Here are four patches that we'd like to get into the rc cycle.
>=20
> These apply on top of the last set of patches Ira sent (including the v=
2 of
> [1]).
>=20
> [1] http://marc.info/?l=3Dlinux-rdma&m=3D147116491910005&w=3D2
>=20
> Patches can also be viewed in my repo at:
> https://github.com/ddalessa/kernel/tree/for-4.8
>=20
> ---
>=20
> Easwar Hariharan (1):
>       IB/hfi1: Return invalid field for non-QSFP CableInfo queries
>=20
> Ira Weiny (1):
>       IB/hfi1: Fix mm_struct use after free
>=20
> Mike Marciniszyn (1):
>       IB/rdmvat: Fix double vfree() in rvt_create_qp() error path
>=20
> Mitko Haralanov (1):
>       IB/hfi1: Improve J_KEY generation
>=20
>=20
>  drivers/infiniband/hw/hfi1/file_ops.c |    2 ++
>  drivers/infiniband/hw/hfi1/hfi.h      |   19 ++++++++++++++++++-
>  drivers/infiniband/hw/hfi1/mad.c      |    5 +++++
>  drivers/infiniband/sw/rdmavt/qp.c     |    3 ++-
>  4 files changed, 27 insertions(+), 2 deletions(-)
>=20
> --
> -Denny
>=20

Series applied, thanks.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG Key ID: 0E572FDD


--BhvT9iki5JVJVcmESersxPKfhF5pqsHg6--

--O9JvVqREEFnm4jSIQ5HhuURLPFH4xKMkL
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJXu0dIAAoJELgmozMOVy/dSpYQAJdC8Du7QVhAAeixmyVgXJJj
FoPka4Fe1s7ZFPMcrXnG1Nsu36yVWbnSclCDKk+dUunAoSWeDQtfiKehHLsvbyXe
B4Y/4whVt92/C48kIjus3zPsvxg6gysaLZ74cxv8RIMF+Mt5oh4Ymp3ACuvytRbP
5pUttY7Y+kfwYC30RhUoHD1OuYLomiuvzYAwzOPWp0rtY3gNHaIwMfyYML2sDeDS
edpbIyPUcgmpns6g13PBV9pw3QLczX2yK4qSuKMtFZGaJAt8aFnNfGK697KGth5G
H4i6hp515Aro5qOln3VPKl2diRdB6yRDAcKN1YSzAmannNBywuswyAhBScR1Bx7U
HBv/L5bc5YRhLvFIcH+1kje1S7sqNno77/j/GHFpQm2j2Cy9vcfmUTpRTRLGzewj
cB+bRzZwY7kURemsC95CjepNIAqoPe614poKc1S3vNssq9ANEpJctqu55ymJMmOx
7zWuuSTUDYsPhdE1ll85FQXPc7Eboypr+0nl/wNUi4dWBJsTW7XDJftJ+SO5MOUU
aTAXIpsa8S8usXo1eTDWzwbux79w/neVx/rNi7+5t9WFbx/zlvhD1dlaxv6NrrQv
eBEYnY3rZwBAz8RTBaLPmtR+dNGKUPIsDCa7jWKvOiq4xdjSpXJufzAtYPQOqxMJ
NQ6vxZr60tVaMfICh/og
=p4Pj
-----END PGP SIGNATURE-----

--O9JvVqREEFnm4jSIQ5HhuURLPFH4xKMkL--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
