From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH 1/5] IB/user_mad: Fix bug in ib_umad_remove_one when
 rdma_cap_ib_mad implementation changed
Date: Tue, 12 May 2015 13:15:05 -0600
Message-ID: <20150512191505.GB3503@obsidianresearch.com>
References: <1431395218-27693-1-git-send-email-ira.weiny@intel.com>
 <1431395218-27693-2-git-send-email-ira.weiny@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1431395218-27693-2-git-send-email-ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Mon, May 11, 2015 at 09:46:54PM -0400, ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org wrote:
> From: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> 
> The addition of the rdma_cap_ib_mad is technically broken in ib_umad_remove_one
> because the loop "i" value is not a port value.
> 
> This bug resulted in the ib_umad failing to properly remove its resources when
> the core capability functions were converted to bit fields.
> 
> NOTE: This original patch did not result in broken behavior on its own.  It was
> only an issue when the implementation of rdma_cap_ib_mad was changed.

Didn't cause a bug, but is certainly wrong..

>+  		if (rdma_cap_ib_mad(device, i))
>-  		if (rdma_cap_ib_mad(device, i + start_port(device)))

Is alot simpler. At the very least, use start_port/end_port to compute
those ranges...

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
