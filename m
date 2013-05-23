From: Jack Wang <jinpu.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Subject: Re: BUG: unable to handle kernel paging request at 0000000000070a78
 IPoIB
Date: Thu, 23 May 2013 17:38:06 +0200
Message-ID: <519E37DE.1080504@profitbricks.com>
References: <51963BC6.1050901@profitbricks.com> <519B6DD6.4090502@profitbricks.com> <519B909A.8010004@profitbricks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <519B909A.8010004-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sebastian Riemer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Cc: Shlomo Pongratz <shlomop-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 05/21/2013 05:19 PM, Jack Wang wrote:
> On 05/21/2013 02:51 PM, Sebastian Riemer wrote:
>> On 17.05.2013 16:16, Jack Wang wrote:
>>> unable to handle kernel paging request
>>
>> Hi Jack,
>>
>> this should be related to the list corruption in IPoIB as list_del()
>> sets the LIST_POISON1 and LIST_POISON2 pointers.
>> Referencing these results in page faults according to the documentation
>> in the code.
>>
>> Cheers,
>> Sebastian
>>
> This bug is easy triggered with below inject_bug with iperf -P 50 &&
> switch ib mode in sync on both side.
> -- a/drivers/infiniband/ulp/ipoib/ipoib_cm.c
> +++ b/drivers/infiniband/ulp/ipoib/ipoib_cm.c
> @@ -1315,7 +1315,8 @@ static void ipoib_cm_tx_start(struct work_struct
> *work)
>  		netif_tx_lock_bh(dev);
>  		spin_lock_irqsave(&priv->lock, flags);
> 
> -		if (ret) {
> +		if (ret || priv->inject_bug) {
> +			priv->inject_bug = 0;
>  			neigh = p->neigh;
>  			if (neigh) {
>  				neigh->cm = NULL;
> 
> It turned into another panic after patch list_del to list_del_init, I'm
> managing to get the back trace.
> 

Some trace I got during testing, Dear IPoIB expert, could you give some
suggestion? It looks like some object life time issues?



May 21 15:12:03 ib2 kernel: [  415.050021] general protection fault:
0000 [#1] SMP
May 21 15:12:03 ib2 kernel: [  415.050114] CPU 2
May 21 15:12:03 ib2 kernel: [  415.050142] Modules linked in:
ib_ipoib(O) rdma_ucm rdma_cm iw_cm ib_addr ib_cm ib_sa ib_uverbs ib_umad
mlx4_ib ib_mad ib_core ip6table_filter ip6_tables iptable_filter
ip_tables ebtable_nat ebtables x_tables cpufreq_powersave
cpufreq_conservative cpufreq_stats cpufreq_userspace binfmt_misc fuse
loop kvm_amd kvm tpm_tis powernow_k8 shpchp tpm processor mperf
edac_core tpm_bios psmouse edac_mce_amd pci_hotplug microcode evdev
serio_raw i2c_piix4 asus_atk0110 thermal_sys button dm_multipath scsi_dh
mlx4_en sg sd_mod crc_t10dif r8169 ahci libahci libata scsi_mod
mlx4_core [last unloaded: ib_ipoib]
May 21 15:12:03 ib2 kernel: [  415.051845]
May 21 15:12:03 ib2 kernel: [  415.051886] Pid: 3166, comm: kworker/2:0
Tainted: G           O 3.4.23-pserver-hotfix+ #109 System manufacturer
System Product Name/M4A89GTD-PRO
May 21 15:12:03 ib2 kernel: [  415.052019] RIP:
0010:[<ffffffffa01c8bf9>]  [<ffffffffa01c8bf9>] ib_modify_qp+0x9/0x20
[ib_core]
May 21 15:12:03 ib2 kernel: [  415.052106] RSP: 0018:ffff88020efd3b00
EFLAGS: 00010246
May 21 15:12:03 ib2 kernel: [  415.052148] RAX: 0000000000000000 RBX:
0000000000000000 RCX: 0000000000000000
May 21 15:12:03 ib2 kernel: [  415.052190] RDX: 0000000000129181 RSI:
ffff88020efd3b20 RDI: dead4ead00000000
May 21 15:12:03 ib2 kernel: [  415.052233] RBP: ffff88020efd3b00 R08:
0000000000000000 R09: 0000000000000001
May 21 15:12:03 ib2 kernel: [  415.052275] R10: 0000000000000000 R11:
0000000000000000 R12: ffff8801fb698c60
May 21 15:12:03 ib2 kernel: [  415.052317] R13: ffff88020efd3b20 R14:
ffff8802101fdc00 R15: ffffffff81e14250
May 21 15:12:03 ib2 kernel: [  415.052360] FS:  00007f8c38a05700(0000)
GS:ffff88021fc80000(0000) knlGS:0000000000000000
May 21 15:12:03 ib2 kernel: [  415.052415] CS:  0010 DS: 0000 ES: 0000
CR0: 000000008005003b
May 21 15:12:03 ib2 kernel: [  415.052457] CR2: 00007f8c38535d70 CR3:
0000000001c0b000 CR4: 00000000000007e0
May 21 15:12:03 ib2 kernel: [  415.052500] DR0: 0000000000000000 DR1:
0000000000000000 DR2: 0000000000000000
May 21 15:12:03 ib2 kernel: [  415.052542] DR3: 0000000000000000 DR6:
00000000ffff0ff0 DR7: 0000000000000400
May 21 15:12:03 ib2 kernel: [  415.052585] Process kworker/2:0 (pid:
3166, threadinfo ffff88020efd2000, task ffff88021228bf00)
May 21 15:12:03 ib2 kernel: [  415.052640] Stack:
May 21 15:12:03 ib2 kernel: [  415.052678]  ffff88020efd3c40
ffffffffa02bfcb9 0000000000000000 001291811228bf00
May 21 15:12:03 ib2 kernel: [  415.052834]  ffffffff00000002
ffff880200000005 000000008173c557 0008005eefed5918
May 21 15:12:03 ib2 kernel: [  415.052988]  ffffffff81e12e00
0000000000000080 ffff88020efd3b70 0000000000000000
May 21 15:12:03 ib2 kernel: [  415.053143] Call Trace:
May 21 15:12:03 ib2 kernel: [  415.053188]  [<ffffffffa02bfcb9>]
ipoib_cm_rep_handler+0x99/0x2c0 [ib_ipoib]
May 21 15:12:03 ib2 kernel: [  415.053233]  [<ffffffff8109c0bd>] ?
trace_hardirqs_off+0xd/0x10
May 21 15:12:03 ib2 kernel: [  415.053277]  [<ffffffff8173c557>] ?
_raw_spin_unlock_irqrestore+0x77/0x80
May 21 15:12:03 ib2 kernel: [  415.053322]  [<ffffffff8105c913>] ?
__queue_work+0x103/0x4a0
May 21 15:12:03 ib2 kernel: [  415.053364]  [<ffffffff8109c009>] ?
trace_hardirqs_off_caller+0x29/0xd0
May 21 15:12:03 ib2 kernel: [  415.053409]  [<ffffffffa02c0373>]
ipoib_cm_tx_handler+0x93/0x2b0 [ib_ipoib]
May 21 15:12:03 ib2 kernel: [  415.053452]  [<ffffffff8109c0bd>] ?
trace_hardirqs_off+0xd/0x10
May 21 15:12:03 ib2 kernel: [  415.053497]  [<ffffffffa0141cc5>]
cm_process_work+0x25/0x120 [ib_cm]
May 21 15:12:03 ib2 kernel: [  415.053540]  [<ffffffffa0142508>]
cm_rep_handler+0x308/0x590 [ib_cm]
May 21 15:12:03 ib2 kernel: [  415.053585]  [<ffffffffa0143c65>]
cm_work_handler+0x145/0x1070 [ib_cm]
May 21 15:12:03 ib2 kernel: [  415.053628]  [<ffffffff8105daea>]
process_one_work+0x19a/0x5c0
May 21 15:12:03 ib2 kernel: [  415.053670]  [<ffffffff8105da7d>] ?
process_one_work+0x12d/0x5c0
May 21 15:12:03 ib2 kernel: [  415.053713]  [<ffffffffa0143b20>] ?
cm_req_handler+0xa40/0xa40 [ib_cm]
May 21 15:12:03 ib2 kernel: [  415.053757]  [<ffffffff8105f865>]
worker_thread+0x175/0x380
May 21 15:12:03 ib2 kernel: [  415.053799]  [<ffffffff8105f6f0>] ?
manage_workers+0x210/0x210
May 21 15:12:03 ib2 kernel: [  415.053841]  [<ffffffff81064e0e>]
kthread+0xbe/0xd0
May 21 15:12:03 ib2 kernel: [  415.053884]  [<ffffffff8109f2b0>] ?
trace_hardirqs_on_caller+0x20/0x1b0
May 21 15:12:03 ib2 kernel: [  415.053928]  [<ffffffff817465b4>]
kernel_thread_helper+0x4/0x10
May 21 15:12:03 ib2 kernel: [  415.053972]  [<ffffffff8173c4c0>] ?
_raw_spin_unlock_irq+0x30/0x50
May 21 15:12:03 ib2 kernel: [  415.054015]  [<ffffffff8109f44d>] ?
trace_hardirqs_on+0xd/0x10
May 21 15:12:03 ib2 kernel: [  415.054058]  [<ffffffff8173c8b0>] ?
retint_restore_args+0x13/0x13
May 21 15:12:03 ib2 kernel: [  415.054100]  [<ffffffff81064d50>] ?
__init_kthread_worker+0x70/0x70
May 21 15:12:03 ib2 kernel: [  415.054144]  [<ffffffff817465b0>] ?
gs_change+0x13/0x13
May 21 15:12:03 ib2 kernel: [  415.054185] Code: ff ff 31 c0 eb d6 0f 1f
40 00 83 ca 01 c9 09 c2 31 c0 f7 d2 85 ca 0f 94 c0 c3 0f 1f 84 00 00 00
00 00 55 48 89 e5 66 66 66 66 90 <48> 8b 07 31 c9 48 8b 7f 58 ff 90 30
02 00 00 c9 c3 66 0f 1f 44
May 21 15:12:03 ib2 kernel: [  415.055875] RIP  [<ffffffffa01c8bf9>]
ib_modify_qp+0x9/0x20 [ib_core]
May 21 15:12:03 ib2 kernel: [  415.055945]  RSP <ffff88020efd3b00>
May 21 15:12:03 ib2 kernel: [  415.056011] ---[ end trace
871425e942ec1142 ]---
(gdb) list *ib_modify_qp+0x9
0xbf9 is in ib_modify_qp (drivers/infiniband/core/verbs.c:807).
802	
803	int ib_modify_qp(struct ib_qp *qp,
804			 struct ib_qp_attr *qp_attr,
805			 int qp_attr_mask)
806	{
807		return qp->device->modify_qp(qp->real_qp, qp_attr, qp_attr_mask, NULL);
808	}
809	EXPORT_SYMBOL(ib_modify_qp);
810	
811	int ib_query_qp(struct ib_qp *qp,



May 21 15:12:03 ib2 kernel: [  415.056065] BUG: unable to handle kernel
paging request at fffffffffffffff8
May 21 15:12:03 ib2 kernel: [  415.056164] IP: [<ffffffff81064700>]
kthread_data+0x10/0x20
May 21 15:12:03 ib2 kernel: [  415.056236] PGD 1c0d067 PUD 1c0e067 PMD 0
May 21 15:12:03 ib2 kernel: [  415.056358] Oops: 0000 [#2] SMP
May 21 15:12:03 ib2 kernel: [  415.056449] CPU 2
May 21 15:12:05 ib2 kernel: [  415.056477] Modules linked in:
ib_ipoib(O) rdma_ucm rdma_cm iw_cm ib_addr ib_cm ib_sa ib_uverbs ib_umad
mlx4_ib ib_mad ib_core ip6table_filter ip6_tables iptable_filter
ip_tables ebtable_nat ebtables x_tables cpufreq_powersave
cpufreq_conservative cpufreq_stats cpufreq_userspace binfmt_misc fuse
loop kvm_amd kvm tpm_tis powernow_k8 shpchp tpm processor mperf
edac_core tpm_bios psmouse edac_mce_amd pci_hotplug microcode evdev
serio_raw i2c_piix4 asus_atk0110 thermal_sys button dm_multipath scsi_dh
mlx4_en sg sd_mod crc_t10dif r8169 ahci libahci libata scsi_mod
mlx4_core [last unloaded: ib_ipoib]
May 21 15:12:05 ib2 kernel: [  415.058609]
May 21 15:12:05 ib2 kernel: [  415.058648] Pid: 3166, comm: kworker/2:0
Tainted: G      D    O 3.4.23-pserver-hotfix+ #109 System manufacturer
System Product Name/M4A89GTD-PRO
May 21 15:12:05 ib2 kernel: [  415.058783] RIP:
0010:[<ffffffff81064700>]  [<ffffffff81064700>] kthread_data+0x10/0x20
May 21 15:12:05 ib2 kernel: [  415.058866] RSP: 0018:ffff88020efd3858
EFLAGS: 00010092
May 21 15:12:05 ib2 kernel: [  415.058909] RAX: 0000000000000000 RBX:
0000000000000002 RCX: 0000000000000002
May 21 15:12:05 ib2 kernel: [  415.058954] RDX: ffffffff81e138c0 RSI:
0000000000000002 RDI: ffff88021228bf00
May 21 15:12:05 ib2 kernel: [  415.058997] RBP: ffff88020efd3858 R08:
ffff88021228bf70 R09: 0000000000000001
May 21 15:12:05 ib2 kernel: [  415.059041] R10: 0000000000000800 R11:
0000000000000000 R12: 0000000000000002
May 21 15:12:05 ib2 kernel: [  415.059085] R13: ffff88021228c2c8 R14:
ffff88020efd3688 R15: ffffffff81e14250
May 21 15:12:05 ib2 kernel: [  415.059128] FS:  00007f8c38a05700(0000)
GS:ffff88021fc80000(0000) knlGS:0000000000000000
May 21 15:12:05 ib2 kernel: [  415.059187] CS:  0010 DS: 0000 ES: 0000
CR0: 000000008005003b
May 21 15:12:05 ib2 kernel: [  415.059230] CR2: fffffffffffffff8 CR3:
0000000001c0b000 CR4: 00000000000007e0
May 21 15:12:05 ib2 kernel: [  415.059274] DR0: 0000000000000000 DR1:
0000000000000000 DR2: 0000000000000000
May 21 15:12:05 ib2 kernel: [  415.059317] DR3: 0000000000000000 DR6:
00000000ffff0ff0 DR7: 0000000000000400
May 21 15:12:05 ib2 kernel: [  415.059362] Process kworker/2:0 (pid:
3166, threadinfo ffff88020efd2000, task ffff88021228bf00)
May 21 15:12:05 ib2 kernel: [  415.059420] Stack:
May 21 15:12:05 ib2 kernel: [  415.059460]  ffff88020efd3878
ffffffff8105c735 ffff88020efd3878 ffff88021fc92f40
May 21 15:12:05 ib2 kernel: [  415.059616]  ffff88020efd3908
ffffffff8173a963 ffff880200000000 ffff88020efd2000
May 21 15:12:05 ib2 kernel: [  415.059771]  ffff88020efd3fd8
ffff88020efd2000 ffff88020efd2010 ffff88020efd2000
May 21 15:12:05 ib2 kernel: [  415.059928] Call Trace:
May 21 15:12:05 ib2 kernel: [  415.059969]  [<ffffffff8105c735>]
wq_worker_sleeping+0x15/0xa0
May 21 15:12:05 ib2 kernel: [  415.060013]  [<ffffffff8173a963>]
__schedule+0x6a3/0x940
May 21 15:12:05 ib2 kernel: [  415.060056]  [<ffffffff8173acc9>]
schedule+0x29/0x70
May 21 15:12:05 ib2 kernel: [  415.060098]  [<ffffffff81042105>]
do_exit+0x615/0xa40
May 21 15:12:05 ib2 kernel: [  415.060141]  [<ffffffff8103e6c1>] ?
kmsg_dump+0x81/0x300
May 21 15:12:05 ib2 kernel: [  415.060184]  [<ffffffff8173d6db>]
oops_end+0xab/0xf0
May 21 15:12:05 ib2 kernel: [  415.060228]  [<ffffffff8100570b>]
die+0x5b/0x90
May 21 15:12:05 ib2 kernel: [  415.060270]  [<ffffffff8173d274>]
do_general_protection+0x164/0x170
May 21 15:12:05 ib2 kernel: [  415.060315]  [<ffffffff8173c8e0>] ?
restore_args+0x30/0x30
May 21 15:12:05 ib2 kernel: [  415.060358]  [<ffffffff8173ca95>]
general_protection+0x25/0x30
May 21 15:12:05 ib2 kernel: [  415.060404]  [<ffffffffa01c8bf9>] ?
ib_modify_qp+0x9/0x20 [ib_core]
May 21 15:12:05 ib2 kernel: [  415.060449]  [<ffffffffa02bfcb9>]
ipoib_cm_rep_handler+0x99/0x2c0 [ib_ipoib]
May 21 15:12:05 ib2 kernel: [  415.060493]  [<ffffffff8109c0bd>] ?
trace_hardirqs_off+0xd/0x10
May 21 15:12:05 ib2 kernel: [  415.060536]  [<ffffffff8173c557>] ?
_raw_spin_unlock_irqrestore+0x77/0x80
May 21 15:12:05 ib2 kernel: [  415.060579]  [<ffffffff8105c913>] ?
__queue_work+0x103/0x4a0
May 21 15:12:05 ib2 kernel: [  415.060625]  [<ffffffff8109c009>] ?
trace_hardirqs_off_caller+0x29/0xd0
May 21 15:12:05 ib2 kernel: [  415.060670]  [<ffffffffa02c0373>]
ipoib_cm_tx_handler+0x93/0x2b0 [ib_ipoib]
May 21 15:12:05 ib2 kernel: [  415.060714]  [<ffffffff8109c0bd>] ?
trace_hardirqs_off+0xd/0x10
May 21 15:12:05 ib2 kernel: [  415.060757]  [<ffffffffa0141cc5>]
cm_process_work+0x25/0x120 [ib_cm]
May 21 15:12:05 ib2 kernel: [  415.060801]  [<ffffffffa0142508>]
cm_rep_handler+0x308/0x590 [ib_cm]
May 21 15:12:05 ib2 kernel: [  415.060844]  [<ffffffffa0143c65>]
cm_work_handler+0x145/0x1070 [ib_cm]
May 21 15:12:05 ib2 kernel: [  415.060887]  [<ffffffff8105daea>]
process_one_work+0x19a/0x5c0
May 21 15:12:05 ib2 kernel: [  415.060930]  [<ffffffff8105da7d>] ?
process_one_work+0x12d/0x5c0
May 21 15:12:05 ib2 kernel: [  415.060973]  [<ffffffffa0143b20>] ?
cm_req_handler+0xa40/0xa40 [ib_cm]
May 21 15:12:05 ib2 kernel: [  415.061016]  [<ffffffff8105f865>]
worker_thread+0x175/0x380
May 21 15:12:05 ib2 kernel: [  415.061059]  [<ffffffff8105f6f0>] ?
manage_workers+0x210/0x210
May 21 15:12:05 ib2 kernel: [  415.061102]  [<ffffffff81064e0e>]
kthread+0xbe/0xd0
May 21 15:12:05 ib2 kernel: [  415.061144]  [<ffffffff8109f2b0>] ?
trace_hardirqs_on_caller+0x20/0x1b0
May 21 15:12:05 ib2 kernel: [  415.061188]  [<ffffffff817465b4>]
kernel_thread_helper+0x4/0x10
May 21 15:12:05 ib2 kernel: [  415.061234]  [<ffffffff8173c4c0>] ?
_raw_spin_unlock_irq+0x30/0x50
May 21 15:12:05 ib2 kernel: [  415.061277]  [<ffffffff8109f44d>] ?
trace_hardirqs_on+0xd/0x10
May 21 15:12:05 ib2 kernel: [  415.061319]  [<ffffffff8173c8b0>] ?
retint_restore_args+0x13/0x13
May 21 15:12:05 ib2 kernel: [  415.061363]  [<ffffffff81064d50>] ?
__init_kthread_worker+0x70/0x70
May 21 15:12:05 ib2 kernel: [  415.061406]  [<ffffffff817465b0>] ?
gs_change+0x13/0x13
May 21 15:12:05 ib2 kernel: [  415.061447] Code: 66 66 66 90 65 48 8b 04
25 80 b9 00 00 48 8b 80 70 03 00 00 8b 40 f0 c9 c3 66 90 55 48 89 e5 66
66 66 66 90 48 8b 87 70 03 00 00 <48> 8b 40 f8 c9 c3 66 2e 0f 1f 84 00
00 00 00 00 55 48 89 e5 66
May 21 15:12:05 ib2 kernel: [  415.063139] RIP  [<ffffffff81064700>]
kthread_data+0x10/0x20
May 21 15:12:05 ib2 kernel: [  415.063205]  RSP <ffff88020efd3858>
May 21 15:12:05 ib2 kernel: [  415.063245] CR2: fffffffffffffff8
May 21 15:12:05 ib2 kernel: [  415.063285] ---[ end trace
871425e942ec1143 ]---
May 21 15:12:05 ib2 kernel: [  415.063326] Fixing recursive fault but
reboot is needed!
May 21 15:12:05 ib2 kernel: [  417.441382] ib0: enabling connected mode
will cause multicast packet drops
May 21 15:12:07 ib2 kernel: [  419.840353] ib0: enabling connected mode
will cause multicast packet drops
May 21 15:12:10 ib2 kernel: [  422.198880] ib0: enabling connected mode
will cause multicast packet drops
May 21 15:12:12 ib2 kernel: [  424.597641] ib0: enabling connected mode
will cause multicast packet drops
May 21 15:12:14 ib2 kernel: [  426.956288] ib0: enabling connected mode
will cause multicast packet drops
May 21 15:12:17 ib2 kernel: [  429.355047] ib0: enabling connected mode
will cause multicast packet drops
May 21 15:12:19 ib2 kernel: [  431.753621] ib0: enabling connected mode
will cause multicast packet drops
May 21 15:12:22 ib2 kernel: [  434.122390] ib0: enabling connected mode
will cause multicast packet drops
May 21 15:12:24 ib2 kernel: [  436.521068] ib0: enabling connected mode
will cause multicast packet drops
May 21 15:12:26 ib2 kernel: [  436.660137] ------------[ cut here
]------------
May 21 15:12:26 ib2 kernel: [  436.660216] WARNING: at
kernel/watchdog.c:241 watchdog_overflow_callback+0x98/0xc0()
May 21 15:12:26 ib2 kernel: [  436.660272] Hardware name: System Product
Name
May 21 15:12:26 ib2 kernel: [  436.660313] Watchdog detected hard LOCKUP
on cpu 2
May 21 15:12:26 ib2 kernel: [  436.660341] Modules linked in:
ib_ipoib(O) rdma_ucm rdma_cm iw_cm ib_addr ib_cm ib_sa ib_uverbs ib_umad
mlx4_ib ib_mad ib_core ip6table_filter ip6_tables iptable_filter
ip_tables ebtable_nat ebtables x_tables cpufreq_powersave
cpufreq_conservative cpufreq_stats cpufreq_userspace binfmt_misc fuse
loop kvm_amd kvm tpm_tis powernow_k8 shpchp tpm processor mperf
edac_core tpm_bios psmouse edac_mce_amd pci_hotplug microcode evdev
serio_raw i2c_piix4 asus_atk0110 thermal_sys button dm_multipath scsi_dh
mlx4_en sg sd_mod crc_t10dif r8169 ahci libahci libata scsi_mod
mlx4_core [last unloaded: ib_ipoib]
May 21 15:12:26 ib2 kernel: [  436.662032] Pid: 3166, comm: kworker/2:0
Tainted: G      D    O 3.4.23-pserver-hotfix+ #109
May 21 15:12:26 ib2 kernel: [  436.662088] Call Trace:
May 21 15:12:26 ib2 kernel: [  436.662127]  <NMI>  [<ffffffff8103c2cf>]
warn_slowpath_common+0x7f/0xc0
May 21 15:12:26 ib2 kernel: [  436.662197]  [<ffffffff8103c3c6>]
warn_slowpath_fmt+0x46/0x50
May 21 15:12:26 ib2 kernel: [  436.662239]  [<ffffffff8109c009>] ?
trace_hardirqs_off_caller+0x29/0xd0
May 21 15:12:26 ib2 kernel: [  436.662283]  [<ffffffff810cd968>]
watchdog_overflow_callback+0x98/0xc0
May 21 15:12:26 ib2 kernel: [  436.662327]  [<ffffffff811077dc>]
__perf_event_overflow+0x9c/0x320
May 21 15:12:26 ib2 kernel: [  436.662370]  [<ffffffff811087ec>] ?
perf_event_update_userpage+0x16c/0x2c0
May 21 15:12:26 ib2 kernel: [  436.662415]  [<ffffffff81108680>] ?
perf_event_mmap_ctx+0x170/0x170
May 21 15:12:26 ib2 kernel: [  436.662458]  [<ffffffff81107f74>]
perf_event_overflow+0x14/0x20
May 21 15:12:26 ib2 kernel: [  436.662501]  [<ffffffff81013f27>]
x86_pmu_handle_irq+0x1b7/0x220
May 21 15:12:26 ib2 kernel: [  436.662545]  [<ffffffff8173e341>]
perf_event_nmi_handler+0x21/0x30
May 21 15:12:26 ib2 kernel: [  436.662588]  [<ffffffff8173d8a6>]
nmi_handle+0xb6/0x200
May 21 15:12:26 ib2 kernel: [  436.662631]  [<ffffffff8173d7f0>] ?
oops_begin+0xd0/0xd0
May 21 15:12:26 ib2 kernel: [  436.662673]  [<ffffffff8173db1d>]
do_nmi+0x12d/0x350
May 21 15:12:26 ib2 kernel: [  436.662715]  [<ffffffff8173ceac>]
end_repeat_nmi+0x1a/0x1e
May 21 15:12:26 ib2 kernel: [  436.662758]  [<ffffffff81420d14>] ?
delay_tsc+0x34/0xb0
May 21 15:12:26 ib2 kernel: [  436.662800]  [<ffffffff81420d14>] ?
delay_tsc+0x34/0xb0
May 21 15:12:26 ib2 kernel: [  436.662842]  [<ffffffff81420d14>] ?
delay_tsc+0x34/0xb0
May 21 15:12:26 ib2 kernel: [  436.662883]  <<EOE>>
[<ffffffff81420c8f>] __delay+0xf/0x20
May 21 15:12:26 ib2 kernel: [  436.662952]  [<ffffffff814285a3>]
do_raw_spin_lock+0xd3/0x140
May 21 15:12:26 ib2 kernel: [  436.662995]  [<ffffffff8173bc74>]
_raw_spin_lock_irq+0x54/0x60
May 21 15:12:26 ib2 kernel: [  436.663037]  [<ffffffff8173a3e0>] ?
__schedule+0x120/0x940
May 21 15:12:26 ib2 kernel: [  436.663080]  [<ffffffff8173a3e0>]
__schedule+0x120/0x940
May 21 15:12:26 ib2 kernel: [  436.663122]  [<ffffffff8173acc9>]
schedule+0x29/0x70
May 21 15:12:26 ib2 kernel: [  436.663164]  [<ffffffff81042293>]
do_exit+0x7a3/0xa40
May 21 15:12:26 ib2 kernel: [  436.663206]  [<ffffffff8103e7fe>] ?
kmsg_dump+0x1be/0x300
May 21 15:12:26 ib2 kernel: [  436.663248]  [<ffffffff8103e6c1>] ?
kmsg_dump+0x81/0x300
May 21 15:12:26 ib2 kernel: [  436.663291]  [<ffffffff817387f9>] ?
printk+0x41/0x48
May 21 15:12:26 ib2 kernel: [  436.663333]  [<ffffffff8173d6db>]
oops_end+0xab/0xf0
May 21 15:12:26 ib2 kernel: [  436.663376]  [<ffffffff8102f6bd>]
no_context+0x11d/0x2d0
May 21 15:12:26 ib2 kernel: [  436.663418]  [<ffffffff810afbf0>] ?
kallsyms_lookup+0x60/0xe0
May 21 15:12:26 ib2 kernel: [  436.663462]  [<ffffffff8102f9ad>]
__bad_area_nosemaphore+0x13d/0x220
May 21 15:12:26 ib2 kernel: [  436.663505]  [<ffffffff8102faa3>]
bad_area_nosemaphore+0x13/0x20
May 21 15:12:26 ib2 kernel: [  436.663548]  [<ffffffff81740603>]
do_page_fault+0x3a3/0x4e0
May 21 15:12:26 ib2 kernel: [  436.663590]  [<ffffffff8173cd06>] ?
error_sti+0x5/0x6
May 21 15:12:26 ib2 kernel: [  436.663632]  [<ffffffff8109c009>] ?
trace_hardirqs_off_caller+0x29/0xd0
May 21 15:12:26 ib2 kernel: [  436.663676]  [<ffffffff8142211d>] ?
trace_hardirqs_off_thunk+0x3a/0x3c
May 21 15:12:26 ib2 kernel: [  436.663719]  [<ffffffff8173cac5>]
page_fault+0x25/0x30
May 21 15:12:26 ib2 kernel: [  436.663762]  [<ffffffff81064700>] ?
kthread_data+0x10/0x20
May 21 15:12:26 ib2 kernel: [  436.663804]  [<ffffffff8105c735>]
wq_worker_sleeping+0x15/0xa0
May 21 15:12:26 ib2 kernel: [  436.663848]  [<ffffffff8173a963>]
__schedule+0x6a3/0x940
May 21 15:12:26 ib2 kernel: [  436.663890]  [<ffffffff8173acc9>]
schedule+0x29/0x70
May 21 15:12:26 ib2 kernel: [  436.663932]  [<ffffffff81042105>]
do_exit+0x615/0xa40
May 21 15:12:26 ib2 kernel: [  436.663974]  [<ffffffff8103e6c1>] ?
kmsg_dump+0x81/0x300
May 21 15:12:26 ib2 kernel: [  436.664017]  [<ffffffff8173d6db>]
oops_end+0xab/0xf0
May 21 15:12:26 ib2 kernel: [  436.664059]  [<ffffffff8100570b>]
die+0x5b/0x90
May 21 15:12:26 ib2 kernel: [  436.664102]  [<ffffffff8173d274>]
do_general_protection+0x164/0x170
May 21 15:12:26 ib2 kernel: [  436.664145]  [<ffffffff8173c8e0>] ?
restore_args+0x30/0x30
May 21 15:12:26 ib2 kernel: [  436.664188]  [<ffffffff8173ca95>]
general_protection+0x25/0x30
May 21 15:12:26 ib2 kernel: [  436.664233]  [<ffffffffa01c8bf9>] ?
ib_modify_qp+0x9/0x20 [ib_core]
May 21 15:12:26 ib2 kernel: [  436.664277]  [<ffffffffa02bfcb9>]
ipoib_cm_rep_handler+0x99/0x2c0 [ib_ipoib]
May 21 15:12:26 ib2 kernel: [  436.664321]  [<ffffffff8109c0bd>] ?
trace_hardirqs_off+0xd/0x10
May 21 15:12:26 ib2 kernel: [  436.664363]  [<ffffffff8173c557>] ?
_raw_spin_unlock_irqrestore+0x77/0x80
May 21 15:12:26 ib2 kernel: [  436.664407]  [<ffffffff8105c913>] ?
__queue_work+0x103/0x4a0
May 21 15:12:26 ib2 kernel: [  436.664450]  [<ffffffff8109c009>] ?
trace_hardirqs_off_caller+0x29/0xd0
May 21 15:12:26 ib2 kernel: [  436.664495]  [<ffffffffa02c0373>]
ipoib_cm_tx_handler+0x93/0x2b0 [ib_ipoib]
May 21 15:12:26 ib2 kernel: [  436.664538]  [<ffffffff8109c0bd>] ?
trace_hardirqs_off+0xd/0x10
May 21 15:12:26 ib2 kernel: [  436.664583]  [<ffffffffa0141cc5>]
cm_process_work+0x25/0x120 [ib_cm]
May 21 15:12:26 ib2 kernel: [  436.664627]  [<ffffffffa0142508>]
cm_rep_handler+0x308/0x590 [ib_cm]
May 21 15:12:26 ib2 kernel: [  436.664671]  [<ffffffffa0143c65>]
cm_work_handler+0x145/0x1070 [ib_cm]
May 21 15:12:26 ib2 kernel: [  436.664714]  [<ffffffff8105daea>]
process_one_work+0x19a/0x5c0
May 21 15:12:26 ib2 kernel: [  436.664756]  [<ffffffff8105da7d>] ?
process_one_work+0x12d/0x5c0
May 21 15:12:26 ib2 kernel: [  436.664800]  [<ffffffffa0143b20>] ?
cm_req_handler+0xa40/0xa40 [ib_cm]
May 21 15:12:26 ib2 kernel: [  436.664843]  [<ffffffff8105f865>]
worker_thread+0x175/0x380
May 21 15:12:26 ib2 kernel: [  436.664886]  [<ffffffff8105f6f0>] ?
manage_workers+0x210/0x210
May 21 15:12:26 ib2 kernel: [  436.664929]  [<ffffffff81064e0e>]
kthread+0xbe/0xd0
May 21 15:12:26 ib2 kernel: [  436.664972]  [<ffffffff8109f2b0>] ?
trace_hardirqs_on_caller+0x20/0x1b0
May 21 15:12:26 ib2 kernel: [  436.665015]  [<ffffffff817465b4>]
kernel_thread_helper+0x4/0x10
May 21 15:12:26 ib2 kernel: [  436.665059]  [<ffffffff8173c4c0>] ?
_raw_spin_unlock_irq+0x30/0x50
May 21 15:12:26 ib2 kernel: [  436.665102]  [<ffffffff8109f44d>] ?
trace_hardirqs_on+0xd/0x10
May 21 15:12:26 ib2 kernel: [  436.665145]  [<ffffffff8173c8b0>] ?
retint_restore_args+0x13/0x13
May 21 15:12:26 ib2 kernel: [  436.665187]  [<ffffffff81064d50>] ?
__init_kthread_worker+0x70/0x70
May 21 15:12:26 ib2 kernel: [  436.665231]  [<ffffffff817465b0>] ?
gs_change+0x13/0x13
May 21 15:12:26 ib2 kernel: [  436.665273] ---[ end trace
871425e942ec1144 ]---
May 21 15:12:26 ib2 kernel: [  438.919742] ib0: enabling connected mode
will cause multicast packet drops
May 21 15:12:29 ib2 kernel: [  441.318429] ib0: enabling connected mode
will cause multicast packet drops
May 21 15:12:31 ib2 kernel: [  443.717220] ib0: enabling connected mode
will cause multicast packet drops
May 21 15:12:34 ib2 kernel: [  446.115789] ib0: enabling connected mode
will cause multicast packet drops
May 21 15:12:36 ib2 kernel: [  448.514602] ib0: enabling connected mode
will cause multicast packet drops
May 21 15:12:38 ib2 kernel: [  450.913390] ib0: enabling connected mode
will cause multicast packet drops
May 21 15:12:41 ib2 kernel: [  453.271906] ib0: enabling connected mode
will cause multicast packet drops
May 21 15:12:43 ib2 kernel: [  455.670796] ib0: enabling connected mode
will cause multicast packet drops
May 21 15:12:46 ib2 kernel: [  458.069297] ib0: enabling connected mode
will cause multicast packet drops
May 21 15:12:48 ib2 kernel: [  460.438309] ib0: enabling connected mode
will cause multicast packet drops
May 21 15:12:50 ib2 kernel: [  462.836738] ib0: enabling connected mode
will cause multicast packet drops
May 21 15:12:53 ib2 kernel: [  465.235553] ib0: enabling connected mode
will cause multicast packet drops
May 21 15:12:55 ib2 kernel: [  467.634331] ib0: enabling connected mode
will cause multicast packet drops
May 21 15:12:58 ib2 kernel: [  468.407807] ------------[ cut here
]------------
May 21 15:12:58 ib2 kernel: [  468.407897] WARNING: at
kernel/watchdog.c:241 watchdog_overflow_callback+0x98/0xc0()
May 21 15:12:58 ib2 kernel: [  468.407957] Hardware name: System Product
Name
May 21 15:12:58 ib2 kernel: [  468.408001] Watchdog detected hard LOCKUP
on cpu 1
May 21 15:12:58 ib2 kernel: [  468.408032] Modules linked in:
ib_ipoib(O) rdma_ucm rdma_cm iw_cm ib_addr ib_cm ib_sa ib_uverbs ib_umad
mlx4_ib ib_mad ib_core ip6table_filter ip6_tables iptable_filter
ip_tables ebtable_nat ebtables x_tables cpufreq_powersave
cpufreq_conservative cpufreq_stats cpufreq_userspace binfmt_misc fuse
loop kvm_amd kvm tpm_tis powernow_k8 shpchp tpm processor mperf
edac_core tpm_bios psmouse edac_mce_amd pci_hotplug microcode evdev
serio_raw i2c_piix4 asus_atk0110 thermal_sys button dm_multipath scsi_dh
mlx4_en sg sd_mod crc_t10dif r8169 ahci libahci libata scsi_mod
mlx4_core [last unloaded: ib_ipoib]
May 21 15:12:58 ib2 kernel: [  468.409806] Pid: 0, comm: swapper/1
Tainted: G      D W  O 3.4.23-pserver-hotfix+ #109
May 21 15:12:58 ib2 kernel: [  468.409866] Call Trace:
May 21 15:12:58 ib2 kernel: [  468.409908]  <NMI>  [<ffffffff8103c2cf>]
warn_slowpath_common+0x7f/0xc0
May 21 15:12:58 ib2 kernel: [  468.409986]  [<ffffffff8103c3c6>]
warn_slowpath_fmt+0x46/0x50
May 21 15:12:58 ib2 kernel: [  468.410033]  [<ffffffff8109c009>] ?
trace_hardirqs_off_caller+0x29/0xd0
May 21 15:12:58 ib2 kernel: [  468.410081]  [<ffffffff810cd968>]
watchdog_overflow_callback+0x98/0xc0
May 21 15:12:58 ib2 kernel: [  468.410129]  [<ffffffff811077dc>]
__perf_event_overflow+0x9c/0x320
May 21 15:12:58 ib2 kernel: [  468.410177]  [<ffffffff811087ec>] ?
perf_event_update_userpage+0x16c/0x2c0
May 21 15:12:58 ib2 kernel: [  468.410225]  [<ffffffff81108680>] ?
perf_event_mmap_ctx+0x170/0x170
May 21 15:12:58 ib2 kernel: [  468.410272]  [<ffffffff81107f74>]
perf_event_overflow+0x14/0x20
May 21 15:12:58 ib2 kernel: [  468.410319]  [<ffffffff81013f27>]
x86_pmu_handle_irq+0x1b7/0x220
May 21 15:12:58 ib2 kernel: [  468.410368]  [<ffffffff8173e341>]
perf_event_nmi_handler+0x21/0x30
May 21 15:12:58 ib2 kernel: [  468.410416]  [<ffffffff8173d8a6>]
nmi_handle+0xb6/0x200
May 21 15:12:58 ib2 kernel: [  468.410462]  [<ffffffff8173d7f0>] ?
oops_begin+0xd0/0xd0
May 21 15:12:58 ib2 kernel: [  468.410508]  [<ffffffff8173db1d>]
do_nmi+0x12d/0x350
May 21 15:12:58 ib2 kernel: [  468.410554]  [<ffffffff8173ceac>]
end_repeat_nmi+0x1a/0x1e
May 21 15:12:58 ib2 kernel: [  468.410602]  [<ffffffff81420d41>] ?
delay_tsc+0x61/0xb0
May 21 15:12:58 ib2 kernel: [  468.410648]  [<ffffffff81420d41>] ?
delay_tsc+0x61/0xb0
May 21 15:12:58 ib2 kernel: [  468.410694]  [<ffffffff81420d41>] ?
delay_tsc+0x61/0xb0
May 21 15:12:58 ib2 kernel: [  468.410738]  <<EOE>>  <IRQ>
[<ffffffff81420c8f>] __delay+0xf/0x20
May 21 15:12:58 ib2 kernel: [  468.410839]  [<ffffffff814285a3>]
do_raw_spin_lock+0xd3/0x140
May 21 15:12:58 ib2 kernel: [  468.410885]  [<ffffffff8173bba8>]
_raw_spin_lock+0x48/0x50
May 21 15:12:58 ib2 kernel: [  468.410932]  [<ffffffff810834f2>] ?
sched_rt_period_timer+0xf2/0x270
May 21 15:12:58 ib2 kernel: [  468.410980]  [<ffffffff8173c58b>] ?
_raw_spin_unlock+0x2b/0x50
May 21 15:12:58 ib2 kernel: [  468.411027]  [<ffffffff810834f2>]
sched_rt_period_timer+0xf2/0x270
May 21 15:12:58 ib2 kernel: [  468.411075]  [<ffffffff81069ff6>]
__run_hrtimer+0x86/0x2f0
May 21 15:12:58 ib2 kernel: [  468.411121]  [<ffffffff81083400>] ?
init_rt_bandwidth+0x60/0x60
May 21 15:12:58 ib2 kernel: [  468.411168]  [<ffffffff8106a50e>]
hrtimer_interrupt+0xfe/0x270
May 21 15:12:58 ib2 kernel: [  468.411215]  [<ffffffff81746ea9>]
smp_apic_timer_interrupt+0x69/0x99
May 21 15:12:58 ib2 kernel: [  468.411263]  [<ffffffff81745caf>]
apic_timer_interrupt+0x6f/0x80
May 21 15:12:58 ib2 kernel: [  468.411308]  <EOI>  [<ffffffff8100bab1>]
? default_idle+0x61/0x320
May 21 15:12:58 ib2 kernel: [  468.411383]  [<ffffffff8109f44d>] ?
trace_hardirqs_on+0xd/0x10
May 21 15:12:58 ib2 kernel: [  468.411431]  [<ffffffff8102b3d6>] ?
native_safe_halt+0x6/0x10
May 21 15:12:58 ib2 kernel: [  468.411477]  [<ffffffff8109f44d>] ?
trace_hardirqs_on+0xd/0x10
May 21 15:12:58 ib2 kernel: [  468.411523]  [<ffffffff8100bab6>]
default_idle+0x66/0x320
May 21 15:12:58 ib2 kernel: [  468.411569]  [<ffffffff8100be02>]
amd_e400_idle+0x92/0x130
May 21 15:12:58 ib2 kernel: [  468.411617]  [<ffffffff8100af36>]
cpu_idle+0xf6/0x140
May 21 15:12:58 ib2 kernel: [  468.411664]  [<ffffffff81731d77>]
start_secondary+0x1ed/0x1f4
May 21 15:12:58 ib2 kernel: [  468.411709] ---[ end trace
871425e942ec1145 ]---
May 21 15:12:58 ib2 kernel: [  470.032848] ib0: enabling connected mode
will cause multicast packet drops
May 21 15:13:00 ib2 kernel: [  472.431601] ib0: enabling connected mode
will cause multicast packet drops
May 21 15:13:02 ib2 kernel: [  474.830297] ib0: enabling connected mode
will cause multicast packet drops
May 21 15:13:05 ib2 kernel: [  477.229094] ib0: enabling connected mode
will cause multicast packet drops
May 21 15:13:07 ib2 kernel: [  479.627563] ib0: enabling connected mode
will cause multicast packet drops
May 21 15:13:10 ib2 kernel: [  482.026253] ib0: enabling connected mode
will cause multicast packet drops
May 21 15:13:12 ib2 kernel: [  484.395049] ib0: enabling connected mode
will cause multicast packet drops
May 21 15:13:14 ib2 kernel: [  486.793758] ib0: enabling connected mode
will cause multicast packet drops
May 21 15:13:17 ib2 kernel: [  489.192468] ib0: enabling connected mode
will cause multicast packet drops


[  884.055635] general protection fault: 0000 [#1] SMP
[  884.055780] CPU 0
[  884.055821] Modules linked in: ib_ipoib(O) rdma_ucm rdma_cm iw_cm
ib_addr ib_cm ib_sa ib_uverbs ib_umad mlx4_ib ib_mad ib_core
ip6table_filter ip6_tables iptable_filter ip_tables ebtable_nat ebtables
x_tables cpufreq_powersave cpufreq_conservative cpufreq_stats
cpufreq_userspace binfmt_misc fuse loop kvm_amd kvm powernow_k8 psmouse
serio_raw mperf microcode tpm_tis tpm evdev edac_core tpm_bios
edac_mce_amd asus_atk0110 shpchp i2c_piix4 pci_hotplug processor
thermal_sys button dm_multipath scsi_dh mlx4_en sg sd_mod crc_t10dif
mlx4_core r8169 ahci libahci libata scsi_mod [last unloaded: ib_ipoib]
[  884.058726]
[  884.058788] Pid: 3001, comm: kworker/0:0 Tainted: G           O
3.4.23-pserver-hotfix+ #111 System manufacturer System Product
Name/M4A89GTD-PRO
[  884.059827] RIP: 0010:[<ffffffffa02dc3e0>]  [<ffffffffa02dc3e0>]
ipoib_cm_tx_handler+0x30/0x2b0 [ib_ipoib]
[  884.059952] RSP: 0018:ffff8801fad67c50  EFLAGS: 00010293
[  884.060015] RAX: ffff8801fad67fd8 RBX: ffff880211ed5d88 RCX:
0000000000000006
[  884.060080] RDX: 0000000000000003 RSI: ffff8801f664c0d8 RDI:
ffff880211ed5d88
[  884.060139] RBP: ffff8801fad67ca0 R08: 0000000000000001 R09:
0000000000000002
[  884.060198] R10: 0000000000000000 R11: 0000000000000000 R12:
ffff8801f664c000
[  884.060257] R13: ffff88020d110b98 R14: 6b6b6b6b6b6b756b R15:
ffff8801f664c0d8
[  884.060316] FS:  00007f11da415700(0000) GS:ffff88021fc00000(0000)
knlGS:0000000000000000
[  884.060390] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  884.060449] CR2: 00007f11d032c000 CR3: 00000001f16f5000 CR4:
00000000000007f0
[  884.060512] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
0000000000000000
[  884.060579] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7:
0000000000000400
[  884.060643] Process kworker/0:0 (pid: 3001, threadinfo
ffff8801fad66000, task ffff8801fb734180)
[  884.060717] Stack:
[  884.060777]  ffff8801fad67ca0 ffffffff8109f019 ffff8801fad67c70
ffffffff8109c0bd
[  884.061014]  ffff8801fad67c90 ffff880211ed5d88 ffff8801f664c000
ffff8801f664c000
[  884.061248]  ffff88020c031100 ffff8801fad67dc0 ffff8801fad67cf0
ffffffffa017fcc5
[  884.061486] Call Trace:
[  884.061544]  [<ffffffff8109f019>] ? mark_held_locks+0x79/0x120
[  884.061610]  [<ffffffff8109c0bd>] ? trace_hardirqs_off+0xd/0x10
[  884.061673]  [<ffffffffa017fcc5>] cm_process_work+0x25/0x120 [ib_cm]
[  884.061734]  [<ffffffffa0180508>] cm_rep_handler+0x308/0x590 [ib_cm]
[  884.061798]  [<ffffffffa0181c65>] cm_work_handler+0x145/0x1070 [ib_cm]
[  884.061867]  [<ffffffff8105daea>] process_one_work+0x19a/0x5c0
[  884.061929]  [<ffffffff8105da7d>] ? process_one_work+0x12d/0x5c0
[  884.061990]  [<ffffffffa0181b20>] ? cm_req_handler+0xa40/0xa40 [ib_cm]
[  884.062055]  [<ffffffff8105f865>] worker_thread+0x175/0x380
[  884.062116]  [<ffffffff8105f6f0>] ? manage_workers+0x210/0x210
[  884.062176]  [<ffffffff81064e0e>] kthread+0xbe/0xd0
[  884.062239]  [<ffffffff8109f2b0>] ? trace_hardirqs_on_caller+0x20/0x1b0
[  884.062302]  [<ffffffff81746734>] kernel_thread_helper+0x4/0x10
[  884.062792]  [<ffffffff8173ca30>] ? retint_restore_args+0x13/0x13
[  884.062853]  [<ffffffff81064d50>] ? __init_kthread_worker+0x70/0x70
[  884.062914]  [<ffffffff81746730>] ? gs_change+0x13/0x13
[  884.062974] Code: 57 41 56 41 55 41 54 53 48 83 ec 28 66 66 66 66 90
4c 8b 6f 08 8b 16 48 89 fb 49 89 f7 4d 8b 75 20 49 81 c6 00 0a 00 00 83
fa 0b <4d> 8b 66 38 77 2a 89 d0 ff 24 c5 90 08 2e a0 90 44 8b 1d a1 79
[  884.066632] RIP  [<ffffffffa02dc3e0>] ipoib_cm_tx_handler+0x30/0x2b0
[ib_ipoib]
[  884.066770]  RSP <ffff8801fad67c50>
[  884.066841] ---[ end trace fa3d54b0aa9bc9ce ]---
(gdb) list *ipoib_cm_tx_handler+0x30
0xa410 is in ipoib_cm_tx_handler
(drivers/infiniband/ulp/ipoib/ipoib_cm.c:1208).
1203	static int ipoib_cm_tx_handler(struct ib_cm_id *cm_id,
1204				       struct ib_cm_event *event)
1205	{
1206		struct ipoib_cm_tx *tx = cm_id->context;
1207		struct ipoib_dev_priv *priv = netdev_priv(tx->dev);
1208		struct net_device *dev = priv->dev;
1209		struct ipoib_neigh *neigh;
1210		unsigned long flags;
1211		int ret;
1212	



[  884.066926] BUG: unable to handle kernel paging request at
fffffffffffffff8
[  884.067090] IP: [<ffffffff81064700>] kthread_data+0x10/0x20
[  884.067210] PGD 1c0d067 PUD 1c0e067 PMD 0
[  884.067412] Oops: 0000 [#2] SMP
[  884.067565] CPU 0
[  884.067618] Modules linked in: ib_ipoib(O) rdma_ucm rdma_cm iw_cm
ib_addr ib_cm ib_sa ib_uverbs ib_umad mlx4_ib ib_mad ib_core
ip6table_filter ip6_tables iptable_filter ip_tables ebtable_nat ebtables
x_tables cpufreq_powersave cpufreq_conservative cpufreq_stats
cpufreq_userspace binfmt_misc fuse loop kvm_amd kvm powernow_k8 psmouse
serio_raw mperf microcode tpm_tis tpm evdev edac_core tpm_bios
edac_mce_amd asus_atk0110 shpchp i2c_piix4 pci_hotplug processor
thermal_sys button dm_multipath scsi_dh mlx4_en sg sd_mod crc_t10dif
mlx4_core r8169 ahci libahci libata scsi_mod [last unloaded: ib_ipoib]
[  884.071695]
[  884.071753] Pid: 3001, comm: kworker/0:0 Tainted: G      D    O
3.4.23-pserver-hotfix+ #111 System manufacturer System Product
Name/M4A89GTD-PRO
[  884.071972] RIP: 0010:[<ffffffff81064700>]  [<ffffffff81064700>]
kthread_data+0x10/0x20
[  884.072099] RSP: 0018:ffff8801fad679a8  EFLAGS: 00010096
[  884.072168] RAX: 0000000000000000 RBX: 0000000000000000 RCX:
0000000000000000
[  884.072228] RDX: ffffffff81e138c0 RSI: 0000000000000000 RDI:
ffff8801fb734180
[  884.072293] RBP: ffff8801fad679a8 R08: ffff8801fb7341f0 R09:
000000cdd60f50a3
[  884.072357] R10: 0000000000000c00 R11: 0000000000000000 R12:
0000000000000000
[  884.072422] R13: ffff8801fb734548 R14: ffff8801fad677d8 R15:
ffff8801f664c0d8
[  884.072485] FS:  00007f11da415700(0000) GS:ffff88021fc00000(0000)
knlGS:0000000000000000
[  884.072560] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  884.072623] CR2: fffffffffffffff8 CR3: 00000001f16f5000 CR4:
00000000000007f0
[  884.072690] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
0000000000000000
[  884.072762] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7:
0000000000000400
[  884.072827] Process kworker/0:0 (pid: 3001, threadinfo
ffff8801fad66000, task ffff8801fb734180)
[  884.072909] Stack:
[  884.072969]  ffff8801fad679c8 ffffffff8105c735 ffff8801fad679c8
ffff88021fc12f40
[  884.074211]  ffff8801fad67a58 ffffffff8173aad3 ffff880100000000
ffff8801fad66000
[  884.074481]  ffff8801fad67fd8 ffff8801fad66000 ffff8801fad66010
ffff8801fad66000
[  884.074742] Call Trace:
[  884.074801]  [<ffffffff8105c735>] wq_worker_sleeping+0x15/0xa0
[  884.074869]  [<ffffffff8173aad3>] __schedule+0x6a3/0x940
[  884.074934]  [<ffffffff8173ae39>] schedule+0x29/0x70
[  884.074998]  [<ffffffff81042105>] do_exit+0x615/0xa40
[  884.075061]  [<ffffffff8103e6c1>] ? kmsg_dump+0x81/0x300
[  884.075123]  [<ffffffff8173d85b>] oops_end+0xab/0xf0
[  884.075184]  [<ffffffff8100570b>] die+0x5b/0x90
[  884.075245]  [<ffffffff8173d3f4>] do_general_protection+0x164/0x170
[  884.075308]  [<ffffffff8173ca60>] ? restore_args+0x30/0x30
[  884.075370]  [<ffffffff8173cc15>] general_protection+0x25/0x30
[  884.075434]  [<ffffffffa02dc3e0>] ? ipoib_cm_tx_handler+0x30/0x2b0
[ib_ipoib]
[  884.075498]  [<ffffffff8109f019>] ? mark_held_locks+0x79/0x120
[  884.075559]  [<ffffffff8109c0bd>] ? trace_hardirqs_off+0xd/0x10
[  884.075622]  [<ffffffffa017fcc5>] cm_process_work+0x25/0x120 [ib_cm]
[  884.075686]  [<ffffffffa0180508>] cm_rep_handler+0x308/0x590 [ib_cm]
[  884.075750]  [<ffffffffa0181c65>] cm_work_handler+0x145/0x1070 [ib_cm]
[  884.075813]  [<ffffffff8105daea>] process_one_work+0x19a/0x5c0
[  884.075875]  [<ffffffff8105da7d>] ? process_one_work+0x12d/0x5c0
[  884.075938]  [<ffffffffa0181b20>] ? cm_req_handler+0xa40/0xa40 [ib_cm]
[  884.076001]  [<ffffffff8105f865>] worker_thread+0x175/0x380
[  884.076064]  [<ffffffff8105f6f0>] ? manage_workers+0x210/0x210
[  884.076126]  [<ffffffff81064e0e>] kthread+0xbe/0xd0
[  884.076187]  [<ffffffff8109f2b0>] ? trace_hardirqs_on_caller+0x20/0x1b0
[  884.076252]  [<ffffffff81746734>] kernel_thread_helper+0x4/0x10
[  884.076313]  [<ffffffff8173ca30>] ? retint_restore_args+0x13/0x13
[  884.076376]  [<ffffffff81064d50>] ? __init_kthread_worker+0x70/0x70
[  884.076438]  [<ffffffff81746730>] ? gs_change+0x13/0x13
[  884.076499] Code: 66 66 66 90 65 48 8b 04 25 80 b9 00 00 48 8b 80 70
03 00 00 8b 40 f0 c9 c3 66 90 55 48 89 e5 66 66 66 66 90 48 8b 87 70 03
00 00 <48> 8b 40 f8 c9 c3 66 2e 0f 1f 84 00 00 00 00 00 55 48 89 e5 66
[  884.081230] RIP  [<ffffffff81064700>] kthread_data+0x10/0x20
[  884.081332]  RSP <ffff8801fad679a8>
[  884.081388] CR2: fffffffffffffff8
[  884.081447] ---[ end trace fa3d54b0aa9bc9cf ]---
[  884.081504] Fixing recursive fault but reboot is needed!
[  903.845688] ------------[ cut here ]------------
[  903.845800] WARNING: at kernel/watchdog.c:241
watchdog_overflow_callback+0x98/0xc0()
[  903.845878] Hardware name: System Product Name
[  903.845939] Watchdog detected hard LOCKUP on cpu 3
[  903.845989] Modules linked in: ib_ipoib(O) rdma_ucm rdma_cm iw_cm
ib_addr ib_cm ib_sa ib_uverbs ib_umad mlx4_ib ib_mad ib_core
ip6table_filter ip6_tables iptable_filter ip_tables ebtable_nat ebtables
x_tables cpufreq_powersave cpufreq_conservative cpufreq_stats
cpufreq_userspace binfmt_misc fuse loop kvm_amd kvm powernow_k8 psmouse
serio_raw mperf microcode tpm_tis tpm evdev edac_core tpm_bios
edac_mce_amd asus_atk0110 shpchp i2c_piix4 pci_hotplug processor
thermal_sys button dm_multipath scsi_dh mlx4_en sg sd_mod crc_t10dif
mlx4_core r8169 ahci libahci libata scsi_mod [last unloaded: ib_ipoib]
[  903.850712] Pid: 19, comm: ksoftirqd/3 Tainted: G      D    O
3.4.23-pserver-hotfix+ #111
[  903.850790] Call Trace:
[  903.850851]  <NMI>  [<ffffffff8103c2cf>] warn_slowpath_common+0x7f/0xc0
[  903.850967]  [<ffffffff8103c3c6>] warn_slowpath_fmt+0x46/0x50
[  903.851034]  [<ffffffff8109c009>] ? trace_hardirqs_off_caller+0x29/0xd0
[  903.851101]  [<ffffffff810cd968>] watchdog_overflow_callback+0x98/0xc0
[  903.851167]  [<ffffffff811077dc>] __perf_event_overflow+0x9c/0x320
[  903.851233]  [<ffffffff811087ec>] ?
perf_event_update_userpage+0x16c/0x2c0
[  903.851299]  [<ffffffff81108680>] ? perf_event_mmap_ctx+0x170/0x170
[  903.852535]  [<ffffffff81107f74>] perf_event_overflow+0x14/0x20
[  903.852601]  [<ffffffff81013f27>] x86_pmu_handle_irq+0x1b7/0x220
[  903.852668]  [<ffffffff8173e4c1>] perf_event_nmi_handler+0x21/0x30
[  903.852733]  [<ffffffff8173da26>] nmi_handle+0xb6/0x200
[  903.852798]  [<ffffffff8173d970>] ? oops_begin+0xd0/0xd0
[  903.852863]  [<ffffffff8173dc9d>] do_nmi+0x12d/0x350
[  903.852928]  [<ffffffff8173d02c>] end_repeat_nmi+0x1a/0x1e
[  903.852994]  [<ffffffff81420eb1>] ? delay_tsc+0x61/0xb0
[  903.853059]  [<ffffffff81420eb1>] ? delay_tsc+0x61/0xb0
[  903.853123]  [<ffffffff81420eb1>] ? delay_tsc+0x61/0xb0
[  903.853188]  <<EOE>>  [<ffffffff81420dff>] __delay+0xf/0x20
[  903.853302]  [<ffffffff81428713>] do_raw_spin_lock+0xd3/0x140
[  903.853367]  [<ffffffff8173bd18>] _raw_spin_lock+0x48/0x50
[  903.853433]  [<ffffffff8107771f>] ? try_to_wake_up+0x20f/0x2f0
[  903.853498]  [<ffffffff8107771f>] try_to_wake_up+0x20f/0x2f0
[  903.853564]  [<ffffffff81077812>] default_wake_function+0x12/0x20
[  903.853629]  [<ffffffff810654cd>] autoremove_wake_function+0x1d/0x50
[  903.853694]  [<ffffffff8106e729>] __wake_up_common+0x59/0x90
[  903.853759]  [<ffffffff81071310>] __wake_up+0x40/0x60
[  903.853827]  [<ffffffff815cc82c>] sk_stream_write_space+0xdc/0x230
[  903.853892]  [<ffffffff815cc794>] ? sk_stream_write_space+0x44/0x230
[  903.853958]  [<ffffffff81629760>] tcp_data_snd_check+0x110/0x120
[  903.854023]  [<ffffffff8162e829>] tcp_rcv_established+0x389/0x870
[  903.854089]  [<ffffffff81639a17>] tcp_v4_do_rcv+0x297/0x5d0
[  903.854153]  [<ffffffff8163a2f1>] tcp_v4_rcv+0x5a1/0x930
[  903.854217]  [<ffffffff81611dfc>] ? ip_local_deliver_finish+0x4c/0x4f0
[  903.854283]  [<ffffffff81611ee5>] ip_local_deliver_finish+0x135/0x4f0
[  903.854348]  [<ffffffff81611dfc>] ? ip_local_deliver_finish+0x4c/0x4f0
[  903.854413]  [<ffffffff81611da0>] ip_local_deliver+0x80/0x90
[  903.854478]  [<ffffffff8161244d>] ip_rcv_finish+0x1ad/0x660
[  903.854544]  [<ffffffff81611c58>] ip_rcv+0x228/0x2f0
[  903.854610]  [<ffffffff815d7696>] __netif_receive_skb+0x2c6/0x990
[  903.854675]  [<ffffffff815d74e6>] ? __netif_receive_skb+0x116/0x990
[  903.854741]  [<ffffffff81162487>] ?
__kmalloc_node_track_caller+0xf7/0x250
[  903.854807]  [<ffffffff815d89bd>] netif_receive_skb+0x2d/0x210
[  903.854877]  [<ffffffffa02de26a>] ipoib_cm_handle_rx_wc+0x1fa/0x710
[ib_ipoib]
[  903.854958]  [<ffffffff8173c6fb>] ? _raw_spin_unlock+0x2b/0x50
[  903.855026]  [<ffffffffa02ded32>] ? ipoib_cm_handle_tx_wc+0x1c2/0x370
[ib_ipoib]
[  903.855108]  [<ffffffffa02d7a86>] ipoib_poll+0xd6/0x190 [ib_ipoib]
[  903.855173]  [<ffffffff815d97ad>] net_rx_action+0x13d/0x320
[  903.855239]  [<ffffffff81045048>] __do_softirq+0xf8/0x380
[  903.855304]  [<ffffffff810453ed>] run_ksoftirqd+0x11d/0x1e0
[  903.855368]  [<ffffffff810452d0>] ? __do_softirq+0x380/0x380
[  903.855433]  [<ffffffff81064e0e>] kthread+0xbe/0xd0
[  903.855497]  [<ffffffff8109f2b0>] ? trace_hardirqs_on_caller+0x20/0x1b0
[  903.855564]  [<ffffffff81746734>] kernel_thread_helper+0x4/0x10
[  903.856798]  [<ffffffff8173ca30>] ? retint_restore_args+0x13/0x13
[  903.856864]  [<ffffffff81064d50>] ? __init_kthread_worker+0x70/0x70
[  903.856929]  [<ffffffff81746730>] ? gs_change+0x13/0x13
[  903.856993] ---[ end trace fa3d54b0aa9bc9d0 ]---
[  917.505825] ------------[ cut here ]------------
[  917.505938] WARNING: at kernel/watchdog.c:241
watchdog_overflow_callback+0x98/0xc0()
[  917.506014] Hardware name: System Product Name
[  917.506075] Watchdog detected hard LOCKUP on cpu 2
[  917.506123] Modules linked in: ib_ipoib(O) rdma_ucm rdma_cm iw_cm
ib_addr ib_cm ib_sa ib_uverbs ib_umad mlx4_ib ib_mad ib_core
ip6table_filter ip6_tables iptable_filter ip_tables ebtable_nat ebtables
x_tables cpufreq_powersave cpufreq_conservative cpufreq_stats
cpufreq_userspace binfmt_misc fuse loop kvm_amd kvm powernow_k8 psmouse
serio_raw mperf microcode tpm_tis tpm evdev edac_core tpm_bios
edac_mce_amd asus_atk0110 shpchp i2c_piix4 pci_hotplug processor
thermal_sys button dm_multipath scsi_dh mlx4_en sg sd_mod crc_t10dif
mlx4_core r8169 ahci libahci libata scsi_mod [last unloaded: ib_ipoib]
[  917.510288] Pid: 3337, comm: iperf Tainted: G      D W  O
3.4.23-pserver-hotfix+ #111
[  917.510362] Call Trace:
[  917.510421]  <NMI>  [<ffffffff8103c2cf>] warn_slowpath_common+0x7f/0xc0
[  917.510534]  [<ffffffff8103c3c6>] warn_slowpath_fmt+0x46/0x50
[  917.510598]  [<ffffffff8109c009>] ? trace_hardirqs_off_caller+0x29/0xd0
[  917.510662]  [<ffffffff810cd968>] watchdog_overflow_callback+0x98/0xc0
[  917.511154]  [<ffffffff811077dc>] __perf_event_overflow+0x9c/0x320
[  917.511218]  [<ffffffff811087ec>] ?
perf_event_update_userpage+0x16c/0x2c0
[  917.511283]  [<ffffffff81108680>] ? perf_event_mmap_ctx+0x170/0x170
[  917.511347]  [<ffffffff81107f74>] perf_event_overflow+0x14/0x20
[  917.511411]  [<ffffffff81013f27>] x86_pmu_handle_irq+0x1b7/0x220
[  917.511477]  [<ffffffff8173e4c1>] perf_event_nmi_handler+0x21/0x30
[  917.511541]  [<ffffffff8173da26>] nmi_handle+0xb6/0x200
[  917.511604]  [<ffffffff8173d970>] ? oops_begin+0xd0/0xd0
[  917.511669]  [<ffffffff8173dc9d>] do_nmi+0x12d/0x350
[  917.511732]  [<ffffffff8173d02c>] end_repeat_nmi+0x1a/0x1e
[  917.511796]  [<ffffffff81420eb1>] ? delay_tsc+0x61/0xb0
[  917.511859]  [<ffffffff81420eb1>] ? delay_tsc+0x61/0xb0
[  917.511921]  [<ffffffff81420eb1>] ? delay_tsc+0x61/0xb0
[  917.511984]  <<EOE>>  [<ffffffff81420dff>] __delay+0xf/0x20
[  917.512093]  [<ffffffff81428713>] do_raw_spin_lock+0xd3/0x140
[  917.512158]  [<ffffffff8173bd18>] _raw_spin_lock+0x48/0x50
[  917.513308]  [<ffffffff8107eee0>] ? load_balance+0x540/0x8a0
[  917.513371]  [<ffffffff8107eee0>] load_balance+0x540/0x8a0
[  917.513435]  [<ffffffff8107eefc>] ? load_balance+0x55c/0x8a0
[  917.513498]  [<ffffffff8107fe8d>] idle_balance+0x13d/0x2b0
[  917.513560]  [<ffffffff8107fda0>] ? idle_balance+0x50/0x2b0
[  917.513623]  [<ffffffff8173acc0>] __schedule+0x890/0x940
[  917.513686]  [<ffffffff8173ae39>] schedule+0x29/0x70
[  917.513749]  [<ffffffff81738bd5>] schedule_timeout+0x225/0x3b0
[  917.513812]  [<ffffffff8109f2b0>] ? trace_hardirqs_on_caller+0x20/0x1b0
[  917.513877]  [<ffffffff815c26ae>] ? release_sock+0x14e/0x1b0
[  917.513939]  [<ffffffff8109f44d>] ? trace_hardirqs_on+0xd/0x10
[  917.514003]  [<ffffffff81045542>] ? local_bh_enable_ip+0x92/0xf0
[  917.514067]  [<ffffffff8173c5f3>] ? _raw_spin_unlock_bh+0x43/0x50
[  917.514132]  [<ffffffff815ccf98>] sk_stream_wait_memory+0x218/0x300
[  917.514196]  [<ffffffff810654b0>] ? wake_up_bit+0x40/0x40
[  917.514260]  [<ffffffff816247d1>] tcp_sendmsg+0x681/0xc30
[  917.514324]  [<ffffffff8164e0db>] inet_sendmsg+0x12b/0x240
[  917.514387]  [<ffffffff8164dfb0>] ? inet_create+0x5b0/0x5b0
[  917.514450]  [<ffffffff815c27c2>] ? sock_update_classid+0xb2/0x2b0
[  917.514514]  [<ffffffff815c2860>] ? sock_update_classid+0x150/0x2b0
[  917.514577]  [<ffffffff815bdf90>] sock_aio_write+0x190/0x1b0
[  917.514641]  [<ffffffff8113924f>] ? handle_pte_fault+0x50f/0x8e0
[  917.514706]  [<ffffffff8116e11a>] do_sync_write+0xea/0x130
[  917.514770]  [<ffffffff81170cc3>] ? fget_light+0x43/0x490
[  917.514835]  [<ffffffff813b1013>] ? security_file_permission+0x23/0x90
[  917.514900]  [<ffffffff8116e772>] vfs_write+0x172/0x190
[  917.514965]  [<ffffffff8116e881>] sys_write+0x51/0x90
[  917.515028]  [<ffffffff817452e9>] system_call_fastpath+0x16/0x1b
[  917.515092] ---[ end trace fa3d54b0aa9bc9d1 ]---

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
