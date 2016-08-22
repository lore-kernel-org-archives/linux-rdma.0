From: Doug Ledford <dledford@redhat.com>
Subject: Re: [PATCH] IB/hfi1: Add missing error code assignment before test
Date: Mon, 22 Aug 2016 14:23:41 -0400
Message-ID: <c0e516a7-a131-25f6-b865-b44f3cf4ac4a@redhat.com>
References: <1470807267-12714-1-git-send-email-christophe.jaillet@wanadoo.fr>
 <1470845455.2576.6.camel@intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="oKQRCo6xbcPaTJR8WaVejTQqPw1h4Lnsx"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1470845455.2576.6.camel@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Dalessandro, Dennis" <dennis.dalessandro@intel.com>, "christophe.jaillet@wanadoo.fr" <christophe.jaillet@wanadoo.fr>, "hal.rosenstock@gmail.com" <hal.rosenstock@gmail.com>, "Marciniszyn, Mike" <mike.marciniszyn@intel.com>, "Hefty, Sean" <sean.hefty@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--oKQRCo6xbcPaTJR8WaVejTQqPw1h4Lnsx
Content-Type: multipart/mixed; boundary="k8mqbc8ciubU8owjhbjdNCLvBSNvjsIoW"
From: Doug Ledford <dledford@redhat.com>
To: "Dalessandro, Dennis" <dennis.dalessandro@intel.com>,
 "christophe.jaillet@wanadoo.fr" <christophe.jaillet@wanadoo.fr>,
 "hal.rosenstock@gmail.com" <hal.rosenstock@gmail.com>,
 "Marciniszyn, Mike" <mike.marciniszyn@intel.com>,
 "Hefty, Sean" <sean.hefty@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
 "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>
Message-ID: <c0e516a7-a131-25f6-b865-b44f3cf4ac4a@redhat.com>
Subject: Re: [PATCH] IB/hfi1: Add missing error code assignment before test
References: <1470807267-12714-1-git-send-email-christophe.jaillet@wanadoo.fr>
 <1470845455.2576.6.camel@intel.com>
In-Reply-To: <1470845455.2576.6.camel@intel.com>

--k8mqbc8ciubU8owjhbjdNCLvBSNvjsIoW
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 8/10/2016 12:10 PM, Dalessandro, Dennis wrote:
> On Wed, 2016-08-10 at 07:34 +0200, Christophe JAILLET wrote:
>> It is likely that checking the result of 'setup_ctxt' is expected
>> here.
>>
>> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
>> ---

>=20
> Thanks for the patch.
>=20
> Acked-by: Dennis Dalessandro <dennis.dalessandro@intel.com>
>=20

Thanks, applied.

--=20
Doug Ledford <dledford@redhat.com>
    GPG Key ID: 0E572FDD


--k8mqbc8ciubU8owjhbjdNCLvBSNvjsIoW--

--oKQRCo6xbcPaTJR8WaVejTQqPw1h4Lnsx
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJXu0MtAAoJELgmozMOVy/ddCcP/Agpoal/jRWob1dgN8w4Z58V
AxS14zNy5JWV+WcxTFt9z6vbog1cnvWzbfJM885hYScs3+N3M77K2Y46CdnVcLZ2
x6GUK8qfUiiKqIvmfsIFE1YbGhtd1XaWBUBMo9NwD2q++r7ITJkDHsqAjtxiMsYo
9HhhRi5q4H91L1ofoGrO5VxsWef2Pm+Ml35RmYzYYINDf8/HEYfYIXFqdRVMT47D
GbpoE3LHRlHoADiBbx4ok8Un0W0jBbdiPM6Mn4oe/9KiiujjF6F5NXeR18f5kDJY
Fbnz85u/QwqufL8gzKOHr3kkKE5KII+XNNOozQ6ehNDw2UJsoe3c8T94o+iyAG+Q
Yb2GWXG3u2vqRXr1CqAGW8cq3Ih6azQwUatKRz2SJebOfLwj3wIfphEBhTaVQLvY
TmYfDRq7c6wENdbnr6Y0xqQeSqB88HnBIWAsJEdgblbZixD0HoPCa8sJQ2vMNrsd
A0M0vECzuPcp5EfJGBQxIJ9mQkIB8fIE6r3JAEjvwHQkwnuSS/xw6743wkil+/z5
mL6PSoROcGl7ofU3AKeKB2PfihYxXB+fDLO47lMfR+cqwA4jZ2GFUU9UeA2IJ47J
6TXqh5QlLtgjO0lA3GQ/CR1FVnqje1IC1lFGAu7ThgLhqF5Ui7+JmEtajkww4cwG
wNqlWzK669mpgG9fX0PL
=To2W
-----END PGP SIGNATURE-----

--oKQRCo6xbcPaTJR8WaVejTQqPw1h4Lnsx--
