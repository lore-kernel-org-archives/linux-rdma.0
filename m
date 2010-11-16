From: Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH] mlx4: properly mask MGM entry members count
Date: Tue, 16 Nov 2010 20:07:32 +0200
Message-ID: <20101116180732.GB29132@mtldesk30>
References: <20101115140829.GA20355@mtldesk30>
 <ada62vxl046.fsf@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <ada62vxl046.fsf-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: RDMA list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Nov 16, 2010 at 08:11:21AM -0800, Roland Dreier wrote:
>  > The members_count field size is 24 bits so mask it properly when reading it.
> 
> what's the impact of this?  Does this actually fix something seen in
> practice or is it just found by inspection?
> 

We need this patch as the MS byte is used now to encode the protocol
of the multicast address. I need to resend since the patch is missing
handling in the dettach function.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
