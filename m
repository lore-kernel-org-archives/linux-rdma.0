From: Alan Cook <acook-osxm6dDZNBBZx8iatJs59jGjJy/sRE9J@public.gmane.org>
Subject: Re: Converting from RC to UC
Date: Mon, 14 Mar 2011 01:08:40 +0000 (UTC)
Message-ID: <loom.20110314T020520-335@post.gmane.org>
References: <loom.20110311T192125-878@post.gmane.org>	<AANLkTimM0PDiWuHFJfn3s-JVEKWHVVfL4+2Kcc4+G5C7@mail.gmail.com> <loom.20110311T224601-402@post.gmane.org> <4D7C94E8.6070906@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Or Gerlitz <ogerlitz@...> writes:

> 
> Alan, you haven't specified if you app is user space or kernel space 
> based,  I assume the former, I believe that it either just works or can 
> be just made to work... e.g maybe a minor error on your side, or maybe 
> something small to change/complete on the rdma-cm side...
> 
> I'm copying the maintainer of the kernel rdma-cm and librdmacm, Sean - 
> should there any problem for librdmacm consumers to use UC at their apps?
> 
> Or.
> 

My application is running in user space, but could run in kernel space if need
be.  I would assume that the error is on my side, but I am unable to find any
documentation on setting up a UC service as opposed to an RC service.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
