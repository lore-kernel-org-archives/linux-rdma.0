From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: Re: [PATCH for-rc 6/6] RDMA/vmw_pvrdma: Add UAR SRQ macros in ABI
 header file
Date: Mon, 11 Dec 2017 13:12:24 -0700
Message-ID: <20171211201224.GC27709@ziepe.ca>
References: <20171208185818.GA28514@bryantan-devbox.prom.eng.vmware.com.prom.eng.vmware.com>
 <20171208190317.GA3636@bryantan-devbox.prom.eng.vmware.com.prom.eng.vmware.com>
 <20171208232809.GA23239@ziepe.ca>
 <20171211183554.GB20684@bryantan-devbox.prom.eng.vmware.com.prom.eng.vmware.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20171211183554.GB20684-qXbCdz4EeRo1jLI2hToXVI42T8aCTgcwy4vvyvUx+exJXi8ZT2ovy+oDBWuYMCC/JZORHMmSJCU@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bryan Tan <bryantan-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Mon, Dec 11, 2017 at 10:35:55AM -0800, Bryan Tan wrote:
> On Fri, Dec 08, 2017 at 04:28:09PM -0700, Jason Gunthorpe wrote:
> > On Fri, Dec 08, 2017 at 11:03:26AM -0800, Bryan Tan wrote:
> > > Add the two UAR SRQ macros that are required by the userlevel
> > > library.
> > > 
> > > Fixes: 8b10ba783c9d ("RDMA/vmw_pvrdma: Add shared receive queue support")
> > > Reviewed-by: Adit Ranadive <aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
> > > Reviewed-by: Aditya Sarwade <asarwade-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
> > > Reviewed-by: Jorgen Hansen <jhansen-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
> > > Signed-off-by: Bryan Tan <bryantan-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
> > >  include/uapi/rdma/vmw_pvrdma-abi.h | 2 ++
> > >  1 file changed, 2 insertions(+)
> > > 
> > > diff --git a/include/uapi/rdma/vmw_pvrdma-abi.h b/include/uapi/rdma/vmw_pvrdma-abi.h
> > > index aaa352f..4007cac 100644
> > > +++ b/include/uapi/rdma/vmw_pvrdma-abi.h
> > > @@ -58,6 +58,8 @@
> > >  #define PVRDMA_UAR_CQ_ARM_SOL		BIT(29)		/* Arm solicited bit. */
> > >  #define PVRDMA_UAR_CQ_ARM		BIT(30)		/* Arm bit. */
> > >  #define PVRDMA_UAR_CQ_POLL		BIT(31)		/* Poll bit. */
> > > +#define PVRDMA_UAR_SRQ_OFFSET		8		/* SRQ doorbell. */
> > > +#define PVRDMA_UAR_SRQ_RECV		BIT(30)		/* Recv bit. */
> > 
> > I didn't think BIT() was allowed in uapi headers? Where does it get
> > defined in user space?
> > 
> > Jason
> 
> Looks like we had BIT() defined in userspace.

In rdma-core? Please remove that too :)

> Seems like the rest of the headers just use a bit shift? If that's
> fine I can send out a V2 with the BIT()s removed.

Yes please remove them all

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
