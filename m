From: Doug Ledford <dledford@redhat.com>
Subject: Re: [PATCH] IB/mlx5: Fix a parameter of find_first_bit
Date: Fri, 2 Sep 2016 13:12:23 -0400
Message-ID: <c503d7b7-8c4f-ee47-a989-63bea7c58a67@redhat.com>
References: <1472188577-14550-1-git-send-email-christophe.jaillet@wanadoo.fr>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="FBGBuoqdD0ccTfgv6l0nATw1TsEcHiFdC"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1472188577-14550-1-git-send-email-christophe.jaillet@wanadoo.fr>
Sender: linux-kernel-owner@vger.kernel.org
To: Christophe JAILLET <christophe.jaillet@wanadoo.fr>, matanb@mellanox.com, leonro@mellanox.com, sean.hefty@intel.com, hal.rosenstock@gmail.com
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--FBGBuoqdD0ccTfgv6l0nATw1TsEcHiFdC
Content-Type: multipart/mixed; boundary="pa2B8wc7Of8VnAxLFnVllIbf2MgmC4MmM";
 protected-headers="v1"
From: Doug Ledford <dledford@redhat.com>
To: Christophe JAILLET <christophe.jaillet@wanadoo.fr>, matanb@mellanox.com,
 leonro@mellanox.com, sean.hefty@intel.com, hal.rosenstock@gmail.com
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org,
 kernel-janitors@vger.kernel.org
Message-ID: <c503d7b7-8c4f-ee47-a989-63bea7c58a67@redhat.com>
Subject: Re: [PATCH] IB/mlx5: Fix a parameter of find_first_bit
References: <1472188577-14550-1-git-send-email-christophe.jaillet@wanadoo.fr>
In-Reply-To: <1472188577-14550-1-git-send-email-christophe.jaillet@wanadoo.fr>

--pa2B8wc7Of8VnAxLFnVllIbf2MgmC4MmM
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 8/26/2016 1:16 AM, Christophe JAILLET wrote:
> The 2nd parameter of 'find_first_bit' is the number of bits to search.
> In this case, we are passing 'sizeof(tmp)' which is likely to be 4 or 8=

> because 'tmp' is an 'unsigned long'.
>=20
> It is likely that the number of bits of 'tmp' was expected here. So use=

> BITS_PER_LONG instead.

Thanks, applied.


--=20
Doug Ledford <dledford@redhat.com>
    GPG Key ID: 0E572FDD


--pa2B8wc7Of8VnAxLFnVllIbf2MgmC4MmM--

--FBGBuoqdD0ccTfgv6l0nATw1TsEcHiFdC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJXybL3AAoJELgmozMOVy/ddpQQAJWnrHS0lgoRbcaznlLVpYiW
E/Xrv5J3DxkjVji4RHaFRoZNoSqf7PPR0PFY4HIdFXNsNnnJukPcoOOWSVMQjGD9
A+EguptQj7DnfifRe43l3E6ATJ5OSFtXTE3p8+j6PD5wRirTiDk7WKbpwQWsW33J
Gu9uVlOL3aCLh6hbB/R0tqQFftwu4k443736q7Qk8it9saMV2O3PPvVcNTXvrUkM
OPaJhBkWKL6Rgiqn0hcVf2gHKG5pmtxoLy6/W7Wfub4wIcVmvhU2ae4AS24DZUhP
Uo7LA2PXrlEwydQRYQGMO7cDSij2tywuWV9QZwdGB8IMErinb6Va6nWLpifooAIT
QqPEAHF5JEdBIhBzTfCEDQsc/hbbgmw/zJYjf0iCcrb810Hh8TGNSxIRRXz6woNJ
bASlrEfsQ0JXXD66KuGtc1X3H9k4Ejwl88+08jzpc7GwrbvlKcL1AZMKUpRnShDH
Yq9Cz7AqKKPdHgSqiOsar5tZ7Z6iLUhteEXQwaKYrffdryoVQR2OlU83er2HM3yc
P56UqztrZoLtS388J++8gElBUuKVhEFLclpMYOENVROiUduF0E75KhssPQGWRgIm
oAI0MRS5+e+Z/Y1Ww5I4fw6GARXnlmaAai2gKr5jGvxTGU8hFoWSA4etV0W+3GAk
sRKD70SV99xh61AGRTzZ
=BLvO
-----END PGP SIGNATURE-----

--FBGBuoqdD0ccTfgv6l0nATw1TsEcHiFdC--
