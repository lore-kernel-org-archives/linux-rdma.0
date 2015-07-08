From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] IB/core: Destroy multcast_idr on moudle exit
Date: Wed, 08 Jul 2015 17:42:51 -0400
Message-ID: <559D995B.1010106@redhat.com>
References: <1436368875-31014-1-git-send-email-jthumshirn@suse.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="QVl33pXHoidfw1TXwKOWmcEg3W3f45rCP"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1436368875-31014-1-git-send-email-jthumshirn-l3A5Bk7waGM@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Johannes Thumshirn <jthumshirn-l3A5Bk7waGM@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Ilya Nelkenbaum <ilyan-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--QVl33pXHoidfw1TXwKOWmcEg3W3f45rCP
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 07/08/2015 11:21 AM, Johannes Thumshirn wrote:
> Destroy multcast_idr on moudle exit, reclaiming the allocated memory.

Thanks, applied.


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--QVl33pXHoidfw1TXwKOWmcEg3W3f45rCP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJVnZlcAAoJELgmozMOVy/dJl0P/ii7+YNv4XiRWQEwd+9y8YPf
sd7AC/9s0Oo72e5XIlEQW8Dt9DNWQLZ+/Q+7IbAdvukKfvEEXtMCoLRdP/XlSV4A
slYzHVxXlQAXGWWuOPW5E0Y4yQYuFPWW4t5yAyQuy0TiJHrU4nC1723BaYXCiLZj
m/bRIZ82ymo2v5wQVxoOpp+d1H5N6GpC/kf+TdRWy6BIHzpd8E116MY3waZTr9xv
qxl3frnoqyS4r5cNtTfzvWSJst0PaKqRFhCFxMKmXG4cOl6xn8j2OYIO26jsAxcr
PNSjQ1YYa+pBjPbRI0OXfZfTwlhM7g9EmCn84nPmiA2QMa+8gu0EbqaHbus7yz5s
YG1c8VgbFiZsRKbIq5AJN36HOYx3qeBoZheQv6gAA+0iprEMwSwujnixeHeLv38Y
4dEuZxhWvkHzsE3rHV3tAjVFCnWZ6E+qUEx54i2EMH1jkAdImCqZxyFZo/saQN1O
ucyc1a98wORk3TtGR6Y0/yz29/vOAes2j+iBqbrymkd8CIpM1P/oejIQboXgca5e
c6lxtIL1iTZMllndtiZYrf/tgSjweRpzmlrJFJLo/h942gG9ZkAfsUsYizdz8n5B
tT/XPPfoSKF361GBhm3fqmMDD5KH9WhpXgfwsTThTZ5YvuipU4sGyb+GXblRIBPH
J3njg61mtlXSnl2Px7sh
=WK1+
-----END PGP SIGNATURE-----

--QVl33pXHoidfw1TXwKOWmcEg3W3f45rCP--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
