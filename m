From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: RFC: RPC/RDMA memory invalidation
Date: Wed, 28 Oct 2015 17:30:17 -0400
Message-ID: <59849A38-0C8F-46AB-BB76-71216C6C0631@oracle.com>
References: <094A348A-0764-4F46-A422-FBF2F1DC1C28@oracle.com> <20151028201002.GA27901@obsidianresearch.com>
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2104\))
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20151028201002.GA27901-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Linux RDMA Mailing List <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


> On Oct 28, 2015, at 4:10 PM, Jason Gunthorpe <jgunthorpe@obsidianrese=
arch.com> wrote:
>=20
> On Wed, Oct 28, 2015 at 03:56:08PM -0400, Chuck Lever wrote:
>=20
>> A key question is whether connection loss guarantees that the
>> server is fenced, for all device types, from existing
>> registered MRs. After reconnect, each MR must be registered
>> again before it can be accessed remotely. Is this true for the
>> Linux IB core, and all kernel providers, when using FRWR?
>=20
> MR validation is not linked to a QP in any way. The memory is not
> fully fenced until the invalidate completes, or the MR unregister
> completes. Nothing else is good enough.

IBTA spec states:

> MW access operations (i.e. RDMA Write, RDMA Reads, and Atom-
> ics) are only allowed if the Type 2B MW is in the Valid state and the
> QP Number (QPN) and PD of the QP performing the MW access op-
> eration matches the QPN and PD associated with the Bound Type 2B
> MW.

Once the QP is out of RTS, there can be no incoming RDMA
requests that match the R_key, QPN, PD tuple. I think you
are saying that the QP state change has the same problem
as not waiting for an invalidation to complete.


>> After a connection loss, the Linux kernel RPC/RDMA client
>> creates a new QP as it reconnects, thus I=E2=80=99d expect the QPN t=
o
>> be different on the new connection. That should be enough to
>> prevent access to MRs that were registered with the previous
>> QP and PD, right?
>=20
> No, the NFS implementation creates a single PD for everything and any
> QP in the PD can access all the MRs. This is another security issue o=
f
> a different sort.

I=E2=80=99m speaking only of the client at the moment.


> If there was one PD per QP then the above would be true, since the MR
> is linked to the PD.

There is a per-connection struct rpcrdma_ia that contains
both a PD and a QP. Therefore there is one PD and only one
QP (on the client) per connection.

Transport reconnect replaces the QP, but not the PD. See
rpcrdma_ep_connect().


> Even so, moving a QP out of RTR is not a synchronous operation, and
> until the CQ is drained, the disoposition of ongoing RDMA is not
> defined.
>=20
> Basically: You can't avoid actually doing a blocking invalidate
> operation. The core layer must allow for this if it is going to async
> cancel RPCs.

Disappointing, but understood.


> FWIW, the same is true on the send side too, if the RPC had send
> buffers and gets canceled, you have to block until a CQ linked to tha=
t
> send is seen.

By =E2=80=9Cyou have to block=E2=80=9D you mean the send buffer cannot =
be reused
until the Send WR is known to have completed, and new Send WRs
cannot be posted until it is known that enough send queue resources
are available.

The connection recovery logic in rpcrdma_ep_connect should flush
pending CQs. New RPCs are blocked until a new connection is
established, although I=E2=80=99m not certain we are careful to ensure
the hardware has truly relinquished the send buffer before it is
made available for re-use. A known issue.


=E2=80=94-
Chuck Lever



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
