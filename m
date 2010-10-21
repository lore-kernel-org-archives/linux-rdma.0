From: Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCHv10 08/12] mlx4: Add support for IBoE - address
 resolution
Date: Fri, 22 Oct 2010 00:54:19 +0200
Message-ID: <20101021225419.GB6367@mtldesk30>
References: <20100826141851.GI8795@mtldesk30>
 <adazku85dcf.fsf@cisco.com>
 <20101021072703.GA1912@mtldesk30>
 <adavd4v8gk4.fsf@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <adavd4v8gk4.fsf-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: RDMA list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Oct 21, 2010 at 12:57:31PM -0700, Roland Dreier wrote:
> Also I don't see anywhere that the global functions
> 
>  > +int eth_to_ib_width(int w)
>  > +int eth_to_ib_speed(int s)
> 
> are called?
> 

Right. Let's remove them.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
