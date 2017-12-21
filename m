From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: Re: [RFC PATCH rdma-next 02/14] RDMA/core: Enforce requirement to
 hold lists_rwsem semaphore
Date: Thu, 21 Dec 2017 13:23:36 -0700
Message-ID: <20171221202336.GG20015@ziepe.ca>
References: <20171221181748.17126-1-leon@kernel.org>
 <20171221181748.17126-3-leon@kernel.org>
 <20171221191200.GE20015@ziepe.ca>
 <20171221195134.GM2942@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20171221195134.GM2942-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Dec 21, 2017 at 09:51:34PM +0200, Leon Romanovsky wrote:

> This for-rc/for-next thing is new for me. In RDMA, we didn't bother ourselves too
> much and sent everything to for-next.

Okay.. But I think it helps distros if we classify our work a little
more finely, eg anything that merged through the for-rc should be
inspected more closely for distro or stable backporting.

The dependencies are easy enough to deal with if you mark them in the
cover letter.

And I prefer a workflow where the series are smaller, focused on a
topic and more often than in a giant patch bomb once per release. At
least so far anyhow..

Though, I know Doug works quite differently.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
