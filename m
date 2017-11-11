From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: Re: [PATCH rdma-next v1 1/6] IB/uverbs: Allow CQ moderation with
 modify CQ
Date: Sat, 11 Nov 2017 08:45:57 -0700
Message-ID: <20171111154557.GJ17451@ziepe.ca>
References: <20171029135140.32649-1-leon@kernel.org>
 <20171029135140.32649-2-leon@kernel.org>
 <20171029174345.GC4488@ziepe.ca>
 <20171029182808.GN16127@mtr-leonro.local>
 <20171030144807.GA12392@ziepe.ca>
 <20171030152815.GA16127@mtr-leonro.local>
 <1510341329.3735.19.camel@redhat.com>
 <20171111080943.GT18825@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20171111080943.GT18825-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yonatan Cohen <yonatanc-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Sat, Nov 11, 2017 at 10:09:43AM +0200, Leon Romanovsky wrote:

> I'll fix commit log, rebase and resubmit, but it is not clear to me the
> benefits of changing kernel version of modify_cq and all their users
> to extended version. I think that we better convert them once they
> actually will require it.

We don't need the kernel to follow user space, modify_cq should just
be renamed to set_cq_moderation to avoid confusion and be done with it.

Jason

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
