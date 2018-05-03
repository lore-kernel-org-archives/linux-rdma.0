From: Doug Ledford <dledford@redhat.com>
Subject: Re: [PATCH for-rc v2 1/6] IB/hfi1: Fix handling of FECN marked
 multicast packet
Date: Thu, 3 May 2018 15:08:39 -0400
Message-ID: <af1960a1-4e05-3e7a-910b-99fd96d1a27f@redhat.com>
References: <20180501123317.24520.8848.stgit@scvm10.sc.intel.com>
 <20180501123532.24520.80857.stgit@scvm10.sc.intel.com>
 <20180501180531.GB17027@ziepe.ca>
 <32E1700B9017364D9B60AED9960492BC6281B784@fmsmsx120.amr.corp.intel.com>
 <1525227892.11756.131.camel@redhat.com>
 <32E1700B9017364D9B60AED9960492BC62829957@fmsmsx120.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="fw8bg0KEs3jqQ5pcESr7dNSk2VgFBZdA4"
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <32E1700B9017364D9B60AED9960492BC62829957@fmsmsx120.amr.corp.intel.com>
Sender: stable-owner@vger.kernel.org
To: "Marciniszyn, Mike" <mike.marciniszyn@intel.com>, Jason Gunthorpe <jgg@ziepe.ca>, "Dalessandro, Dennis" <dennis.dalessandro@intel.com>
Cc: "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "Hiatt, Don" <don.hiatt@intel.com>, "stable@vger.kernel.org" <stable@vger.kernel.org>, "Ruhl, Michael J" <michael.j.ruhl@intel.com>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--fw8bg0KEs3jqQ5pcESr7dNSk2VgFBZdA4
Content-Type: multipart/mixed; boundary="xoTKiR9Xg4Os0xk0JY93B42ADm533R99B";
 protected-headers="v1"
From: Doug Ledford <dledford@redhat.com>
To: "Marciniszyn, Mike" <mike.marciniszyn@intel.com>,
 Jason Gunthorpe <jgg@ziepe.ca>,
 "Dalessandro, Dennis" <dennis.dalessandro@intel.com>
Cc: "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
 "Hiatt, Don" <don.hiatt@intel.com>,
 "stable@vger.kernel.org" <stable@vger.kernel.org>,
 "Ruhl, Michael J" <michael.j.ruhl@intel.com>
Message-ID: <af1960a1-4e05-3e7a-910b-99fd96d1a27f@redhat.com>
Subject: Re: [PATCH for-rc v2 1/6] IB/hfi1: Fix handling of FECN marked
 multicast packet
References: <20180501123317.24520.8848.stgit@scvm10.sc.intel.com>
 <20180501123532.24520.80857.stgit@scvm10.sc.intel.com>
 <20180501180531.GB17027@ziepe.ca>
 <32E1700B9017364D9B60AED9960492BC6281B784@fmsmsx120.amr.corp.intel.com>
 <1525227892.11756.131.camel@redhat.com>
 <32E1700B9017364D9B60AED9960492BC62829957@fmsmsx120.amr.corp.intel.com>
In-Reply-To: <32E1700B9017364D9B60AED9960492BC62829957@fmsmsx120.amr.corp.intel.com>

--xoTKiR9Xg4Os0xk0JY93B42ADm533R99B
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 5/3/2018 8:54 AM, Marciniszyn, Mike wrote:
>>>
>>> But I see Doug pulled the fix?
>>
>> It's in my wip branch, so until I merge it into the official for-rc
>> branch, I can still fix up minor things like this.
>>
>=20
> The patch works without the cast.
>=20
> How do you want to do this:
> - A v2 -> v3 of the patch?
> - Manually delete the cast in your wip branch?
>=20
> Here is the diff hunk for removing the cast from return_cnp:
> diff --git a/drivers/infiniband/hw/hfi1/ud.c b/drivers/infiniband/hw/hf=
i1/ud.c
> index 9aa7d87..6ad203f 100644
> --- a/drivers/infiniband/hw/hfi1/ud.c
> +++ b/drivers/infiniband/hw/hfi1/ud.c
> @@ -719,7 +719,7 @@ void return_cnp(struct hfi1_ibport *ibp, struct rvt=
_qp *qp, u32 remote_qpn,
>=20
>         lrh0 |=3D (sc5 & 0xf) << 12 | sl << 4;
>=20
> -       bth0 =3D (u32)pkey | (IB_OPCODE_CNP << 24);
> +       bth0 =3D pkey | (IB_OPCODE_CNP << 24);
>         ohdr->bth[0] =3D cpu_to_be32(bth0);
>=20
>         ohdr->bth[1] =3D cpu_to_be32(remote_qpn | (1 << IB_BECN_SHIFT))=
;
>=20
> Mike
>=20

I'll manually delete it in my WIP.  Thanks for getting the test results
back :-)


--xoTKiR9Xg4Os0xk0JY93B42ADm533R99B--

--fw8bg0KEs3jqQ5pcESr7dNSk2VgFBZdA4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIzBAEBCAAdFiEErmsb2hIrI7QmWxJ0uCajMw5XL90FAlrrXjcACgkQuCajMw5X
L90atRAArkClqe2RIwgtHplQgL3cqAyxiwG20kDdP4yvmbYLww3+ghcXDaMLy712
hGm8VJBvOOPecG17P7XlcefRDDnNdymIaoP2JxuHm8XKYYBfupkL/pFAUQkgMTia
t7IT0wS3CDemvHHOmJlvMRLofFbk68iq3b3ZPxXd7JvyDegjbdErc5DYRrgq54wz
GDbA/EG7pSgR8RSUHC78PBB6BBlPt0yqQTBNSUFsXY29bNykrnUNYZZTQ6yg5M1B
DZ2ndFUxCPX5CDW0/jiJj2V7JhVX3sig0rn9mNZRYQENS5JIcdYKcm0s1ErwUrIB
gr8hJYTTmykKll0DKqssKwm1L5eIkdIoYqRrlh65eioNdpXEmp/NT+4QUhm4lq3K
YOQ2ggjO3qDYzvhKTKJFu3O1QqSrHWe1El/xWzbBKrO+uE/BtpNyijaX5intf399
UWojqkquqtjbmluNYo6XWVYx7YuPHOQsbqhDP58VQtWmP/nTsn3QhhsPeYYj5hv5
tTgbmOdogXRnKFgJFYRwJdrNcrFAHut1jYYVbpcNH4xyd5dTxQXZxigBUPitJuZ0
4QnvRZ2SNvMYpIfgK1z88hZa8J0n4XZHKQPbyjH5w6IosILWkobfDgOWUVQp2bf/
GxJh7K3Wflq4TrYXf7cvVsAcyIiHDA1uZHPVcobXVNbOt8Vc+W8=
=6iz6
-----END PGP SIGNATURE-----

--fw8bg0KEs3jqQ5pcESr7dNSk2VgFBZdA4--
