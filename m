From: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Subject: Re: IPoIB multiqueue support?
Date: Tue, 11 May 2010 17:11:22 -0500 (CDT)
Message-ID: <alpine.DEB.2.00.1005111711050.10091@router.home>
References: <alpine.DEB.2.00.1005101607580.17916@router.home> <adawrvbxxyd.fsf@roland-alpha.cisco.com> <alpine.DEB.2.00.1005110851530.1500@router.home> <adawrvawhyc.fsf@roland-alpha.cisco.com> <alpine.DEB.2.00.1005111516500.1500@router.home>
 <20100511204358.GQ15969@obsidianresearch.com> <alpine.DEB.2.00.1005111548450.8388@router.home> <20100511205808.GS15969@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100511205808.GS15969-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Tue, 11 May 2010, Jason Gunthorpe wrote:

> > The UMCAST flag can stop the kernel from processing the IGMP reply.
>
> I'm not talking about IGMP, but the IB version of IGMP, the kernel
> joins the group in IB land and also attaches the IPOIB QP. This can
> all be faked out in userspace, but it isn't entirely straightforward.

Yes vendors use the UMCAST flag to avoid this.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
