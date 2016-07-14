From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [QUESTION] IB/ipoib: IB_DEVICE_UD_IP_CSUM & NETIF_F_SG
Date: Thu, 14 Jul 2016 16:06:44 -0400
Message-ID: <5b29dc59-6228-438a-3d32-f6fc3b54610e@redhat.com>
References: <20160714095714.GA13573@yuval-lap.uk.oracle.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="ieUsiXl1a3wC5DiJhln7QiSqkUktaIB2H"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160714095714.GA13573-Hxa29pjIrETlQW142y8m19+IiqhCXseY@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--ieUsiXl1a3wC5DiJhln7QiSqkUktaIB2H
Content-Type: multipart/mixed; boundary="WooBn863Jxo7x3Ex53rEfQ4euMp3LH3XN"
From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Message-ID: <5b29dc59-6228-438a-3d32-f6fc3b54610e-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [QUESTION] IB/ipoib: IB_DEVICE_UD_IP_CSUM & NETIF_F_SG
References: <20160714095714.GA13573-Hxa29pjIrETlQW142y8m19+IiqhCXseY@public.gmane.org>
In-Reply-To: <20160714095714.GA13573-Hxa29pjIrETlQW142y8m19+IiqhCXseY@public.gmane.org>

--WooBn863Jxo7x3Ex53rEfQ4euMp3LH3XN
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 7/14/2016 5:57 AM, Yuval Shaia wrote:
> Hi,
> Looking at ipoib_set_dev_features().
> Any idea why NETIF_F_SG depends on IB_DEVICE_UD_IP_CSUM?

I believe this is both historical and outdated.  IIRC, at one point in
time the core net stack required IP_CSUM to support SG, but it no longer
does.


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG Key ID: 0E572FDD


--WooBn863Jxo7x3Ex53rEfQ4euMp3LH3XN--

--ieUsiXl1a3wC5DiJhln7QiSqkUktaIB2H
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJXh/DUAAoJELgmozMOVy/dQy0P/2AaTrHGCcXjK3G6T6p97f2z
9ksxW0dxQf/aCizx7B+QY6A4N9X8lJOEpceUMa30aOYJ9cZHUP1Sep22y6t8YXTT
qcZe7PegopRPhylBLCgGEoqXdWuTRHn1zTYjnHXWnrkxpDM2RhWm9FQkMCmcu+hj
cASmbo7VqxmbHegu0pXNHPRDkWX5tCtamHSzLzNP0NGryaddMzmhH8+nXk1d+bGg
WjjKYp3+qXeNP4/LkXB7Z2YD+FC7w1iAvCoFL1hd6OhnSb1WQox+bGjf4Djuk1ay
RSsQqLcBCAsZep5ioDs3k2rlshMj42Pm26uGY7LElhYmmqQt+9n4RxtO7xcJq54T
vlEEsQD+049ivPQYTotDuLb1V5lLDy0aqcEAJVZEuzP4W0tPFNdHOtTSjEP7t5/0
jojD3JuzjeJXb7+nuHfG16I1407MpTU5xKnI2py+1CO3HUNGnzzWPqmSN8PB37dc
UApHShpsnGNNsItJJwRowlc/KyTW2eE4zerkeKfnHnxBdkRAje1VmiEfMDDthWtu
saWCnmTQoFhLhYbfGe5mFiQ1x12+rF8pJ0GxdBKIlMRQd74Gg7Ift+2fz9qz0wnN
tIG8IEbqgFA+oFBFycQ0jPGSAw8IgIF9zInj9NzJqxsV8tSBaVViMMF0bDQIC8bp
68bKWw/gOflNtyp62bqe
=kKqZ
-----END PGP SIGNATURE-----

--ieUsiXl1a3wC5DiJhln7QiSqkUktaIB2H--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
