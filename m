From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [rdma-rc 03/14] RDMA/core: Remove unimplemented node_types and
 node transport
Date: Mon, 31 Jul 2017 11:35:00 -0400
Message-ID: <786999dd-81cf-cbef-5dc4-a18953cb2ca9@redhat.com>
References: <20170731070924.7193-1-leon@kernel.org>
 <20170731070924.7193-4-leon@kernel.org>
 <2e1b38f9-ae7a-4f5e-9cac-168f1f9b56af@dev.mellanox.co.il>
 <20170731121823.GV13672@mtr-leonro.local>
 <63a8961c-7341-80c2-c417-67d4e6fd4702@intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="Ndow32EEGFBrC42bSxrdAK6SMqw87lGm8"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <63a8961c-7341-80c2-c417-67d4e6fd4702-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--Ndow32EEGFBrC42bSxrdAK6SMqw87lGm8
Content-Type: multipart/mixed; boundary="Xv9uWkrQW4bIk7fN0tTgnBxXENjfO7NHU";
 protected-headers="v1"
From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>,
 Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Message-ID: <786999dd-81cf-cbef-5dc4-a18953cb2ca9-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [rdma-rc 03/14] RDMA/core: Remove unimplemented node_types and
 node transport
References: <20170731070924.7193-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
 <20170731070924.7193-4-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
 <2e1b38f9-ae7a-4f5e-9cac-168f1f9b56af-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
 <20170731121823.GV13672-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
 <63a8961c-7341-80c2-c417-67d4e6fd4702-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
In-Reply-To: <63a8961c-7341-80c2-c417-67d4e6fd4702-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

--Xv9uWkrQW4bIk7fN0tTgnBxXENjfO7NHU
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 7/31/2017 9:32 AM, Dennis Dalessandro wrote:
> On 7/31/2017 8:18 AM, Leon Romanovsky wrote:
>> On Mon, Jul 31, 2017 at 08:01:51AM -0400, Hal Rosenstock wrote:
>>> On 7/31/2017 3:09 AM, Leon Romanovsky wrote:
>>>> From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>>>>
>>>> There is no need to carry code, which is not implemented in any
>>>> underlying hardware.
>>>
>>> AFAIK there are Linux based IB switch implementations and there may b=
e
>>> IB router implementation(s) whose drivers have not been pushed upstre=
am
>>> so it would be better to leave at least those 2 node types in.
>>
>> So if they care, this code will be pushed together with needed fields.=

>> Right now, this code is not connected in current linux kernel code,
>> not tested and can't be exposed.
>>
>> It is dead code from upstream point of view.
>>
>> Thanks
>>
>=20
> I would be fine leaving the code in for a driver which was in the works=

> or fairly new. For instance the bnxt patch (11/14), perhaps there are
> plans to implement that stuff soonish. I'll let that driver's maintaine=
r
> make that case though.
>=20
> However these things are not new and unless someone is working on code
> to implement those things I would lean toward removing.
>=20
> There is a fine line between dead code and code waiting to be written.
>=20
> -Denny

Neither of which is -rc material though.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG Key ID: B826A3330E572FDD
    Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FD=
D


--Xv9uWkrQW4bIk7fN0tTgnBxXENjfO7NHU--

--Ndow32EEGFBrC42bSxrdAK6SMqw87lGm8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJZf04kAAoJELgmozMOVy/dVpAP/iImZM2ZK3vC3HszoXNobn1j
o5nJ24duwzZank5hX7FI1u/T9p4dCqc1AqrHRgFEmnb2kh3kkA/Zw06N5KL82zMg
z8c+S0aVFj8BO1vhQzVFDu3I6Jtp86j4Ots9q/4xaHHh/TKBZbP3/wZFoy5ZxzB7
MjkQ3kWVRVLPeg/JIcUsDr2bmw5e8jtzbS4hoXdiQMLu+tXSP2Ogijvf36Ow0fXc
uf4d2UjcTvhOXb62fSykCeJLILFsT0cLoLAG9Kvy+fRMHv5dXZnd+of1CGPGyQ4q
iqdfMLG5JwbdbFLClll1aUgyTcW3YiIBC2qMes9UbxjkKDIKuftlG69eVTVd5+Ji
X05smmGv/WYISH+iPEoUsmDbkki58nvEtMd7ZJb+jHn67FXphLcOlYeZp0rAx6pN
uSmt5VwQF/onPih8DGZrUvcp0hgasFWN/VKPBCHo8TuoJizcGp/amQvsO/awGTxv
JHV6W5+UV+SvPxtzPlzEQbva/0wiqid4tbG4ifI8ogf8iq1kevnAc58H/IW3JQpT
bja+iu4G8wghP0linq4pBqQA7krG1vYYVd0VmOprpRAHNlyOGVFjFKPbyPkoaQxx
3o4Ux+eNdGLQ/yF+4UqaIN6OlGwYXREScKth1R4rHUhyuVpIUUcubxlXUHD+FvFG
IUx6kVD6viuiA5Oax7hv
=fdou
-----END PGP SIGNATURE-----

--Ndow32EEGFBrC42bSxrdAK6SMqw87lGm8--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
