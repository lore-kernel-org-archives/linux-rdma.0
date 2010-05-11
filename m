From: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Subject: Re: IPoIB multiqueue support?
Date: Tue, 11 May 2010 15:50:35 -0500 (CDT)
Message-ID: <alpine.DEB.2.00.1005111548450.8388@router.home>
References: <alpine.DEB.2.00.1005101607580.17916@router.home> <adawrvbxxyd.fsf@roland-alpha.cisco.com> <alpine.DEB.2.00.1005110851530.1500@router.home> <adawrvawhyc.fsf@roland-alpha.cisco.com> <alpine.DEB.2.00.1005111516500.1500@router.home>
 <20100511204358.GQ15969@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100511204358.GQ15969-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Tue, 11 May 2010, Jason Gunthorpe wrote:

> > Right but then would each individual QP need its own IP address?
>
> I think Roland means that each IP multicast address is mapped into an
> IB multicast GID, and you can bind a QP to a set of MGIDs. Right now
> the driver binds all MGIDs to the rx QP and basically ignores the
> MGID on receive.

Aha.

> To go multi-queue you'd create multiple QPs and spread the MGID binds
> amongst them.

It would be best to bind them to the QP of the local processor (assuming
that the process continues to run on that processor).

What about unicast traffic? One QP gets all unicast?

> Yes, but the downside is that if you rely on the kernel to the group
> join then the HCA will send the packet to user space and the kernel QP.
>
> Some of the weird features in the RDMA CM seem to be for supporting
> this..

The UMCAST flag can stop the kernel from processing the IGMP reply.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
