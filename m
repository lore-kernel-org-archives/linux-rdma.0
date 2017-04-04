From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH rdma-next 0/6] Enhanced mode for IPoIB driver
Date: Tue, 4 Apr 2017 13:47:50 -0600
Message-ID: <20170404194750.GC10780@obsidianresearch.com>
References: <20170404191732.31895-1-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170404191732.31895-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Niranjana Vishwanathapura <niranjana.vishwanathapura-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Alex Vesker <valex-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Apr 04, 2017 at 10:17:26PM +0300, Leon Romanovsky wrote:
> Hi Doug,
> 
> This patchset mostly comes from Erez with one exception in the first patch.
> 
> That patch origins from two different commits, first from Niranjana who added
> RDMA netdev interface and second from Erez who added IPoIB support.
> 
> During the preparation to submission, I squashed their commits into one
> and refactored code to allow submission as a standalone topic without creating
> dependecies between different submissions. This caused to change in author line.
> I hope that it doesn't really matter and it won't stop you from merging it.
> 
> Per-your request, I based this patch set on v4.11-rc3.

I didn't dig into the details of the ipoib part, but I think the
core change and the overall look is now what I would expect. modulo
the little comments

It would still have been nicer to isolate the 'default' implementation
so those functions did not touch ipoib_priv, but that is also
something that could be done in a followup..

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
