From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH V2] powerpc/infiniband: Use cache inhibitted and guarded
 mapping on powerpc
Date: Fri, 22 Apr 2016 10:09:27 -0600
Message-ID: <20160422160927.GB12897@obsidianresearch.com>
References: <1461139097-10213-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <1461278876.3135.18.camel@kernel.crashing.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1461278876.3135.18.camel-XVmvHMARGAS8U2dJNN8I7kB+6BGkLq7r@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Benjamin Herrenschmidt <benh-XVmvHMARGAS8U2dJNN8I7kB+6BGkLq7r@public.gmane.org>
Cc: "Aneesh Kumar K.V" <aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, paulus-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org, mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org, linuxppc-dev-uLR06cmDAlY/bJ5BZ2RsiQ@public.gmane.org, Mike Marciniszyn <infinipath-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Fri, Apr 22, 2016 at 08:47:56AM +1000, Benjamin Herrenschmidt wrote:
> On Wed, 2016-04-20 at 03:58 -0400, Aneesh Kumar K.V wrote:
> > The driver was requesting for a writethrough mapping. But with thoses
> > flags we will end up with a SAO mapping because we now have memory
> > conherence always enabled. ie, the existing mapping will end up with
> > a WIMG value 0b1110 which is Strong Access Order.
> > 
> > Update this to use cache inhibitted guarded mapping
> 
> Why guarded ? If it's performance sensitive (and the driver has
> appropriate barriers where needed), you will get write combining
> without guarded, you won't with it.

This driver uses uncached write combining on x86

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
