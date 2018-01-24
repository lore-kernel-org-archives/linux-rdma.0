From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: Re: 2x difference between multi-thread and multi-process for same
 number of CTXs
Date: Wed, 24 Jan 2018 15:22:40 -0700
Message-ID: <20180124222240.GA10706@ziepe.ca>
References: <CAJ84Q-aFfcXxaJS5rApcoow6SBjfZAvt71_OKo1ORorXAOZKbw@mail.gmail.com>
 <20180124170830.GD16845@ziepe.ca>
 <CAJ84Q-aMW7PXFFuODm6RN=SO342=tJ4_eSJ2TB0b8DLrxgwtGQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAJ84Q-aMW7PXFFuODm6RN=SO342=tJ4_eSJ2TB0b8DLrxgwtGQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Rohit Zambre <rzambre-sXc7qaQca9o@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wed, Jan 24, 2018 at 02:53:13PM -0600, Rohit Zambre wrote:

> Yes, that's correct. My concern was that during resource creation, the
> kernel was maybe sharing some resource for a process or that some sort
> of multiplexing was occurring to hardware contexts through control
> groups. Is it safe for me to conclude that separate, independent
> contexts/bfregs are being assigned when a process calls
> ibv_open_device multiple times?

I believe that is true.

There is no obvious point of contention if you use multiple contexts
and set the single threading flag..

Is it possible your benchmark is actually working differently in the
two modes? In a more broad sense, like the cluster network traffic
pattern is detrimental in the thread case for some reason?

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
