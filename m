From: "Steve Wise" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: RE: RXE and ib_write_bw
Date: Wed, 15 Jun 2016 16:29:58 -0500
Message-ID: <01e201d1c74d$115d9550$3418bff0$@opengridcomputing.com>
References: <01e001d1c74c$961cd950$c2568bf0$@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <01e001d1c74c$961cd950$c2568bf0$@opengridcomputing.com>
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Moni Shoua' <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: 'Doug Ledford' <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, 'linux-rdma' <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, 'Matan Barak' <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, 'Majd Dibbiny' <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, 'Liran Liss' <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, 'Kamal Heib' <kamalh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, 'Amir Vadai' <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, 'Leon Romanovsky' <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org



> -----Original Message-----
> From: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-rdma-
> owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of Steve Wise
> Sent: Wednesday, June 15, 2016 4:27 PM
> To: 'Moni Shoua'
> Cc: 'Doug Ledford'; 'linux-rdma'; 'Matan Barak'; 'Majd Dibbiny'; 'Liran Liss'; 'Kamal
> Heib'; 'Amir Vadai'; 'Leon Romanovsky'
> Subject: RXE and ib_write_bw
> 
> Hey Moni,
> 
> When I run ib_write_bw, I get this logged on one or sometimes both nodes.  I think
> RXE is perhaps doing too much in the interrupt context or in its tasklet?
>

I also see this logged this in the log: 

Failed sending ack
Failed sending ack
Failed sending ack
Failed sending ack
 
> The test is:
> 
> ib_write_bw -a -R -d rxe0 --report_gbits --bidir 10.0.1.14
> 
> The dmesg log:
> 
> INFO: rcu_sched self-detected stall on CPU
>         8-...: (1 GPs behind) idle=49f/140000000000001/0 softirq=16690/16690
> fqs=6706
> INFO: rcu_sched detected stalls on CPUs/tasks:
>         8-...: (1 GPs behind) idle=49f/140000000000001/0 softirq=16690/16690
> fqs=6706
>         (detected by 13, t=21008 jiffies, g=17642, c=17641, q=4090)
> Task dump for CPU 8:
> ksoftirqd/8     R  running task        0    48      2 0x10000008
>  ffffffff00000100 ffff88107861ed80 ffffffff81a050f0 0000000000000006
>  0000000000000100 ffff881078627e68 ffffffff8161abbb 0420804000000000
>  ffff881078624008 000000010018d17d 0000000a7861ed80 ffffffff81a050f0
> Call Trace:
>  [<ffffffff8161abbb>] ? __do_softirq+0xeb/0x2d8
>  [<ffffffff81086240>] ? smpboot_create_threads+0x80/0x80
>  [<ffffffff81614eb0>] ? schedule+0x40/0xb0
>  [<ffffffff81086240>] ? smpboot_create_threads+0x80/0x80
>  [<ffffffff810686dd>] ? run_ksoftirqd+0x1d/0x40
>  [<ffffffff8108634c>] ? smpboot_thread_fn+0x10c/0x160
>  [<ffffffff8108255c>] ? kthread+0xcc/0xf0
>  [<ffffffff8108cade>] ? schedule_tail+0x1e/0xc0
>  [<ffffffff816186cf>] ? ret_from_fork+0x1f/0x40
>  [<ffffffff81082490>] ? kthread_freezable_should_stop+0x70/0x70
>          (t=21081 jiffies g=17642 c=17641 q=4090)
> Task dump for CPU 8:
> ksoftirqd/8     R  running task        0    48      2 0x10000008
>  0000000000000009 ffff88107f403ba8 ffffffff8108956d ffff881078bfa040
>  0000000000000008 000000000000000f 0000000000000006 0000000000000008
>  ffffffff81a48240 ffff88107f403bc8 ffffffff8108960f ffff88107f403bc8
> Call Trace:
>  <IRQ>  [<ffffffff8108956d>] sched_show_task+0xbd/0x120
>  [<ffffffff8108960f>] dump_cpu_task+0x3f/0x50
>  [<ffffffff810c0c3c>] rcu_dump_cpu_stacks+0x7c/0xb0
>  [<ffffffff810c0f01>] print_cpu_stall+0xf1/0x150
>  [<ffffffff810c1360>] check_cpu_stall+0x110/0x120
>  [<ffffffff8111b3b1>] ? trace_buffer_unlock_commit_regs+0x61/0x80
>  [<ffffffff8112c7f6>] ? trace_event_buffer_commit+0x146/0x1d0
>  [<ffffffff810682fd>] ? trace_event_raw_event_softirq+0x5d/0xa0
>  [<ffffffff810c3878>] rcu_check_callbacks+0xe8/0x330
>  [<ffffffff81068822>] ? __raise_softirq_irqoff+0x72/0x80
>  [<ffffffff8110aacc>] ? acct_account_cputime+0x1c/0x20
>  [<ffffffff81092c80>] ? account_system_time+0x90/0x130
>  [<ffffffff810c6639>] update_process_times+0x39/0x70
>  [<ffffffff810d7e0a>] tick_sched_handle+0x3a/0x50
>  [<ffffffff810d8842>] tick_sched_timer+0x52/0xa0
>  [<ffffffff810c92b7>] __run_hrtimer+0x77/0x1d0
>  [<ffffffff810d87f0>] ? tick_nohz_handler+0xc0/0xc0
>  [<ffffffff810682fd>] ? trace_event_raw_event_softirq+0x5d/0xa0
>  [<ffffffff810cfe5c>] ? ktime_get+0x4c/0xc0
>  [<ffffffff810c9477>] __hrtimer_run_queues+0x67/0x90
>  [<ffffffff810c961b>] hrtimer_interrupt+0x9b/0x170
>  [<ffffffff81044e19>] local_apic_timer_interrupt+0x39/0x60
>  [<ffffffff8161a9b1>] smp_apic_timer_interrupt+0x41/0x60
>  [<ffffffff8161908f>] apic_timer_interrupt+0x7f/0x90
>  <EOI>  [<ffffffffa0293662>] ? rxe_requester+0x252/0x780 [ib_rxe]
>  [<ffffffffa0293643>] ? rxe_requester+0x233/0x780 [ib_rxe]
>  [<ffffffff8112c7f6>] ? trace_event_buffer_commit+0x146/0x1d0
>  [<ffffffffa029df89>] rxe_do_task+0x59/0x100 [ib_rxe]
>  [<ffffffff81068993>] tasklet_action+0xa3/0xc0
>  [<ffffffff8161abbb>] __do_softirq+0xeb/0x2d8
>  [<ffffffff81086240>] ? smpboot_create_threads+0x80/0x80
>  [<ffffffff81614eb0>] ? schedule+0x40/0xb0
>  [<ffffffff81086240>] ? smpboot_create_threads+0x80/0x80
>  [<ffffffff810686dd>] run_ksoftirqd+0x1d/0x40
>  [<ffffffff8108634c>] smpboot_thread_fn+0x10c/0x160
>  [<ffffffff8108255c>] kthread+0xcc/0xf0
>  [<ffffffff8108cade>] ? schedule_tail+0x1e/0xc0
>  [<ffffffff816186cf>] ret_from_fork+0x1f/0x40
>  [<ffffffff81082490>] ? kthread_freezable_should_stop+0x70/0x70
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
