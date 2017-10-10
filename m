From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: Is ib_mtu iboe_get_mtu() slightly off?
Date: Tue, 10 Oct 2017 10:48:01 -0400
Message-ID: <c27ee8b9-a011-9b0b-b20a-433d9f74d4b1@redhat.com>
References: <CAL1RGDX33tBR=x2sOp_F1605SY5nu_6YALr-XYE_LiuvsHQ1ng@mail.gmail.com>
 <VI1PR0502MB300886CB47BB3DFDE098A26AD1660@VI1PR0502MB3008.eurprd05.prod.outlook.com>
 <1507556073.46071.27.camel@redhat.com>
 <20171009134131.GB1252@mtr-leonro.local>
 <1507565652.46071.33.camel@redhat.com>
 <VI1PR0502MB3008900E038DEF6EEAB719DFD1740@VI1PR0502MB3008.eurprd05.prod.outlook.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="Sf0hW1UQJpo61318TN9DmST2TXiqHCuGW"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <VI1PR0502MB3008900E038DEF6EEAB719DFD1740-o1MPJYiShExKsLr+rGaxW8DSnupUy6xnnBOFsp37pqbUKgpGm//BTAC/G2K4zDHf@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--Sf0hW1UQJpo61318TN9DmST2TXiqHCuGW
Content-Type: multipart/mixed; boundary="Wg7VrhM1UoQv3NhngTHLJuvBlPA5jILcp";
 protected-headers="v1"
From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>,
 "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Message-ID: <c27ee8b9-a011-9b0b-b20a-433d9f74d4b1-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: Is ib_mtu iboe_get_mtu() slightly off?
References: <CAL1RGDX33tBR=x2sOp_F1605SY5nu_6YALr-XYE_LiuvsHQ1ng-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
 <VI1PR0502MB300886CB47BB3DFDE098A26AD1660-o1MPJYiShExKsLr+rGaxW8DSnupUy6xnnBOFsp37pqbUKgpGm//BTAC/G2K4zDHf@public.gmane.org>
 <1507556073.46071.27.camel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
 <20171009134131.GB1252-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
 <1507565652.46071.33.camel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
 <VI1PR0502MB3008900E038DEF6EEAB719DFD1740-o1MPJYiShExKsLr+rGaxW8DSnupUy6xnnBOFsp37pqbUKgpGm//BTAC/G2K4zDHf@public.gmane.org>
In-Reply-To: <VI1PR0502MB3008900E038DEF6EEAB719DFD1740-o1MPJYiShExKsLr+rGaxW8DSnupUy6xnnBOFsp37pqbUKgpGm//BTAC/G2K4zDHf@public.gmane.org>

--Wg7VrhM1UoQv3NhngTHLJuvBlPA5jILcp
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 10/9/2017 4:47 PM, Parav Pandit wrote:

> Sorry for not ACKing that I was doing it last week.
> If possible, please pick the one that Leon is sending because=20
> instead of doing calculation in half comment based and half defined bas=
ed code,
> my patch defines all necessary header sizes in calculation, little clea=
n way.

In this instance we are lucky that 0day testing was being slow yesterday
or else this would already be pushed to k.o.  Since it's not, I can drop
my patch and take yours.


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG Key ID: B826A3330E572FDD
    Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FD=
D


--Wg7VrhM1UoQv3NhngTHLJuvBlPA5jILcp--

--Sf0hW1UQJpo61318TN9DmST2TXiqHCuGW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJZ3N2hAAoJELgmozMOVy/dDIUQAMNmozugU/7ASzPdOf0kQeJa
6IaLYA/V05rOfBWdYEPdgXf+c1oKXn81L8vVeGZZdngBtnUGL1YTgG8Q9QxuWXFZ
hz73Yl+YXtcaix1NXRssbTkfN5xrdxEof7726vPDhxFHoJO8mqsSq2ZX64MMDG0g
rlEgk3azwEYfksPNP5UihYkjZRrrU5cuCvhoeLvtwvBk/0hhl6MBhnEAQmTM1YoR
EXDPqe8bTkRGVHmI49rgctB4LV+GasuZ8EeAzXWGuiwgcUDMKpJaVr9RcjpbgfYZ
iGwDrWy5JpU9UznvDSgb2qQ8kPp7bdzhm+MDt9Rsqlulj7pKKXLRt1FsHxHLZXMv
azf7JRvgZJwhXF3U41HzmK2/IX9qMt3Q4iQWdEXuAMParizpmuxIKr1ERqyATOal
k3+HqX0b9NgbO4lvExSCa3X6IoKPU4DAuPkZI6NZuPV+qIxttYq1wKCMdHuTmgTu
T6FDXxmdCPJdhhDAUOdOC+xzrMMipeMsLsD+sqxZOYbTSwIPIp3Em1+NGd4wztPn
LxNxb65wNygAI2QwU95C6fPNgeUbBYvlgRHi8kADsXPx1AbfNgOb7GenR1sNXv+2
FiyYy/ZHx20MF7EUSSXwIrpcsRvxlaJPH+xoJcsLCNc+2jRxy8Ej+1GgCqe2YV+E
eJGBEp39L/dawt9G9vIc
=/93d
-----END PGP SIGNATURE-----

--Sf0hW1UQJpo61318TN9DmST2TXiqHCuGW--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
