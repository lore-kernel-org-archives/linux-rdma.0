From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] IB/mlx4: Rework special QP creation error path
Date: Wed, 14 Dec 2016 13:01:14 -0500
Message-ID: <e6b47e40-afbe-df49-d287-6e7610e728be@redhat.com>
References: <3a41daa7-cfb8-7374-5dab-dfa3b1bf83ff@sandisk.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="v2IO0Ap4QkHNGs1CVKWnH90U85MQb3Kss"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <3a41daa7-cfb8-7374-5dab-dfa3b1bf83ff-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--v2IO0Ap4QkHNGs1CVKWnH90U85MQb3Kss
Content-Type: multipart/mixed; boundary="MbePMeOLLrsiPVJWpTfdnSvfnS9srpEJw";
 protected-headers="v1"
From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>,
 "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Message-ID: <e6b47e40-afbe-df49-d287-6e7610e728be-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] IB/mlx4: Rework special QP creation error path
References: <3a41daa7-cfb8-7374-5dab-dfa3b1bf83ff-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
In-Reply-To: <3a41daa7-cfb8-7374-5dab-dfa3b1bf83ff-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>

--MbePMeOLLrsiPVJWpTfdnSvfnS9srpEJw
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 11/14/2016 11:44 AM, Bart Van Assche wrote:
> The special QP creation error path relies on offset_of(struct mlx4_ib_s=
qp,
> qp) =3D=3D 0. Remove this assumption because that makes the QP creation=

> code easier to understand.
>=20
> Signed-off-by: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
> Cc: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Thanks, applied.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG Key ID: 0E572FDD


--MbePMeOLLrsiPVJWpTfdnSvfnS9srpEJw--

--v2IO0Ap4QkHNGs1CVKWnH90U85MQb3Kss
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJYUYjrAAoJELgmozMOVy/dF/EP/Aoe3tNl1MCaGjchSfqvHwRu
zTSx8EiDDXt6hQSl9wFQRqnzBoltAVn4F5YhcxsK9w2dRLE9ObAkdXoUi7Bi4O1o
adSF3wRCuC3FiPym7ar5djmJmWOlWu7BVHKpivGkamh3gwU92k77edAJ7XyllttB
3GewUOfZBUJLWgGz4z0gNpfOqY7H/0vJCky8REyD9f8UWV1M6ljS2WZm9qe5oj6c
JCf/6DNamyAvCcg8hnkKihlBkNukcuONcl47j+zRBg0QbLsPmnNd94tRAo55xnbg
Uup5iU92F+qkpnq/EikQE2xthdc3r/r7MZZhMh4uemPPRQpuZjU3oXESR68WxoS0
TmC+pelYikrTB7fjidLBmtLP6S8TzL7XthspPqVDvCExkEtBoahPRK9RXxTm4YZ1
cJbq4HXnY19Az6Tvw/9jVJwOCaHVur0hySXLctuFYbgPTtUPYlqwncpQHy6nHTMY
urekAa/FyOn60e4veC7S0xGdSsRMW+ejWfoKs2JOF9g4QhoG86Nd/jI3Xpdkv2Sw
AbZ54e93CDVE0jutAh06Lkp8qm58kRoVY2+wtG2zg1ASt+aDJif8E0cxH9eTwNl7
ZNoFTLt6fIFOopM+9+sinb9CeqXJmpriWhRuTlbtTLuTQQqHYgBnSFtH7p2Zne1k
i3U2a9NYhG9JVFHKA/WF
=ZCr8
-----END PGP SIGNATURE-----

--v2IO0Ap4QkHNGs1CVKWnH90U85MQb3Kss--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
