From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: Re: sg_map failures when tuning SRP via ib_srp module parameters for
 maximum SG entries
Date: Sat, 12 Mar 2016 16:34:37 -0800
Message-ID: <56E4B59D.4070701@sandisk.com>
References: <1195068688.21605141.1457794577569.JavaMail.zimbra@redhat.com>
 <56E492F0.1070609@dev.mellanox.co.il>
 <1578713476.21612303.1457821295989.JavaMail.zimbra@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1578713476.21612303.1457821295989.JavaMail.zimbra-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Laurence Oberman <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, James Hartsock <hartsjc-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 03/12/16 14:21, Laurence Oberman wrote:
> Array issue here
> -------------------
> Mar 12 15:48:53 localhost kernel: ib_srpt received unsupported SRP_CMD request type (128 out + 0 in != 2288 / 16)
> Mar 12 15:48:53 localhost kernel: ib_srpt 0x3e: parsing SRP descriptor table failed.
> Mar 12 15:48:55 localhost kernel: BUG: unable to handle kernel NULL pointer dereference at           (null)
> Mar 12 15:48:55 localhost kernel: IP: [<ffffffff81524a2d>] scsi_build_sense_buffer+0xd/0x40
> Mar 12 15:48:55 localhost kernel: PGD 0
> Mar 12 15:48:55 localhost kernel: Oops: 0002 [#1] SMP
> Mar 12 15:48:55 localhost kernel: Modules linked in: target_core_user uio target_core_pscsi target_core_file target_core_iblock iscsi_target_mod ib_srp scsi_transport_srp ib_srpt target_core_mod mlx5_ib ip6t_rpfilter ip6t_REJECT nf_reject_ipv6 xt_conntrack ip_set nfnetlink ebtable_filter ebtable_nat ebtable_broute bridge stp llc ebtables ip6table_nat nf_conntrack_ipv6 nf_defrag_ipv6 nf_nat_ipv6 ip6table_mangle ip6table_security ip6table_raw ip6table_filter ip6_tables iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack iptable_mangle iptable_security iptable_raw ib_ipoib rdma_ucm ib_ucm ib_uverbs ib_umad rdma_cm ib_cm iw_cm ib_sa ib_mad ib_core ib_addr coretemp kvm_intel iTCO_wdt iTCO_vendor_support gpio_ich joydev ipmi_ssif kvm pcc_cpufreq acpi_power_meter i7core
 _edac nfsd hpilo hpwdt acpi_cpufreq
> Mar 12 15:48:55 localhost kernel: ipmi_si edac_core shpchp wmi pcspkr irqbypass ipmi_msghandler tpm_tis lpc_ich tpm auth_rpcgss nfs_acl lockd grace sunrpc xfs libcrc32c amdkfd amd_iommu_v2 radeon i2c_algo_bit drm_kms_helper ttm drm mlx5_core crc32c_intel serio_raw netxen_nic hpsa nvme ata_generic pata_acpi scsi_transport_sas fjes
> Mar 12 15:48:55 localhost kernel: CPU: 40 PID: 2495 Comm: ib_srpt_compl Not tainted 4.4.5 #1
> Mar 12 15:48:55 localhost kernel: Hardware name: HP ProLiant DL580 G7, BIOS P65 10/01/2013
> Mar 12 15:48:55 localhost kernel: task: ffff8813e5750000 ti: ffff8813c1560000 task.ti: ffff8813c1560000
> Mar 12 15:48:55 localhost kernel: RIP: 0010:[<ffffffff81524a2d>]  [<ffffffff81524a2d>] scsi_build_sense_buffer+0xd/0x40
> Mar 12 15:48:55 localhost kernel: RSP: 0018:ffff8813c1563d30  EFLAGS: 00010246
> Mar 12 15:48:55 localhost kernel: RAX: 0000000000000000 RBX: ffff8813d6418468 RCX: 0000000000000024
> Mar 12 15:48:55 localhost kernel: RDX: 0000000000000005 RSI: 0000000000000000 RDI: 0000000000000000
> Mar 12 15:48:55 localhost kernel: RBP: ffff8813c1563d30 R08: 0000000000000000 R09: 00000000000005b4
> Mar 12 15:48:55 localhost kernel: R10: ffff8813c26ee030 R11: 00000000000005b4 R12: 0000000000000000
> Mar 12 15:48:55 localhost kernel: R13: 0000000000000008 R14: ffffffffa06c6640 R15: ffff8813dae1e000
> Mar 12 15:48:55 localhost kernel: FS:  0000000000000000(0000) GS:ffff8827efc00000(0000) knlGS:0000000000000000
> Mar 12 15:48:55 localhost kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> Mar 12 15:48:55 localhost kernel: CR2: 0000000000000000 CR3: 0000000001c09000 CR4: 00000000000006e0
> Mar 12 15:48:55 localhost kernel: Stack:
> Mar 12 15:48:55 localhost kernel: ffff8813c1563d78 ffffffffa06b65bb ffff8813c1563d78 002400000000003e
> Mar 12 15:48:55 localhost kernel: 0000000018e17efa ffff8813c2bab040 ffff8813d6418400 ffff8813c26ee000
> Mar 12 15:48:55 localhost kernel: ffff8813d6418468 ffff8813c1563e00 ffffffffa0705d89 ffff881300000020
> Mar 12 15:48:55 localhost kernel: Call Trace:
> Mar 12 15:48:55 localhost kernel: [<ffffffffa06b65bb>] transport_send_check_condition_and_sense+0x18b/0x250 [target_core_mod]
> Mar 12 15:48:55 localhost kernel: [<ffffffffa0705d89>] srpt_handle_new_iu+0x2c9/0x700 [ib_srpt]
> Mar 12 15:48:55 localhost kernel: [<ffffffffa0706848>] srpt_process_completion+0xc8/0x4b0 [ib_srpt]
> Mar 12 15:48:55 localhost kernel: [<ffffffffa0706cfb>] srpt_compl_thread+0xcb/0x140 [ib_srpt]
> Mar 12 15:48:55 localhost kernel: [<ffffffff810e4c20>] ? wake_atomic_t_function+0x70/0x70
> Mar 12 15:48:55 localhost kernel: [<ffffffffa0706c30>] ? srpt_process_completion+0x4b0/0x4b0 [ib_srpt]
> Mar 12 15:48:55 localhost kernel: [<ffffffff810c1628>] kthread+0xd8/0xf0
> Mar 12 15:48:55 localhost kernel: [<ffffffff810c1550>] ? kthread_worker_fn+0x160/0x160
> ar 12 15:48:55 localhost kernel: [<ffffffff8179aa8f>] ret_from_fork+0x3f/0x70
> Mar 12 15:48:55 localhost kernel: [<ffffffff810c1550>] ? kthread_worker_fn+0x160/0x160
> Mar 12 15:48:55 localhost kernel: Code: 89 c8 5d c3 0f b6 01 5d 39 d0 b8 00 00 00 00 48 0f 44 c1 c3 31 c0 eb ea 66 0f 1f 44 00 00 66 66 66 66 90 55 85 ff 48 89 e5 75 13 <c6> 06 70 88 56 02 c6 46 07 0a 88 4e 0c 44 88 46 0d 5d c3 c6 06
> Mar 12 15:48:55 localhost kernel: RIP  [<ffffffff81524a2d>] scsi_build_sense_buffer+0xd/0x40
> Mar 12 15:48:55 localhost kernel: RSP <ffff8813c1563d30>
> Mar 12 15:48:55 localhost kernel: CR2: 0000000000000000

Hello Laurence,

This is one of the issues for which a fix is present in the patch series 
"IB/srpt patches for Linux kernel v4.6" 
(http://thread.gmane.org/gmane.linux.drivers.rdma/33715), a patch series 
of which it is expected that it will be sent to Linus during the v4.6 
merge window.

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
