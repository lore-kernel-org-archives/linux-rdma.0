From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH FIX For-3.19 v4 0/7] IB/ipoib: follow fixes for
 multicast handling
Date: Tue, 20 Jan 2015 12:37:00 -0500
Message-ID: <1421775420.3352.29.camel@redhat.com>
References: <cover.1421725318.git.dledford@redhat.com>
	 <54BE7F66.4070404@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-/D+ziXpv2MdAfX4RZd98"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <54BE7F66.4070404-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Erez Shitrit <erezsh-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Amir Vadai <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eyal Perry <eyalpe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--=-/D+ziXpv2MdAfX4RZd98
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2015-01-20 at 18:16 +0200, Erez Shitrit wrote:
> On 1/20/2015 5:58 AM, Doug Ledford wrote:
> > These patches are to resolve issues created by my previous patch set.
> > While that set worked fine in my testing, there were problems with
> > multicast joins after the initial set of joins had completed.  Since my
> > testing relied upon the normal set of multicast joins that happen
> > when the interface is first brought up, I missed those problems.
> >
> > Symptoms vary from failure to send packets due to a failed join, to
> > loss of connectivity after a subnet manager restart, to failure
> > to properly release multicast groups on shutdown resulting in hangs
> > when the mlx4 driver attempts to unload itself via its reboot
> > notifier handler.
> >
> > This set of patches has passed a number of tests above and beyond my
> > original tests.  As suggested by Or Gerlitz I added IPv6 and IPv4
> > multicast tests.  I also added both subnet manager restarts and
> > manual shutdown/restart of individual ports at the switch in order to
> > ensure that the ENETRESET path was properly tested.  I included
> > testing, then a subnet manager restart, then a quiescent period for
> > caches to expire, then restarting testing to make sure that arp and
> > neighbor discovery work after the subnet manager restart.
> >
> > All in all, I have not been able to trip the multicast joins up any
> > longer.
> >
> > Additionally, the original impetus for my first 8 patch set was that
> > it was simply too easy to break the IPoIB subsystem with this simple
> > loop:
> >
> > while true; do
> >      ifconfig ib0 up
> >      ifconfig ib0 down
> > done
> >
> > Just to be safe, I made sure this problem did not resurface.
> >
> > Roland, the 3.19-rc code is broken.  We either need to revert my
> > original patchset, or grab these, but I would not recommend leaving
> > it as it currently stands.
> >
> > Doug Ledford (7):
> >    IB/ipoib: Fix failed multicast joins/sends
> >    IB/ipoib: Add a helper to restart the multicast task
> >    IB/ipoib: make delayed tasks not hold up everything
> >    IB/ipoib: Handle -ENETRESET properly in our callback
> >    IB/ipoib: don't restart our thread on ENETRESET
> >    IB/ipoib: remove unneeded locks
> >    IB/ipoib: fix race between mcast_dev_flush and mcast_join
> >
> >   drivers/infiniband/ulp/ipoib/ipoib.h           |   1 +
> >   drivers/infiniband/ulp/ipoib/ipoib_multicast.c | 204 +++++++++++++++-=
---------
> >   2 files changed, 121 insertions(+), 84 deletions(-)
> >
> Hi Doug,
>=20
> After trying your V4 patch series, I can tell that first, the endless=20
> scheduling of
> the mcast task is indeed over,

Good.

>  but still, the multicast functionality in=20
> ipoib is unstable.

I'm not seeing that here.  Let's try to figure out what's different.

> I see that there are times that ping6 works good, and sometimes it=20
> doesn't, to
> make it clear I always use the link-local address assigned by the stack=
=20
> to the
> IPoIB device, see [1] below for how I run it.

As do I.  I'll attach the scripts I used to run it for your reference.

> I also see that send-only mcast stops working from time to time, see [2]=
=20
> below
> for how I run this. I can narrow the problem to be on the sender=20
> (client) side,
> since I work with a peer node which has well functioning IPoIB multicast=
=20
> code.

I don't think the peer side really denotes a conclusive argument ;-)

> One more phenomena, that in some cases I can see that the driver (after t=
he
> mcast_debug_level is set) prints endless message:
> "ib0: no address vector, but multicast join already started"

OK, this is to be expected from your tests I think.  In particular, this
is generated by mcast_send() if it's called by your program while the
send only join has not yet completed.  The flow goes like this:

First packet after interface comes up:
mcast_send() -> ipoib_mcast_alloc() -> ipoib_mcast_add() -> schedule join t=
ask thread

				In a different thread:
				mcast_join_task()
				  find unjoined mcast group
				  mark mcast->flags with IPOIB_MCAST_FLAG BUSY
				  -> mcast_join()
				     send join request over the wire

Back on original thread context:
mcast_send()
  this time we find a matching mcast entry but mcast->ah is NULL
  queue packet, unless backlog is full and then drop packet
  if mcast->flags & IPOIB_MCAST_FLAG_BUSY, emit notice that you see

				In a different thread:
				mcast_sendonly_join_complete() ->
					mcast_join_finish()
					  set mcast->ah
					  send skb backlog queue
				  clear IPOIB_MCAST_FLAG_BUSY

Back on original thread context:
mcast_send()
  now we find the mcast entry, and we find the mcast->ah entry, so
  sends now proceed as expected with no messages, and any lost packets
  while waiting on mcast->ah to be valid are simply gone

This looks entirely normal to me if your application is busy blasting
packets while the join is happening.  Actually, I think the message is
worthless to be honest.  I would be more interested in a message about
dropping packets than simply a message that denotes we are sending
packets while the join is still in process.

Unless we are sending so many packets out that we are starving the
join's ability to finish.  That would be interesting data to know.  Does
the join never finish in this case?  Also, I think you indicated that
you are running back to back and without a switch?  These joins have to
go to the subnet manager and back.  What is your subnet management like?

>=20
> One practical solution here would be to revert the offending commit 3.19-=
rc1
> 016d9fb "IPoIB: fix MCAST_FLAG_BUSY usage".

It is not practical to revert that patch by itself.  That patch changes
semantics of the mcast->flag usage in such a way that all of my
subsequent patches are broken without it.  They go as a group or not at
all.

> Thanks, Erez
>=20
> 1] IPv6 ping
>=20
> $ ping6 fe80::202:c903:9f:3b0a -I ib0
> where the IPv6 address is the one displayed by "ip addr show dev ib0" on=
=20
> the remote node

Mine is similar.  I use these two files:
[root@rdma-master testing]$ cat ip6-addresses.txt=20
rdma-master	fe80::f652:1403:7b:cba1	mlx4_ib0
rdma-perf-00	fe80::202:c903:31:7791	mlx4_ib0
rdma-perf-01	fe80::f652:1403:7b:e1b1	mlx4_ib0
rdma-perf-02	fe80::211:7500:77:d3cc	qib_ib0
rdma-perf-03	fe80::211:7500:77:d81a	qib_ib0
rdma-storage-01	fe80::f652:1403:7b:e131	mlx4_ib0
rdma-vr6-master	fe80::601:1403:7b:cba1	mlx4_ib0
[root@rdma-master testing]$ cat ping_loop=20
#!/bin/bash

trap_handler()
{
	exit 0
}

trap 'trap_handler' 2 15

ADDR_FILE=3Dip6-addresses.txt
ME=3D`hostname -s`
LOCAL=3D`awk '/'"$ME"'/ { print $3 }' $ADDR_FILE`
while true; do
	cat $ADDR_FILE | \
	while read host addr dev; do
		[ ${host} =3D `hostname -s` ] && continue
		ping6 ${addr}%$LOCAL -c 3
	done
done
[root@rdma-master testing]$=20


>=20
> [2] IPv4 multicast
>=20
> # server
> $ route add -net 224.0.0.0 netmask 240.0.0.0 dev ib0
> $ netserver
>=20
> # client
> $ route add -net 224.0.0.0 netmask 240.0.0.0 dev ib0
> $ netperf -H 11.134.33.1 -t omni -- -H 225.5.5.4 -T udp -R 1

I've been using iperf with a slightly different setup:

Each machine is a server:
ip route add 224.0.0.0/4 dev <ib0 device>
iperf -usB 224.3.2.<server #> -i 1 > <host>-iperf-server.out &

Each machine rotates as a client:
iperf_loop &

[root@rdma-master testing]$ cat iperf-addresses.txt=20
rdma-master	224.3.2.1
rdma-perf-00	224.3.2.2
rdma-perf-01	224.3.2.3
rdma-perf-02	224.3.2.4
rdma-perf-03	224.3.2.5
rdma-storage-01	224.3.2.6
[root@rdma-master testing]$ cat iperf_loop=20
#!/bin/bash

ADDR_FILE=3Diperf-addresses.txt
ME=3D`hostname -s`
LOG=3D${ME}-iperf-client.out
> $LOG
while true; do
	cat $ADDR_FILE | \
	while read host addr ; do
		[ ${host} =3D $ME ] && continue
		iperf -uc ${addr} -i 1 >> $LOG
	done
done
[root@rdma-master testing]$=20

One of the differences between iperf and netperf is the speed with which
it is blasting the multicast packets out.  iperf sends them at a fairly
sane rate while netperf is balls to the wall.  So I don't see the kernel
messages you posted as a problem, they are simply telling you that
netperf is blasting away at the group while it is coming online.  Unless
they happen infinitely on a single sendonly group, which would indicate
that our join never completed.  If that's the case, we have to find out
why the join never completed.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--=-/D+ziXpv2MdAfX4RZd98
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABAgAGBQJUvpI8AAoJELgmozMOVy/dUHMP/jH/j3smM6RQStqQMLJlFmHJ
PcGj/eTljT4u/WrXZY0mQGzD0x5XuQsUdTWPJaohSJSi9dBhGP7IMyMQh8mP0hPk
OcKvxG/4oNfmhSl6h9ZL9W03akmHnCW7RMwJu7MAx40cBzxVoyV4x1Ol/4WboESQ
DxNZbFG7fmSPkix9M1nWDHxgbyDs2Et10ADXY6JR9GPEBglYVkq32LqXqEDGQqag
2Z2w7W0ewxkqIu8vo2m9h/aLu6kinqt038P5QEOR6aCR0wVOQasRmx2RfPUbtC91
OQf8ypzFI9vUbEm4vYoBLD417RSnnhzD9WxBQI6Hdvgd0sIobEYye1LkpJVkpkUj
EBBkYTLCCbgNhT/bCAnEhmDjUlkxO28x89hazrS4GbnYmgeZ87DOjlyjQ8Axuk6N
92WXz9Ocxm6n4aYhRIwx6HZhO+KY4pdR1uilhvzM/dHQhTPjX//6JCHV5K8vuyOl
wDhHLW2jyjy9JiJIwwthhc8CmdDyajWGDlPt/FhXFFcvUCiuxyDVMaduMAFeDaik
HIW82UeEAif+X2ahLYmF6qYhgXZzvKrz6dq/kHWcOzVC7TP2GwYm2TGD03C4HH/i
2R4bYHxikfXsTLtspLyDozKlHncrdFrVqwQWeC42r3fgT6HgZ7RQJsNwqV0h5rbC
5/+y+wfaiw6Ioxe3qUYE
=BiqU
-----END PGP SIGNATURE-----

--=-/D+ziXpv2MdAfX4RZd98--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
