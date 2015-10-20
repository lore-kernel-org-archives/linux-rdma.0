From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH TRIVIAL] ib_pack.h: Fix commentary IBA reference for CNP
 in IB opcode enum
Date: Tue, 20 Oct 2015 13:30:32 -0400
Message-ID: <56267A38.6080202@redhat.com>
References: <560C323D.1000409@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="TA1Mg1ceRo4warosDuPswuxDTDF0L3sTE"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <560C323D.1000409-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--TA1Mg1ceRo4warosDuPswuxDTDF0L3sTE
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 09/30/2015 03:04 PM, Hal Rosenstock wrote:
>=20
> IBA spec is now 1.3 not 3.1 and vol 1 should be mentioned
> as there is also vol 2.
>=20
> Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> ---
> diff --git a/include/rdma/ib_pack.h b/include/rdma/ib_pack.h
> index 709a533..e99d8f9 100644
> --- a/include/rdma/ib_pack.h
> +++ b/include/rdma/ib_pack.h
> @@ -76,7 +76,7 @@ enum {
>  	IB_OPCODE_UC                                =3D 0x20,
>  	IB_OPCODE_RD                                =3D 0x40,
>  	IB_OPCODE_UD                                =3D 0x60,
> -	/* per IBTA 3.1 Table 38, A10.3.2 */
> +	/* per IBTA 1.3 vol 1 Table 38, A10.3.2 */

Thanks Hal, I've added this to the 4.4 list.


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--TA1Mg1ceRo4warosDuPswuxDTDF0L3sTE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJWJno4AAoJELgmozMOVy/diD0P/jKHXH6iApK9DtmqMDAuZabz
K6teSvS55ZXVNhrYnhdMMfPghPN4GTT2vAdSUi08TZtVkbTDePYUr9K6wHj4VezH
1nfDSWzUk5BN/HGziGdlUsbfsbLyFkv82ReBGJl6WVQryNq2hzoieAsNsHpgLeTF
LGf3/OOBQIPzuDqC7bjEOqMFRsEifYTLtn/WtmWa8nF/WeB8I5bwaRndGvdmJSOJ
AK+dm8gpfi0Fe97IXSp9axujJ6IQ6XKWgpne0hxNwv+aCqYm8/fJxxLk/WLLcFfB
bXFNK1eGuMK8nOnfySe1OBvc6rCAdYo5n2wBKox/6ZIufM8oAwgyiGM/49D2bE1H
0bVpV7FG/eKtyaaVV73LfWInWb2v0DGxqwdrzYVC5k7h5LP79kGSoFq7fpPK/TY1
/CkkTb00wth6RToH9REJ6Dyez1r0Pw+iECxK7dzZr1nG9wJSUCtmAmzF1kBtewnd
TzqS7Z30wiZGSM+uW0QENLQUbvzvSSFGv2hHi/O8NJz2lKXJVqr1qR572eyJ6Y4u
J/9SN52UpvCzNI1leXmJ14/M92JjfCjE3evHx47cHld7vznje94NGTPdJvUgHIDi
xKHiJt9YUZJoSvyY/OYK3bS9DtB3s5FpvqVPBsrq2n4+nIZJMzMDl1cpKw9nGy4p
lkoJZsDiQh5LWP1FQ65W
=sOiU
-----END PGP SIGNATURE-----

--TA1Mg1ceRo4warosDuPswuxDTDF0L3sTE--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
