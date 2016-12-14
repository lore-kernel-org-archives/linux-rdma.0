From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 1/5] mlx5: Use NULL instead of 0 to represent a pointer
Date: Wed, 14 Dec 2016 13:44:22 -0500
Message-ID: <1e55085d-5c33-1356-085f-cc2313203c2c@redhat.com>
References: <9ff07804-492c-c67a-e729-b31e0f863027@sandisk.com>
 <16dc2a07-86f7-ce47-7b0c-1da03e58d99f@sandisk.com>
 <20161206135917.GC2437@mtr-leonro.local>
 <a8d3dbb7-aafa-c5af-5d06-78d1f4914c5d@sandisk.com>
 <20161207082110.GA11857@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="eIrGP2DsQ8UKTHhRjKdPJ5IVHsgtMQwSK"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20161207082110.GA11857-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--eIrGP2DsQ8UKTHhRjKdPJ5IVHsgtMQwSK
Content-Type: multipart/mixed; boundary="HGpOtgbUuIxdXe28aa8uRxQvLL0EcErsI";
 protected-headers="v1"
From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>,
 Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>,
 "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Message-ID: <1e55085d-5c33-1356-085f-cc2313203c2c-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 1/5] mlx5: Use NULL instead of 0 to represent a pointer
References: <9ff07804-492c-c67a-e729-b31e0f863027-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
 <16dc2a07-86f7-ce47-7b0c-1da03e58d99f-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
 <20161206135917.GC2437-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
 <a8d3dbb7-aafa-c5af-5d06-78d1f4914c5d-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
 <20161207082110.GA11857-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
In-Reply-To: <20161207082110.GA11857-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>

--HGpOtgbUuIxdXe28aa8uRxQvLL0EcErsI
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 12/7/2016 3:21 AM, Leon Romanovsky wrote:
> On Tue, Dec 06, 2016 at 08:29:56AM -0800, Bart Van Assche wrote:

>> Anyway, how about one of the following two
>> alternatives:
>> * Change {0} into { }.
>=20
> Yes, please.
> Thanks

Fixed this one up and applied it.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG Key ID: 0E572FDD


--HGpOtgbUuIxdXe28aa8uRxQvLL0EcErsI--

--eIrGP2DsQ8UKTHhRjKdPJ5IVHsgtMQwSK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJYUZMGAAoJELgmozMOVy/dRc4P/RRsFePPyy5IS039Le8SaoQ1
1IlUH8FC+W1afBMlcEA2o36TQSeSAzGCgEE7KAPDyQxbNUmh2jFEue7ylDyFcCrv
B9/1m9viU9QKbpnXuxvEzEOUqB16wBqjAH/7+kKddFyDmju0Qh2RfZ2rNUs1Ikai
MM3jWXsrsZVlwyFG6UUyPGGRo6+tHAinbqSe0g9kRosMM72+FkFuFWVNekj2nTGg
zRekwQyS64Hoqk522/njzyoUEVyFteYkhwwSUJFIyA2qnf+Br3zMEs09e0QjIoFC
csHJWnW4XvFK2efODgUbT0AnszgdqyLUTPPt8TVM6IX00iCOE0yfJBWZd+g0H4c+
PS0kWjBZ6oiKMzaskerl27+5oSmMOEGryCXMtKnl+HZu0pWTu0KAvLMuUBU/JiQW
2dT1Mar4uttZ0lyMiVVz4IvMyxNIcF44s9mEGY+cUQO7YPK2Krb9/j6LCiRQbHnP
IIDKXuVU2BOfDir7ancdP77ny2h0IKvzf1ukNltPwwlUrIfdotBEPv4gjqMHMfWu
lhoucejlYrMkMKQhT5oyzoDULKzY62r6cVbOzLqTkgn3wH65CBje2YcuutRMgGVy
Std1PlT+26OUBNgIk02P3t1ucpV1gZSZavXqYB5q2ah6qRwnLHlSwWfjHO44ERuQ
ZOpUfrv9D//A4yx5/Q+E
=FcM7
-----END PGP SIGNATURE-----

--eIrGP2DsQ8UKTHhRjKdPJ5IVHsgtMQwSK--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
