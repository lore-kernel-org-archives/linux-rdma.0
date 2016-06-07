From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v3 0/2] fix ib_device_cap_flags bit curruption
Date: Tue, 7 Jun 2016 08:00:09 -0400
Message-ID: <23179dd8-1b68-bda5-7ea8-a810084129cc@redhat.com>
References: <1465230880-25953-1-git-send-email-maxg@mellanox.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="ISWivmOrswOlSGdajnRhjW3dngSMrbe8x"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1465230880-25953-1-git-send-email-maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, robert-4JaGZRWAfWbajFs6igw21g@public.gmane.org, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, leon-2ukJVAZIZ/Y@public.gmane.org, sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--ISWivmOrswOlSGdajnRhjW3dngSMrbe8x
Content-Type: multipart/mixed; boundary="qisvVbwr3CAwKote0DpR0r6bxI1S06gfR"
From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, robert-4JaGZRWAfWbajFs6igw21g@public.gmane.org,
 matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, leon-2ukJVAZIZ/Y@public.gmane.org, sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org,
 linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Message-ID: <23179dd8-1b68-bda5-7ea8-a810084129cc-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v3 0/2] fix ib_device_cap_flags bit curruption
References: <1465230880-25953-1-git-send-email-maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
In-Reply-To: <1465230880-25953-1-git-send-email-maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

--qisvVbwr3CAwKote0DpR0r6bxI1S06gfR
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 6/6/2016 12:34 PM, Max Gurtovoy wrote:
> This patch set fixes a bit corruption caused by expanding ib_device_cap=
_flags
> enum to 64 bits, that caused a sign extension.
> After many discussions regarding the solution, we decided on minimal fi=
x in the
> first stage.
> Later on, we'll align all the caps enum to BIT/BIT_ULL macros as GKH re=
commended.
> The addition in this vesion is the alignment of the casting method.
>=20
>=20
> Max Gurtovoy (2):
>   IB/core: Fix bit curruption in ib_device_cap_flags structure
>   IB/core: Align casting method of ib_device_cap_flags enumerations to
>     ULL

Series applied (albeit with a fixed up subject and message in the second
patch).  Thanks.



--qisvVbwr3CAwKote0DpR0r6bxI1S06gfR--

--ISWivmOrswOlSGdajnRhjW3dngSMrbe8x
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJXVrdJAAoJELgmozMOVy/dGW0P/jsGoMCOQPjCp7X4NIk7Tejv
693yQyWs6l7Kehvm1p5fY7Rq08igjfYOxtraEr8RTwzAylU6Rc1rg6Q+H/Jt8lD3
kx3MLZfhphMXTmR241aMe+DmcymSLije07hW7/jc7+y4Jf+VbUG42zg6C0toQKYC
MLUGe+ARrFZ2HdvtTCNiw5fI8+F9RqG0NTCTvB2N0dtNLC9jySH7P6oPlhAVvv3A
u7qAxQyr+LLjasEKafXV8MRRXRY87xfKL0yqGOCWMBEsW0UDFTmFl2lo94Vb6scz
zt3Bt4cr+qTAfaWHJJmuhrSpXoh74CnQDIq+kC+7CLKK0/SiJuOitswGSbvPnB3X
jipOJCWZJMR7AaVVIPdgQfKk5xLeno5tQZWZ8RCVdOkDe9JCbTGu67Q/iJaxz8PM
X/KGGY1c0aPb5Vl8F+lYFTidW3I5p4kOrU+U1DuJ2rTxpWdUM80Mo8RjIkuc0MOb
T6jZQeKdkdeL+c+CyHPyYPhd/ovc9ANHNfZLJFYkQvt+QcxiYswgt0bYYhZhpoUf
H6ayF1DWRuuzUudJdF4tvGhNWnHahMEHze7vSzwIC3bsZvrRX2RA9ClxYw1ul/NC
bBbX202pUE+sSjhkIjhhHv8j2Rq5yFT8mdyFLZgnktYQJtInoSwJQ8VY64QXOs9l
/uPy0OeOwAn/tvjDVR3S
=on12
-----END PGP SIGNATURE-----

--ISWivmOrswOlSGdajnRhjW3dngSMrbe8x--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
