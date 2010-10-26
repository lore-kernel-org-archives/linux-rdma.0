From: Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: can't get IB link with the for-next branch / IBoE patches
Date: Tue, 26 Oct 2010 15:46:01 +0200
Message-ID: <20101026134601.GA20206@mtldesk30>
References: <adaocajo90s.fsf@cisco.com>
 <AANLkTimb++kFYFXCWajBGACpA1OpCXyyeyD-98Ed3uTu@mail.gmail.com>
 <4CC54D4E.7050203@Voltaire.com>
 <4CC5604D.2080803@Voltaire.com>
 <adaaam2jswk.fsf@cisco.com>
 <20101025161730.GA9335@mtldesk30>
 <adalj5mgp96.fsf@cisco.com>
 <adahbgagopw.fsf@cisco.com>
 <4CC6A051.3010703@Voltaire.com>
 <4CC6C75F.8030103@Voltaire.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <4CC6C75F.8030103-hKgKHo2Ms0FWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-hKgKHo2Ms0FWk0Htik3J/w@public.gmane.org>
Cc: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, RDMA list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Andy Grover <andy.grover-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

I'll try to reproduce here. Anyway, I don't see how it could possibly
be related to IBoE.

On Tue, Oct 26, 2010 at 02:19:43PM +0200, Or Gerlitz wrote:
> > I have IB port coming to active and basic IPoIB, opensm working okay
> > on the node with the current for-next/IBoE bits
> 
> doing a little bit stress testing, I came across the below oops, when running IPoIB
> and couple of iperf/udp sessions, it doesn't look like a problem in the IB stack.
> 
> Also with rds, using rds-stress from rds-tools-1.5-1.el5 and "rds-stress -s 192.168.20.18 -p 4000 -t 1 
> -q 1K -a 1K -D 1M" on the client side, the node running the for-next/IBoE bits and acting as the passive side
> of the test, got hanged. Also here, this could be a bug in RDS and not in the IBoE patches, I know that the rds guys queued about a hundred! patches for 2.6.37 so with these patches things might be better. I have the oops trace in jpg, will send to Andy, Roland and Eli. I guess we can continue these tests for 2-3 days and have the push over the weekend, or push it before and get fixes if needed through the -rc cycle.
> 
> 
> Oct 26 12:36:30 nsg2 kernel: BUG: spinlock bad magic on CPU#0, iperf/20845
> Oct 26 12:36:30 nsg2 kernel:  lock: ffffffff81663ef8, .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0
> Oct 26 12:36:30 nsg2 kernel: Pid: 20845, comm: iperf Not tainted 2.6.36-rc5-42052-gce806e1 #1
> Oct 26 12:36:30 nsg2 kernel: Call Trace:
> Oct 26 12:36:30 nsg2 kernel:  [<ffffffff811542b7>] ? do_raw_spin_lock+0x22/0x122
> Oct 26 12:36:30 nsg2 kernel:  [<ffffffff81268b2b>] ? dev_queue_xmit+0x10d/0x346
> Oct 26 12:36:30 nsg2 kernel:  [<ffffffff8128ca13>] ? ip_push_pending_frames+0x2bf/0x318
> Oct 26 12:36:30 nsg2 kernel:  [<ffffffff812a7e66>] ? udp_push_pending_frames+0x2d2/0x351
> Oct 26 12:36:30 nsg2 kernel:  [<ffffffff812a970c>] ? udp_sendmsg+0x4b0/0x59c
> Oct 26 12:36:30 nsg2 kernel:  [<ffffffff8112e9f7>] ? cap_socket_sendmsg+0x0/0x3
> Oct 26 12:36:30 nsg2 kernel:  [<ffffffff812e7d8e>] ? common_interrupt+0xe/0x13
> Oct 26 12:36:30 nsg2 kernel:  [<ffffffff8112e9f7>] ? cap_socket_sendmsg+0x0/0x3
> Oct 26 12:36:30 nsg2 kernel:  [<ffffffff81256bbb>] ? sock_aio_write+0xf5/0x10d
> Oct 26 12:36:30 nsg2 kernel:  [<ffffffff810029ae>] ? reschedule_interrupt+0xe/0x20
> Oct 26 12:36:30 nsg2 kernel:  [<ffffffff812e7d8e>] ? common_interrupt+0xe/0x13
> Oct 26 12:36:30 nsg2 kernel:  [<ffffffff812e7d8e>] ? common_interrupt+0xe/0x13
> Oct 26 12:36:30 nsg2 kernel:  [<ffffffff810b9b49>] ? do_sync_write+0xab/0xeb
> Oct 26 12:36:30 nsg2 kernel:  [<ffffffff812e7abf>] ? _raw_spin_unlock_irq+0x9/0xd
> Oct 26 12:36:30 nsg2 kernel:  [<ffffffff8112e83f>] ? security_file_permission+0x18/0x6b
> Oct 26 12:36:30 nsg2 kernel:  [<ffffffff810ba1f7>] ? vfs_write+0xbe/0x132
> Oct 26 12:36:30 nsg2 kernel:  [<ffffffff810ba754>] ? sys_write+0x45/0x6e
> Oct 26 12:36:30 nsg2 kernel:  [<ffffffff81001e6b>] ? system_call_fastpath+0x16/0x1b
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
