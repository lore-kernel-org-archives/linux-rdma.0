From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: RFC: RPC/RDMA memory invalidation
Date: Wed, 28 Oct 2015 15:51:19 -0600
Message-ID: <20151028215119.GA30564@obsidianresearch.com>
References: <094A348A-0764-4F46-A422-FBF2F1DC1C28@oracle.com>
 <20151028201002.GA27901@obsidianresearch.com>
 <59849A38-0C8F-46AB-BB76-71216C6C0631@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <59849A38-0C8F-46AB-BB76-71216C6C0631-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: Linux RDMA Mailing List <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Oct 28, 2015 at 05:30:17PM -0400, Chuck Lever wrote:

> IBTA spec states:
>=20
> > MW access operations (i.e. RDMA Write, RDMA Reads, and Atom-
> > ics) are only allowed if the Type 2B MW is in the Valid state and t=
he
> > QP Number (QPN) and PD of the QP performing the MW access op-
> > eration matches the QPN and PD associated with the Bound Type 2B
> > MW.
>=20
> Once the QP is out of RTS, there can be no incoming RDMA
> requests that match the R_key, QPN, PD tuple. I think you
> are saying that the QP state change has the same problem
> as not waiting for an invalidation to complete.

MW (Memory Window) is something different from a MR.

MR's do not match on the QPN.

> > If there was one PD per QP then the above would be true, since the =
MR
> > is linked to the PD.
>=20
> There is a per-connection struct rpcrdma_ia that contains
> both a PD and a QP. Therefore there is one PD and only one
> QP (on the client) per connection.

Oh, that is great then

> > FWIW, the same is true on the send side too, if the RPC had send
> > buffers and gets canceled, you have to block until a CQ linked to t=
hat
> > send is seen.
>=20
> By =E2=80=9Cyou have to block=E2=80=9D you mean the send buffer canno=
t be reused
> until the Send WR is known to have completed, and new Send WRs
> cannot be posted until it is known that enough send queue resources
> are available.

Yes

> I=E2=80=99m not certain we are careful to ensure
> the hardware has truly relinquished the send buffer before it is
> made available for re-use. A known issue.

This is the issue I was thinking of, yes. Ideally the CPU would not
touch the send buffer until the HW is done with it under any
situation. This is less serious than having a rouge writable R_Key
however.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
