From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: Bug introduced by commit ebeeb1ad9b8a
Date: Wed, 3 Oct 2018 04:28:25 -0700
Message-ID: <20181003112825.GA28237@kroah.com>
References: <8EEB4CE2-F6E5-4128-AB04-6326F8315E31@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <8EEB4CE2-F6E5-4128-AB04-6326F8315E31@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
To: =?iso-8859-1?Q?H=E5kon?= Bugge <haakon.bugge@oracle.com>
Cc: Sowmini Varadhan <sowmini.varadhan@oracle.com>, Santosh Shilimkar <santosh.shilimkar@oracle.com>, "David S. Miller" <davem@davemloft.net>, Ka-Cheong Poon <ka-cheong.poon@oracle.com>, netdev@vger.kernel.or, OFED mailing list <linux-rdma@vger.kernel.org>, rds-devel@oss.oracle.com, linux-kernel@vger.kernel.org, Yanjun Zhu <yanjun.zhu@oracle.com>
List-Id: linux-rdma@vger.kernel.org

On Wed, Oct 03, 2018 at 01:20:44PM +0200, Håkon Bugge wrote:
> Hi Greg,
> 
> 
> I hope you will find this note appropriate.
> 
> The stable cherry-pick of upstream commit ebeeb1ad9b8a ("rds: tcp: use rds_destroy_pending() to synchronize netns/module teardown and rds connection/workq management") provokes the following stack trace when running with debug:
> 
> 
> kernel: BUG: sleeping function called from invalid context at kernel/locking/mutex.c:748
> kernel: =============================
> kernel: in_atomic(): 1, irqs_disabled(): 0, pid: 4392, name: rds-stress
> kernel: 1 lock held by rds-stress/4392:
> kernel: #0: 00000000df837d5e
> kernel: WARNING: suspicious RCU usage
> kernel: 4.18.8 #1 Not tainted
> kernel: -----------------------------
> kernel: ./include/linux/rcupdate.h:303 Illegal context switch in RCU read-side critical section!
> kernel: (
> kernel: #012other info that might help us debug this:
> kernel: #012rcu_scheduler_active = 2, debug_locks = 1
> kernel: rcu_read_lock){....}
> kernel: 1 lock held by rds-stress/4393:
> kernel: #0:
> kernel: , at: __rds_conn_create+0x604/0x960 [rds]
> kernel: 00000000df837d5e
> kernel: CPU: 38 PID: 4392 Comm: rds-stress Not tainted 4.18.8 #1
> kernel: Hardware name: Oracle Corporation ORACLE SERVER X5-2L/ASM,MOBO TRAY,2U, BIOS 31110000 03/03/2017
> kernel: (rcu_read_lock
> kernel: Call Trace:
> kernel: ){....}
> kernel: dump_stack+0x81/0xb8
> kernel: , at: __rds_conn_create+0x604/0x960 [rds]
> kernel: #012stack backtrace:
> kernel: ___might_sleep+0x239/0x260
> kernel: __might_sleep+0x4a/0x80
> kernel: __mutex_lock+0x58/0x9c0
> kernel: ? __lock_acquire+0x47f/0x7e0
> kernel: ? pcpu_alloc+0x429/0x860
> kernel: ? find_held_lock+0x40/0xb0
> kernel: ? create_object+0x22f/0x320
> kernel: ? _raw_write_unlock_irqrestore+0x36/0x60
> kernel: mutex_lock_killable_nested+0x1b/0x20
> kernel: pcpu_alloc+0x429/0x860
> kernel: ? create_object+0x22f/0x320
> kernel: __alloc_percpu+0x15/0x20
> kernel: rds_ib_recv_alloc_cache+0x1c/0x80 [rds_rdma]
> kernel: rds_ib_recv_alloc_caches+0x1d/0x60 [rds_rdma]
> kernel: rds_ib_conn_alloc+0x46/0x170 [rds_rdma]
> kernel: __rds_conn_create+0x68d/0x960 [rds]
> kernel: ? __rds_conn_create+0x604/0x960 [rds]
> kernel: rds_conn_create_outgoing+0x14/0x20 [rds]
> kernel: rds_sendmsg+0x2e8/0xcd0 [rds]
> kernel: ? copy_msghdr_from_user+0xdb/0x140
> kernel: sock_sendmsg+0x38/0x50
> kernel: ___sys_sendmsg+0x27b/0x290
> kernel: ? __lock_acquire+0x47f/0x7e0
> kernel: ? find_held_lock+0x40/0xb0
> kernel: ? __audit_syscall_entry+0xdf/0x160
> kernel: ? ktime_get_coarse_real_ts64+0x6e/0xe0
> kernel: ? trace_hardirqs_on_caller+0x128/0x1b0
> kernel: ? trace_hardirqs_on+0xd/0x10
> kernel: ? __audit_syscall_entry+0xdf/0x160
> kernel: ? __audit_syscall_entry+0xdf/0x160
> kernel: __sys_sendmsg+0x5d/0xb0
> kernel: __x64_sys_sendmsg+0x1f/0x30
> kernel: do_syscall_64+0x5f/0x220
> kernel: entry_SYSCALL_64_after_hwframe+0x49/0xbe
> 
> Command line:
> 
> $ rds-stress -r <IB port 1 IP>& sleep 1; rds-stress -r <IB port 2 IP> -s <IB port 1 IP> -T 10
> 
> Deliberately or accidently, Ka-Cheong's commit f394ad28feff ("rds: rds_ib_recv_alloc_cache() should call alloc_percpu_gfp() instead") fixes the bug introduced by commit ebeeb1ad9b8a. Kudos to Zhu Yanjun who quickly detected this.
> 
> But be aware, commit f394ad28feff does not contain the "Fixes:" tag.
> 
> Hence, I suggest that in all stable releases containing commit ebeeb1ad9b8a, f394ad28feff must be included as well.

Great, thanks for the information.  Can you submit this info to the
netdev developers who will queue it up for a stable release?  Or, as
David is already on the cc: list here, he can just tell me to
cherry-pick it and I can do it on my own :)

thanks,

greg k-h
