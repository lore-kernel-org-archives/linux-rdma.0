From: "ira.weiny" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [RFC PATCH 3/5] IB/core: Convert cap_ib_mad to core_cap_flags bit mask
Date: Mon, 4 May 2015 18:43:43 -0400
Message-ID: <20150504224342.GD10115@phlsvsds.ph.intel.com>
References: <1430720099-32512-1-git-send-email-ira.weiny@intel.com> <1430720099-32512-4-git-send-email-ira.weiny@intel.com> <20150504184610.GB20586@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150504184610.GB20586-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Michael Wang <yun.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, May 04, 2015 at 12:46:10PM -0600, Jason Gunthorpe wrote:
> On Mon, May 04, 2015 at 02:14:57AM -0400, ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org wrote:
> 
> > Use the new Core Capability bits instead of inferring this support from the
> > protocol.
> 
> Does this really need to be a seperate patch? At least for the
> core_cap_flags parts it makes no sense to change those lines twice

Only to show the progression and for me to test as I went.  I think a squash is
good.  I just was taking my testing slowly to make sure I did not do something
stupid...  ;-)

> 
> > -	props->core_cap_flags = RDMA_CORE_CAP_PROT_IB;
> > +	props->core_cap_flags = RDMA_CORE_CAP_PROT_IB | RDMA_CORE_CAP_IB_MAD;
> 
> Hurm,
> 
> Maybe add some macros to help this out, document the standard that
> the port implements:
> 
> #define RDMA_CORE_PORT_IB_IBA_v1_2 (RDMA_CORE_CAP_PROT_IB | RDMA_CORE_CAP_IB_MAD)
> #define RDMA_CORE_PORT_ROCEE_IBA_v1_2_A15 ..
> #define RDMA_CORE_PORT_ROCEE_IBA_v1_3_A16 ..

Good idea.

> 
> >  static inline int cap_ib_mad(struct ib_device *device, u8 port_num)
> >  {
> > -	return rdma_ib_or_iboe(device, port_num);
> > +	return !!(device->core_cap_flags[port_num] & RDMA_CORE_CAP_IB_MAD);
> 
> 
> 'bool' is OK in the kernel, just use that instead of !! - in fact all of
> thse cap returns should return bool. Michael should fix that in his
> series too.

Michael?

Ira

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
