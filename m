From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] IB/core: Do not require CAP_NET_ADMIN for flow steering
Date: Wed, 18 May 2016 10:42:21 -0400
Message-ID: <9fa74108-e2f8-6a42-6d71-bf50b754734d@redhat.com>
References: <alpine.DEB.2.20.1605131020320.13832@east.gentwo.org>
 <alpine.DEB.2.20.1605131051170.27372@east.gentwo.org>
 <cf61efc8-e426-dd7c-7065-e46bbfb323b0@redhat.com>
 <alpine.DEB.2.20.1605160853050.23895@east.gentwo.org>
 <2994c976-8ed1-75f9-7534-2d0e5f5303b8@redhat.com>
 <alpine.DEB.2.20.1605161123170.26453@east.gentwo.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="pgShRl61f6wdt4OwJO4jeT6GIQcmbFEBx"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.DEB.2.20.1605161123170.26453-wcBtFHqTun5QOdAKl3ChDw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, marinav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, hadarh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--pgShRl61f6wdt4OwJO4jeT6GIQcmbFEBx
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 05/16/2016 12:28 PM, Christoph Lameter wrote:
> On Mon, 16 May 2016, Doug Ledford wrote:
>=20
>>> CAP_NET_RAW is sufficient for tcpdump and this is not more than that.=

>>
>>
>> That's not true.  In order to set promisc on an interface, tcpdump cal=
ls
>> ioctl with SIOCSIFFLAGS as the ioctl and IFF_PROMISC set in the flags,=

>> and in net/core/dev_ioctl.c we see this check for SIOCSIFFLAGS:
>=20
> Tcpdump works fine without promiscuous mode. DONT_TRAP does not
> mean that the interface is switched into promiscuous mode. It just mean=
s
> that all traffic accepted by the hardware is also going to the QP
> specified.
>=20
> One can switch the interface into promiscuous mode in addition if one
> wants that. Then you need CAP_NET_ADMIN.

I've applied your patch.  I completely reworded the commit message,
you'll want to check that it meets your satisfaction before I issue my
pull request.


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--pgShRl61f6wdt4OwJO4jeT6GIQcmbFEBx
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJXPH9NAAoJELgmozMOVy/ddEMP/jhu/Em4cAVbKKDjisufWJAe
0TI2LhJJkBjvKkTWKo1ibUKR5JIIIQks85ewlbPW7mrXMvnSc/BKBvQKb5eLHh44
Fn2CTfjrojexjlJ7+PyklnCTKetvKGz/E58mSOiXhjrH9TRe4YSmG4WGhc02XAU8
QihvgQb0SohL8lr0mLKmsmrYXR7ZOv+xlX63Vi54atlvAxMYv/lfUTJtKoZvIyfw
zAJ4UuwqyGG27Qb597mE1o+714THkj/Aye13ZIRNQubtYeJENzxQQ6d8zS+Rdtlp
fvdLAe18dh8LYoz2iIufcKevIMEA/PLaSgRSV3lzuYROKeTsCQEh9NSg1HU1nx0q
S2Tn1mgNj1Kxt676lDgMVQowbkm3bpgxA1czsa+Lz+DsenMsLO4e+t6u17zKlNvo
IksWjcm8EuNxDSAbr5xntTliZLqNG0rgUAD8r4I54ktFki6MgZCyW92qriK6p/K2
w4tIucXqA58DC1zpPaosEIyOFzTHpwuG9lO1zHs78k3chLqcFkp95F5+D2KGis0q
UzTJsYntx1YdZlzAR9u5SvE6hdlWF3edDuaCRl/wNnR8xzo6+ud3tlFy4Ikt019A
ljStD8XrdsBzZDiKMj4606YpqTI1ieR2572nTpiwJoWA+4fV6KBDSZFQ8jlqIKw5
IqXcu8ZrRIDfvCwzy1lg
=93z9
-----END PGP SIGNATURE-----

--pgShRl61f6wdt4OwJO4jeT6GIQcmbFEBx--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
