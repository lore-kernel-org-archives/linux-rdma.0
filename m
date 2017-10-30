From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: Re: 4.13 ib_mthca NULL pointer dereference with OpenSM
Date: Mon, 30 Oct 2017 17:01:56 -0600
Message-ID: <20171030230156.GA4081@ziepe.ca>
References: <CALpBJjoMLCqzVe5yKp4wCX-X-sH+=zv1QZfMvOWh2Ukh3c2LFg@mail.gmail.com>
 <20171029191114.GO16127@mtr-leonro.local>
 <CALpBJjoJpgR1QB-gzRJLOjGtjK4T2H4EbG1-R+ndodvznWkgwA@mail.gmail.com>
 <20171030071956.GU16127@mtr-leonro.local>
 <CALpBJjqWrXu3b12EG2-AWKwKs9v2q5pTf11rXSy04C-5dGta6A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CALpBJjqWrXu3b12EG2-AWKwKs9v2q5pTf11rXSy04C-5dGta6A-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chris Blake <chrisrblake93-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Oct 30, 2017 at 01:39:42PM -0500, Chris Blake wrote:
> On Mon, Oct 30, 2017 at 2:19 AM, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> >
> > Can you please try to set CONFIG_SECURITY_INFINIBAND=n and see if it
> > helps?
> >
> > Thanks
> >
> 
> Hello Leon,
> 
> I went ahead and set CONFIG_SECURITY_INFINIBAND=n in my kernel, and so
> far the issue seems resolved. I will run this for a week or so and
> will get back to you, but things are looking promising. :)

I certainly don't expect this setting to break any drivers..

Parav?

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
