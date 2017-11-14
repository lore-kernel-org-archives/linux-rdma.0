From: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [RFC PATCH] RDMA/cma: Remove netlink interface of CMA statistics
Date: Tue, 14 Nov 2017 10:51:31 +0200
Message-ID: <CAJ3xEMhfdXz8zQFetjQPfe7HZiCi+N0z6r9XSucuTzQo1--PBg@mail.gmail.com>
References: <20171113144024.26655-1-leon@kernel.org> <20171113192432.GL6918@ziepe.ca>
 <20171114080550.GR18825@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171114080550.GR18825-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Nov 14, 2017 at 10:05 AM, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
>
> On Mon, Nov 13, 2017 at 12:24:32PM -0700, Jason Gunthorpe wrote:
> > On Mon, Nov 13, 2017 at 04:40:24PM +0200, Leon Romanovsky wrote:
> > > From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> > >
> > > CMA statistics were exposed to users through netlink interface long time
> > > ago, but it wasn't exposed using netlink extensibility approach. The
> > > current implementation was based on struct and not attributes.
> > >
> > > Let's remove it, before anyone is actually start to use it and prevents us
> > > to write it properly.
> >
> > You should describe why you think it is safe to remove a uAPI from the
> > kernel in the commit message.. When was it introduced? Why was a uAPI
> > added with no users??
>
> I didn't want to invest time before I actually see that it is possible.
> The purpose of this RFC is to hear feedback and see if anyone cares enough
> about that code.
>
> The code was introduced a long time ago [1]


missing ref

>
> as an attempt to provide netstat-like information. It had simple demo application, which didn't
> work for me



what didn't work exactly?

This is UAPI, if you want to remove it, make sure to provide a good
replacement and see
if/what is the upstream procedure for UAPI changes/removals, I guess
there is such, sending
email to a subsystem list doesn't seem enough to me.


>
> before I started to refactor ib_netlink.
>
> Also latest fixes from Parav in the actual callback implementation support
> my feelings that the kernel part is broken too.
>
> Is it enough to proceed with the submission of actual patch?
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
