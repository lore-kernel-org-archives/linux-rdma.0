From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 0/8] IPoIB: Fix multiple race conditions
Date: Wed, 03 Sep 2014 14:12:17 -0400
Message-ID: <1409767937.26762.10.camel@firewall.xsintricity.com>
References: <cover.1407885724.git.dledford@redhat.com>
	 <54071D14.9040404@mellanox.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-w5r+tArHKMD8NQaCVHOO"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <54071D14.9040404-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Saeed Mahameed <saeedm-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Yevgeny Petrilin <yevgenyp-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--=-w5r+tArHKMD8NQaCVHOO
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

On Wed, 2014-09-03 at 16:52 +0300, Or Gerlitz wrote:
> On 8/13/2014 2:38 AM, Doug Ledford wrote:
> > Locking of multicast joins/leaves in the IPoIB layer have been problema=
tic
> > for a while.  There have been recent changes to try and make things bet=
ter,
> > including these changes:
> >
> > bea1e22 IPoIB: Fix use-after-free of multicast object
> > a9c8ba5 IPoIB: Fix usage of uninitialized multicast objects
> >
> > Unfortunately, the following test still fails (miserably) on a plain
> > upstream kernel:
> >
> > pass=3D0
> > ifdown ib0
> > while true; do
> >      ifconfig ib0 up
> >      ifconfig ib0 down
> >      echo "Pass $pass"
> >      let pass++
> > done
> >
> > This usually fails within 10 to 20 passes, although I did have a lucky
> > run make it to 300 or so.  If you happen to have a P_Key child interfac=
e,
> > it fails even quicker.
>=20
> Hi Doug,
>=20
> Thanks for looking on that. I wasn't aware we're doing so badly... I=20
> checked here and the plan is that Erez Shitrit from Mellanox will also=
=20
> be providing feedback on the series.
>=20
> Anyway, just to make sure we're on the same page, people agree that=20
> picking such series is too heavy for post merge window, right? so we are=
=20
> talking on 3.18, agree?

Given how easy the problem is to reproduce, and how this patch set
positively solves the reproducer, I would have preferred 3.17, and I had
it in to Roland before the merge window closed, but Roland chose to put
it off.

/me boggles.

> Or.
>=20
> >
> > In tracking down the rtnl deadlock in the multicast code, I ended up
> > re-designing the flag usage and clean up just the race conditions in
> > the various tasks.  Even that wasn't enough to resolve the issue entire=
ly
> > though, as if you ran the test above on multiple interfaces simultaneou=
sly,
> > it could still deadlock.  So in the end I re-did the workqueue usage to=
o
> > so that we now use a workqueue per device (and that includes P_Key devi=
ces
> > have dedicated workqueues) as well as one global workqueue that does
> > nothing but flush tasks.  This turns out to be a much more elegant way
> > of handling the workqueues and in fact enabled me to remove all of the
> > klunky passing around of flush parameters to tell various functions not
> > to flush the workqueue if it would deadlock the workqueue we are runnin=
g
> > from.
> >
> > Here is my test setup:
> >
> > 2 InfiniBand physical fabrics: ib0 and ib1
> > 2 P_Keys on each fabric: default and 0x8002 on ib0 and 0x8003 on ib1
> > 4 total IPoIB devices that I have named mlx4_ib0, mlx4_ib0.8002,
> >    mlx4_ib1, and mlx4_ib1.8003
> >
> > In order to test my final patch set, I logged into my test machine on
> > four different virtual terminals, I used ifdown on all of the above
> > interfaces to get things in a consistent state, and then I ran the abov=
e
> > loop, one per terminal per interface simultaneously.
> >
> > It's worth noting here that when you ifconfig a base interface up, it
> > automatically brings up the child interface too, so the ifconfig mlx4_i=
b0
> > up is in fact racing with both ups and downs of mlx4_ib0.8002.  The sam=
e
> > is true for the mlx4_ib1 interface and its child.  With my patch set in
> > place, these loops are currently running without a problem and have pas=
sed
> > 15,000 up/down cycles per interface.
> >
> > Doug Ledford (8):
> >    IPoIB: Consolidate rtnl_lock tasks in workqueue
> >    IPoIB: Make the carrier_on_task race aware
> >    IPoIB: fix MCAST_FLAG_BUSY usage
> >    IPoIB: fix mcast_dev_flush/mcast_restart_task race
> >    IPoIB: change init sequence ordering
> >    IPoIB: Use dedicated workqueues per interface
> >    IPoIB: Make ipoib_mcast_stop_thread flush the workqueue
> >    IPoIB: No longer use flush as a parameter
> >
> >   drivers/infiniband/ulp/ipoib/ipoib.h           |  19 +-
> >   drivers/infiniband/ulp/ipoib/ipoib_cm.c        |  18 +-
> >   drivers/infiniband/ulp/ipoib/ipoib_ib.c        |  27 ++-
> >   drivers/infiniband/ulp/ipoib/ipoib_main.c      |  49 +++--
> >   drivers/infiniband/ulp/ipoib/ipoib_multicast.c | 239 ++++++++++++++++=
---------
> >   drivers/infiniband/ulp/ipoib/ipoib_verbs.c     |  22 ++-
> >   6 files changed, 240 insertions(+), 134 deletions(-)
> >
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--=-w5r+tArHKMD8NQaCVHOO
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABAgAGBQJUB1oCAAoJELgmozMOVy/dQ78P/10dlhJhtU34o+LT8Dmv6CmD
Gzz5205989/WQulTC2x1Eqk3F/6UfGjbdvFZIM3x4leDZmDb3m8a3MubA1R0SVJU
zg1bmv9a7NrlDxaV9kBwtCu+yFjBy13sHgCGzLFIbRlp/A7WzV9FcxfevXUQKjYC
FiR0dmbzQN2isH9mP/5ZGCYWAWTZy30GWmW86O0AKed44p0D5xg5zHrlRl25es4w
0IRJJHBOCfGYlu7FB8RxkV6QYTRXw/M3tgu9Akbau802k6X+p+63UuWJEOPY94B3
FVBM8e4qohE8o6BnmhavBoFmCgrrZyQZDKuxiItQknVgw7wfdsNQlfsDqr9mX9aS
xiVuYGRwjkvadU1yJveI/T0FwX8W8XNKRWq3dndhcGSXKRKK3bzDLlrwKjsn5bTl
OMbxf47lxD0TvPq36iOp4+nxZZpeHj0YM0XYxUV9KqO1K1MOI+rJYLAzn2oLH8g9
Ekj8NyO+trDOpxq94osBhRVclCi6tmSY4ze9pEfazTo3NZW1OmtZWVZN47kLKghN
UsqLYz6fDHORmx8x7EqbfaBd4O0UQN8UI//N/Et0IUmMOZoV2qrC8GqIzFcny1mL
GbFCkNjjvQeP26tLlbG6cnbFtR2r+J89IumAhqNcgugd7yzBWjvQrLt7NZ2a8LFx
o2DeL/sQejzlnTrlCx/J
=wsmY
-----END PGP SIGNATURE-----

--=-w5r+tArHKMD8NQaCVHOO--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
