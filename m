From: Carol Soto <clsoto-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: Re: device removal hangs where there are open uverbs refs
Date: Tue, 25 Mar 2014 09:35:47 -0500
Message-ID: <53319443.5070604@linux.vnet.ibm.com>
References: <CAJZOPZ+No+UY+owMOCVFVWKOFy1xG4zsX23F9CT9ZXC2a0SNzA@mail.gmail.com> <001401cf476c$db7e95e0$927bc1a0$@opengridcomputing.com> <53315E18.2010601@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <53315E18.2010601-HInyCGIudOg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, 'Or Gerlitz' <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, 'Roland Dreier' <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: 'linux-rdma' <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


On 3/25/2014 5:44 AM, Bart Van Assche wrote:
> On 03/24/14 15:25, Steve Wise wrote:
>>> -----Original Message-----
>>> From: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On
>>> Behalf Of Or Gerlitz
>>> Sent: Monday, March 24, 2014 2:16 AM
>>> To: Roland Dreier
>>> Cc: Bart Van Assche; linux-rdma
>>> Subject: device removal hangs where there are open uverbs refs
>>>
>>> Hi Roland,
>>>
>>> >From time to time I get a customer case which goes through something
>>> like the below trace which steps on a design limitation of the
>>> upstream IB stack  -- namely, if you have a process with open uverbs
>>> reference -- device removal flow hangs and this would happen with any
>>> device/driver, nothing specific to mlx4. So... I think it's about time
>>> to address it.
>>>
>>> Can't we just foricibly close their uverbs file descriptor from within
>>> the kernel and drop the ref?
>>>
>>> Or.
>>>
>>> INFO: task mlx4:2003 blocked for more than 120 seconds.
>>> "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
>>> Call Trace:
>>> [<ffffffff814fe6a5>] schedule_timeout+0x215/0x2e0
>>> [<ffffffff814fe323>] wait_for_common+0x123/0x180
>>> [<ffffffff814fe43d>] wait_for_completion+0x1d/0x20
>>> [<ffffffffa04600b3>] ib_uverbs_remove_one+0x73/0xa0 [ib_uverbs]
>>> [<ffffffffa036fa6f>] ib_unregister_device+0x4f/0x100 [ib_core]
>>> [<ffffffffa038fd76>] mlx4_ib_remove+0x26/0x110 [mlx4_ib]
>>> [<ffffffffa0348391>] mlx4_remove_device+0x71/0x90 [mlx4_core]
>>> [<ffffffffa03483f3>] mlx4_unregister_device+0x43/0x90 [mlx4_core]
>>> [<ffffffffa0349bb8>] mlx4_change_port_types+0x68/0x120 [mlx4_core]
>>> [<ffffffffa03546ab>] mlx4_sense_port+0x9b/0xd0 [mlx4_core]
>>> [<ffffffff8108c760>] worker_thread+0x170/0x2a0
>>> [<ffffffff81091d66>] kthread+0x96/0xa0
>>> [<ffffffff8100c14a>] child_rip+0xa/0x20
>> Here is a previous thread discussing the issue in 2010:
>>
>> http://marc.info/?l=linux-rdma&m=126961887406371&w=3
> There might be an easier solution for the issue reported by Or than what
> has been discussed in 2010. Is it necessary that mlx4_sense_port()
> blocks until ib_uverbs_remove_one() has finished ? Since
> mlx4_sense_port() runs periodically, how about changing that function
> such that it does not invoke mlx4_unregister_device() if a port is still
> in use but instead tries again to change the port type during the next
> call of mlx4_sense_port() ?
>
> Bart.
> --
I have seen the same hang doing PCI error injection to Mellanox cards. 
Here is the
stack trace:
kernel:  Call Trace:
kernel:  [c0000000fb40ef60] [0000000000000001] 0x1 (unreliable)
kernel:  [c0000000fb40f130] [c0000000000144f0] .__switch_to+0x1c0/0x390
kernel:  [c0000000fb40f1e0] [c0000000006d3af8] .__schedule+0x328/0x920
kernel:  [c0000000fb40f460] [c0000000006d1364] .schedule_timeout+0x244/0x2e0
kernel:  [c0000000fb40f560] [c0000000006d47ac] .wait_for_common+0x18c/0x210
kernel:  [c0000000fb40f630] [d0000000069a0af4] 
.ib_uverbs_remove_one+0xd4/0x150 [ib_uverbs]
kernel:  [c0000000fb40f6b0] [d0000000063d5174] 
.ib_unregister_device+0x74/0x150 [ib_core]
kernel:  [c0000000fb40f750] [d0000000066b7ad4] 
.mlx4_ib_remove+0x44/0x220 [mlx4_ib]
kernel:  [c0000000fb40f7e0] [d000000002d3d07c] 
.mlx4_remove_device+0xdc/0x120 [mlx4_core]
kernel:  [c0000000fb40f870] [d000000002d3d6ec] 
.mlx4_unregister_device+0x7c/0xf0 [mlx4_core]
kernel:  [c0000000fb40f900] [d000000002d3ec20] 
.mlx4_remove_one+0x60/0x3e0 [mlx4_core]
kernel:  [c0000000fb40f9a0] [d000000002d3efb8] 
.mlx4_pci_err_detected+0x18/0x40 [mlx4_core]
kernel:  [c0000000fb40fa20] [c000000000035600] .eeh_report_error+0xa0/0x120
kernel:  [c0000000fb40fab0] [c0000000000342ec] 
.eeh_pe_dev_traverse+0x9c/0x190
kernel:  [c0000000fb40fb60] [c000000000035c1c] 
.eeh_handle_normal_event+0x11c/0x3c0
kernel:  [c0000000fb40fbf0] [c000000000035ef0] .eeh_handle_event+0x30/0x2b0
kernel:  [c0000000fb40fc90] [c0000000000362b4] 
.eeh_event_handler+0x144/0x160
kernel:  [c0000000fb40fd30] [c0000000000c01b8] .kthread+0xe8/0xf0
kernel:  [c0000000fb40fe30] [c00000000000a168] 
.ret_from_kernel_thread+0x5c/0x74

The only way that I can get out of this hang is CTRL+C or send a signal 
to kill the application that has the file descriptor open.
Is there any other way to close the file descriptor to avoid this hang?

Carol
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
