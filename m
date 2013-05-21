From: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: MLX4 Cq Question
Date: Tue, 21 May 2013 17:13:24 +0300
Message-ID: <201305211713.24370.jackm@dev.mellanox.co.il>
References: <51968438.7070907@opengridcomputing.com> <519B4F81.9040108@acm.org> <519B4FEB.5090701@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <519B4FEB.5090701-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Tom Tucker <tom-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tuesday 21 May 2013 13:43, Or Gerlitz wrote:
> On 21/05/2013 13:42, Bart Van Assche wrote:
> > On 05/21/13 11:40, Or Gerlitz wrote:
> >> 2. is possible in the Linux kernel for one hard irq callback to flash on
> >> CPU X while another hard irq callback is running on the same CPU?
> >
> > I think that from kernel 2.6.35 on MSI IRQs are no longer nested. See 
> > also 
> > http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=753649dbc49345a73a2454c770a3f2d54d11aec6 
> > or http://lwn.net/Articles/380931/
> 
> thanks, so suppose we agree on that, still the patch makes sense as the 
> race is there, but does the patch has to change?
> 
> Or.
> 
I just need to verify that the patch can be applied correctly on the upstream kernel.
The use of RCU (and not spinlock) makes sense from a performance standpoint
in any case. We do NOT want to force mlx4_cq_completion to have a spinlock
which is device-global, resulting in having completion event processing be
single-threaded in effect).
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
