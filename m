From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: Re: [PATCH v1 rdma-core 1/2] bnxt_re/lib: fix the memory barrier
 call during poll-cq
Date: Fri, 10 Nov 2017 10:30:46 -0700
Message-ID: <20171110173046.GD17451@ziepe.ca>
References: <1510225840-20034-1-git-send-email-devesh.sharma@broadcom.com>
 <1510225840-20034-2-git-send-email-devesh.sharma@broadcom.com>
 <20171109180521.GM7063@ziepe.ca>
 <CANjDDBggw1wKuyh6OobsxPpe1U7esnFgD9evCoTYDV2FvnjTTQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CANjDDBggw1wKuyh6OobsxPpe1U7esnFgD9evCoTYDV2FvnjTTQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, Nov 10, 2017 at 05:01:42PM +0530, Devesh Sharma wrote:

> > And the the kernel version of this should be using READ_ONCE()
> 
> Okay, we will fix this in our driver. So, READ_ONCE(CQE.valid) should
> be enough right?

Yes, I think so.

> > In user space we should probably create a
> >
> >  udma_from_device_read_once(x)
> >
> > That incorporates the barrier and the 'access_once' semantics..
> 
> Do you want us to pull all the defined in kernel space compiler.h
> verbitum to rdma-core

No.. kernel is using a quite different approach. We would want to use
C11 atomic_read in user space for most architectures.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
