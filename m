From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: [PATCH, RFC] mlx4: Avoid that mlx4_cmd_wait() contributes to
 the system load
Date: Wed, 24 Jul 2013 20:34:19 +0200
Message-ID: <51F01E2B.5000201@acm.org>
References: <51ED4E60.30203@acm.org> <51EFF018.7050409@mellanox.com> <51F0055F.7000703@acm.org> <51F0097C.4010806@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <51F0097C.4010806-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, David Miller <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 07/24/13 19:06, Or Gerlitz wrote:
> On 24/07/2013 19:48, Bart Van Assche wrote:
>> I saw a load of 0.5 with several different upstream kernels (3.6..3.10
>> at least). The only IB-related process that was running on the system
>> was opensmd. This is definitely reproducible. It was only a month
>> after I had noticed this phenomenon that I started searching for the
>> root cause.
> do you see it also on systems that don't run opensm?

Yes. This happens both on systems running opensm and on systems not 
running opensm. A call trace from a system on which CPU load was higher 
than expected is as follows:

# echo w >/proc/sysrq-trigger; dmesg -c
SysRq : Show Blocked State
   task                        PC stack   pid father
kworker/u:7     D ffff88011fa125c0     0   181      2 0x00000000
  ffff880114d63b48 0000000000000046 ffff8801158d1c40 ffff880114d63fd8
  ffff880114d63fd8 ffff880114d63fd8 ffffffff81613440 ffff8801158d1c40
  ffffffff817a7180 ffff880114d63b80 ffffffff817a7180 000000010000ebf9
Call Trace:
  [<ffffffff813ea259>] schedule+0x29/0x70
  [<ffffffff813e88aa>] schedule_timeout+0x10a/0x1e0
  [<ffffffff813e98e2>] wait_for_common+0xd2/0x180
  [<ffffffff813e9a63>] wait_for_completion_timeout+0x13/0x20
  [<ffffffffa03bfb99>] __mlx4_cmd+0x259/0x5e0 [mlx4_core]
  [<ffffffffa03d60e4>] mlx4_SENSE_PORT+0x54/0xc0 [mlx4_core]
  [<ffffffffa03d620f>] mlx4_do_sense_ports+0xbf/0xd0 [mlx4_core]
  [<ffffffffa03d6262>] mlx4_sense_port+0x42/0xc0 [mlx4_core]
  [<ffffffff81055f9c>] process_one_work+0x16c/0x4b0
  [<ffffffff8105825d>] worker_thread+0x15d/0x450
  [<ffffffff8105d5b0>] kthread+0xc0/0xd0
  [<ffffffff813f34dc>] ret_from_fork+0x7c/0xb0

Bart.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
