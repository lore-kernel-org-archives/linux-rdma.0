From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: SRPt oops with 4.5-rc3-ish
Date: Sat, 27 Feb 2016 19:37:19 -0800
Message-ID: <1456630639.19657.47.camel@haakon3.risingtidesystems.com>
References: <56C0A6C3.3010903@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <56C0A6C3.3010903@redhat.com>
Sender: target-devel-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: Bart Van Assche <bart.vanassche@sandisk.com>, linux-rdma <linux-rdma@vger.kernel.org>, target-devel <target-devel@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

Hi Doug,

On Sun, 2016-02-14 at 11:09 -0500, Doug Ledford wrote:
> While testing with my latest kernel (rc3 plus pening RDMA patches), I
> ran across this oops:
> 
> [dledford@linux-ws ~]$ console rdma-storage-04
> Enter dledford@conserver-01.app.eng.rdu2.redhat.com's password:
> [Enter `^Ec?' for help]
> [-- MOTD -- https://home.corp.redhat.com/wiki/conserver]
> [playback]
> [160605.947614]  [<ffffffff81150545>] ? call_rcu_sched+0x25/0x30
> [160605.954074]  [<ffffffffc0b3dd84>] target_fabric_nacl_base_release+0x64/0x70]
> [160605.963731]  [<ffffffff813ccc6f>] config_item_release+0x9f/0x1c0
> [160605.970579]  [<ffffffff813ccdf2>] config_item_put+0x62/0x80
> [160605.976936]  [<ffffffff813c97d3>] configfs_rmdir+0x343/0x500
> [160605.983396]  [<ffffffff8131287a>] vfs_rmdir+0x13a/0x220
> [160605.989375]  [<ffffffff813197db>] do_rmdir+0x1fb/0x260
> [160605.995244]  [<ffffffff8131adde>] SyS_rmdir+0x1e/0x30
> [160606.001019]  [<ffffffff81a0922e>] entry_SYSCALL_64_fastpath+0x12/0x71
> [160606.009586] ---[ end trace 820588f5ef5f6148 ]---
> [160607.051593] ib_srpt Received SRP_LOGIN_REQ with i_port_id 0x7f0ee700032d1de)
> [160607.078225] ib_srpt rejected SRP_LOGIN_REQ because the target port has not d
> [160611.228909] ib_srpt Received IB DREQ ERROR event.
> [160613.276862] ib_srpt Received IB TimeWait exit for cm_id ffff881cc9dc7a00.
> [160613.290322] BUG: unable to handle kernel paging request at 0000000000018630
> [160613.301470] IP: [<ffffffff81125694>] native_queued_spin_lock_slowpath+0x2e40
> [160613.313112] PGD 0
> [160613.318577] Oops: 0002 [#1] SMP
> [160613.325358] Modules linked in: nfnetlink(+) ip6t_rpfilter 8021q garp ip6t_R]
> [160613.492357] CPU: 1 PID: 44982 Comm: kworker/1:1 Tainted: G        W I     44
> [160613.505978] Hardware name: Dell Inc. PowerEdge R730xd/0599V5, BIOS 1.0.4 084
> [160613.517697] Workqueue: events srpt_release_channel_work [ib_srpt]
> [160613.527634] task: ffff881d01099000 ti: ffff881d02014000 task.ti: ffff881d020
> [160613.539130] RIP: 0010:[<ffffffff81125694>]  [<ffffffff81125694>] native_que0
> [160613.553326] RSP: 0018:ffff881d02017d90  EFLAGS: 00010006
> [160613.562332] RAX: 00000000000000ea RBX: 0000000000000206 RCX: 000000000001860
> [160613.573401] RDX: 0000000000080000 RSI: ffff881d4c818600 RDI: ffff880f2d7c7d8
> [160613.584472] RBP: ffff881d02017d90 R08: 0000000000000023 R09: 000000000000000
> [160613.595491] R10: 00000000ffffffd8 R11: 00000000000211c0 R12: ffff880f2d7c7d0
> [160613.606568] R13: ffff881ce426d000 R14: ffff881cca702a00 R15: 000000000000000
> [160613.617643] FS:  0000000000000000(0000) GS:ffff881d4c800000(0000) knlGS:0000
> [160613.629793] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [160613.639315] CR2: 0000000000018630 CR3: 0000000001ca9000 CR4: 000000000014060
> [160613.650471] Stack:
> [160613.655843]  ffff881d02017da0 ffffffff8122ac4c ffff881d02017db8 ffffffff81a7
> [160613.667361]  ffff880f2d7c7d18 ffff881d02017de0 ffffffff81121255 ffff881cca70
> [160613.678885]  ffff881ce426d058 ffff881ce426d000 ffff881d02017e10 ffffffffc070
> [160613.690366] Call Trace:
> [160613.696195]  [<ffffffff8122ac4c>] queued_spin_lock_slowpath+0x12/0x1d
> [160613.706533]  [<ffffffff81a08ea7>] _raw_spin_lock_irqsave+0x87/0xa0
> [160613.716586]  [<ffffffff81121255>] complete+0x25/0x70
> [160613.725318]  [<ffffffffc07e7e80>] srpt_release_channel_work+0x180/0x210 [ib]
> [160613.736889]  [<ffffffff810e6dd8>] process_one_work+0x228/0x650
> [160613.746616]  [<ffffffff810e79be>] worker_thread+0x21e/0x800
> [160613.756047]  [<ffffffff81a02035>] ? __schedule+0x4b5/0xe6a
> [160613.765371]  [<ffffffff810e77a0>] ? kzalloc+0x30/0x30
> [160613.774203]  [<ffffffff810efc38>] kthread+0x118/0x150
> [160613.783000]  [<ffffffff810efb20>] ? flush_kthread_worker+0xd0/0xd0
> [160613.792932]  [<ffffffff81a0958f>] ret_from_fork+0x3f/0x70
> [160613.801994]  [<ffffffff810efb20>] ? flush_kthread_worker+0xd0/0xd0
> [160613.811897] Code: 01 00 00 74 ec e9 d7 fd ff ff 48 89 c1 c1 e8 12 48 c1 e9
> [160613.840260] RIP  [<ffffffff81125694>] native_queued_spin_lock_slowpath+0x2e0
> [160613.851846]  RSP <ffff881d02017d90>
> [160613.858812] CR2: 0000000000018630
> [160613.874762] ---[ end trace 820588f5ef5f6149 ]---
> [160613.937225] Kernel panic - not syncing: Fatal exception
> [160613.946167] Kernel Offset: disabled
> [160614.004693] ---[ end Kernel panic - not syncing: Fatal exception
> [-- MARK -- Sun Feb 14 15:50:00 2016]
> [-- dledford@REDHAT.COM@ovpn-116-26.rdu2.redhat.com attached -- Sun Feb
> 14 15:5]
> 
> 
> 
> Basic description of situation that cause the oops:
> 
> Server with 30+ SRPt luns, 2 SRP devices, 1 active client busy beating
> away on 1 lun via two paths (active/passive setup)
> 
> Run dnf upgrade (dnf is yum's replacement, so just a system wide
> software update).
> 
> Get to the cleanup for targetcli/target-restore and it invokes an
> attempt to reload the target service while still in use.  During the
> process of deconfiguring the luns that are in use, this oops occurred.
> Sending the report to you because it appears to involve the
> multi-channel support.
> 

This is a fairly recent srpt shutdown regression, right..?

Any chance to reproduce with full pr_debug enabled..?

I'm curious to see if HCH's changes in commit 59fae4dea to drop
ib_create_cq() w/ ib_comp_handler -> srpt_compl_thread() usage
are somehow involved.
