From: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: Kernel v4.16 / v4.17 SRP and SRPT patches
Date: Wed, 10 Jan 2018 13:52:43 -0700
Message-ID: <20180110205243.GP4776@mellanox.com>
References: <1515529869.3919.4.camel@redhat.com>
 <1515531079.2721.26.camel@wdc.com>
 <1515531652.26021.1.camel@redhat.com>
 <1515537614.26021.3.camel@redhat.com>
 <1515591723.26021.6.camel@redhat.com>
 <20180110182648.GI4518@ziepe.ca>
 <1515609623.2745.20.camel@wdc.com>
 <1515610750.10153.1.camel@redhat.com>
 <20180110191510.GK4518@ziepe.ca>
 <1515612639.10153.3.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1515612639.10153.3.camel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Laurence Oberman <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Bart Van Assche <Bart.VanAssche-Sjgp3cTcYWE@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "ddutile-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <ddutile-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Jan 10, 2018 at 02:30:39PM -0500, Laurence Oberman wrote:

> Just to be clear, I have posted two types of stack traces, one where I
> panic the other here above where I am not panicking.

Guessing it is just luck which you hit.. Random corrupted memory and
all..

> This is not any special type of test. I booted the kernel, mapped
> the SRP devices from the target server and proceeded to shutdown the
> client with shutdown -r now.  This is part of my holistic test I
> always do against new patches in Bart's tree.  I start with reboots,
> them rmmod's etc. before I go on to perform I/O against the LUNS
> from the target.

Well, your shtudown is triggering the mlx driver shutdown code,
then it looks like the SRP stuff gets cleaned up? That certainly is
getting a bit exciting code wise

I see there have been some changes in the mlx5 shutdown handling
recently..

As an experiment comment out the '.shutdown = shutdown' in
drivers/net/ethernet/mellanox/mlx5/core/main.c?

And it would be interesting to know if your past success kernels were
printing the mlx5 shutdown message too? Perhaps something core kernel
changed to enable this path for your test?

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
