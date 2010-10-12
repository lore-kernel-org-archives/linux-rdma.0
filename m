From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] mlx4: Limit num of fast reg WRs
Date: Tue, 12 Oct 2010 13:37:37 -0700
Message-ID: <adad3rf171q.fsf@cisco.com>
References: <20101007142416.GA11518@mtldesk30>
	<AANLkTinKiBHOT2sSA+_s5CGhqC8nEoDTp2_pGmo6MrQp@mail.gmail.com>
	<20101012081955.GB1617@mtldesk30>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20101012081955.GB1617@mtldesk30> (Eli Cohen's message of "Tue,
	12 Oct 2010 10:19:55 +0200")
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, RDMA list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

 > After I posted this patch, I was told that there is yet another
 > constraint on the page list: The buffer containing the list must not
 > cross a page boundary. So I was thinking what is the best way to deal
 > with this. One way is to always allocate a whole page and map it using
 > dma_map_page(page, DMA_TO_DEVICE), something like this (not a complete
 > patch, just the idea).

Is there any chance of the dma_alloc_coherent() in the current code
allocating memory that crosses a page boundary?

 - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
