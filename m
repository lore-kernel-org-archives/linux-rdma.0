From: "tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH -next] IB/ipath: use GFP_ATOMIC under spin lock
Date: Wed, 20 Feb 2013 07:54:18 -0800
Message-ID: <20130220155418.GA23235@htj.dyndns.org>
References: <CAPgLHd-jM-DN1VjvwUh=-s0jLOyqijdn2xHzXhdoxRs0UTGtNg@mail.gmail.com>
 <32E1700B9017364D9B60AED9960492BC0D59FCD6@FMSMSX108.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <32E1700B9017364D9B60AED9960492BC0D59FCD6-AtyAts71sc88Ug9VwtkbtrfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Marciniszyn, Mike" <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Wei Yongjun <weiyj.lk-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, infinipath <infinipath-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "yongjun_wei-zrsr2BFq86L20UzCJQGyNP8+0UxHXcjY@public.gmane.org" <yongjun_wei-zrsr2BFq86L20UzCJQGyNP8+0UxHXcjY@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Feb 20, 2013 at 02:42:28PM +0000, Marciniszyn, Mike wrote:
> > -	ret = idr_alloc(&unit_table, dd, 0, 0, GFP_KERNEL);
> > +	ret = idr_alloc(&unit_table, dd, 0, 0, GFP_ATOMIC);
> 
> GFP_NOWAIT seems to match other use cases introduced by commit cf1f5bb608af6e0d57610c2740a3f69e3568eee3.
> 
> Is that what should be used?

Yes, it should have been GFP_NOWAIT.  Sorry about that.

Thanks.

-- 
tejun
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
