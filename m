From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 5/5] mlx5, calc_sq_size(): Make a debug message more
 informative
Date: Wed, 14 Dec 2016 13:46:37 -0500
Message-ID: <4739c2c5-f1c7-f2c4-f6f3-f95c7b7aac63@redhat.com>
References: <9ff07804-492c-c67a-e729-b31e0f863027@sandisk.com>
 <4387aa0f-5097-d456-eee2-b480dfa5af87@sandisk.com>
 <20161206143159.GB3437@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="3p5QiGdD6j5MbN4jNwbbGtvJdhAgV94Nb"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20161206143159.GB3437-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--3p5QiGdD6j5MbN4jNwbbGtvJdhAgV94Nb
Content-Type: multipart/mixed; boundary="jQje6CQQM2TiMe8u1dveHa4i7XJWRtHmx";
 protected-headers="v1"
From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>,
 Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>,
 "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Message-ID: <4739c2c5-f1c7-f2c4-f6f3-f95c7b7aac63-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 5/5] mlx5, calc_sq_size(): Make a debug message more
 informative
References: <9ff07804-492c-c67a-e729-b31e0f863027-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
 <4387aa0f-5097-d456-eee2-b480dfa5af87-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
 <20161206143159.GB3437-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
In-Reply-To: <20161206143159.GB3437-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>

--jQje6CQQM2TiMe8u1dveHa4i7XJWRtHmx
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 12/6/2016 9:31 AM, Leon Romanovsky wrote:
> On Mon, Dec 05, 2016 at 05:19:52PM -0800, Bart Van Assche wrote:
>> Make it clear that qp->sq.wqe_cnt is not the number of WQEs.
>>
>> Signed-off-by: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
>> Cc: Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>=20
> Thanks,
> Acked-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Applied, thanks.


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG Key ID: 0E572FDD


--jQje6CQQM2TiMe8u1dveHa4i7XJWRtHmx--

--3p5QiGdD6j5MbN4jNwbbGtvJdhAgV94Nb
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJYUZONAAoJELgmozMOVy/d6ZYQAJ/qef7QXYHBWxNuPIOkwVXl
ivxMHhr/+kkDv/oJK5m9RWKit4VTEUpwDnBvYKNJ7h0RekzumOMZJCsJ3b8eMREa
u+IOH6RXPWHKO3y+CVeZXzsjTg0rSAPvL+soKoQb5sKTSNl9T2OT8YcPb0ane2I3
7VAFfW0dDl5dtKYd9AnpaGtNWn2dNgUTQPBO4Zn5RdVbVoTdkZXCp7diC4MxqE0R
Tj4FCZatI4YgSdwSqZobW136oPJRjIskH5YzsMQ3V+4dUSLWuUCS/Ce1ht0qHczR
Y3+3RvKLGdiw236Wc0f6CaVBjqNzUHhnX2XHrHla3okk/0bKK+8y/UNyjasFzNez
d3Al5fCTFSpnkyO3tajkTjdXKHuh72bcB+7Ao3RNlfyrL4RTbuGb/sfXz3BAvmux
a6yVHsO9/RBRCBYS0DPyjzdGriR0vCg1GGInGTB+SjC3rzfLrhabAlk2SxqV3CPZ
mTM+bTD3QsWGfXAcahbKWYRvEnVWwp02Lflhc7I6ZGPVoQ4S0X2IRqreTzLjxA1P
D3nbyfARhLXG7Jd43ynpKcHpEbHL+yWTvJM8NbKggIXLS4VTMynSpyczlavPs31+
WVJS/Pu+7MnVnt13BPeL7dEp8VP1D/xHigOfCFZQLY5gj9c9C5JSntLrAPAEBCr3
IpRUYd1FB2j5OJbr5DF1
=y5RJ
-----END PGP SIGNATURE-----

--3p5QiGdD6j5MbN4jNwbbGtvJdhAgV94Nb--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
