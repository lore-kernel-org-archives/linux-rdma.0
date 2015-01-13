From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH V1 FIX for-3.19] IB/ipoib: Fix broken multicast flow
Date: Tue, 13 Jan 2015 11:45:44 -0500
Message-ID: <1421167544.43839.190.camel@redhat.com>
References: <1420643066-3599-1-git-send-email-ogerlitz@mellanox.com>
	 <CAJ3xEMh60SGsK43b49MSozqmL8PDzTevs5CMGCvhPfmL3kHHVQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-/+mx2SDoV/zHsXa4KwXA"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAJ3xEMh60SGsK43b49MSozqmL8PDzTevs5CMGCvhPfmL3kHHVQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Amir Vadai <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eyal Perry <eyalpe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--=-/+mx2SDoV/zHsXa4KwXA
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2015-01-09 at 10:32 +0200, Or Gerlitz wrote:
> On Wed, Jan 7, 2015 at 5:04 PM, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote:
> > From: Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> >
> > Following commit 016d9fb25cd9 "IPoIB: fix MCAST_FLAG_BUSY usage"
> > both IPv6 traffic and for the most cases all IPv4 multicast traffic
> > aren't working.
>=20
> Doug, can you ack the breakage introduced by your commit and the fix?

I haven't double checked the breakage, I'll take your word for it (at
the time I did my work, I had multicast debugging on and I verified the
join/leave process, but I had assumed that the process would work the
same for optional multicast groups as it does for the IPoIB broadcast
group and other default IPoIB groups, so I didn't specifically test
additional multicast groups above and beyond the broadcast/etc groups).

However, the fix is not workable.  In particular, as soon as this patch
is added to the kernel, you will start getting messages like this:

mlx4_ib0: ipoib_mcast_leave on an in-flight join

Every time you get this message, you've run into a "shouldn't ever
happen" situation.  If this happens, then we've lost track of the mcast
flags settings or we've genuinely tried to remove a mcast group where
the lower layer is still working on our join.  Either way, it means
we've screwed up.  Further, with this patch in place, I'm seeing random
acts of badness now with non-default IPoIB pkey joins.  Sometimes they
work, sometimes they don't.

So, no, this patch doesn't work.  I'll do some more investigating and
report back.

> Or.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--=-/+mx2SDoV/zHsXa4KwXA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABAgAGBQJUtUu4AAoJELgmozMOVy/dVScQAI6/kjwOlPgN5slZz68764sC
dZDRlTzWPjjOGE2Br/12O+TH7vczGzl87Y3sc8bAwAbanK/k8sf0myDBjpQ8VanR
8wzmWeXhUF59Vdj3CZJgedvXzEHhWy/4BqjKsVzVX0dQYwk/q2ikNTkwuqjtfzl8
dvtmybXbcvc8tnPoHtJSQTUVDYjcc05Da99AmOsHSaNYBBQJJ3E3ba1fGo5qc6L0
HsY5H+rMu9K3JK5tFTWjzC80XR3b4nDADkecRGpW4FFJxv74e2cJ/MTUMK3J2aih
uaFcbU9h5yp/9ye29TbIrGXTa/wJs5fwLE40VSjkGIBsh2jQqOWgAGRLmXne9TOx
k9tkJsElAr6N8iE8kXDAGasMV5szCnYY7E9gk6w//Kv9Ondo8XfN6FVfCqkjzgvG
ydbkDaVRXnjb7mtCS+zcRCUpwX8H9qnfD1qTd/lz7XFIJBHI48KqPdcuFO2Bh1T0
u8CLSowvfbKMjnaJ5n3eibl2ASJ7fCFaIghLDw5Uaj7H/iX3iEt+c1VJ3l1qquDD
2JiYppbsRB0C5NQ/jGGo1fOkNuwkuEAny+ewISztz/jAA5VAchHB+X31Wke46la3
edo80kabM3d6hQW4El900hzmOzs64VdxKrxnW0Jq14XSMYPYUE7m8Z00ne/QdGiX
8i9aeTkLUw47tT7XOWLD
=7sT/
-----END PGP SIGNATURE-----

--=-/+mx2SDoV/zHsXa4KwXA--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
