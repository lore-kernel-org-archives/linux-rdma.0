From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: Reconnect on RDMA device reset
Date: Thu, 25 Jan 2018 13:13:42 -0500
Message-ID: <1516904022.27592.187.camel@redhat.com>
References: <CADZhsQqDFc1NWmsihOwki8_2Zj0HuYKC_N_x0jMnCtU9Rww1UA@mail.gmail.com>
         <f0a14240-1566-1bae-1b9f-21880bc3f3a0@grimberg.me>
         <CADZhsQqvK0LMd9sfxzz+x_5qVnoi4FP0FCFMsTPjpeXyqfXKew@mail.gmail.com>
         <77cef33e-a563-97fc-7ba6-69f220f1be84@grimberg.me>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-OHJMygM2TSXPd/A1L2rB"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <77cef33e-a563-97fc-7ba6-69f220f1be84-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, Oren Duer <oren.duer-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Oren Duer <oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--=-OHJMygM2TSXPd/A1L2rB
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2018-01-24 at 22:52 +0200, Sagi Grimberg wrote:
> > > > Today host and target stacks will respond to RDMA device reset (or =
plug
> > > > out
> > > > and plug in) by cleaning all resources related to that device, and =
sitting
> > > > idle waiting for administrator intervention to reconnect (host stac=
k) or
> > > > rebind subsystem to a port (target stack).
> > > >=20
> > > > I'm thinking that maybe the right behaviour should be to try and re=
store
> > > > everything as soon as the device becomes available again. I don't t=
hink a
> > > > device reset should look different to the users than ports going do=
wn and
> > > > up
> > > > again.
> > >=20
> > >=20
> > > Hmm, not sure I fully agree here. In my mind device removal means the
> > > device is going away which means there is no point in keeping the con=
troller
> > > around...
> >=20
> > The same could have been said on a port going down. You don't know if i=
t will
> > come back up connected to the same network...
>=20
> That's true. However in my mind port events are considered transient,
> and we do give up at some point. I'm simply arguing that device removal
> has different semantics. I don't argue that we need to support it.

I think it depends on how you view yourself (meaning the target or
initiator stacks).  It's my understanding that if device eth0
disappeared completely, and then device eth1 was plugged in, and eth1
got the same ip address as eth0, then as long as any TCP sockets hadn't
gone into reset state, the iSCSI devices across the existing connection
would simply keep working.  This is correct, yes?  If so, then maybe you
want iSER at least to operate the same way.  The problem, of course, is
that iSER may use the IP address and ports for connection, but then it
transitions to queue pairs for data transfer.  Because iSER does that,
it is sitting at the same level as, say, the net core that *did* know
about the eth change in the above example and transitioned the TCP
socket from the old device to the new, meaning that iSER now has to take
that same responsibility on itself if it wishes the user visible
behavior of iSER devices to be the same as iSCSI devices.  And that
would even be true if the old RDMA device went away and a new RDMA
device came up with the old IP address, so the less drastic form of
bouncing the existing device should certainly fall under the same
umbrella.

I *think* for SRP this is already the case.  The SRP target uses the
kernel LIO framework, so if you bounce the device under the SRPt layer,
doesn't the config get preserved?  So that when the device came back up,
the LIO configuration would still be there and the SRPt driver would see
that? Bart?

For the SRP client, I'm almost certain it will try to reconnect since it
uses a user space daemon with a shell script that restarts the daemon on
various events.  That might have changed...didn't we just take a patch
to rdma-core to drop the shell script?  It might not reconnect
automatically with the latest rdma-core, I'd have to check.  Bart should
know though...

I haven't the faintest clue on NVMe over fabrics though.  But, again, I
think that's up to you guys to decide what semantics you want.  With
iSER it's a little easier since you can use the TCP semantics as a
guideline and you have an IP/port discovery so it doesn't even have to
be the same controller that comes back.  With SRP it must be the same
controller that comes back or else your login information will be all
wrong (well, we did just take RDMA_CM support patches for SRP that will
allow IP/port addressing instead, so theoretically it could now do the
same thing if you are using RDMA_CM mode logins).  I don't know the
details of the NVMe addressing though.

> > > AFAIK device resets usually are expected to quiesce inflight I/O,
> > > cleanup resources and restore when the reset sequence completes (whic=
h is
> > > what we do in nvme controller resets).

I think your perspective here might be a bit skewed by the way the NVMe
stack is implemented (which was intentional for speed as I understand
it).  As a differing example, in the SCSI stack when the LLD does a SCSI
host reset, it resets the host but does not restore or restart any
commands that were aborted.  It is up to the upper layer SCSI drivers to
do so (if they chose, they might send it back to the block layer).  From
the way you wrote the above, it sounds like the NVMe layer is almost
monolithic in nature with no separation between upper level consumer
layer and lower level driver layer, and so you can reset/restart all
internally.  I would argue that's rare in the linux kernel and most
places the low level driver resets, and some other upper layer has to
restart things if it wants or error out if it doesn't.

> > >  I'm not sure I understand why
> > > RDMA device resets manifest as DEVICE_REMOVAL events to ULPs (via
> > > rdma_cm or .remove_one via ib_client API). I think the correct interf=
ace
> > > would be suspend/resume semantics for RDMA device resets (similar to =
pm
> > > interface).

No, we can't do this.  Suspend/Resume is not the right model for an RDMA
device reset.  An RDMA device reset is a hard action that stops all
ongoing DMA regardless of its source.  Those sources include kernel
layer consumers, user space consumers acting without the kernel's direct
intervention, and ongoing DMA with remote RDMA peers (which will throw
the remote queue pairs into an error state almost immediately).  In the
future it very likely could include RDMA between things like GPU offload
processors too.  We can't restart that stuff even if we wanted to.  So
suspend/resume semantics for an RDMA device level reset is a non-
starter.

> > > I think that it would make a much cleaner semantics and ULPs should b=
e
> > > able to understand exactly what to do (which is what you suggested
> > > above).
> > >=20
> > > CCing linux-rdma.
> >=20
> > Maybe so. I don't know what's the "standard" here for Linux in general =
and
> > networking devices in particular. Let's see if linux-rdma agree here.
>=20
> I would like to hear more opinions on the current interface.

There is a difference between RDMA device and other network devices.=20
The net stack is much more like the SCSI stack in that you have an upper
layer connection (socket or otherwise) and a lower layer transport and
the net core code which is free to move your upper layer abstraction
from one lower layer transport to another.  With the RDMA subsystem,
your upper layer is connecting directly into the low level hardware.  If
you want a semantic that includes reconnection on an event, then it has
to be handled in your upper layer as there is no intervening middle
layer to abstract out the task of moving your connection from one low
level device to another (that's not to say we couldn't create one, and
several actually already exist, like SMC-R and RDS, but direct hooks
into the core ib stack are not abstracted out and you are talking
directly to the hardware).  And if you want to support moving your
connection from an old removed device to a new replacement device that
is not simply the same physical device being plugged back in, then you
need an addressing scheme that doesn't rely on the link layer hardware
address of the device.

> > > Regardless of ib_client vs. rdma_cm, we can't simply perform normal
> > > reconnects because we have dma mappings we need to unmap for each
> > > request in the tagset which we don't teardown in every reconnect (as
> > > we may have inflight I/O). We could have theoretically use reinit_tag=
set
> > > to do that though.
> >=20
> > Obviously it isn't that simple... Just trying to agree on the right dir=
ection
> > to go.
>=20
> Yea, I agree. It shouldn't be too hard also.
>=20
> > > > In the reconnect flow the stack already repeats creating the cm_id =
and
> > > > resolving address and route, so when the RDMA device comes back up,=
 and
> > > > assuming it will be configured with the same address and connected =
to the
> > > > same
> > > > network (as is the case in device reset), connections will be resto=
red
> > > > automatically.
> > >=20
> > >=20
> > > As I said, I think that the problem is the interface of RDMA device
> > > resets. IMO, device removal means we need to delete all the nvme
> > > controllers associated with the device.
> >=20
> > Do you think all associated controllers should be deleted when a TCP so=
cket
> > gets disconnected in NVMe-over-TCP? Do they?
>=20
> Nope, but that is equivalent to QP going into error state IMO, and we
> don't do that in nvme-rdma as well.

There is no equivalent in the TCP realm of an RDMA controller reset or
an RDMA controller permanent removal event.  When dealing with TCP, if
the underlying ethernet device is reset, you *might* get a TCP socket
reset, you might not.  If the underlying ethernet is removed, you might
get a socket reset, you might not, depending on how the route to the
remote host is re-established.  If all IP capable devices in the entire
system are removed, your TCP socket will get a reset, and attempts to
reconnect will get an error.

None of those sound semantically comparable to RDMA device
unplug/replug.  Again, that's just because the net core never percolates
that up to the TCP layer.

When you have a driver that has both TCP and RDMA transports, the truth
is you are plugging into two very different levels of the kernel and the
work you have to do to support one is very different from the other.  I
don't think it's worthwhile to even talk about trying to treat them
equivalently unless you want to take on an address scheme and
reset/restart capability in the RDMA side of things that you don't have
to have in the TCP side of things.

As a user of things like iSER/SRP/NVMe, I would personally like
connections to persist across non-fatal events.  But the RDMA stack, as
it stands, can't reconnect things for you, you would have to do that in
your own code.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD
--=-OHJMygM2TSXPd/A1L2rB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEErmsb2hIrI7QmWxJ0uCajMw5XL90FAlpqHlYACgkQuCajMw5X
L90SrQ/8Cnjp2vK+1nwUtAPGMEMOtHhC6+6B0xotcdmO71g5wcZNzLktu3pc/DEK
hbC88JDg+ArvAW+IutKZB/Mlq9hMp6GgvicEjnYLF2CgxMy0tLq8OSVayMyeTCla
+NBHs7G04F+X5ERjdNVc9SGlNYmEwbcJ6k8Rev0D46a8EbIuqpoPm+7IsoZeUQk8
DTdtnPzJGSiUAE1yAuYF0Zgxcg9gO4IRHMv55pAfv1YT8eGHKiJHwIGuO5mDszhn
ltuUj7SWH96ru1kT3p4b6k88ECur5C9wjwHydJDU5WMTlXcye7zjAHJmFsGsTQp5
G6KIRBgNg5Vi6YCC5PT4QS/PdyCXMVbJwClkAh8/Kv5xvC1JQmHlcHDoLjG4az83
BJAhnDmzSnAolAy1BkjETCd1BTnJp0Kk5tlv08y5qhfp4/FCaHszeUGGNJrf2pEF
CNNBdVwSrPSXi60DzXCiEmojeerypJeuDcuhpNgVNt/NpRmJtmtDmnpocFq7GGPM
p8sHyoMapcriH2mnh3270TQ2mCCUlyeUEPnhVaosRdGG8KHCw/rA4njLtrc/e2Uf
BQIe18qiBnDt7Xk5A0RHO49ihNta8DoBQqEzOEvQBnmH8+kO3EgiOxHCqf9A4KdQ
Dcv6F0vLik6C1gRfgGroB4ongK129qXGd+yUzYKnzfvrw776P2Y=
=ZzHe
-----END PGP SIGNATURE-----

--=-OHJMygM2TSXPd/A1L2rB--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
