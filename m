From: Erez Shitrit <erezsh-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH V3 FIX for-3.19] IB/ipoib: Fix sendonly traffic and multicast
 traffic
Date: Tue, 27 Jan 2015 10:33:13 +0200
Message-ID: <54C74D49.3080201@dev.mellanox.co.il>
References: <1422277227-1086-1-git-send-email-erezsh@mellanox.com>	 <CAJ3xEMjERaEP5d_ZT8RN5+w8Z_Hig4T7dhuq3o+1NOUuQgfJLw@mail.gmail.com>	 <1422301106.2854.41.camel@redhat.com>	 <CAJ3xEMg3vYGbGuT+Z-XQMv5YuPws33XHQP_Wcz8gvpBbCg3TSw@mail.gmail.com> <1422309605.2854.62.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1422309605.2854.62.camel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Amir Vadai <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eyal Perry <eyalpe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 1/27/2015 12:00 AM, Doug Ledford wrote:
> On Mon, 2015-01-26 at 22:57 +0200, Or Gerlitz wrote:
>> On Mon, Jan 26, 2015 at 9:38 PM, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
>>> On Mon, 2015-01-26 at 15:16 +0200, Or Gerlitz wrote:
>>>> On Mon, Jan 26, 2015 at 3:00 PM, Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote:
>>>>> Following commit 016d9fb25cd9 "IPoIB: fix MCAST_FLAG_BUSY usage" both
>>>>> IPv6 traffic and for the most cases all IPv4 multicast traffic aren't
>>>>> working.
>>>>
>>>> Hi Doug + Roland
>>>>
>>>> Erez was very patiently reviewing and testing all the six (V0...V5)
>>>> patch series you sent to fix the 3.19-rc1 regression.
>>> Yes he has.
>>
>>>>   Can you also give this patch a try?
>>> I can test it.  But I need to know how it's supposed to be applied.
>> just apply it on latest upstream and run whatever tests you have, simple.
> I used the same base kernel that I used for my patchset.
>
>>> It might fix the regression, it might also reintroduce a race on
>>> ifup/ifdown.  I'll test and see.
>> Let's see it in action @ your env
> It passed the initial IPv6 after a failed join issue that my own
> patchset just finally passes.
>
> However, I didn't get more than 5 minutes into testing before I was able
> to livelock the system.  In this case, from machine A running my
> patchset, I did
>
> ping6 -I mlx4_ib0 -i .25 <machine B address>
>
> On machine B running Erez's patch, I did:
>
> rmmod ib_ipoib; modprobe ib_ipoib mcast_debug_level=1; sleep 2; ping6
> -i .25 -c 10 -I mlx4_ib0 <machine A address>
>
> And on the machine rdma-master, where the opensm runs, I did just a few:
>
> systemctl restart opensm
>
> The livelock is in the mcast flushing code.  On the machine that
> livelocked, here's the dmesg tail:
>
> [  423.189514] mlx4_ib0.8002: multicast join failed for ff12:401b:8002:0000:0000:0000:ffff:ffff, status -110
> [  423.189541] mlx4_ib0.8002: deleting multicast group ff12:401b:8002:0000:0000:0000:0000:0001
> [  423.189545] mlx4_ib0.8002: deleting multicast group ff12:601b:8002:0000:0000:0000:0000:0001
> [  423.189547] mlx4_ib0.8002: deleting multicast group ff12:601b:8002:0000:0000:0001:ff7b:e1b1
> [  423.189549] mlx4_ib0.8002: deleting multicast group ff12:401b:8002:0000:0000:0000:0000:00fb
> [  423.189551] mlx4_ib0.8002: deleting multicast group ff12:401b:8002:0000:0000:0000:ffff:ffff
> [  423.204570] mlx4_ib0.8002: stopping multicast thread
> [  423.204573] mlx4_ib0.8002: flushing multicast list
> [  423.213567] mlx4_ib0: stopping multicast thread
> [  423.213571] mlx4_ib0: flushing multicast list
>
> The rmmod operation is stuck in ib_sa_unregister_client (one of the
> specific fixes my patchset resolves BTW).

The patch I sent, only claims to fix the regression in multicast and 
sendonly issues, it can replace the first 3 patches and the one you sent 
me off list from your last patchset.
(probably there are more bugs, that the rest of your patchset solved, 
hence it should be tested with the rest of your patchset)

And probably there are more bugs that your patcheset didn't fix yet -:)
For example, I run your last patchset+ the last fix you sent me with:
modprobe -r ib_ipoib; modprobe  ib_ipoib;
ping6
some adding/deleting  one child interface and got the next panic:

[81209.348259] ib0: join completion for 
ff12:601b:ffff:0000:0000:0001:ff43:3bf1 (status -102)
[81209.408787] BUG: unable to handle kernel NULL pointer dereference at 
0000000000000020
[81209.416750] IP: [<ffffffffa096b399>] ipoib_mcast_join+0xa9/0x1b0 
[ib_ipoib]
[81209.423787] PGD 0
[81209.425864] Oops: 0000 [#1] SMP
[81209.429165] Modules linked in: ib_ipoib(E) ib_cm mlx4_ib ib_sa ib_mad 
ib_core ib_addr mlx4_core netconsole configfs nfsv3 nfs_acl 
rpcsec_gss_krb5 auth_rpcgss nfsv4 nfs fscache lockd grace 
ip6table_filter ip6_tables ebtable_nat ebtables nf_conntrack_ipv4 
nf_defrag_ipv4 xt_state nf_conntrack ipt_REJECT nf_reject_ipv4 
xt_CHECKSUM iptable_mangle iptable_filter ip_tables autofs4 sunrpc 
bridge stp llc ipv6 dm_mirror dm_region_hash dm_log dm_mod vhost_net 
macvtap macvlan vhost tun kvm_intel kvm iTCO_wdt iTCO_vendor_support 
dcdbas microcode pcspkr serio_raw wmi sg lpc_ich mfd_core i7core_edac 
edac_core bnx2 ext3(E) jbd(E) mbcache(E) sr_mod(E) cdrom(E) sd_mod(E) 
pata_acpi(E) ata_generic(E) ata_piix(E) megaraid_sas(E) [last unloaded: 
ib_cm]
[81209.495358] CPU: 10 PID: 7655 Comm: kworker/u64:0 Tainted: 
G            E  3.18.0+ #1
[81209.503297] Hardware name: Dell Inc. PowerEdge R710/0MD99X, BIOS 
6.4.0 07/23/2013
[81209.510905] Workqueue: ipoib_wq ipoib_mcast_join_task [ib_ipoib]
[81209.516975] task: ffff88041bb64050 ti: ffff88041b968000 task.ti: 
ffff88041b968000
[81209.524566] RIP: 0010:[<ffffffffa096b399>] [<ffffffffa096b399>] 
ipoib_mcast_join+0xa9/0x1b0 [ib_ipoib]
[81209.534079] RSP: 0018:ffff88041b96bcf8  EFLAGS: 00010202
[81209.539447] RAX: 0000000000000000 RBX: ffff8803bd92e8c0 RCX: 
0000000000000000
[81209.546636] RDX: ffff88082fcaea38 RSI: ffff88082fcad238 RDI: 
ffff88082fcad238
[81209.553833] RBP: ffff88041b96bd78 R08: 0000000000000000 R09: 
00000000000060f0
[81209.561027] R10: 0000000000000000 R11: 0000000000000001 R12: 
ffff88041bec0700
[81209.568217] R13: ffff88041b96bd08 R14: 0000000000000001 R15: 
f773010000000000
[81209.575411] FS:  0000000000000000(0000) GS:ffff88082fca0000(0000) 
knlGS:0000000000000000
[81209.583608] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[81209.589411] CR2: 0000000000000020 CR3: 0000000001a14000 CR4: 
00000000000007e0
[81209.596599] Stack:
[81209.598664]  ffff8803bd92ecc0 0000000100000000 000001801b6012ff 
f13b43ff01000000
[81209.606216]  00000000000080fe f13b430003c90200 0000000000000000 
0000000001800000
[81209.613768]  0000000000000000 0000000000010000 ffff8803bd92ea60 
ffff8803bd92ea60
[81209.621328] Call Trace:
[81209.623832]  [<ffffffffa096b7d5>] ipoib_mcast_join_task+0x195/0x370 
[ib_ipoib]
[81209.631172]  [<ffffffff8106d6cd>] process_one_work+0x14d/0x430
[81209.637059]  [<ffffffff8106dad0>] worker_thread+0x120/0x3c0
[81209.642689]  [<ffffffff815b7e35>] ? __schedule+0x355/0x6d0
[81209.648227]  [<ffffffff8106d9b0>] ? process_one_work+0x430/0x430
[81209.654290]  [<ffffffff8107290e>] kthread+0xce/0xf0
[81209.659222]  [<ffffffff81072840>] ? 
kthread_freezable_should_stop+0x70/0x70
[81209.666242]  [<ffffffff815bbb2c>] ret_from_fork+0x7c/0xb0
[81209.671698]  [<ffffffff81072840>] ? 
kthread_freezable_should_stop+0x70/0x70
[81209.678713] Code: 00 00 48 89 45 a8 0f b7 83 ca 03 00 00 66 c1 c0 08 
45 85 f6 66 89 45 ba 74 48 48 8b 83 78 01 00 00 49 bf 00 00 00 00 00 01 
73 f7 <8b> 50 20 c6 45 b6 02 89 55 b0 0f b6 50 27 88 55 b7 0f b6 50 28
[81209.698543] RIP  [<ffffffffa096b399>] ipoib_mcast_join+0xa9/0x1b0 
[ib_ipoib]
[81209.705661]  RSP <ffff88041b96bcf8>
[81209.709201] CR2: 0000000000000020
[81209.712896] ---[ end trace 02ca131660e82eb4 ]---
[81209.728390] BUG: unable to handle kernel paging request at 
ffffffffffffffd8
[81209.735555] IP: [<ffffffff81072230>] kthread_data+0x10/0x20
[81209.741280] PGD 1a15067 PUD 1a17067 PMD 0
[81209.745626] Oops: 0000 [#2] SMP
[81209.749049] Modules linked in: ib_ipoib(E) ib_cm mlx4_ib ib_sa ib_mad 
ib_core ib_addr mlx4_core netconsole configfs nfsv3 nfs_acl 
rpcsec_gss_krb5 auth_rpcgss nfsv4 nfs fscache lockd grace 
ip6table_filter ip6_tables ebtable_nat ebtables nf_conntrack_ipv4 
nf_defrag_ipv4 xt_state nf_conntrack ipt_REJECT nf_reject_ipv4 
xt_CHECKSUM iptable_mangle iptable_filter ip_tables autofs4 sunrpc 
bridge stp llc ipv6 dm_mirror dm_region_hash dm_log dm_mod vhost_net 
macvtap macvlan vhost tun kvm_intel kvm iTCO_wdt iTCO_vendor_support 
dcdbas microcode pcspkr serio_raw wmi sg lpc_ich mfd_core i7core_edac 
edac_core bnx2 ext3(E) jbd(E) mbcache(E) sr_mod(E) cdrom(E) sd_mod(E) 
pata_acpi(E) ata_generic(E) ata_piix(E) megaraid_sas(E) [last unloaded: 
ib_cm]
[81209.818287] CPU: 22 PID: 7655 Comm: kworker/u64:0 Tainted: G D     E  
3.18.0+ #1
[81209.826266] Hardware name: Dell Inc. PowerEdge R710/0MD99X, BIOS 
6.4.0 07/23/2013
[81209.833901] task: ffff88041bb64050 ti: ffff88041b968000 task.ti: 
ffff88041b968000
[81209.841545] RIP: 0010:[<ffffffff81072230>] [<ffffffff81072230>] 
kthread_data+0x10/0x20
[81209.849750] RSP: 0018:ffff88041b96b958  EFLAGS: 00010092
[81209.855158] RAX: 0000000000000000 RBX: 0000000000000016 RCX: 
ffffffff81d627a0
[81209.862386] RDX: ffff88041bb64050 RSI: 0000000000000016 RDI: 
ffff88041bb64050
[81209.869615] RBP: ffff88041b96b958 R08: ffff88041bb640e0 R09: 
dead000000200200
[81209.876842] R10: dead000000200200 R11: 0000000000000007 R12: 
0000000000000016
[81209.884074] R13: ffff88041bb64960 R14: 0000000000000001 R15: 
0000000000000092
[81209.891302] FS:  0000000000000000(0000) GS:ffff88082fd60000(0000) 
knlGS:0000000000000000
[81209.899538] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[81209.905377] CR2: 0000000000000028 CR3: 0000000001a14000 CR4: 
00000000000007e0
[81209.912606] Stack:
[81209.914713]  ffff88041b96b978 ffffffff8106b025 ffff88041b96b978 
ffff88082fd72a40
[81209.922469]  ffff88041b96b9d8 ffffffff815b7ffa ffff88041b968010 
0000000000012a40
[81209.930219]  ffff88041bb64050 ffff88041bb64050 ffff88041b96b9e8 
ffff88041bb64050
[81209.937968] Call Trace:
[81209.940509]  [<ffffffff8106b025>] wq_worker_sleeping+0x15/0xb0
[81209.946435]  [<ffffffff815b7ffa>] __schedule+0x51a/0x6d0
[81209.951844]  [<ffffffff815b82e9>] schedule+0x29/0x70
[81209.956904]  [<ffffffff810585ba>] do_exit+0x2da/0x490
[81209.962051]  [<ffffffff81007840>] oops_end+0xa0/0xe0
[81209.967111]  [<ffffffff81047ec5>] no_context+0x125/0x200
[81209.972517]  [<ffffffff810480bd>] __bad_area_nosemaphore+0x11d/0x220
[81209.978966]  [<ffffffff810481d3>] bad_area_nosemaphore+0x13/0x20
[81209.985067]  [<ffffffff81048792>] __do_page_fault+0x322/0x4b0
[81209.990908]  [<ffffffff81097a4f>] ? up+0x2f/0x50
[81209.995624]  [<ffffffff8112ad8b>] ? irq_work_queue+0x9b/0xd0
[81210.002583]  [<ffffffff810a47d2>] ? wake_up_klogd+0x32/0x40
[81210.008251]  [<ffffffff810a56b0>] ? console_unlock+0x2a0/0x2e0
[81210.014179]  [<ffffffff810489fc>] do_page_fault+0xc/0x10
[81210.019585]  [<ffffffff815bd542>] page_fault+0x22/0x30
[81210.024818]  [<ffffffffa096b399>] ? ipoib_mcast_join+0xa9/0x1b0 
[ib_ipoib]
[81210.031795]  [<ffffffffa096b451>] ? ipoib_mcast_join+0x161/0x1b0 
[ib_ipoib]
[81210.038853]  [<ffffffffa096b7d5>] ipoib_mcast_join_task+0x195/0x370 
[ib_ipoib]
[81210.046226]  [<ffffffff8106d6cd>] process_one_work+0x14d/0x430
[81210.052157]  [<ffffffff8106dad0>] worker_thread+0x120/0x3c0
[81210.057824]  [<ffffffff815b7e35>] ? __schedule+0x355/0x6d0
[81210.063403]  [<ffffffff8106d9b0>] ? process_one_work+0x430/0x430
[81210.069502]  [<ffffffff8107290e>] kthread+0xce/0xf0
[81210.074473]  [<ffffffff81072840>] ? 
kthread_freezable_should_stop+0x70/0x70
[81210.081535]  [<ffffffff815bbb2c>] ret_from_fork+0x7c/0xb0
[81210.087028]  [<ffffffff81072840>] ? 
kthread_freezable_should_stop+0x70/0x70
[81210.094084] Code: b8 08 00 00 48 8b 40 c8 c9 48 c1 e8 02 83 e0 01 c3 
66 2e 0f 1f 84 00 00 00 00 00 55 48 89 e5 66 66 66 66 90 48 8b 87 b8 08 
00 00 <48> 8b 40 d8 c9 c3 66 2e 0f 1f 84 00 00 00 00 00 55 48 89 e5 66
[81210.116583] RIP  [<ffffffff81072230>] kthread_data+0x10/0x20
[81210.122388]  RSP <ffff88041b96b958>
[81210.125971] CR2: ffffffffffffffd8

> On another machine I started another one of my tests:
>
> On machine A:
>
> ping6 I mlx4_ib0 -i .25 <machine C address>
>
> On rdma-master:
>
> while true; do sleep 4; systemctl restart opensm; done
>
> One machine C:
>
> passes=0; while true; do ifdown qib_ib0; ifup qib_ib0; echo "Passes $passes..."; let passes++; done
>
> In this test Erez's patch made it through about 5 down/up cycles before
> the machine oopsed.
>
> Do I need to keep going?  I was able to crash two different machines on
> two different brands of hardware within only a few test cycles.  My
> patchset, while large and intrusive, now survives all of this with
> flying colors, and now that I've replicated Erez's specific multicast
> join failure, I've taken care of that corner case too (and will be
> adding that to my long term QE setup so it doesn't regress in the
> future).
>

Doug, there are bugs that probably will be found all the time with any 
patchset, my point was only according to the way sendonly need to be 
handled.

Thanks, Erez


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
