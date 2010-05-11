From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: IPoIB multiqueue support?
Date: Tue, 11 May 2010 14:58:08 -0600
Message-ID: <20100511205808.GS15969@obsidianresearch.com>
References: <alpine.DEB.2.00.1005101607580.17916@router.home> <adawrvbxxyd.fsf@roland-alpha.cisco.com> <alpine.DEB.2.00.1005110851530.1500@router.home> <adawrvawhyc.fsf@roland-alpha.cisco.com> <alpine.DEB.2.00.1005111516500.1500@router.home> <20100511204358.GQ15969@obsidianresearch.com> <alpine.DEB.2.00.1005111548450.8388@router.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1005111548450.8388-sBS69tsa9Uj/9pzu0YdTqQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Cc: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Tue, May 11, 2010 at 03:50:35PM -0500, Christoph Lameter wrote:

> > To go multi-queue you'd create multiple QPs and spread the MGID binds
> > amongst them.
> 
> It would be best to bind them to the QP of the local processor (assuming
> that the process continues to run on that processor).

Yes
 
> What about unicast traffic? One QP gets all unicast?

IIRC, there are some HCA-specific features for spreading traffic
amongst QPs using a hash of the IP/TCP/UDP headers. I don't know
anything about them though.

Within the standard IB functionality the best you could do is to
create a wack of QPs and then return different QPNs in your ARP
replies. Though this is very limited and probably not worth doing.
 
> > Yes, but the downside is that if you rely on the kernel to the group
> > join then the HCA will send the packet to user space and the kernel QP.
> >
> > Some of the weird features in the RDMA CM seem to be for supporting
> > this..
> 
> The UMCAST flag can stop the kernel from processing the IGMP reply.

I'm not talking about IGMP, but the IB version of IGMP, the kernel
joins the group in IB land and also attaches the IPOIB QP. This can
all be faked out in userspace, but it isn't entirely straightforward.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
