From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 22/37] IB/rdmavt: Add queue pair data structure to rdmavt
Date: Mon, 14 Dec 2015 11:29:19 -0500
Message-ID: <20151214162918.GB23833@phlsvsds.ph.intel.com>
References: <20151207204046.8144.18752.stgit@phlsvslse11.ph.intel.com> <20151207204433.8144.93461.stgit@phlsvslse11.ph.intel.com> <1828884A29C6694DAF28B7E6B8A82373AAFE733B@ORSMSX109.amr.corp.intel.com> <20151210190656.GE13412@phlsvsds.ph.intel.com> <1828884A29C6694DAF28B7E6B8A82373AAFE87E8@ORSMSX109.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1828884A29C6694DAF28B7E6B8A82373AAFE87E8-P5GAC/sN6hkd3b2yrw5b5LfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Marciniszyn, Mike" <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Dec 10, 2015 at 01:12:51PM -0600, Hefty, Sean wrote:
>> >> +struct rvt_rwqe {
>> >> +	u64 wr_id;
>> >> +	u8 num_sge;
>> >> +	struct ib_sge sg_list[0];
>> >> +};
>> >> +
>> >> +/*
>> >> + * This structure is used to contain the head pointer, tail pointer,
>> >> + * and receive work queue entries as a single memory allocation so
>> >> + * it can be mmap'ed into user space.
>> >> + * Note that the wq array elements are variable size so you can't
>> >> + * just index into the array to get the N'th element;
>> >> + * use get_rwqe_ptr() instead.
>> >
>> >Can you add/use an entry_size field?
>> 
>> I think we could work something like that, however what we have in
>> qib/hfi1
>> also works.  Any reason we really should change this?
>
>I did not check to see what the drivers do.  Using entry_size is 
>straightforward, may provide the best performance, and can be done in 
>common code, versus adding callbacks to all users. 

Are you concerned that we have to do something different in each driver? If 
so, I do plan to move get_rwqe_ptr to rdmavt in a later patch.  It won't be 
part of the drivers any more.

I kind of like what we have for get_rwqe_ptr, it illustrates how we are 
fishing out the pointer. I'll take another look at it though for the coming 
patch, it could save us from doing a bit of math on the fly.

-Denny
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
