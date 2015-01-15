From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH V3 FIX For-3.19 0/3] IB/ipoib: Fix multicast join flow
Date: Thu, 15 Jan 2015 10:24:20 -0500
Message-ID: <1421335460.2484.21.camel@redhat.com>
References: <cover.1421264928.git.dledford@redhat.com>
	 <DBXPR05MB067182B666A7F24EE23DC8ADB64E0@DBXPR05MB0671.eurprd05.prod.outlook.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-dA5ktpI+07/IPVmtvnfb"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <DBXPR05MB067182B666A7F24EE23DC8ADB64E0-c2uBOMY7wQg6ranl7A9sk9qRiQSDpxhJvxpqHgZTriW3zl9H0oFU5g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Amir Vadai <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eyal Perry <eyalpe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--=-dA5ktpI+07/IPVmtvnfb
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2015-01-15 at 09:19 +0000, Erez Shitrit wrote:
> Hi Doug,
>=20
> Thank you for the quick response.
>=20
> Now I can see 2 issues, that I want to draw your attention to:
>=20
> 1. if there is a mcg that the driver failed to join, the mc_task enters t=
o endless loop of re-queue, and the log will be full with the next messages=
:
> [682560.569826] ib0: no multicast record for ff12:601b:ffff:0000:0000:000=
0:0000:0016, starting sendonly join
> [682560.580136] ib0: no multicast record for ff12:601b:ffff:0000:0000:000=
0:0000:0016, starting sendonly join
> [682560.590364] ib0: no multicast record for ff12:601b:ffff:0000:0000:000=
0:0000:0016, starting sendonly join
> [682560.600504] ib0: no multicast record for ff12:601b:ffff:0000:0000:000=
0:0000:0016, starting sendonly join
> [682560.610627] ib0: no multicast record for ff12:601b:ffff:0000:0000:000=
0:0000:0016, starting sendonly join
> [682560.620769] ib0: no multicast record for ff12:601b:ffff:0000:0000:000=
0:0000:0016, starting sendonly join
> [682560.631082] ib0: no multicast record for ff12:601b:ffff:0000:0000:000=
0:0000:0016, starting sendonly join
> [682560.640835] ib0: sendonly multicast join failed for ff12:601b:ffff:00=
00:0000:0000:0000:0016, status -22
> [682560.651033] ib0: no multicast record for ff12:601b:ffff:0000:0000:000=
0:0000:0016, starting sendonly join
> [682560.660758] ib0: sendonly multicast join failed for ff12:601b:ffff:00=
00:0000:0000:0000:0016, status -22
> [682560.670923] ib0: no multicast record for ff12:601b:ffff:0000:0000:000=
0:0000:0016, starting sendonly join
> [682560.680676] ib0: sendonly multicast join failed for ff12:601b:ffff:00=
00:0000:0000:0000:0016, status -22
> [682560.690898] ib0: no multicast record for ff12:601b:ffff:0000:0000:000=
0:0000:0016, starting sendonly join
> [682560.700630] ib0: sendonly multicast join failed for ff12:601b:ffff:00=
00:0000:0000:0000:0016, status -22
>=20
> around 100 times a sec.

OK, this looks like the send only joins that fail are not setting a
fallback properly or something like that.  There is a separate bug that
I've isolated that I'm going to fix, then I we can see if that fix
effects things here, as it very well might.

> 2. IPv6 still doesn't work for me, at the same case where it is not the f=
irst mcg in the list.

Can you give me some sort of instructions on how to replicate your
testing?  Things are working for me here, but I don't have a complex
IPv6 setup and mine may be too simple to reproduce what you are seeing.

> Thanks, Erez
>=20
> -----Original Message-----
> From: Doug Ledford [mailto:dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org]=20
> Sent: Wednesday, January 14, 2015 9:53 PM
> To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
> Cc: Amir Vadai; Eyal Perry; Erez Shitrit; Or Gerlitz; Doug Ledford
> Subject: [PATCH V3 FIX For-3.19 0/3] IB/ipoib: Fix multicast join flow
>=20
> This patch series fixes the multicast join behavior problems introduced b=
y my previous patchset.  In particular, the original code did not use the s=
end only join code from the multicast thread context, and so it did not nee=
d to restart the multicast thread.  After my previous patchset, it does get=
 called from the thread context, and so the send only join completion areas=
 need to restart the join thread but they don't.  This patchset makes them =
do so.  It then adds in some cleanups for restarting the thread, and fixes =
the fact that one delayed join holds up the entire list of joins.
>=20
> v3: Resend because the last send didn't register in patchworks properly
>     (because the subject-prefix was not on all of the emails, only the
>     first) and because the Cc: list didn't not pass from cover letter
>     to patches
>=20
> v2: Added two new patches, the first creates a helper to restart the
>     multicast join thread and also adds using it in the two places where
>     it should have been used but wasn't, the second allows the joins to
>     proceed around a delayed join instead of stalling everything.
>=20
> v1: Addressed the usage of the IPOIB_MCAST_RUN flag
>=20
> Doug Ledford (3):
>   IB/ipoib: Fix failed multicast joins/sends
>   IB/ipoib: Add a helper to restart the multicast task
>   IB/ipoib: make delayed tasks not hold up everything
>=20
>  drivers/infiniband/ulp/ipoib/ipoib.h           |  1 +
>  drivers/infiniband/ulp/ipoib/ipoib_multicast.c | 94 ++++++++++++++++++--=
------
>  2 files changed, 66 insertions(+), 29 deletions(-)
>=20
> --
> 2.1.0
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--=-dA5ktpI+07/IPVmtvnfb
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABAgAGBQJUt9ulAAoJELgmozMOVy/dMnoP/0zPn6tA+NmfS1jVpWXOhmzt
do244vdUplrx8bGzhktaTpgHfsQWtN9D92OovnDrqHgYpCW7nf1YHHWVWHBz4Cfz
bifo6+dxzXURhpKLbefGh5+SECDHuRb6/qkPYWpc9TCLfXR4P8J6CK/9Ti5HqWfB
krcb+FaumiEaLI0PTC/RXokHkYKCu9qGEkl6Qd3Jbqnv89PLXn0tEu3Q6Vf+DW0F
5nFdDbtho1w3vrgC2ats8JHAS+HDk7JiJYr0Ex0d3ybQPdZOVLE4d7GEnKEQbusx
8GW9vgDWMeil+ZR11+Z0uwcuRkXsg14v7e3FmAmkwsnANjIzhUe1ApArgqzXt4oA
CahLeGVe8p5FeipH4EkWxkA8OJ8ofjl4MP/oRrmkb8dg2wSUYLmNsEvmQ6L5RrB7
d5aTxaNPOtUd0fINpgfBq5LhAeMIiICg1j8HxciBHORxby2f34GJ4Kk1XsM9rbRk
TndTP8Qg61lJxX3hepaHQtZfrvBu5NXNVjS9/Ucvcc6YWC4Oar3CkD6g5h1FEFF4
7hS33Fz5X0FpqMAIIBhtZLX8jR0eN/1hkC5ztKTNTR7MDsGQhAhSyoUNGveySgE7
t48KrykUBfnCLxnhm04m3fWk93niclAiJvAj2rZbzQJfudrxWQgGL3VtN2WSpzVq
wPLNnqxujGuJdZuZPU8k
=juUF
-----END PGP SIGNATURE-----

--=-dA5ktpI+07/IPVmtvnfb--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
