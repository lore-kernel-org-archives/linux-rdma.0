From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: Re: [PATCH v3 for-next 2/2] RDMA/hns: Fix alignment problem of the
 doorbell
Date: Fri, 29 Dec 2017 10:47:17 -0700
Message-ID: <20171229174717.GB6513@ziepe.ca>
References: <1514470683-6972-1-git-send-email-liuyixian@huawei.com>
 <1514470683-6972-3-git-send-email-liuyixian@huawei.com>
 <20171228155712.GU25436@ziepe.ca>
 <aa43b6d4-bb56-ed2f-33c9-c047e27a0a59@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <aa43b6d4-bb56-ed2f-33c9-c047e27a0a59-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Liuyixian (Eason)" <liuyixian-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Fri, Dec 29, 2017 at 06:29:35PM +0800, Liuyixian (Eason) wrote:
> 
> 
> On 2017/12/28 23:57, Jason Gunthorpe wrote:
> > 
> > On Thu, Dec 28, 2017 at 10:18:03PM +0800, Yixian Liu wrote:
> > 
> >> -	hns_roce_write64_k(doorbell, eq->doorbell);
> >> +	hns_roce_write64_k(db.doorbell, eq->doorbell);
> > 
> > You need to pass &db to hns_roce_write64_k and have it deref the 64
> > bit value using the union. The point here is to eliminate the cast inside
> > hns_roce_write64_k.
> > 
> > Jason
> 
> Hi Jason,
> 
> I know exactly what you mean, but the interface also called by lots of
> other places in our driver, I plan to leave this revision in future
> work.

Yes, exactly, and they all have the same problem, right?

The point of my original note was for you to fix the systemic problem
not just the single location I used as an example.
 
> With db.doorbell input, we could get the correct value (64 bit) w/o
> *(u64 *).  Thus, this patch will not be updated in patch v4.

Let us drop it then, resend it when you fix them all.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
