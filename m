From: "Steve Wise" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: RE: device removal hangs where there are open uverbs refs
Date: Mon, 24 Mar 2014 09:25:08 -0500
Message-ID: <001401cf476c$db7e95e0$927bc1a0$@opengridcomputing.com>
References: <CAJZOPZ+No+UY+owMOCVFVWKOFy1xG4zsX23F9CT9ZXC2a0SNzA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAJZOPZ+No+UY+owMOCVFVWKOFy1xG4zsX23F9CT9ZXC2a0SNzA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Or Gerlitz' <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, 'Roland Dreier' <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: 'Bart Van Assche' <bvanassche-HInyCGIudOg@public.gmane.org>, 'linux-rdma' <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org



> -----Original Message-----
> From: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On
> Behalf Of Or Gerlitz
> Sent: Monday, March 24, 2014 2:16 AM
> To: Roland Dreier
> Cc: Bart Van Assche; linux-rdma
> Subject: device removal hangs where there are open uverbs refs
> 
> Hi Roland,
> 
> >From time to time I get a customer case which goes through something
> like the below trace which steps on a design limitation of the
> upstream IB stack  -- namely, if you have a process with open uverbs
> reference -- device removal flow hangs and this would happen with any
> device/driver, nothing specific to mlx4. So... I think it's about time
> to address it.
> 
> Can't we just foricibly close their uverbs file descriptor from within
> the kernel and drop the ref?
>

Here is a previous thread discussing the issue in 2010: 

http://marc.info/?l=linux-rdma&m=126961887406371&w=3


 
> Or.
> 
> INFO: task mlx4:2003 blocked for more than 120 seconds.
> "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> Call Trace:
> [<ffffffff814fe6a5>] schedule_timeout+0x215/0x2e0
> [<ffffffff814fe323>] wait_for_common+0x123/0x180
> [<ffffffff814fe43d>] wait_for_completion+0x1d/0x20
> [<ffffffffa04600b3>] ib_uverbs_remove_one+0x73/0xa0 [ib_uverbs]
> [<ffffffffa036fa6f>] ib_unregister_device+0x4f/0x100 [ib_core]
> [<ffffffffa038fd76>] mlx4_ib_remove+0x26/0x110 [mlx4_ib]
> [<ffffffffa0348391>] mlx4_remove_device+0x71/0x90 [mlx4_core]
> [<ffffffffa03483f3>] mlx4_unregister_device+0x43/0x90 [mlx4_core]
> [<ffffffffa0349bb8>] mlx4_change_port_types+0x68/0x120 [mlx4_core]
> [<ffffffffa03546ab>] mlx4_sense_port+0x9b/0xd0 [mlx4_core]
> [<ffffffff8108c760>] worker_thread+0x170/0x2a0
> [<ffffffff81091d66>] kthread+0x96/0xa0
> [<ffffffff8100c14a>] child_rip+0xa/0x20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
