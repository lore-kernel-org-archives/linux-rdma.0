From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH V2] i40iw: Replace the obsolete crypto hash interface with
 shash
Date: Mon, 21 Mar 2016 16:14:57 -0400
Message-ID: <56F05641.5090208@redhat.com>
References: <20160318153833.GA13316@TENIKOLO-MOBL2>
 <20160318155156.GB21677@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="lHB3Bls9fSuL4VA1s1HVQJj698DJWr7oo"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160318155156.GB21677-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>, Tatyana Nikolova <Tatyana.E.Nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: mustafa.ismail-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, sfr-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--lHB3Bls9fSuL4VA1s1HVQJj698DJWr7oo
Content-Type: multipart/mixed; boundary="Uq8RpR953PqsowIMcSfcxhvJVS5UXST1m"
From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>,
 Tatyana Nikolova <Tatyana.E.Nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: mustafa.ismail-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
 faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, sfr-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org
Message-ID: <56F05641.5090208-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH V2] i40iw: Replace the obsolete crypto hash interface with
 shash
References: <20160318153833.GA13316@TENIKOLO-MOBL2>
 <20160318155156.GB21677-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>
In-Reply-To: <20160318155156.GB21677-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>

--Uq8RpR953PqsowIMcSfcxhvJVS5UXST1m
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 3/18/2016 11:51 AM, Herbert Xu wrote:
> On Fri, Mar 18, 2016 at 10:38:33AM -0500, Tatyana Nikolova wrote:
>> This patch replaces the obsolete crypto hash interface with shash
>> and resolves a build failure after merge of the rdma tree
>> which is caused by the removal of crypto hash interface
>>
>> Removing CRYPTO_ALG_ASYNC from crypto_alloc_shash(),
>> because it is by definition sync only =20
>>
>> Signed-off-by: Mustafa Ismail <mustafa.ismail-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>> Signed-off-by: Tatyana Nikolova <tatyana.e.nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>=20
> Acked-by: Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>
>=20

Thanks, applied.


--Uq8RpR953PqsowIMcSfcxhvJVS5UXST1m--

--lHB3Bls9fSuL4VA1s1HVQJj698DJWr7oo
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJW8FZBAAoJELgmozMOVy/dEVMQAIqLK3R4hVyHgvQDHVfMXIAf
2qk/NtFUBEwxaZxfCNMxdGtLsjIPCc7ImVmkph6W/likmCN48PPZa9xuFSeSVPy7
eGdtMOwedKARP86GbNT3n2zqTTxqf5HD4oIi4FyjOX079D/XqSldmmtNAzHQ65Rk
t2/ltpeO+5c82+eqTPgMamCncxyK4m27e9gCq+RgvgmHBa2sqz5B8LHjxboB3sTa
R+VJNc2FAygwO/rxQKzk92y3WxHSpSjKuxS7OSLjPbjzYQFfdkEOrKLTI7dsvVM9
d89F2BAaG84aETYw9bBRrKbQBIWQ2Lmk6k+IZ9XezouVQeyIOwgjXlOB6lsusz5M
U4znTP/VKfiDxMGik19vW+tmurHffiBILuPAf407DPWwEH6kZuJneeMmEsCJEN91
YKHKtV6zHy3uhCZ2jqtzWX1jdOAXaT23+oQvRijnBoTX2D/zzzbqNAzDdeYZn8c5
KgY2Hgf0WFhSiYKC/zZXb2bzZpx30ikzRQIcFO6byuDnADYu7gDJhWVT7/5j2C09
8YdlesZp6rlgF9S8KBiPJGMiTwPJw3Bglnv/zxxwoen/PtucnRWVUmMC5Tp5LBnx
JbwbB0qSzubtzm11suroBLbU39cSxHddY+4WVGypPPhoOU3QGkuikzgpIv00QLw1
3ttxiJxUZ/bc8U/PwsKl
=uTuZ
-----END PGP SIGNATURE-----

--lHB3Bls9fSuL4VA1s1HVQJj698DJWr7oo--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
