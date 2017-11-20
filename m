From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: Re: [RFC PATCH] RDMA/cma: Remove netlink interface of CMA statistics
Date: Mon, 20 Nov 2017 12:41:52 -0700
Message-ID: <20171120194152.GN29075@ziepe.ca>
References: <20171113192432.GL6918@ziepe.ca>
 <20171114080550.GR18825@mtr-leonro.local>
 <CAJ3xEMhfdXz8zQFetjQPfe7HZiCi+N0z6r9XSucuTzQo1--PBg@mail.gmail.com>
 <20171114095605.GU18825@mtr-leonro.local>
 <CAJ3xEMhM0xfNxRU+37oWKq_w=MGtE3sUXy38bARgX5-3G9zhvw@mail.gmail.com>
 <20171114173516.GZ18825@mtr-leonro.local>
 <CAJ3xEMgJJX0FXMK9Rj=kGmNGkF14tBe03zfwzKHnEEp=cEDVxw@mail.gmail.com>
 <20171115052926.GN18825@mtr-leonro.local>
 <CAJ3xEMjrTvY+hq=1Q3tmPk_QiZtpO8dLMmCtrPjJgbtOeiU=6Q@mail.gmail.com>
 <CAJ3xEMjst4EaFYfUVwqiOzsh5pVPj85joPYsGsap8p6tQYUwew@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAJ3xEMjst4EaFYfUVwqiOzsh5pVPj85joPYsGsap8p6tQYUwew-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Nov 16, 2017 at 01:53:03PM +0200, Or Gerlitz wrote:
> On Wed, Nov 15, 2017 at 9:50 AM, Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> 
> > But before that, you ignored my question asking what is broken in the
> > current code, please don't.
> 
> > You can't come to someone's code say it's broken without providing the data
> > and ask to revert it.
> 
> Doug, Jason,
> 
> I have asked multiple times what is broken in the cma netlink code and
> no answer.
> 
> Please suggest how to proceed with this patch, there's a claim there
> that the code
> which is removed has issues but no data is given.

Well, I would like to know the issues as well, as I've already said I
think they should be described in the commit message.

But also, at the RFC stage the onus is on other people, particularly
people that want to keep the feature, to explain where it is being
used and why..

We need to decide if we drop the RFC and fix the implementation, apply
the the RFC, or add a deprecation printk warning, or something..

Please try to be productive here and concentrate on adding information
and not nit-picking the process! We all know removing a uapi is a big
deal.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
