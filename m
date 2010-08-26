From: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCHv10 0/11] IBoE support to Infiniband
Date: Thu, 26 Aug 2010 14:16:44 -0500 (CDT)
Message-ID: <alpine.DEB.2.00.1008261415420.21466@router.home>
References: <20100826141659.GA8795@mtldesk30>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100826141659.GA8795@mtldesk30>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, RDMA list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, 26 Aug 2010, Eli Cohen wrote:

> With these patches, IBoE multicast frames may be broadcast as there is
> currently no use of a L2 multicast group membership protocol.

May be? They are broadcast because there is no IGMP like support? Any
hopes of multicast support soon?

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
