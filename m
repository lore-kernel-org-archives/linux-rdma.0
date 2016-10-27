From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH] rdma UAPI: Use __kernel_sockaddr_storage
Date: Thu, 27 Oct 2016 11:55:31 -0600
Message-ID: <20161027175531.GA22024@obsidianresearch.com>
References: <1477587077-15410-1-git-send-email-jgunthorpe@obsidianresearch.com>
 <028b01d2307a$41454dd0$c3cfe970$@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <028b01d2307a$41454dd0$c3cfe970$@opengridcomputing.com>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: 'Doug Ledford' <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, Oct 27, 2016 at 12:47:58PM -0500, Steve Wise wrote:
> > 
> > The kernel side is #ifdef'd to this type, and the UAPI header
> > should use it directly. It has slightly different alignment
> > requirments from the usual user space version.
> > 
> > Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
> 
> If the alignment changed, does this break binary compatibility?  IE a new
> librdmacm with an old rdma_ucm.ko? 

The kernel side already uses __kernel_sockaddr_storage (via a
#define), so there is no possible break to binary compatibility.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
