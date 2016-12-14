From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2] qedr: remove pointless NULL check in qedr_post_send()
Date: Wed, 14 Dec 2016 11:28:43 -0500
Message-ID: <e1e3fef3-25ff-94e2-0a2b-bd57fe67e433@redhat.com>
References: <1477672406-31487-1-git-send-email-weiyj.lk@gmail.com>
 <1478092292-17225-1-git-send-email-weiyj.lk@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="sueoF5GEW6H8VXgsOlxD80xvxBn4J4k3a"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1478092292-17225-1-git-send-email-weiyj.lk-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Wei Yongjun <weiyj.lk-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Ram Amrani <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, Rajesh Borundia <rajesh.borundia-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Wei Yongjun <weiyongjun1-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--sueoF5GEW6H8VXgsOlxD80xvxBn4J4k3a
Content-Type: multipart/mixed; boundary="V8bmCj1OvN48xoiTExsTcTdwLWox2U9kt";
 protected-headers="v1"
From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Wei Yongjun <weiyj.lk-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>,
 Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Ram Amrani
 <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, Rajesh Borundia <rajesh.borundia-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>,
 Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Wei Yongjun <weiyongjun1-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Message-ID: <e1e3fef3-25ff-94e2-0a2b-bd57fe67e433-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2] qedr: remove pointless NULL check in qedr_post_send()
References: <1477672406-31487-1-git-send-email-weiyj.lk-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
 <1478092292-17225-1-git-send-email-weiyj.lk-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
In-Reply-To: <1478092292-17225-1-git-send-email-weiyj.lk-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

--V8bmCj1OvN48xoiTExsTcTdwLWox2U9kt
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 11/2/2016 9:11 AM, Wei Yongjun wrote:
> From: Wei Yongjun <weiyongjun1-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
>=20
> Remove pointless NULL check for 'wr' in qedr_post_send().
>=20
> Signed-off-by: Wei Yongjun <weiyongjun1-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

Thanks, applied.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG Key ID: 0E572FDD


--V8bmCj1OvN48xoiTExsTcTdwLWox2U9kt--

--sueoF5GEW6H8VXgsOlxD80xvxBn4J4k3a
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJYUXM7AAoJELgmozMOVy/d4ZYP/258yXE0aqOK3Dn2L8GKAlPj
3E9TAQjpOYG5jrazY1M1ZTogVA8djvTXjd448shARkd9C+sC2NvspoZpwKDO3zp3
RfNla/duJmcJdNaDUQNSCm1nlwpHKkuq5x9c5zZkS8YqEFS4S/8NNJzo+OuxFXtl
4db4x6/2MDSW+Er82ZCECQqMRKgRbnm/VfmYPXyDGSeYMKFGmzmG1Lt1f5nwrkwo
0KEqjUWuFCqh/UB9Ur7QxVhZEMI8XaBbhG14vNskwkcLd41cUVWyqSksHsrMy5HU
6tT79gO7v9/utCiuc3KFphnuR42ng3J0j1tuexksePC/UNedQdxMsz+77TFPdjzJ
5Id0+uWMqn7XSmHoxKHtQRcDUku9cWcemNUUXdEybPvAYwd803Uq4DfCjh0Og9wC
yP8vORuIdOIEFDzudl2QpBuyCSmEI677HTrv+H1BYA1sSMsoWBGbKjsmuicVwWVo
7nbPpYWqLVWdaVQAJlKBCOw9IyExS2m5wt97mz3NVIbDfzo2NUjcpEWkzarWS8om
pp9c9SA0NtPqwPay/S51QOEUahNTRscPdJVb65F/lxdhIIY7SlMBH/baPxz4fncz
V+kvKW4e5oGw4KXxncublJoaX+HvZpzZT/n24dejaW7pts+Nzho4lXLqLP83Yy2V
IhsRAlU7utmAkguiQNO3
=ioyG
-----END PGP SIGNATURE-----

--sueoF5GEW6H8VXgsOlxD80xvxBn4J4k3a--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
