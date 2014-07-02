From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: mlx4 lockdep splat
Date: Wed, 2 Jul 2014 10:45:12 -0400
Message-ID: <E900818E-32D4-4667-85EB-34BC2BA88B9F@oracle.com>
References: <B2CFBE8B-333B-4EA3-8853-9C91FFCE92D8@oracle.com> <20140702101954.0af46c74@jpm-OptiPlex-GX620>
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.2\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140702101954.0af46c74@jpm-OptiPlex-GX620>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi Jack-


On Jul 2, 2014, at 3:19 AM, Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org> wrote:

> On Tue, 1 Jul 2014 18:17:27 -0400
> Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org> wrote:
> 
>> Hi-
>> 
>> This happens during boot, and means that lockdep and lock_stat are
>> completely disabled during any testing I do.
>> 
>> Does this splat have a known fix, or should I file an upstream
>> bugzilla?
>> 
>> 
>> Jul  1 15:50:22 manet kernel: =================================
>> Jul  1 15:50:22 manet kernel: [ INFO: inconsistent lock state ]
>> Jul  1 15:50:22 manet kernel: 3.16.0-rc2-00024-g2e78883 #17 Tainted:
>> G            E Jul  1 15:50:22 manet kernel:
>> --------------------------------- Jul  1 15:50:22 manet kernel:
>> inconsistent {SOFTIRQ-ON-W} -> {IN-SOFTIRQ-W} usage. Jul  1 15:50:22
>> manet kernel: swapper/0/0 [HC0[0]:SC1[1]:HE1:SE0] takes: Jul  1
>> 15:50:22 manet kernel: (&(&iboe->lock)->rlock){+.?...}, at:
>> [<ffffffffa065f68b>] mlx4_ib_addr_event+0xdb/0x1a0 [mlx4_ib] Jul  1
>> 15:50:22 manet kernel: {SOFTIRQ-ON-W} state was registered at: Jul  1
>> 15:50:22 manet kernel:  [<ffffffff810b3110>]
>> mark_irqflags+0x110/0x170 Jul  1 15:50:22 manet kernel:
>> [<ffffffff810b4806>] __lock_acquire+0x2c6/0x5b0 Jul  1 15:50:22 manet
>> kernel:  [<ffffffff810b4bd9>] lock_acquire+0xe9/0x120 Jul  1 15:50:22
>> manet kernel:  [<ffffffff815f7f6e>] _raw_spin_lock+0x3e/0x80 Jul  1
>> 15:50:22 manet kernel:  [<ffffffffa0661084>]
>> mlx4_ib_scan_netdevs+0x34/0x260 [mlx4_ib] Jul  1 15:50:22 manet
>> kernel:  [<ffffffffa06612db>] mlx4_ib_netdev_event+0x2b/0x40
>> [mlx4_ib] Jul  1 15:50:22 manet kernel:  [<ffffffff81522219>]
>> register_netdevice_notifier+0x99/0x1e0 Jul  1 15:50:22 manet kernel:
>> [<ffffffffa06626e3>] mlx4_ib_add+0x743/0xbc0 [mlx4_ib]
> 
> Hi Chuck,
> 
> There is a known fix which I need to submit.
> The fix is to use lock/unlock_bh instead of spin_lock/unlock.
> 
> The netdev event notifier callback (mlx4_ib_addr_event), which also
> uses the lock, is called from a soft-interrupt context, so turning off
> hard interrupts is not needed here.  _bh spinlocks are sufficient.

If you have a patch handy, I'm happy to test. Thanks!

-- 
Chuck Lever
chuck[dot]lever[at]oracle[dot]com




--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
