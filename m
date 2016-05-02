From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH V1 for-next 1/2] IB/core: Report LSO capabilities when
 querying device
Date: Mon, 2 May 2016 18:13:45 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A82373AB04816A@ORSMSX109.amr.corp.intel.com>
References: <1461765892-1285-1-git-send-email-matanb@mellanox.com>
 <1461765892-1285-2-git-send-email-matanb@mellanox.com>
 <alpine.DEB.2.20.1604271043540.20042@east.gentwo.org>
 <1828884A29C6694DAF28B7E6B8A82373AB046AB1@ORSMSX109.amr.corp.intel.com>
 <5721C3AD.8050407@mellanox.com>
 <1828884A29C6694DAF28B7E6B8A82373AB046FD8@ORSMSX109.amr.corp.intel.com>
 <d8f8d6bf-9fad-fcc9-5a15-2b2423349c26@mellanox.com>
 <1828884A29C6694DAF28B7E6B8A82373AB0480DB@ORSMSX109.amr.corp.intel.com>
 <20160502175011.GB32096@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160502175011.GB32096-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Bodong Wang <bodong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> > > So, what do you think about stating an optional protocol in create_qp
> > > and putting LSO in query_qp?
> >
> > This makes sense to me, and I think will work well as devices become
> > more complex (e.g. the qlogic NIC that supports both iWarp and
> > RoCE).
> 
> What is the actual issue here?

My issue is how this is being exposed.  RC QPs already do LSO.  What does this change mean in that context?  What is actually being offloaded?

When I see LSO, I think of TCP LSO.  Is LSO the most appropriate term here?

> LSO should just be programmable UD fragmentation. It should be
> indistinguishable from a user app sending multiple send WRs to the UD
> QP. Surely it doesn't have anything to do with the underlying wire
> protocol?

IMO - the fragmentation has everything to do with the underlying protocol.  Are we fragmenting into IP datagrams?  IB UD datagrams?  UDP packets?  Is re-assembly occurring on the opposite side (assuming no)?  Is the receiver seeing multiple messages (assuming yes)?  How many messages, and where did the breaks occur?  If the wire protocol doesn't matter, why does the qp type?

> That said, I haven't seen anything talking about how to program the
> segmentation behavior (presumably it is assuming IP datagrams or
> something?). It is absolutely necessary to specify the segmentation
> method that the HW is going to use, there is lots of variety there.

I'm hoping that the protocol conveys this information.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
