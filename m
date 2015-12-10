From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH libibcm] cmpost.c: Handle ibv_get_device_list returning no
 IB devices in init()
Date: Thu, 10 Dec 2015 15:39:59 -0500
Message-ID: <5669E31F.30602@redhat.com>
References: <56369FEE.7060100@dev.mellanox.co.il>
 <1828884A29C6694DAF28B7E6B8A82373A9BA5132@ORSMSX110.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="oLWJVxrVcJo9lS463Q92qikLJ1MSslkGK"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A82373A9BA5132-8oqHQFITsIHTXloPLtfHfbfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--oLWJVxrVcJo9lS463Q92qikLJ1MSslkGK
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 11/05/2015 12:46 PM, Hefty, Sean wrote:
> Merged - thanks.
>=20
> This is the first patch against the libibcm in over 4 years.  Is there =
a reason why this is being used instead of the librdmacm?  I ask because =
I assumed that the libibcm was basically deprecated.  The last release wa=
s over 6 years ago.

Not to mention the fact that libibcm is completely lacking all
documentation if I recall correctly.  No man pages or anything like
that.  We've considered it deprecated for quite some time.


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--oLWJVxrVcJo9lS463Q92qikLJ1MSslkGK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJWaeMfAAoJELgmozMOVy/dKowQAL081WcBKTC0QRbgTwlpppTZ
AZ1ezICqx0akO/yxudcanZgFAGKNXeFzgSNBmFDgaG1l51XQI+EiAFRElNaH3rLl
3ISVzm5XPlYGgOOKLOw9gyiCnKj1Ck6Ww7s1cVxhrg1fH6QqXCmgT2PWQdy9NE5h
f6FtNSwfaQr2oQwfnFdg4rlxJoIgNEUuHQ2tSAKSK/hVLG1qQl+4ibCyGwRtCBU5
CPKip3Tv5td4FNidTCtEMUGDRAYscocdQQZqJ0PpMMYiKFyXsiYmvcYUM+Sb51Tu
u5J8jcxQMikyWSnpdFpTYGHi5IOolRIBy4rWukKgQ7INNlJMQ9PcRWtknT6dL4Em
qP42nHnI75zAXIVC6kHJx2RhoKGTuo5vMWMLZRrGmwJonuc+s8buW5gO/Zdz9gl9
VPyzmM7E/TPxl41lLrJh+ru6EMH3P7mOtEWrVJ/1pHSGu7vG+H2zdfebOFz2HL55
H7w4mgsJaMeblCt32WVqKp5Q5wL7Ou0KAYUXFgGlCSPk3Eo5af9YwqXEJUtOEflP
MC5srD1YTAh1WISCpN/MN6zlszFFa+ylExUXm2Q3Kgucr+QGZsM9CyNuAZ1WWrVV
Yeg7qOh4hfwcMOf/Oc5/1NYvdXVT6WNUGAEgBEAIvCf+5wySpA4xAAybgQopE4Rp
17VV10KMfVppU5q2d+J5
=m24Z
-----END PGP SIGNATURE-----

--oLWJVxrVcJo9lS463Q92qikLJ1MSslkGK--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
