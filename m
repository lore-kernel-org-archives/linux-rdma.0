From: Leon Romanovsky <leon-2ukJVAZIZ/Y@public.gmane.org>
Subject: Re: [PATCH 00/16] IB/hfi1: Add a page pinning cache for PSM sdma
Date: Mon, 14 Mar 2016 14:27:52 +0200
Message-ID: <20160314122752.GC26456@leon.nu>
References: <20160308191210.30542.91885.stgit@scvm10.sc.intel.com>
 <CAJ3xEMj8gz6Xw1bqA677fC8=U2ktLQ6b4W20SeNrztN7u6UKZg@mail.gmail.com>
 <20160309002157.GA20105@phlsvsds.ph.intel.com>
 <20160309050731.GM13396@leon.nu>
 <20160309192109.GB15031@phlsvsds.ph.intel.com>
 <20160310045609.GC1977@leon.nu>
 <20160314070951.GB26456@leon.nu>
 <20160314120152.GA30838@phlsvsds.ph.intel.com>
Reply-To: leon-2ukJVAZIZ/Y@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160314120152.GA30838-W4f6Xiosr+yv7QzWx2u06xL4W9x8LtSr@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Mar 14, 2016 at 08:01:53AM -0400, Dennis Dalessandro wrote:
> On Mon, Mar 14, 2016 at 09:09:51AM +0200, Leon Romanovsky wrote:
> >Hi Doug,
> >I saw that you picked these patches and it is now in your github
> >repository. Since the original author probably missed my and Or's questions, It
> >will be great if you can share with us your technical view on the topic.
> >
> >In addition to my question regarding appropriate layer - IB/core. MM, I see that
> >it can be natively implemented in user-space layer too.
> 
> Leon,
> 
> The original author did not miss your questions. When I say "we" or "our"
> you can be assured that includes the original author.
> 
> Our position continues to be that this is best located in the hfi1 driver.
> If something else comes along that can make use of the same/similar
> functionality we can then move it to the core or elsewhere, once we have a
> better understanding of the use cases and how best to generalize the code.

Denny,

There are no doubts that your understanding of this part of the code is
superior to mine. It causes me to ask you and/or Doug to share
your knowledge and give to the community the TECHNICAL reasons
why you placed the cache mechanism logic into the driver and not in
other more appropriate places.

Thanks

> 
> -Denny
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
