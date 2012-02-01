From: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: Infiniband stack allows references to freed memory
Date: Wed, 1 Feb 2012 13:04:58 -0800
Message-ID: <CAG4TOxPrAhac1y-TzA=x47sm88JfQdkrpWW4Em_mBD=KbyRo+g@mail.gmail.com>
References: <20120201.152213.433850213028883896.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120201.152213.433850213028883896.davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Miller <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>
Cc: sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wed, Feb 1, 2012 at 12:22 PM, David Miller <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org> wro=
te:
>
> Any time an ipoib_neigh is changed, a sequence like the following is =
made:
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0spin_lock_irqsave(&pri=
v->lock, flags);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/*
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 * It's safe to call i=
poib_put_ah() inside
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 * priv->lock here, be=
cause we know that
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 * path->ah will alway=
s hold one more reference,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 * so ipoib_put_ah() w=
ill never do more than
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 * decrement the ref c=
ount.
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 */
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (neigh->ah)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ipoib_=
put_ah(neigh->ah);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0list_del(&neigh->list)=
;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ipoib_neigh_free(dev, =
neigh);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0spin_unlock_irqrestore=
(&priv->lock, flags);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ipoib_path_lookup(skb,=
 n, dev);
>
> This doesn't work, because you're leaving a stale pointer to the free=
d up
> ipoib_neigh in the special neigh->ha pointer cookie. =A0Yes, it even =
fails
> with all the locking done to protect _changes_ to *ipoib_neigh(n), an=
d
> with the code in ipoib_neigh_free() that NULLs out the pointer.
>
> The core issue is that read side calls to *to_ipoib_neigh(n) are not
> being synchronized at all, they are performed without any locking. =A0=
So
> whether we hold the lock or not when making changes to *ipoib_neigh(n=
)
> you still can have threads see references to freed up ipoib_neigh
> objects.
>
> =A0 =A0 =A0 =A0cpu 1 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cpu 2
> =A0 =A0 =A0 =A0n =3D *ipoib_neigh()
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0*ipoib=
_neigh() =3D NULL
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0kfree(=
n)
> =A0 =A0 =A0 =A0n->foo =3D=3D OOPS
>
> To be honest I wouldn't mind if ipoib managed it's neighbour entries
> differently. =A0The way it works now is getting in the way of some
> changes I want to make. =A0Namely that I want to make it so that
> dst_entry objects do not have an attached neighbour, instead
> neighbours are always looked up on demand.
>
> Such on-demand neigh lookups require having access to the ipv4/ipv6
> header destination address of the packet, and in these ipoib paths we
> don't have a real obvious way to get at that without lots of kludgy
> tests.
>
> Sticking datastructure pointers into the hardware address of the neig=
h
> is not pretty either :-)
>
> Perhaps the ipoib code can have a private path database it manages
> entirely itself, which holds all the necessary information and is
> looked up by some generic key which is available easily at transmit
> time and does not involve generic neighbour entries.

Thanks David.  This is probably the crux of some rare crashes we see
in the ipoib driver around handling the neighbour database.

I've made a few half-hearted stabs at fixing this up but I never really
got past the impedence mismatch between the networking core and
the strange requirements of the IPoIB neighbour handling.

The problem is that we definitely want to use the core networking
stack to resolve neighbours, since we clearly don't want a private
implementation of ARP and IPv6 ND.  But what IPoIB abstractly
calls a "hardware address" is actually an IB GID, which does
uniquely identify a destination but is not actually what we need
to send a packet.

So we do have the whole path database inside the ipoib driver,
and in fact for things like unicast ARPs (which comes without a
neighbour attached) we do lookup the hardware address to an
internal ipoib path.

The problem is that we don't want to do the expensive lookup of
a full 16-byte GID to path for real datapath packets where we do
have a neighbour resolved.  So we try to do the lookup once for
each network stack neighbour.

Perhaps we could do some RCU-ish thing where we don't actually
free the ipoib_neigh immediately?

 - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
