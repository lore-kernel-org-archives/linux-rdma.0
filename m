From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 00/22] IB/ipoib: Fixups for multicast issues
Date: Thu, 12 Feb 2015 09:02:57 -0500
Message-ID: <1423749777.3424.76.camel@redhat.com>
References: <cover.1423703861.git.dledford@redhat.com>
		 <54DC303C.2020207@mellanox.com> <1423716906.3424.74.camel@redhat.com>
	 <54DC3934.3010401@mellanox.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-HHUhRkmbb7Bf2cLrKziS"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <54DC3934.3010401-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--=-HHUhRkmbb7Bf2cLrKziS
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2015-02-12 at 00:25 -0500, Or Gerlitz wrote:
> On 2/11/2015 11:55 PM, Doug Ledford wrote:
> > I tried, but the most appropriate squashes were things like patch 18 an=
d
> > 19 squashed into patch 3, and some other similar jumping around of
> > patches.  The number of conflicts that created in both the original
> > squash and the follow on patches was perverse.  So, since the original
> > 20 patches as I submitted previously are what has gone through our QA, =
I
> > left them as they were.  If I fixed them up and squashed them, and if
> > some overlooked fixup failure snuck in there, it would invalidate all o=
f
> > that testing.
>=20
> I see. Does this sequence bisect-able? namely the driver builds and=20
> functions after applying patch by patch? note this is hard requirement=
=20
> when modifying existing upstream drivers.

Yes.  There might be some oddities in the behavior of the running IPoIB
driver specifically when testing the mcast abilities in the middle of
this patch set, but they will all build and function at a basic level.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--=-HHUhRkmbb7Bf2cLrKziS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABAgAGBQJU3LKRAAoJELgmozMOVy/dbSUP/3Hcu4SmBy3oQ/GQJtVHNuTP
RX71at+T7ANhQl/UgTq3ZGtv1JUhkUHB8YsIYDzz5SNCURDEr5Tw+eBD9jxAa61S
gFlLAtMr3SZyEO7HAUXR62QfP7WuYOGhcoqJyDRHWsdWPUpH0/0rQkAkOCeXaDRD
Z6s2FO7bAJykMIVHySh3e8tYUDIfVSLKj48x35kPDXbw+kalhWoYnXeW5Ptgt5To
A414KTuf/WnZsMCJYMv6kibGRyV0V+8CIaELHQniq5IguRsKgQU6/mnmrzH2Wwx6
vjpHkHe1SexduaLRnpuCoHivpiuqyUWsTXYW2dAc8FF4mEyzyTAnSANYdBTm9NV3
pTq2GYAuoNEjNC7wgoWD0/HGlD5GRxwZgYnLxQ3vDb8rlrrLVti+bB2N0WzkgJqn
tmf06sAKsCC67WKcsIX2b6cimU4t2wwqT+B0BYcapAQ8MEoxqxvM+jAPLGEHo52k
zlTU4W2fTK3OopSdsUeLIVHzxTzhust2av85mMSMkNBLVC7ehu7npkW1AHQCR0EF
EJO0iDhhswMKQ4aPiIIOuz8TFnwV26vqJP6tD471HCAV05lmeysJSQgVXRTq6hLM
kemZUkSjVPVlTtxLlmp25BCgJZM5wxLvNZuzsx4zQNc5E3UltrabbpZmxEfhrpRO
p2TA9JEr2miPJuhKY/kv
=EyLZ
-----END PGP SIGNATURE-----

--=-HHUhRkmbb7Bf2cLrKziS--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
