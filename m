From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 21/37] IB/rdmavt: Move MR datastructures into rvt
Date: Mon, 14 Dec 2015 11:07:56 -0500
Message-ID: <20151214160755.GA23833@phlsvsds.ph.intel.com>
References: <20151207204046.8144.18752.stgit@phlsvslse11.ph.intel.com> <20151207204429.8144.62688.stgit@phlsvslse11.ph.intel.com> <1828884A29C6694DAF28B7E6B8A82373AAFE7322@ORSMSX109.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1828884A29C6694DAF28B7E6B8A82373AAFE7322-P5GAC/sN6hkd3b2yrw5b5LfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Marciniszyn, Mike" <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Luick, Dean" <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Dec 07, 2015 at 03:39:17PM -0600, Hefty, Sean wrote:
>> +struct rvt_mregion {
>> +	struct ib_pd *pd;       /* shares refcnt of ibmr.pd */
>> +	u64 user_base;          /* User's address for this region */
>> +	u64 iova;               /* IB start address of this region */
>> +	size_t length;
>> +	u32 lkey;
>> +	u32 offset;             /* offset (bytes) to start of region */
>> +	int access_flags;
>> +	u32 max_segs;           /* number of rvt_segs in all the arrays */
>> +	u32 mapsz;              /* size of the map array */
>> +	u8  page_shift;         /* 0 - non unform/non powerof2 sizes */
>> +	u8  lkey_published;     /* in global table */
>
>Without looking ahead in the patch series, won't the access_flags indicate this?

I think it could. However to me this is more clear. When we allocate an lkey 
we set this, when it's freed we clear it, we check this flag in the free 
routine to decide if we should actually free it.

-Denny
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
