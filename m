From: Caitlin Bestler <caitlin.bestler-x4E8uuA0+mFBDgjK7y7TUQ@public.gmane.org>
Subject: Re: NFS over RDMA with no TCP/UDP
Date: Mon, 6 Oct 2014 12:29:53 -0700
Message-ID: <D3BEE0C4-83CF-41E9-A367-9F84862209E3@asomi.com>
References: <CAO9TOLckugLP5_r+9MMeRWfCC3oXq8XcXbyaT7QgTyfg5i-now@mail.gmail.com>
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAO9TOLckugLP5_r+9MMeRWfCC3oXq8XcXbyaT7QgTyfg5i-now-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Adam Brenner <aebrenne-sXc7qaQca9o@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

The DDP draft alludes to the requirements for the generic transport lay=
er that support iWARP.
You then have two concrete examples: TCP and SCTP.

One of the more critical requirements is that the LLP delivers all DDP =
Segments in order
or fails the DDP Connection/Association/Whatever.

DDP does not handle reliability or retries on its own. So if you wanted=
 to build
=93iWARP over raw Ethernet=94 you would have to build an intermediate r=
eliability layer.

Now you might be able to define a new transport layer well tailored to =
your target
environment, or perhaps even better adapter to carrying DDP Segments, b=
ut it is
still a new transport layer.

That is not a trivial undertaking.

Attempting to map RPC over UDP directly to some sort of unreliable DDP =
transport
would have to address the safety guarantees built into iWARP that curre=
ntly rely on
the reliable LLP layer. You do not want your NIC to provide access to y=
our memory
to just any random packet. Unreliable RPC can accumulate and then authe=
nticate
the entire command before executing it. NFS over RMDA is really RPC ove=
r RDMA,
but it utilizes RDMA transfers which transfer directly into user buffer=
s without waiting
for the command to be validated as a whole. So not only are you recreat=
ing congestion
control and retransmission, but the authentication provided by a connec=
tion-oriented
session.

On Oct 6, 2014, at 12:11 PM, Adam Brenner <aebrenne-sXc7qaQca9o@public.gmane.org> wrote:

> Howdy,
>=20
> On our HPC cluster, we are exploring the option of mounting a NFS
> client over RDMA where no TCP/UDP connection will be available. Both
> the client and the server will have RDMA configured with OFED.
>=20
> Is this possible?
>=20
> er
> If so, what address would we specify on the NFS client side as the
> source host? iWARP address + port number? How I find out the iWARP
> address? Is that the same as the GID given by the command ibaddr? Or
> is this the Node GUID from ibstat? Do we have to safe escape or quote
> this address for both the mount option and /etc/exports?
>=20
> thanks,
> /adam
>=20
> --
> Adam Brenner
> Computer Science, Undergraduate Student
> Donald Bren School of Information and Computer Sciences
>=20
> System Administrator, HPC Cluster
> Office of Information Technology
> http://hpc.oit.uci.edu/
>=20
> University of California, Irvine
> www.ics.uci.edu/~aebrenne/
> aebrenne-sXc7qaQca9o@public.gmane.org
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma"=
 in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
