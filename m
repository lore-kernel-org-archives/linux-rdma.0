From: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH 2/8] bnxt_re: Convert from init_context to alloc_context
Date: Wed, 10 Jan 2018 10:36:24 -0700
Message-ID: <20180110173624.GF4776@mellanox.com>
References: <20180108212632.5183-1-jgg@ziepe.ca>
 <20180108212632.5183-3-jgg@ziepe.ca>
 <CANjDDBjwmtO2aOtY5NCObrU_VJVmHjw=fdJOk_VvfZx+8+4Ejw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CANjDDBjwmtO2aOtY5NCObrU_VJVmHjw=fdJOk_VvfZx+8+4Ejw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Jan 10, 2018 at 11:23:16AM +0530, Devesh Sharma wrote:

> Looks good, will test and comeback if there are any failures seen.
> Reveiwed-By: Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>

Thanks!

I didn't find any bugs when I first tested it, so I have optimisim
that the compiler static analysis is containing most of the mess :)

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
