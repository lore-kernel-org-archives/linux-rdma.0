From: Mike Heinz <michael.heinz-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Subject: Hang in ib_umad when attempting to unregister.
Date: Mon, 3 May 2010 10:15:25 -0500
Message-ID: <4C2744E8AD2982428C5BFE523DF8CDCB49A47409EA@MNEXMB1.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: LINUX-RDMA <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hello, all.

In my company's test labs, we've been seeing nodes occasionally hang when a process tries to disconnect from the ib_mad interface. Can anyone suggest what might be causing this?

Here's a typical example:

Apr 29 10:01:37 st2139 kernel: qlgc_dsc      D ffffffff80148c54     0  5478    
 1          5497  5477 (NOTLB)
Apr 29 10:01:37 st2139 kernel:  ffff81042b785dd8 0000000000000082 000000000062f388 00000000437b2038
Apr 29 10:01:37 st2139 kernel:  0000000000000000 000000000000000a ffff81043fa3f040 ffff81043fb6e100
Apr 29 10:01:37 st2139 kernel:  00003463ec0fbcd0 0000000000003720 ffff81043fa3f228 000000080062f388
Apr 29 10:01:37 st2139 kernel: Call Trace:
Apr 29 10:01:37 st2139 kernel:  [<ffffffff8003dd13>] do_futex+0x282/0xc3f
Apr 29 10:01:37 st2139 kernel:  [<ffffffff80063206>] wait_for_completion+0x79/0xa2
Apr 29 10:01:37 st2139 kernel:  [<ffffffff8008a461>] default_wake_function+0x0/0xe
Apr 29 10:01:37 st2139 kernel:  [<ffffffff88318399>]:ib_mad:ib_cancel_rmpp_recvs+0xa6/0xe9
Apr 29 10:01:37 st2139 kernel:  [<ffffffff883155f1>]:ib_mad:ib_unregister_mad_agent+0x30d/0x424
Apr 29 10:01:37 st2139 kernel:  [<ffffffff8850d24e>]:ib_umad:ib_umad_unreg_agent+0x6f/0x94
Apr 29 10:01:37 st2139 kernel:  [<ffffffff8850db71>]:ib_umad:ib_umad_ioctl+0x4a/0x5d
Apr 29 10:01:37 st2139 kernel:  [<ffffffff80041b2e>] do_ioctl+0x21/0x6b
Apr 29 10:01:37 st2139 kernel:  [<ffffffff8002fd1e>] vfs_ioctl+0x248/0x261
Apr 29 10:01:37 st2139 kernel:  [<ffffffff8004c0a3>] sys_ioctl+0x59/0x78
Apr 29 10:01:37 st2139 kernel:  [<ffffffff8005d28d>] tracesys+0xd5/0xe0

Reviewing the code, the problem is that, basically, ib_cancel_rmpp_recvs is waiting for a completion() to occur, but the completion() is never getting invoked, presumably because the reference count is wrong on one of the rmpp structures:

static inline void deref_rmpp_recv(struct mad_rmpp_recv *rmpp_recv)
{
                if (atomic_dec_and_test(&rmpp_recv->refcount))
                                complete(&rmpp_recv->comp);
}

static void destroy_rmpp_recv(struct mad_rmpp_recv *rmpp_recv)
{
                deref_rmpp_recv(rmpp_recv);
                wait_for_completion(&rmpp_recv->comp);
                ib_destroy_ah(rmpp_recv->ah);
                kfree(rmpp_recv);
}

Reviewing our internal bugs database, I actually found that this problem has actually been around for several years, but we were never able to reproduce it under controlled circumstances. Most frequently, the problem occurred when trying to unload a module. Here's an example that was captured in 2007:

rmmod         D ffff81003af6fd60     0 22020  21962
 ffff81003b017c68 0000000000000082 ffffffff813a22a8 ffff81003b017c88
 ffff81003b017c90 ffff81003ab39800 ffff81003fba6800 ffff81003ab39a68
 000000013b017c58 ffffffff8126b945 0000000000000001 ffffffff81042433
Call Trace:
 [<ffffffff8126b945>] wait_for_completion+0xa0/0xb3
 [<ffffffff81042433>] flush_cpu_workqueue+0x29/0x6f
 [<ffffffff8102def5>] default_wake_function+0x0/0xe
 [<ffffffff8126b92f>] wait_for_completion+0x8a/0xb3
 [<ffffffff8102def5>] default_wake_function+0x0/0xe
 [<ffffffff881271d7>] :ib_mad:ib_cancel_rmpp_recvs+0x8a/0xdf
 [<ffffffff88124475>] :ib_mad:ib_unregister_mad_agent+0x333/0x445
 [<ffffffff8812f0d0>] :ib_sa:free_sm_ah+0x0/0x17
 [<ffffffff88125e90>] :ib_mad:ib_agent_port_close+0x7c/0x8b
 [<ffffffff8812245b>] :ib_mad:ib_mad_remove_device+0x38/0x85
 [<ffffffff880fbf20>] :ib_core:ib_unregister_device+0x30/0xc4
 [<ffffffff8817033c>] :ib_ipath:ipath_unregister_ib_device+0x59/0x282
 [<ffffffff88152e69>] :ib_ipath:ipath_remove_one+0x75/0x474
 [<ffffffff81122d01>] pci_device_remove+0x24/0x48
 [<ffffffff811885aa>] __device_release_driver+0x8e/0xb0
 [<ffffffff81188ae8>] driver_detach+0xce/0x10e
 [<ffffffff81188053>] bus_remove_driver+0x6d/0x90
 [<ffffffff81122f53>] pci_unregister_driver+0x10/0x5f
 [<ffffffff8817da5f>] :ib_ipath:infinipath_cleanup+0x3f/0x4c
 [<ffffffff81050d23>] sys_delete_module+0x196/0x1c5

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
