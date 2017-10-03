From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH for-next 5/8] IB/core: Use __be32 for LIDs in
 opa_is_extended_lid
Date: Tue, 3 Oct 2017 10:00:59 -0600
Message-ID: <20171003160059.GB30753@obsidianresearch.com>
References: <20171002180204.31117.12254.stgit@scvm10.sc.intel.com>
 <20171002180431.31117.33069.stgit@scvm10.sc.intel.com>
 <20171003061657.GA13648@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20171003061657.GA13648-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Don Hiatt <don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Oct 03, 2017 at 09:16:57AM +0300, Leon Romanovsky wrote:

> > -static inline bool opa_is_extended_lid(u32 dlid, u32 slid)
> > +static inline bool opa_is_extended_lid(__be32 dlid, __be32 slid)
> >  {
> >  	if ((be32_to_cpu(dlid) >=
> >  	     be16_to_cpu(IB_MULTICAST_LID_BASE)) ||
> >  	    (be32_to_cpu(slid) >=
> >  	     be16_to_cpu(IB_MULTICAST_LID_BASE)))
> 
> You can drop be32_to_cpu and be16_to_cpu now.
> The dlid is __be32 and IB_MULTICAST_LID_BASE is __be16. The direct
> comparison will work.

It won't order properly for >=, the swap is still needed...

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
