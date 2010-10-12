From: Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH] mlx4: Limit num of fast reg WRs
Date: Tue, 12 Oct 2010 22:44:32 +0200
Message-ID: <20101012204432.GE1617@mtldesk30>
References: <20101007142416.GA11518@mtldesk30>
 <AANLkTinKiBHOT2sSA+_s5CGhqC8nEoDTp2_pGmo6MrQp@mail.gmail.com>
 <20101012081955.GB1617@mtldesk30>
 <adad3rf171q.fsf@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <adad3rf171q.fsf-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, RDMA list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Oct 12, 2010 at 01:37:37PM -0700, Roland Dreier wrote:
> 
> Is there any chance of the dma_alloc_coherent() in the current code
> allocating memory that crosses a page boundary?
> 

You mean that the allocation is aligned at least to its size? I could
not find any commitment to this anywhere.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
