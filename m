From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: RFC: RPC/RDMA memory invalidation
Date: Wed, 28 Oct 2015 14:10:02 -0600
Message-ID: <20151028201002.GA27901@obsidianresearch.com>
References: <094A348A-0764-4F46-A422-FBF2F1DC1C28@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <094A348A-0764-4F46-A422-FBF2F1DC1C28-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: Linux RDMA Mailing List <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Oct 28, 2015 at 03:56:08PM -0400, Chuck Lever wrote:

> A key question is whether connection loss guarantees that the
> server is fenced, for all device types, from existing
> registered MRs. After reconnect, each MR must be registered
> again before it can be accessed remotely. Is this true for the
> Linux IB core, and all kernel providers, when using FRWR?

MR validation is not linked to a QP in any way. The memory is not
fully fenced until the invalidate completes, or the MR unregister
completes. Nothing else is good enough.

> After a connection loss, the Linux kernel RPC/RDMA client
> creates a new QP as it reconnects, thus I=E2=80=99d expect the QPN to
> be different on the new connection. That should be enough to
> prevent access to MRs that were registered with the previous
> QP and PD, right?

No, the NFS implementation creates a single PD for everything and any
QP in the PD can access all the MRs. This is another security issue of
a different sort.

If there was one PD per QP then the above would be true, since the MR
is linked to the PD.

Even so, moving a QP out of RTR is not a synchronous operation, and
until the CQ is drained, the disoposition of ongoing RDMA is not
defined.

Basically: You can't avoid actually doing a blocking invalidate
operation. The core layer must allow for this if it is going to async
cancel RPCs.

=46WIW, the same is true on the send side too, if the RPC had send
buffers and gets canceled, you have to block until a CQ linked to that
send is seen.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
