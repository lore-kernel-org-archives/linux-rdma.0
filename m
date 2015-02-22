From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 0/9] IB/ipoib: fixup multicast locking issues
Date: Sun, 22 Feb 2015 16:57:34 -0500
Message-ID: <1424642254.4847.3.camel@redhat.com>
References: <cover.1424562072.git.dledford@redhat.com>
	 <CAJ3xEMgj=ATKLt0MA67c3WefCrG1hZ59eSrhpD-u_dxLJe2kfg@mail.gmail.com>
	 <1424642176.4847.2.camel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-SbpvJ2cMI+ri9MG6EDP4"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1424642176.4847.2.camel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--=-SbpvJ2cMI+ri9MG6EDP4
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, 2015-02-22 at 16:56 -0500, Doug Ledford wrote:
> On Sun, 2015-02-22 at 23:34 +0200, Or Gerlitz wrote:
> > On Sun, Feb 22, 2015 at 2:26 AM, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wro=
te:
> > > This is the re-ordered, squashed version of my 22 patch set that I
> > > posted on Feb 11.  There are a few minor differences between that
> > > set and this one.
> >=20
> > Hi Doug,
> >=20
> > I took quick look on your git repo @
> > git://github.com/dledford/linux.git and it seems not to contain this
> > series, can you please get that there and tell what branch to pull?
>=20
> It's there now, branch for-3.20-squashed.

Also, git diff for-3.20..for-3.20-squashed will show the exact
differences between this 9 patch set and the previous 22 patch set.

> > Or.
> >=20
> > > They are:
> > > 1) Rename __ipoib_mcast_continue_join_thread to
> > >    __ipoib_mcast_schedule_join_thread
> > > 2) Make __ipoib_mcast_schedule_join_thread cancel any delayed work to
> > >    avoid us accidentally trying to queue the single work struct insta=
nce
> > >    twice (which doesn't work)
> > > 3) Slight alter layout of __ipoib_mcast_schedule_join_thread.  Logic
> > >    is the same modulo #2, but indenting is reduced and readability
> > >    increased
> > > 4) Switch a few instances of FLAG_ADMIN_UP to FLAG_OPER_UP
> > > 5) Add a couple missing spinlocks so that we always call the schedule
> > >    helper with the spinlock held
> > > 6) Make sure that we only clear the BUSY flag once we have done all t=
he
> > >    other things we are going to do to the mcast entry, and if possibl=
e,
> > >    only call complete after we have released the spinlock
> > > 7) Fix the usage of time_before_eq when we should have just used
> > >    time_before in ipoib_mcast_join_task
> > > 8) Create/destroy priv->wq in a slightly different point of
> > >    ipoib_transport_dev_init/ipoib_transport_dev_cleanup
> > >
> > > This entire patchset was intended to address the issue of ipoib
> > > interfaces being brought up/down in a tight loop, which will hardlock
> > > a standard v3.19 kernel.  It succeeds at resolving that problem.  In
> > > order to be sure this patchset does not introduce other problems,
> > > and in order to ensure that this rework of the patches into a new
> > > set does not break bisectability, this entire patchset has been
> > > extensively tested, starting with the first patch and going through
> > > the last.
> > >
> > > I used a 12 machine group plus the subnet manager to test these
> > > patches.
> > >
> > > 1 machine ran ifconfig up/ifconfig down in a tight loop tests
> > > 1 machine ran rmmod/insmod ib_ipoib in a loop with a 10 second pause
> > >   between insmod and rmmod
> > > 1 machine ran rmmod/insmod ib_ipoib in a tight loop with only a .1
> > >   second pause between insmod and rmmod
> > > 9 machines that kept their interfaces up and ran iperf servers, 6 als=
o
> > >   ran ping6 instances to the addresses of all 12 machines, 3 ran iper=
f
> > >   clients that sent data to all 9 iperf servers in an infinite loop
> > > 1 subnet manager machine that otherwise did not participate, but
> > >   during testing was set to restart opensm once every 30 seconds to
> > >   force net re-register events on all 12 machines in the group
> > >
> > > In addition to the configuration of various machines above to test
> > > data transfers, the IPoIB infrastructure itself contained several
> > > elements designed to test specific multicast capabilities.
> > >
> > > The primary P_Key, the one with the ping6 instances running on it,
> > > intentionally had some well known multicast groups not defined in
> > > order to intentionally cause failed sendonly multicast joins on
> > > the same device that needed to work with IPv6 pings as well as
> > > IPv4 multicast.
> > >
> > > One of the alternate P_Key interfaces was defined with a minimum
> > > rate of 56GBit/s, so all machines without 56GBit/s capability
> > > were unable to ever join the broadcast group on these P_Keys.
> > > This was done to make sure that when the broadcast group is not
> > > joined, no other multicast joins, sendonly or otherwise, are ever
> > > sent.  It also was done to make sure that failed attempts to join
> > > the broadcast group honored the backoff delays properly.
> > >
> > > Note: both machines that were doing the insmod/rmmod loops were
> > > changed to not have any P_Key interfaces defined other than the
> > > default P_Key interface.  It is known that repeated insmod/rmmod
> > > of the ib_ipoib interface is fragile and easily breaks in the
> > > presence of child interfaces.  It was not my intent to address
> > > that particular problem with this patch set and so to avoid false
> > > issues, children interfaces were removed from the mix on these
> > > machines.
> > >
> > > A wide array of hardware was also tested with this 12 machine group,
> > > covering mthca, mlx4, mlx5, and qib hardware.
> > >
> > > Patches 1 through 6 were tested without the ifconfig/rmmod/opensm
> > > loops as those particular problems were not expected to be addressed
> > > until patch 7.  Pathes 7 through 9 were tested with all tests.
> > >
> > > The final, complete patch set was left running with the various
> > > tests until it had completed 257 opensm restarts, 12052
> > > ifconfig up/ifconfig down loops, 765 10 second insmod/rmmod loops,
> > > and 1971 .1 second insmod/rmmod loops.  The only observed problem
> > > was that the fast insmod/rmmod loop eventually locked up the
> > > network stack on the machine.  It was stuck on a rtnl_lock deadlock,
> > > but not one related to the multicast code (and therefore outside
> > > the scope of these patches to address).  There are several bits of
> > > additional locking to be fixed in the overall ipoib code in relation
> > > to insmod/rmmod races and this patch set does not attempt to address
> > > those.  It merely attempts not to introduce any new issues while
> > > resolving the mcast locking issues related to bringing the interface
> > > up and down.  I feel confident that it does that.
> > >
> > > Doug Ledford (9):
> > >   IB/ipoib: factor out ah flushing
> > >   IB/ipoib: change init sequence ordering
> > >   IB/ipoib: Consolidate rtnl_lock tasks in workqueue
> > >   IB/ipoib: Make the carrier_on_task race aware
> > >   IB/ipoib: Use dedicated workqueues per interface
> > >   IB/ipoib: No longer use flush as a parameter
> > >   IB/ipoib: fix MCAST_FLAG_BUSY usage
> > >   IB/ipoib: deserialize multicast joins
> > >   IB/ipoib: drop mcast_mutex usage
> > >
> > >  drivers/infiniband/ulp/ipoib/ipoib.h           |  20 +-
> > >  drivers/infiniband/ulp/ipoib/ipoib_cm.c        |  18 +-
> > >  drivers/infiniband/ulp/ipoib/ipoib_ib.c        |  69 ++--
> > >  drivers/infiniband/ulp/ipoib/ipoib_main.c      |  60 +--
> > >  drivers/infiniband/ulp/ipoib/ipoib_multicast.c | 500 +++++++++++++--=
----------
> > >  drivers/infiniband/ulp/ipoib/ipoib_verbs.c     |  31 +-
> > >  6 files changed, 389 insertions(+), 309 deletions(-)
> > >
> > > --
> > > 2.1.0
> > >
>=20
>=20


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--=-SbpvJ2cMI+ri9MG6EDP4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABAgAGBQJU6lDOAAoJELgmozMOVy/d8XwP/AqGDFSxNfKWQzy0ZGy9U5kN
jeh8sqaU11vNU6AuwiScUQG7XLwoAnRGv8gzFizupGaEwNrNEC0PysLJjWao+7Yy
we8XLYAGEAjnEEar7kbgGKiWZz7c9gXUedAtYHWnuwHMfMbjCdKpu1hdFr4rCq8W
MeBpqaRQnfmefzEJYrrMFzSeTISD8gEgcHA3DiCW8RX+cQXRtifrE/qVZuVv+Qy5
/aIKDa5SrD0MpOwo0ELsLN5HKPFx4tp7xfBHvHzzqnmIEeTWpRMUC6GRdM/qlYNY
gD0/O/W4L+kJ0AX1xJ6G9pzTIzAf73G50nQOCJIY8OWKKZwDqDKjeJF45Odgje3Q
QKOrB9mLtPBsGEhixNazsH1LLvcVFqZ5vcVM8//QdZ/cII2DeEZkD/P6IHZl97xK
rnryogOHsg3v0w6PoAN0ll9/F8DLEcbG8f2orzw+83ULu1M1JJfIr9DxvEqRmUS6
YgGdmJrPZ/8TkJyRNnASODhSw0b2JQzKZrhzw4wYaAewDpRlJOfIXZdQGLSARWQJ
ohF7UWOlOofhYM2265NFsVnyeUapvpB6OTuZGgL3g/to1EJVmkDynr/9475pGp/D
oLsvNKVlLIenDhjhK4yDxW1Mu2Z9lPgqAd9FPXrDVq5eJX/djamaHoGCRLyxbtVc
bAoH/9U0Wh/YXa6+yFDB
=KlIs
-----END PGP SIGNATURE-----

--=-SbpvJ2cMI+ri9MG6EDP4--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
