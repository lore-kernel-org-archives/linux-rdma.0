From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: Re: [PATCH for-rc] IB/hfi: Only read capability registers if the
 capability exists
Date: Fri, 22 Dec 2017 09:53:52 -0700
Message-ID: <20171222165352.GD30884@ziepe.ca>
References: <20171222164717.31842.12554.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20171222164717.31842.12554.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Michael J. Ruhl" <michael.j.ruhl-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Fri, Dec 22, 2017 at 08:47:20AM -0800, Dennis Dalessandro wrote:
> From: Michael J. Ruhl <michael.j.ruhl-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> 
> During driver init, various registers are saved to allow restoration
> after an FLR or gen3 bump.  Some of these registers are not available
> in some circumstances (i.e. Virtual machines).
> 
> Delete unnecessary register read/write, and only access register if
> the capability exists.
> 
> Cc: <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org> # 4.14.x
> Fixes: a618b7e40af2 ("IB/hfi1: Move saving PCI values to a separate function")
> Reviewed-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Michael J. Ruhl <michael.j.ruhl-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>  drivers/infiniband/hw/hfi1/hfi.h  |    1 -
>  drivers/infiniband/hw/hfi1/pcie.c |   30 ++++++++++++------------------
>  2 files changed, 12 insertions(+), 19 deletions(-)

Since we are getting late in the RC cycle can you help me clarify the
user visible bug here? No need to resend

I'm guessing when hfi1 is used in a virtual machine with passthrough
(SRIOV?) it fails in ?? way?

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
