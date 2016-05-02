From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH V1 for-next 1/2] IB/core: Report LSO capabilities when
 querying device
Date: Mon, 2 May 2016 13:06:19 -0600
Message-ID: <20160502190619.GB32613@obsidianresearch.com>
References: <1461765892-1285-1-git-send-email-matanb@mellanox.com>
 <1461765892-1285-2-git-send-email-matanb@mellanox.com>
 <alpine.DEB.2.20.1604271043540.20042@east.gentwo.org>
 <1828884A29C6694DAF28B7E6B8A82373AB046AB1@ORSMSX109.amr.corp.intel.com>
 <5721C3AD.8050407@mellanox.com>
 <1828884A29C6694DAF28B7E6B8A82373AB046FD8@ORSMSX109.amr.corp.intel.com>
 <d8f8d6bf-9fad-fcc9-5a15-2b2423349c26@mellanox.com>
 <1828884A29C6694DAF28B7E6B8A82373AB0480DB@ORSMSX109.amr.corp.intel.com>
 <20160502175011.GB32096@obsidianresearch.com>
 <1828884A29C6694DAF28B7E6B8A82373AB04816A@ORSMSX109.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1828884A29C6694DAF28B7E6B8A82373AB04816A-P5GAC/sN6hkd3b2yrw5b5LfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Bodong Wang <bodong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, May 02, 2016 at 06:13:45PM +0000, Hefty, Sean wrote:
> > > > So, what do you think about stating an optional protocol in create_qp
> > > > and putting LSO in query_qp?
> > >
> > > This makes sense to me, and I think will work well as devices become
> > > more complex (e.g. the qlogic NIC that supports both iWarp and
> > > RoCE).
> > 
> > What is the actual issue here?
> 
> My issue is how this is being exposed.  RC QPs already do LSO.  What
> does this change mean in that context?  What is actually being
> offloaded?

No, you are mixing layers.

LSO is only defined at the WR layer.

LSO says, 'take this WR, in HW perform a split and transform operation
and create multiple SEND WRs'.

The end result is still SEND, LSO does not change anything about the
layers below the WR. A SEND on a UD, RC, or RAW QP is still exactly the
same as before LSO was involved.

Critically, the operation of LSO should be indistinguishable on the
wire from actually generating the final WRs directly by the
application in the SQ.

Thus, RC/UC QPs do not do LSO. Their message segmentation protocol is
something totally different.

> > LSO should just be programmable UD fragmentation. It should be
> > indistinguishable from a user app sending multiple send WRs to the UD
> > QP. Surely it doesn't have anything to do with the underlying wire
> > protocol?
> 
> IMO - the fragmentation has everything to do with the underlying
> protocol.  Are we fragmenting into IP datagrams?  IB UD datagrams?
> UDP packets?

It really doesn't.

It is perfectly legitimate to perform an Ethernet IPv4 TCP LSO
transformation on a RC QP for IB (for instance). You'd get Ethernet
frames split up within IB RC SEND packets. eg for ethernet over IB
type applications.

The LSO transformation requested and underlying QP are totally
orthogonal concepts.

> Is re-assembly occurring on the opposite side (assuming no)?  Is the
> receiver seeing multiple messages (assuming yes)?  How many
> messages, and where did the breaks occur?  If the wire protocol
> doesn't matter, why does the qp type?

Typically an IP focused LSO will work like this:

 'SEND' WR for 32k.
 Split it into 1500 byte chunks, and make a new SEND for each chunk
 Replicate bytes 0->NN of header onto every new SEND
 Edit bytes XX->YY assuming they are an IPv4 header (update lengths,
  checksum, sequence, etc)
 Edit bytes YY->ZZ assuming they are a TCP or UDP header
  (length,checksum,etc)

In all cases the LSO is simply a transformation of a single SEND into
multiple SEND according to certain rules.

The rules *must* be specified in the API. I think this is what you are
thinking about when you say 'protocol', but this is not IB or iWarp,
it is 'LSO packet format protocol #1' or something.

IIRC there is quite a lot of variety here in Ethernet hardware, and
some hardware can specify the LSO format on each WR.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
