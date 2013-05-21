From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: MLX4 Cq Question
Date: Tue, 21 May 2013 12:40:20 +0300
Message-ID: <519B4104.4090102@mellanox.com>
References: <51968438.7070907@opengridcomputing.com> <CAG4TOxNi0PxxskqXgxRhMPG0bmr+sS-x0_RG-zKyvLW1LNzoBg@mail.gmail.com> <201305201753.10806.jackm@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <201305201753.10806.jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Tom Tucker <tom-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 20/05/2013 17:53, Jack Morgenstein wrote:
> ===================================================
> net/mlx4_core: Fix racy flow in the driver CQ completion handler
>
> The mlx4 CQ completion handler, mlx4_cq_completion, doesn't bother to lock
> the radix tree which is used to manage the table of CQs, nor does it increase
> the reference count of the CQ before invoking the user provided callback
> (and decrease it afterwards).
>
> This is racy and can cause use-after-free, null pointer dereference, etc, which
> result in kernel crashes.
>
> To fix this, we must do the following in mlx4_cq_completion:
> - increase the ref count on the cq before invoking the user callback, and
>    decrement it after the callback.
> - Place a lock around the radix tree lookup/ref-count-increase
>
> Using an irq spinlock will not fix this issue. The problem is that under VPI,
> the ETH interface uses multiple msix irq's, which can result in one cq completion
> event interrupting another in-progress cq completion event. A deadlock results
> when the handler for the first cq completion grabs the spinlock, and is
> interrupted by the second completion before it has a chance to release the spinlock.
> The handler for the second completion will deadlock waiting for the spinlock
> to be released.

I am not sure to follow on two pieces here:

1. why we say that only mlx4_en uses multiple msix irq's? mlx4_ib also 
exposes multiple vectors (--> EQs --> MSI-X --> IRQ)
and the iser driver use that, e.g creates multiple CQs each on different EQ

2. is possible in the Linux kernel for one hard irq callback to flash on 
CPU X while another hard irq callback is running on the same CPU?

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
