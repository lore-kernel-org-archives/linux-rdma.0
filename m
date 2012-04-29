From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: possible circular locking dependency detected in uverbs
Date: Sun, 29 Apr 2012 16:17:09 +0300
Message-ID: <alpine.LRH.2.00.1204291614040.11752@ogerlitz.voltaire.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

I got this today with the IB git for-next, with some other patches applied
(the ones I will send next, but they they don't seem to be related?), and
libibverbs/mlx4 from their git heads.

Or.

======================================================
[ INFO: possible circular locking dependency detected ]
3.4.0-rc2-00017-g418ba09 #15 Tainted: G          I
-------------------------------------------------------
ibv_srq_pingpon/27854 is trying to acquire lock:
 (key#14){+++++.}, at: [<ffffffffa0290548>] idr_read_uobj+0x2f/0x4d [ib_uverbs]

but task is already holding lock:
 (key#13){+++++.}, at: [<ffffffffa0290548>] idr_read_uobj+0x2f/0x4d [ib_uverbs]

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #2 (key#13){+++++.}:
       [<ffffffff8106892e>] lock_acquire+0xf0/0x116
       [<ffffffff813639f7>] down_read+0x42/0x57
       [<ffffffffa0290548>] idr_read_uobj+0x2f/0x4d [ib_uverbs]
       [<ffffffffa0293209>] ib_uverbs_create_qp+0x1b1/0x6c1 [ib_uverbs]
       [<ffffffffa028f177>] ib_uverbs_write+0xae/0xc2 [ib_uverbs]
       [<ffffffff810dfdd6>] vfs_write+0xae/0x133
       [<ffffffff810dff14>] sys_write+0x45/0x6c
       [<ffffffff8136c6a2>] system_call_fastpath+0x16/0x1b

-> #1 (key#11){++++++}:
       [<ffffffff8106892e>] lock_acquire+0xf0/0x116
       [<ffffffff813639f7>] down_read+0x42/0x57
       [<ffffffffa0290548>] idr_read_uobj+0x2f/0x4d [ib_uverbs]
       [<ffffffffa029249a>] __uverbs_create_xsrq+0x95/0x378 [ib_uverbs]
       [<ffffffffa02928e0>] ib_uverbs_create_xsrq+0x163/0x17c [ib_uverbs]
       [<ffffffffa028f177>] ib_uverbs_write+0xae/0xc2 [ib_uverbs]
       [<ffffffff810dfdd6>] vfs_write+0xae/0x133
       [<ffffffff810dff14>] sys_write+0x45/0x6c
       [<ffffffff8136c6a2>] system_call_fastpath+0x16/0x1b

-> #0 (key#14){+++++.}:
       [<ffffffff810681c1>] __lock_acquire+0x10d1/0x174e
       [<ffffffff8106892e>] lock_acquire+0xf0/0x116
       [<ffffffff813639f7>] down_read+0x42/0x57
       [<ffffffffa0290548>] idr_read_uobj+0x2f/0x4d [ib_uverbs]
       [<ffffffffa0293282>] ib_uverbs_create_qp+0x22a/0x6c1 [ib_uverbs]
       [<ffffffffa028f177>] ib_uverbs_write+0xae/0xc2 [ib_uverbs]
       [<ffffffff810dfdd6>] vfs_write+0xae/0x133
       [<ffffffff810dff14>] sys_write+0x45/0x6c
       [<ffffffff8136c6a2>] system_call_fastpath+0x16/0x1b

other info that might help us debug this:

Chain exists of:
  key#14 --> key#11 --> key#13

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  lock(key#13);
                               lock(key#11);
                               lock(key#13);
  lock(key#14);

 *** DEADLOCK ***

3 locks held by ibv_srq_pingpon/27854:
 #0:  (key#15){+.+...}, at: [<ffffffffa0293164>] ib_uverbs_create_qp+0x10c/0x6c1 [ib_uverbs]
 #1:  (key#11){++++++}, at: [<ffffffffa0290548>] idr_read_uobj+0x2f/0x4d [ib_uverbs]
 #2:  (key#13){+++++.}, at: [<ffffffffa0290548>] idr_read_uobj+0x2f/0x4d [ib_uverbs]

stack backtrace:
Pid: 27854, comm: ibv_srq_pingpon Tainted: G          I  3.4.0-rc2-00017-g418ba09 #15
Call Trace:
 [<ffffffff8102af9a>] ? unregister_console+0x1/0x80
 [<ffffffff81066a72>] print_circular_bug+0x28e/0x29f
 [<ffffffff810681c1>] __lock_acquire+0x10d1/0x174e
 [<ffffffff8106892e>] lock_acquire+0xf0/0x116
 [<ffffffffa0290548>] ? idr_read_uobj+0x2f/0x4d [ib_uverbs]
 [<ffffffff813639f7>] down_read+0x42/0x57
 [<ffffffffa0290548>] ? idr_read_uobj+0x2f/0x4d [ib_uverbs]
 [<ffffffffa0290548>] idr_read_uobj+0x2f/0x4d [ib_uverbs]
 [<ffffffffa0293282>] ib_uverbs_create_qp+0x22a/0x6c1 [ib_uverbs]
 [<ffffffff810689fb>] ? lock_release_non_nested+0xa7/0x282
 [<ffffffff810c173e>] ? might_fault+0x4e/0x9e
 [<ffffffffa028f177>] ib_uverbs_write+0xae/0xc2 [ib_uverbs]
 [<ffffffff810df691>] ? rw_verify_area+0xac/0xcf
 [<ffffffff81365e86>] ? retint_swapgs+0xe/0x13
 [<ffffffff810dfdd6>] vfs_write+0xae/0x133
 [<ffffffff810dff14>] sys_write+0x45/0x6c
 [<ffffffff8136c6a2>] system_call_fastpath+0x16/0x1b
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
