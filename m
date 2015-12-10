From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH 22/37] IB/rdmavt: Add queue pair data structure to rdmavt
Date: Thu, 10 Dec 2015 19:12:51 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A82373AAFE87E8@ORSMSX109.amr.corp.intel.com>
References: <20151207204046.8144.18752.stgit@phlsvslse11.ph.intel.com>
 <20151207204433.8144.93461.stgit@phlsvslse11.ph.intel.com>
 <1828884A29C6694DAF28B7E6B8A82373AAFE733B@ORSMSX109.amr.corp.intel.com>
 <20151210190656.GE13412@phlsvsds.ph.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20151210190656.GE13412-W4f6Xiosr+yv7QzWx2u06xL4W9x8LtSr@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Dalessandro, Dennis" <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Marciniszyn, Mike" <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> >> +struct rvt_rwqe {
> >> +	u64 wr_id;
> >> +	u8 num_sge;
> >> +	struct ib_sge sg_list[0];
> >> +};
> >> +
> >> +/*
> >> + * This structure is used to contain the head pointer, tail pointer,
> >> + * and receive work queue entries as a single memory allocation so
> >> + * it can be mmap'ed into user space.
> >> + * Note that the wq array elements are variable size so you can't
> >> + * just index into the array to get the N'th element;
> >> + * use get_rwqe_ptr() instead.
> >
> >Can you add/use an entry_size field?
> 
> I think we could work something like that, however what we have in
> qib/hfi1
> also works.  Any reason we really should change this?

I did not check to see what the drivers do.  Using entry_size is straightforward, may provide the best performance, and can be done in common code, versus adding callbacks to all users. 
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
