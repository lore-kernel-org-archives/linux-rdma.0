From: "Steve Wise" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: stuck iscsi/iser target with linux-4.15.0-rc1
Date: Fri, 1 Dec 2017 11:05:42 -0600
Message-ID: <000801d36ac6$9e9f5f70$dbde1e50$@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain;
        charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: target-devel <target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: sagi grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hey, while working on some changes in the cxgb4 qp_drain functionality, I
encountered this stall.  To reproduce it, I attach 2 ram disks via iser over
cxgb4 and run an fio test.  While the test is running, I tear down the target
stack with 'targetcli clearconfig true'

While this could be something with my qp_drain logic, I don't see that in these
stuck threads.  Has anybody seen this?  

Thanks

Steve.

---

[ 1107.205467] INFO: task iscsi_trx:9901 blocked for more than 120 seconds.
[ 1107.221177]       Tainted: G        W        4.15.0-rc1-drain-flush-fix+ #8
[ 1107.237174] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this
message.
[ 1107.254109] iscsi_trx       D    0  9901      2 0x80000084
[ 1107.268775] Call Trace:
[ 1107.280341]  ? __schedule+0x28d/0x870
[ 1107.293129]  schedule+0x32/0x80
[ 1107.305381]  schedule_timeout+0x1d4/0x2f0
[ 1107.318529]  ? ib_sg_to_pages+0x1a0/0x1a0 [ib_core]
[ 1107.332554]  wait_for_completion+0x123/0x190
[ 1107.345965]  ? wake_up_q+0x70/0x70
[ 1107.358526]  target_wait_for_sess_cmds+0x41/0x180 [target_core_mod]
[ 1107.373826]  isert_wait_conn+0x1bd/0x320 [ib_isert]
[ 1107.387559]  iscsit_close_connection+0x155/0x8e0 [iscsi_target_mod]
[ 1107.402604]  ? wait_for_completion_interruptible+0x16f/0x1c0
[ 1107.416966]  ? wake_up_q+0x70/0x70
[ 1107.428926]  iscsit_take_action_for_connection_exit+0x7e/0x100
[iscsi_target_mod]
[ 1107.445049]  iscsi_target_rx_thread+0xdc/0xf0 [iscsi_target_mod]
[ 1107.459636]  kthread+0xf5/0x130
[ 1107.471236]  ? iscsi_target_tx_thread+0x1f0/0x1f0 [iscsi_target_mod]
[ 1107.486060]  ? kthread_associate_blkcg+0x90/0x90
[ 1107.499068]  ret_from_fork+0x1f/0x30
[ 1107.510902] INFO: task targetcli:9913 blocked for more than 120 seconds.
[ 1107.525915]       Tainted: G        W        4.15.0-rc1-drain-flush-fix+ #8
[ 1107.541170] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this
message.
[ 1107.557317] targetcli       D    0  9913   9750 0x00000080
[ 1107.571126] Call Trace:
[ 1107.581750]  ? __schedule+0x28d/0x870
[ 1107.593499]  schedule+0x32/0x80
[ 1107.604578]  schedule_timeout+0x1d4/0x2f0
[ 1107.616433]  ? signal_wake_up_state+0x15/0x30
[ 1107.628515]  wait_for_completion+0x123/0x190
[ 1107.640367]  ? wake_up_q+0x70/0x70
[ 1107.651248]  iscsit_cause_connection_reinstatement+0x95/0xe0
[iscsi_target_mod]
[ 1107.666102]  iscsit_free_session+0x100/0x160 [iscsi_target_mod]
[ 1107.679489]  iscsit_release_sessions_for_tpg+0x18b/0x200 [iscsi_target_mod]
[ 1107.693909]  iscsit_tpg_disable_portal_group+0xc1/0x1c0 [iscsi_target_mod]
[ 1107.708180]  lio_target_tpg_enable_store+0x65/0xe0 [iscsi_target_mod]
[ 1107.721984]  configfs_write_file+0xa3/0x100
[ 1107.733431]  __vfs_write+0x33/0x170
[ 1107.744056]  ? handle_mm_fault+0xc4/0x1d0
[ 1107.755084]  ? _cond_resched+0x15/0x30
[ 1107.765748]  vfs_write+0xad/0x1a0
[ 1107.775832]  SyS_write+0x52/0xc0
[ 1107.785683]  do_syscall_64+0x61/0x1a0
[ 1107.795865]  entry_SYSCALL64_slow_path+0x25/0x25
[ 1107.806931] RIP: 0033:0x7f967db18c60
[ 1107.816850] RSP: 002b:00007ffdce1705e8 EFLAGS: 00000246 ORIG_RAX:
0000000000000001
[ 1107.830847] RAX: ffffffffffffffda RBX: 0000000000000001 RCX: 00007f967db18c60
[ 1107.844408] RDX: 0000000000000001 RSI: 00007f967ec76000 RDI: 0000000000000003
[ 1107.857898] RBP: 00007f967ec76000 R08: 0000000001e0abb0 R09: 00007f967ecfa740
[ 1107.871311] R10: 00007f967eae05f0 R11: 0000000000000246 R12: 0000000001e0aad0
[ 1107.884703] R13: 0000000000000001 R14: 00000000018440a0 R15: 00007f967eaaaf00

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
