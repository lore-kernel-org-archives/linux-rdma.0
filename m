From: Or Gerlitz <ogerlitz-hKgKHo2Ms0FWk0Htik3J/w@public.gmane.org>
Subject: Re: can't get IB link with the for-next branch / IBoE patches
Date: Tue, 26 Oct 2010 15:10:41 +0200
Message-ID: <4CC6D351.3080700@Voltaire.com>
References: <20101024075835.GA11359@mtldesk30> <adahbgbppgx.fsf@cisco.com>	<20101024160018.GA32499@mtldesk30> <adaocajo90s.fsf@cisco.com>	<AANLkTimb++kFYFXCWajBGACpA1OpCXyyeyD-98Ed3uTu@mail.gmail.com>	<4CC54D4E.7050203@Voltaire.com> <4CC5604D.2080803@Voltaire.com>	<adaaam2jswk.fsf@cisco.com> <20101025161730.GA9335@mtldesk30>	<adalj5mgp96.fsf@cisco.com> <adahbgagopw.fsf@cisco.com>	<4CC6A051.3010703@Voltaire.com> <4CC6C75F.8030103@Voltaire.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4CC6C75F.8030103-hKgKHo2Ms0FWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: RDMA list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> doing a little bit stress testing, I came across the below oops, when running IPoIB
> and couple of iperf/udp sessions, it doesn't look like a problem in the IB stack.

To trigger this I run from client node the following "iperf -uc 192.168.21.18 -l 64000 -t 72000 -i 1 -b 40g  -d -P 4" where the server node (21.18 here) was the one that has the IBoE patches and got this oops 

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
