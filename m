From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: Re: [PATCH v2 rdma-rc] RDMA/restrack: don't use uaccess_kernel()
Date: Fri, 16 Feb 2018 13:00:03 -0700
Message-ID: <20180216200003.GE22739@ziepe.ca>
References: <20180216165919.997D72BB6D@smtp.opengridcomputing.com>
 <20180216172537.GA10123@ziepe.ca>
 <03ee01d3a75b$951f37f0$bf5da7d0$@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <03ee01d3a75b$951f37f0$bf5da7d0$@opengridcomputing.com>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Fri, Feb 16, 2018 at 01:23:10PM -0600, Steve Wise wrote:

> > I took this to for-rc, but when I fixed the XRCD conflict with Leon's
> > patch I ended up retyping it to this - don't really need all rambly
> > boilerplate. Someone should fix the other one too..
> 
> I don't know what you mean by 'rambly boilerplate'?

Just that there is lots of unncessary statements to get to a fairly
simple result...

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
