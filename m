From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH FIX For-3.19 v5 00/10] Fix ipoib regressions
Date: Sun, 25 Jan 2015 17:21:17 -0500
Message-ID: <1422224477.3352.373.camel@redhat.com>
References: <cover.1421936879.git.dledford@redhat.com>
	 <1422031938.3352.286.camel@redhat.com>
	 <54C4E793.2010103@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-rUJTq1ZP/tYIfCWhpjXo"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <54C4E793.2010103-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Erez Shitrit <erezsh-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Amir Vadai <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eyal Perry <eyalpe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--=-rUJTq1ZP/tYIfCWhpjXo
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, 2015-01-25 at 14:54 +0200, Erez Shitrit wrote:
> On 1/23/2015 6:52 PM, Doug Ledford wrote:
> > On Thu, 2015-01-22 at 09:31 -0500, Doug Ledford wrote:
> >> My 8 patch set taken into 3.19 caused some regressions.  This patch
> >> set resolves those issues.
> >>
> >> These patches are to resolve issues created by my previous patch set.
> >> While that set worked fine in my testing, there were problems with
> >> multicast joins after the initial set of joins had completed.  Since m=
y
> >> testing relied upon the normal set of multicast joins that happen
> >> when the interface is first brought up, I missed those problems.
> >>
> >> Symptoms vary from failure to send packets due to a failed join, to
> >> loss of connectivity after a subnet manager restart, to failure
> >> to properly release multicast groups on shutdown resulting in hangs
> >> when the mlx4 driver attempts to unload itself via its reboot
> >> notifier handler.
> >>
> >> This set of patches has passed a number of tests above and beyond my
> >> original tests.  As suggested by Or Gerlitz I added IPv6 and IPv4
> >> multicast tests.  I also added both subnet manager restarts and
> >> manual shutdown/restart of individual ports at the switch in order to
> >> ensure that the ENETRESET path was properly tested.  I included
> >> testing, then a subnet manager restart, then a quiescent period for
> >> caches to expire, then restarting testing to make sure that arp and
> >> neighbor discovery work after the subnet manager restart.
> >>
> >> All in all, I have not been able to trip the multicast joins up any
> >> longer.
> >>
> >> Additionally, the original impetus for my first 8 patch set was that
> >> it was simply too easy to break the IPoIB subsystem with this simple
> >> loop:
> >>
> >> while true; do
> >>      ifconfig ib0 up
> >>      ifconfig ib0 down
> >> done
> >>
> >> Just to be safe, I made sure this problem did not resurface.
> >>
> >> v5: fix an oversight in mcast_restart_task that leaked mcast joins
> >>      fix a failure to flush the ipoib_workqueue on deregister that
> >>      meant we could end up running our code after our device had been
> >>      removed, resulting in an oops
> >>      remove a debug message that could be trigger so fast that the
> >>      kernel printk mechanism would starve out the mcast join task thre=
ad
> >>      resulting in what looked like a mcast failure that was really jus=
t
> >>      delayed action
> >>
> >>
> >> Doug Ledford (10):
> >>    IB/ipoib: fix IPOIB_MCAST_RUN flag usage
> >>    IB/ipoib: Add a helper to restart the multicast task
> >>    IB/ipoib: make delayed tasks not hold up everything
> >>    IB/ipoib: Handle -ENETRESET properly in our callback
> >>    IB/ipoib: don't restart our thread on ENETRESET
> >>    IB/ipoib: remove unneeded locks
> >>    IB/ipoib: fix race between mcast_dev_flush and mcast_join
> >>    IB/ipoib: fix ipoib_mcast_restart_task
> >>    IB/ipoib: flush the ipoib_workqueue on unregister
> >>    IB/ipoib: cleanup a couple debug messages
> >>
> >>   drivers/infiniband/ulp/ipoib/ipoib.h           |   1 +
> >>   drivers/infiniband/ulp/ipoib/ipoib_main.c      |   2 +
> >>   drivers/infiniband/ulp/ipoib/ipoib_multicast.c | 234 ++++++++++++++-=
----------
> >>   3 files changed, 131 insertions(+), 106 deletions(-)
> >>
> > FWIW, a couple different customers have tried a test kernel I built
> > internally with my patches and I've had multiple reports that all
> > previously observed issues have been resolved.
> >
>=20
> Hi Doug,
> still see an issue with the last version, and as a result no sendonly or=
=20
> IPv6 is working.

I disagree with your assessment.  See below.

> The scenario is some how simple to reproduce, if there is a sendonly=20
> multicast group that failed to join (sm refuses, perhaps the group was=
=20
> closed, etc.)

This is not the case.  "failed to join" implies that the join completed
with an error.  According to the logs below, something impossible is
happening.

>  that causes all the other mcg's to be blocked behind it=20
> forever.

Your right.  Because the join tasks are serialized and we only queue up
one join at a time (something I would like to address, but not in the
3.19 timeframe), if one join simply never returns, as the logs below
indicate, then it blocks up the whole system.

> for example, there is bad mcg ff12:601b:ffff:0000:0000:0000:0000:0016=20
> that the sm refuses to join, and after some time the user tries to send=
=20
> packets to ip address 225.5.5.5 (mcg:=20
> ff12:401b:ffff:0000:0000:0000:0105:0505 )
> the log will show something like:
> [1561627.426080] ib0: no multicast record for=20
> ff12:601b:ffff:0000:0000:0000:0000:0016, starting sendonly join

This is printed out by sendonly_join

> [1561633.726768] ib0: setting up send only multicast group for=20
> ff12:401b:ffff:0000:0000:0000:0105:0505

This is part of mcast_send and indicates we have created the new group
and added it to the mcast rbtree, but not that we've started the join.

> [1561643.498990] ib0: no multicast record for=20
> ff12:601b:ffff:0000:0000:0000:0000:0016, starting sendonly join

Our mcast task got ran again, and we are restarting the same group for
some reason.  Theoretically that means we should have cleared the busy
flag on this group somehow, which requires that sendonly_join_complete
must have been called.  However, I can't find a single code path in
sendonly_join_complete that could possibly clear out the busy flag on
this group and not result in a printout message of some sort.  Are you
trimming the list of messages here?  The reason I say this is that these
are the possibilities:

sendonly_join_complete with status =3D=3D ENETRESET, we silently drop out
but we would immediately get an ib_event with netreset and process a
flush, which would print out copious messages
sendonly_join_complete with status =3D=3D 0, we would call mcast_join_finis=
h
and the only silent return is if this is our broadcast group and
priv->broadcast is not set, in which case we don't have link up and the
silent failures and the failure to join any other address are normal and
expected since the ipoib layer considers things dead without the
broadcast group joined, every other return path will print out
something, and in particular the attempt to get an ah on the group will
always print out either success or failure
sendonly_join_complete with status anything else results in a debug
message about the join failing.

As far as I know, your setup has the IPv4 broadcast attached and the
link is up.  The group you are actually showing as bad is the IPv6
MLDv2-capable Routers group and failure to join it should not be
blocking anything else.  So I'm back to what I said before: unless you
are trimming messages, this debug output makes no sense whatsoever and
should be impossible to generate.  Are you sure you have a clean tree
with no possible merge oddities that are throwing your testing off?

> [1561675.645424] ib0: no multicast record for=20
> ff12:601b:ffff:0000:0000:0000:0000:0016, starting sendonly join
> [1561691.718464] ib0: no multicast record for=20
> ff12:601b:ffff:0000:0000:0000:0000:0016, starting sendonly join
> [1561707.791609] ib0: no multicast record for=20
> ff12:601b:ffff:0000:0000:0000:0000:0016, starting sendonly join
> [1561723.864839] ib0: no multicast record for=20
> ff12:601b:ffff:0000:0000:0000:0000:0016, starting sendonly join
> [1561739.937981] ib0: no multicast record for=20
> ff12:601b:ffff:0000:0000:0000:0000:0016, starting sendonly join
> [1561756.010895] ib0: no multicast record for=20
> ff12:601b:ffff:0000:0000:0000:0000:0016, starting sendonly join

These are all being queued with successively longer backoffs, exactly as
they should be.

In __ipoib_mcast_continue_join_thread, when we get called with delay !=3D
0, we end up doing two things.  One, we change the mcast->backoff from 1
to whatever it should be now (minimum of 2, maximum of 16), and we set
delay_until to jiffies + (HZ * mcast->backoff).  This lets the mcast
task know to skip this group until such time as its backoff is expired.
=46rom the messages above, that seems to be working. The other thing we do
is we don't queue up the mcast thread just once, we queue it up twice.
Once at the right time for the backoff, and again now (although there is
a bug here, the second instance queues it up with delay as the time
offset, that should be 0, that's a holdover from before, at least
fortunately it is only ever 1 or 0 so it's not horrible, but things
would go a little faster if I fix that so that the second instance is
always 0).  That way the instance that's queued up first will know to
skip the delayed group and continue on through the list, and that should
allow us to get these other groups that you say are blocked.

> ....
> for ever or till the sm will decide in the future to let=20
> ff12:601b:ffff:0000:0000:0000:0000:0016 join, till than no sendonly traff=
ic.
>=20
>=20
> The main cause is the concept that was broken for the send-only join,=20
> when you treat the sendonly like a regular mcg and add it to the mc list=
=20
> and to the mc_task etc.

I'm looking at 3.18 right now, and 3.18 adds sendonly groups to the mcg
just like my current code does.  The only difference, and I do mean
*only*, is that it calls sendonly_join directly instead of via the
mcast_task.  The net effect of that is that sendonly joins are not
serialized in the old version and they are in the new.  I'm more than
happy to deserialize them, but I don't think that necessarily means we
have to call sendonly_join directly from mcast_send, it could also be
done by allowing the mcast_task to fire off more than one join at a
time.  Whether we use the mcast_task or call sendonly_join directly is
in-consequential, it's more an issue of whether or not we serialize the
joins.

> (not consider other issues like packet drop, and bw of the sendonly traff=
ic)
> IMHO, sendonly is part of the TX flow as it was till now in the ipoib=20
> driver and should stay in that way.

It seems like you're thinking of the mcast task thread as something that
only runs as part of mcast joins or leaves when the upper layer calls
set multicast list in our driver.  It used to be that way, but since I
reworked the task thread, that's no longer the case.  As such, I don't
think this distinction you are drawing is necessarily still correct.

> I went over your comments to my patch, will try to response/ cover them=
=20
> ASAP.
>=20
> Thanks, Erez
>=20
>=20
>=20
>=20
>=20
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--=-rUJTq1ZP/tYIfCWhpjXo
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABAgAGBQJUxWxdAAoJELgmozMOVy/dfycP/1QhwG/dBN3+2o3mVAJ6yUZu
N6GVhHswH9xK2CS4sGC5lKwJZc233X/OShPI/ymgdK1LkCCtUCKN8U7una3gXtGw
YKMqfigtGta2bpRlYzE+5qtQo0pjVDW1ezacJ9NbhnAg4Dy/AGaTAUDMOvYpmfHT
D1v6R+qCBar34A94S1Uryv6YH2z2Q53w2OjfO3F6Sqmyn9rq4lBkmjOM41/xCLXV
mt+oXiQWDaEY84xWQfnbQRlggYbnjfwzlbLNZ25qqNiiY9rAdMUSAlqeqOGukdUq
B2olLrKWZ3hQHiQJv9teYTbBwg/H/MWnmzc/4/zw0y4lXlTmnaI3BFowK1325FA2
cbbV4/8jKSWSdXJp9O+ZuNnToVS94upWQ6cq3XystlBwjVEfC8asPXavBOshFATk
ZDOoUQMplskDMpnNOxrMkpL5/WdhpX2jnKXby45PdPpB2w6he4SMBOl9b1+1phZg
W9hXBkBn11QAILd3IPZZzcN3U+onbY7Ix8d3AJrPffvUW6uwexXSK1q1jI3OpYng
27RyqKeDQCtOEH3GIBfN73NpzDXDJk9BIPSWzh17jtqhUqnjW+6hX708VQ4ZgNBT
kocs856bl118HNb4qrLFWWhTv0ZeI53I8g55eVXeMHCYPwAxJ6xZd9IRZX6jiQR7
GQrufAqnOeakyU30dscD
=lZYX
-----END PGP SIGNATURE-----

--=-rUJTq1ZP/tYIfCWhpjXo--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
