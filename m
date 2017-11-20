From: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [RFC PATCH] RDMA/cma: Remove netlink interface of CMA statistics
Date: Tue, 21 Nov 2017 00:14:01 +0200
Message-ID: <CAJ3xEMhKEXB3-RJFyEh2dE8dr6OOpQPZ2rJ14MoKQ-2sB0GTXg@mail.gmail.com>
References: <20171113192432.GL6918@ziepe.ca> <20171114080550.GR18825@mtr-leonro.local>
 <CAJ3xEMhfdXz8zQFetjQPfe7HZiCi+N0z6r9XSucuTzQo1--PBg@mail.gmail.com>
 <20171114095605.GU18825@mtr-leonro.local> <CAJ3xEMhM0xfNxRU+37oWKq_w=MGtE3sUXy38bARgX5-3G9zhvw@mail.gmail.com>
 <20171114173516.GZ18825@mtr-leonro.local> <CAJ3xEMgJJX0FXMK9Rj=kGmNGkF14tBe03zfwzKHnEEp=cEDVxw@mail.gmail.com>
 <20171115052926.GN18825@mtr-leonro.local> <CAJ3xEMjrTvY+hq=1Q3tmPk_QiZtpO8dLMmCtrPjJgbtOeiU=6Q@mail.gmail.com>
 <CAJ3xEMjst4EaFYfUVwqiOzsh5pVPj85joPYsGsap8p6tQYUwew@mail.gmail.com> <20171120194152.GN29075@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171120194152.GN29075-uk2M96/98Pc@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Nov 20, 2017 at 9:41 PM, Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org> wrote:

> Well, I would like to know the issues as well, as I've already said I
> think they should be described in the commit message.

> But also, at the RFC stage the onus is on other people, particularly
> people that want to keep the feature, to explain where it is being
> used and why..

we did it to allow user space track rdma-cm connections through the rdma
subsystem netlink infra-structure, e.g one can come up with netstat like
reporting of rdma listeners and connections, this is it!

> We need to decide if we drop the RFC and fix the implementation, apply
> the the RFC, or add a deprecation printk warning, or something..

right. To my opinion, if there are issues in the implementation, lets fix them,
I don't see why remove this implementation and replace it with a new one
that does the same thing.

> Please try to be productive here and concentrate on adding information
> and not nit-picking the process! We all know removing a uapi is a big
> deal.

Re usage I provided what I know.

When a patch is sent  to remove code "which has problems" and the author
doesn't provide any information on the nature nor the details of the problems
after being asked three times - what this has to do with nit picking
or processes?
it's something totally different, isn't that?

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
