From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-next V1 0/8] Introduce vector CALC support
Date: Thu, 17 Mar 2016 11:23:50 -0400
Message-ID: <56EACC06.5030006@redhat.com>
References: <1456215928-9305-1-git-send-email-leon@leon.nu>
 <20160306104508.GB13396@leon.nu> <20160312101724.GB11383@leon.nu>
 <20160317144847.GF25216@leon.nu>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="99EGEi70q9k7OK82F5AqjH6kbKgDF9r9Q"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160317144847.GF25216-2ukJVAZIZ/Y@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: saeedm-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--99EGEi70q9k7OK82F5AqjH6kbKgDF9r9Q
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 03/17/2016 10:48 AM, Leon Romanovsky wrote:
> On Sat, Mar 12, 2016 at 12:17:24PM +0200, Leon Romanovsky wrote:
>> On Sun, Mar 06, 2016 at 12:45:08PM +0200, Leon Romanovsky wrote:
>>> On Tue, Feb 23, 2016 at 10:25:20AM +0200, Leon Romanovsky wrote:
>>>> From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>>>>
>>>> NET part (patches #1-3)
>>>> * Patch #1 fixes ATOMIC capability mode. This change has  no impact =
on
>>>> * the system, since MAX property is not in use for ATOMIC.
>>>> * Patch #2 merges two device capability calls in one.
>>>> * Patch #3 adds infrastructure to support vector CALC querying.
>>>>
>>>> IB part (patches #4-8)
>>>> * Patch #4 refactors device query code by eliminating the unnecessar=
y zeroing
>>>>   of variables
>>>> * Patch #5 converts device capability mask from u32 to be u64 and su=
pport more
>>>>   than 32 device capabilities.
>>>
>>> Hi Doug,
>>> Is it possible to accept the patches #1-5 which fix and refactor
>>> code only?
>>
>> Hi Doug,
>> Your response will be greatly appreciated.
>=20
> Hi Doug,
> As a follow up to our phone conversation, the patches #1-5 has nothing
> related to Vector CALC which is introduced in patch #6 only.
>=20
> These patches perform simple refactoring and value extension which is
> enough for Eli's SRIOV series.
>=20
> The patches #6-8 will be respinned later with improved version of
> Vector CALC.

Ok.


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--99EGEi70q9k7OK82F5AqjH6kbKgDF9r9Q
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJW6swHAAoJELgmozMOVy/dgO4P/iKjknQkB5isMsFRIysg+Cjj
XG0fbjDsPOK88qvbZz+9qCSnDqR76xeENeomtdNucm36/JTgC2Zuu4Kqa9T/0QdI
ocdI4BmWEPBzFGEyO1arw+FgpO+/8GbVYZPXJhKP4B6QlyNnNVEtuG+AtUaUD5iL
j9bduNolS1RL7IcGbLYUn+UqTwLk7f5+OlF1/eVm2ijKS/5EdsXH6lAk/+fnNODN
16Vvh3fX6oD3m2Rrytwi+QbCE0vwumEMzVM88Yki2OsVHz120QR13HI24c57p20o
zx7DtxypToqnhLPr7VwNFF4RO6XPuSRFTAswIVTKUO1QyPTFChpj1LnyZ7mH63Ir
mYChpgomR4QcUvUDQoVtLsgSF+Fv/ylOwKJvAe3n1d2/WyI/BZObA0T2ZincWgEV
dp2S3Jow0uZSd2vo3hhppAtcVSg+gs8cQSBkVx8ebgGFANMSrXyYqQIE9rDOxYVd
mjMOOZt11i40adfsFg9Yc/gMb7DNwkAcjKj0PCicR5aj8DzckVQ9Lx5+K57QM3C9
nB9xNucBxVWJRF2qQczo60AHtDvgtdSjR4hhvyOfQLUy7o5KAOJu/QK+oiuZ/zQ1
S013g4QfYfoG2fdl3Ad8DLx4mTi9WreFxF2snJvAYbJqPtfCPGxVQ7L2n8GrPaln
Ydn6vWPw+wf8isA37dal
=X/RK
-----END PGP SIGNATURE-----

--99EGEi70q9k7OK82F5AqjH6kbKgDF9r9Q--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
