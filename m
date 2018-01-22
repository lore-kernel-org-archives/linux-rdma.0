From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH] net/mlx4_en: ensure rx_desc updating reaches HW before
 prod db updating
Date: Mon, 22 Jan 2018 08:47:34 -0700
Message-ID: <20180122154734.GD14372@ziepe.ca>
References: <1515728542-3060-1-git-send-email-jianchao.w.wang@oracle.com>
 <339a7156-9ef1-1f3c-30b8-3cc3558d124e@mellanox.com>
 <1516552998.3478.5.camel@gmail.com>
 <460fca68-f8a8-e3c4-2e60-e90dc0e2f843@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <460fca68-f8a8-e3c4-2e60-e90dc0e2f843@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "jianchao.wang" <jianchao.w.wang@oracle.com>
Cc: Eric Dumazet <eric.dumazet@gmail.com>, Tariq Toukan <tariqt@mellanox.com>, junxiao.bi@oracle.com, netdev@vger.kernel.org, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, Saeed Mahameed <saeedm@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

On Mon, Jan 22, 2018 at 10:40:53AM +0800, jianchao.wang wrote:
> Hi Eric
> 
> On 01/22/2018 12:43 AM, Eric Dumazet wrote:
> > On Sun, 2018-01-21 at 18:24 +0200, Tariq Toukan wrote:
> >>
> >> On 21/01/2018 11:31 AM, Tariq Toukan wrote:
> >>>
> >>>
> >>> On 19/01/2018 5:49 PM, Eric Dumazet wrote:
> >>>> On Fri, 2018-01-19 at 23:16 +0800, jianchao.wang wrote:
> >>>>> Hi Tariq
> >>>>>
> >>>>> Very sad that the crash was reproduced again after applied the patch.
> >>
> >> Memory barriers vary for different Archs, can you please share more 
> >> details regarding arch and repro steps?
> > 
> > Yeah, mlx4 NICs in Google fleet receive trillions of packets per
> > second, and we never noticed an issue.
> > 
> > Although we are using a slightly different driver, using order-0 pages
> > and fast pages recycling.
> > 
> > 
> The driver we use will will set the page reference count to (size of pages)/stride, the
> pages will be freed by networking stack when the reference become zero, and the order-3
> pages maybe allocated soon, this give NIC device a chance to corrupt the pages which have
>  been allocated by others, such as slab.

But it looks like the wmb() is placed when stuffing new rx descriptors
into the device - how can it prevent corruption of pages where
ownership was transfered from device to the host? That sounds more like a
rmb() is missing someplace to me...

(Granted the missing wmb() is a bug, but it may not be fully solving this
 issue??)

Jason
