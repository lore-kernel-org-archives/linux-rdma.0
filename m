From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH V3 FIX For-3.19 0/3] IB/ipoib: Fix multicast join flow
Date: Thu, 15 Jan 2015 15:27:11 -0500
Message-ID: <1421353631.2484.31.camel@redhat.com>
References: <cover.1421264928.git.dledford@redhat.com>
		 <DBXPR05MB067182B666A7F24EE23DC8ADB64E0@DBXPR05MB0671.eurprd05.prod.outlook.com>
	 <1421335460.2484.21.camel@redhat.com> <54B81E2B.9030101@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-aSS1oBPHI9P8zISyDmMU"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <54B81E2B.9030101-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Erez Shitrit <erezsh-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Amir Vadai <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eyal Perry <eyalpe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--=-aSS1oBPHI9P8zISyDmMU
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2015-01-15 at 22:08 +0200, Erez Shitrit wrote:
> On 1/15/2015 5:24 PM, Doug Ledford wrote:
> > On Thu, 2015-01-15 at 09:19 +0000, Erez Shitrit wrote:
> >> Hi Doug,
> >>
> >> Thank you for the quick response.
> >>
> >> Now I can see 2 issues, that I want to draw your attention to:
> >>
> >> 1. if there is a mcg that the driver failed to join, the mc_task enter=
s to endless loop of re-queue, and the log will be full with the next messa=
ges:
> >> [682560.569826] ib0: no multicast record for ff12:601b:ffff:0000:0000:=
0000:0000:0016, starting sendonly join
> >> [682560.580136] ib0: no multicast record for ff12:601b:ffff:0000:0000:=
0000:0000:0016, starting sendonly join
> >> [682560.590364] ib0: no multicast record for ff12:601b:ffff:0000:0000:=
0000:0000:0016, starting sendonly join
> >> [682560.600504] ib0: no multicast record for ff12:601b:ffff:0000:0000:=
0000:0000:0016, starting sendonly join
> >> [682560.610627] ib0: no multicast record for ff12:601b:ffff:0000:0000:=
0000:0000:0016, starting sendonly join
> >> [682560.620769] ib0: no multicast record for ff12:601b:ffff:0000:0000:=
0000:0000:0016, starting sendonly join
> >> [682560.631082] ib0: no multicast record for ff12:601b:ffff:0000:0000:=
0000:0000:0016, starting sendonly join
> >> [682560.640835] ib0: sendonly multicast join failed for ff12:601b:ffff=
:0000:0000:0000:0000:0016, status -22
> >> [682560.651033] ib0: no multicast record for ff12:601b:ffff:0000:0000:=
0000:0000:0016, starting sendonly join
> >> [682560.660758] ib0: sendonly multicast join failed for ff12:601b:ffff=
:0000:0000:0000:0000:0016, status -22
> >> [682560.670923] ib0: no multicast record for ff12:601b:ffff:0000:0000:=
0000:0000:0016, starting sendonly join
> >> [682560.680676] ib0: sendonly multicast join failed for ff12:601b:ffff=
:0000:0000:0000:0000:0016, status -22
> >> [682560.690898] ib0: no multicast record for ff12:601b:ffff:0000:0000:=
0000:0000:0016, starting sendonly join
> >> [682560.700630] ib0: sendonly multicast join failed for ff12:601b:ffff=
:0000:0000:0000:0000:0016, status -22
> >>
> >> around 100 times a sec.
> > OK, this looks like the send only joins that fail are not setting a
> > fallback properly or something like that.  There is a separate bug that
> > I've isolated that I'm going to fix, then I we can see if that fix
> > effects things here, as it very well might.
> >
> >> 2. IPv6 still doesn't work for me, at the same case where it is not th=
e first mcg in the list.
> > Can you give me some sort of instructions on how to replicate your
> > testing?  Things are working for me here, but I don't have a complex
> > IPv6 setup and mine may be too simple to reproduce what you are seeing.
> I don't have a complex setup, i have 2 devices, and i do a regular ping6=
=20
> from device with the full series in it, to some other device. nothing=20
> special, the only thing i can say that in the list there is one sendonly=
=20
> mcg (
>=20
> ff12:601b:ffff:0000:0000:0000:0000:0016) that is at the first place in th=
e list.
> anyway, i think it connected to the first issue,because it at some endles=
s loop with the first mcg, it doesn't have the chance to handle the other m=
cg's.

OK, well, I have this all working here.  However, there is still one
lingering issue (not reported on this thread yet) that needs addressed,
so I don't yet consider the patchset complete.  But, I'll post it as it
stands so far for you to try your tests again.

The outstanding issue is that it is possible for ipoib_mcast_flush_dev
to race with ipoib_mcast_join and cause ipoib_mcast_join to oops.  It's
rare, I've only seen it once, but I was afraid that it was possible by
looking at the code, and now I have confirmation that it is indeed
possible.  So, it needs to be fixed.

> >
> >> Thanks, Erez
> >>
> >> -----Original Message-----
> >> From: Doug Ledford [mailto:dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org]
> >> Sent: Wednesday, January 14, 2015 9:53 PM
> >> To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
> >> Cc: Amir Vadai; Eyal Perry; Erez Shitrit; Or Gerlitz; Doug Ledford
> >> Subject: [PATCH V3 FIX For-3.19 0/3] IB/ipoib: Fix multicast join flow
> >>
> >> This patch series fixes the multicast join behavior problems introduce=
d by my previous patchset.  In particular, the original code did not use th=
e send only join code from the multicast thread context, and so it did not =
need to restart the multicast thread.  After my previous patchset, it does =
get called from the thread context, and so the send only join completion ar=
eas need to restart the join thread but they don't.  This patchset makes th=
em do so.  It then adds in some cleanups for restarting the thread, and fix=
es the fact that one delayed join holds up the entire list of joins.
> >>
> >> v3: Resend because the last send didn't register in patchworks properl=
y
> >>      (because the subject-prefix was not on all of the emails, only th=
e
> >>      first) and because the Cc: list didn't not pass from cover letter
> >>      to patches
> >>
> >> v2: Added two new patches, the first creates a helper to restart the
> >>      multicast join thread and also adds using it in the two places wh=
ere
> >>      it should have been used but wasn't, the second allows the joins =
to
> >>      proceed around a delayed join instead of stalling everything.
> >>
> >> v1: Addressed the usage of the IPOIB_MCAST_RUN flag
> >>
> >> Doug Ledford (3):
> >>    IB/ipoib: Fix failed multicast joins/sends
> >>    IB/ipoib: Add a helper to restart the multicast task
> >>    IB/ipoib: make delayed tasks not hold up everything
> >>
> >>   drivers/infiniband/ulp/ipoib/ipoib.h           |  1 +
> >>   drivers/infiniband/ulp/ipoib/ipoib_multicast.c | 94 ++++++++++++++++=
++--------
> >>   2 files changed, 66 insertions(+), 29 deletions(-)
> >>
> >> --
> >> 2.1.0
> >>
> >> --
> >> To unsubscribe from this list: send the line "unsubscribe linux-rdma" =
in
> >> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> >> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--=-aSS1oBPHI9P8zISyDmMU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABAgAGBQJUuCKfAAoJELgmozMOVy/drx8P/i2FQxkl2+8ro/Gny2DnPhaM
eMRMWA4Qn/Q+mnNdoXUP8+bKc9IiiQ6zqoO1LE7JPxxYruh8TdhoiTeCb1w5dWRy
r9JPx/LTm86WxHz2+JqUyNzUfUqN1GgTVckOBoHTGzMDTfbiCp/2/ZSkm5ioSnHe
Yj5OZbo6M7aLCCH889WDa8Sm97mMd4gQkYXNchlsr7YYX/TqACvpSnr0Po4qMhKJ
3nLhjHHadGmr8raALZTXezM5HV3NIdhds7WJi5cw/3kzaM32VM3XoJpJw6/hxvUu
dJyblwbLwugxIXAcquzY+KWDAP/KW97tkBnbAdQoOEKkQrHtt4Dn+pjxDsVt557p
EjsmrQCnu+iF4ibbgwcgjqinhmWeXMkeXloMX5FhCbfhcwoTPMj6wG4DpDeTFmAK
mDNpU0wUNKPQTPeNeed2Z3Riq9yFgIsHa2UODSMw/XAS6LzjiZL/FS4NVszGCW9v
8xgQtSKJMwYK0ajnsWq42ulwhXJ2+vSyZGdD5P/mLykBu9TogPi2yDfcbyZ+aT4m
l5N4P9Hl6eHTX3+9TVYQf2oW3x7YUdKjhkIhFClf2ULftYMALbFAXOK3uMggonlC
pSe0F2F+R+WjL6W2aLKBn3p/YmN5vqTzgvg2rvBa8QIG5xiKxK7Vq7tT4GHEkW4r
CC8HuUpYrEkQyFjpJDbg
=w377
-----END PGP SIGNATURE-----

--=-aSS1oBPHI9P8zISyDmMU--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
