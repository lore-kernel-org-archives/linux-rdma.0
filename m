From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH for-next 5/8] IB/core: Use __be32 for LIDs in
 opa_is_extended_lid
Date: Tue, 3 Oct 2017 17:05:06 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A82373AB19A6C6@ORSMSX109.amr.corp.intel.com>
References: <20171002180204.31117.12254.stgit@scvm10.sc.intel.com>
 <20171002180431.31117.33069.stgit@scvm10.sc.intel.com>
 <20171003061657.GA13648@mtr-leonro.local>
 <20171003160059.GB30753@obsidianresearch.com>
 <20171003170140.GD25829@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171003170140.GD25829-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: "Dalessandro, Dennis" <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Hiatt, Don" <don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Marciniszyn, Mike" <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> > > >  	if ((be32_to_cpu(dlid) >=
> > > >  	     be16_to_cpu(IB_MULTICAST_LID_BASE)) ||
> > > >  	    (be32_to_cpu(slid) >=
> > > >  	     be16_to_cpu(IB_MULTICAST_LID_BASE)))
> > >
> > > You can drop be32_to_cpu and be16_to_cpu now.
> > > The dlid is __be32 and IB_MULTICAST_LID_BASE is __be16. The direct
> > > comparison will work.
> >
> > It won't order properly for >=, the swap is still needed...
> 
> Jason,
> Do you have reference for that?
> 
> I tried to find any information about comparison of values from one
> endianess on machine with another endianess and didn't find anything
> relevant.

The bytes are out of order, so the comparisons won't work.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
