From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: Re: 2x difference between multi-thread and multi-process for same
 number of CTXs
Date: Wed, 24 Jan 2018 10:08:30 -0700
Message-ID: <20180124170830.GD16845@ziepe.ca>
References: <CAJ84Q-aFfcXxaJS5rApcoow6SBjfZAvt71_OKo1ORorXAOZKbw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAJ84Q-aFfcXxaJS5rApcoow6SBjfZAvt71_OKo1ORorXAOZKbw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Rohit Zambre <rzambre-sXc7qaQca9o@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wed, Jan 24, 2018 at 10:22:53AM -0600, Rohit Zambre wrote:

> (1) First, is this a surprising result or is the 2x difference
> actually expected behavior?

Maybe, there are lots of locks in one process, for instance glibc's
malloc has locking - so any memory allocation anywhere in the
applications processing path will cause lock contention. The issue may
have nothing to do with RDMA.

There is also some locking inside the userspace mlx5 driver that may
contend depending on how your process has set things up.

The entire send path is in user space so there is no kernel component
here.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
