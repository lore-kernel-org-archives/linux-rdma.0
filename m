From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: Re: [PATCH for-next 2/2] RDMA/hns: Fix alignment problem of the
 doorbell
Date: Wed, 27 Dec 2017 09:44:07 -0700
Message-ID: <20171227164407.GB25436@ziepe.ca>
References: <1514209039-9388-1-git-send-email-liuyixian@huawei.com>
 <1514209039-9388-3-git-send-email-liuyixian@huawei.com>
 <20171226081526.GB10734@mtr-leonro.local>
 <6f657295-ab91-a940-c1d8-8d85dcedb4ea@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <6f657295-ab91-a940-c1d8-8d85dcedb4ea-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Liuyixian (Eason)" <liuyixian-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wed, Dec 27, 2017 at 06:01:25PM +0800, Liuyixian (Eason) wrote:
> 
> 
> On 2017/12/26 16:15, Leon Romanovsky wrote:
> > On Mon, Dec 25, 2017 at 09:37:19PM +0800, Yixian Liu wrote:
> >> The array defined for doorbell is not guaranteed to be 64 bit
> >> aligned while we write it to the hardware with 64 bit
> >> alignment required.
> >>
> >> This patch fixes this problem by defining a union for doorbell
> >> to make sure it 64 bit alignment.
> > 
> > Are you sure that it gives you alignment?
> > The macros ALIGN/PTR_ALIGN are usually used for that.
> 
> Hi Leon,
> 
> I have considered your doubt combined with Jason's previous comment.
> With a union defined with u64 member and assign the wanted value to it,
> then we can deref *(u64 *)doorbell for the correct value.
> 
> In this patch set, the assignment is missed.
> Thanks for your comment and I will fix it in v2.

You are not supposed to assign to doorbell64, you are supposed to read
from it inside hns_roce_write64_k instead of using a case.

The compiler guarentees it can read from all union members without
causing an alignment fault, which is all we want here. It does not
guarantee that the union is aligned to anything particular.

The v2 patch is very confusing.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
