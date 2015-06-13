From: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Upstream mlx4 driver very broken (when using SRIOV)
Date: Sun, 14 Jun 2015 00:02:49 +0300
Message-ID: <CAJ3xEMiVDdnvAQvVF6cfqBCz6hc=OpSTYRhRn4pn6KJDumMMZQ@mail.gmail.com>
References: <557BC105.3070405@redhat.com>
	<CAJ3xEMjn-T+qzRU1OSbrp=q5PcKkG30wqQhdnde2S_ThBMtSRA@mail.gmail.com>
	<557C2718.2000505@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <557C2718.2000505-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Amir Vadai <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Ido Shamay <idos-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Sat, Jun 13, 2015 at 3:50 PM, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> On 06/13/2015 03:18 AM, Or Gerlitz wrote:
>> On Sat, Jun 13, 2015 at 8:35 AM, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
>>> I ran across a problem today when I went to do some run tests of my
>>> for-4.2 tree.  For a second there, I was about to seriously have a
>>> conniption fit.  But, after about 6 hours of work bisecting and
>>> debugging, I've come to find that I wasn't so crazy after all.
>>>
>>> When I went to install my for-4.2 tree, IPoIB was totally busted, as in
>>> DOA.  I knew the 4.1 code I submitted to Linus I had checked, but I
>>> wanted to have a good starting point for a bisection so I compiled a
>>> kernel from my for-4.1-rc branch.  And it was DOA too.  That seriously
>>> unnerved me because I knew I tested that code.  I did a number of manual
>>> checkouts at possible suspicious code points, and none of them showed
>>> that the problem was resolved.  Then I started doing some debugging on
>>> both the afflicted machine and on the opensm server.  I finally saw that
>>> the afflicted machine was claiming that it was attempting to join the
>>> multicast group, but was reporting error 110 (ETIMEDOUT).  The opensm
>>> server was not seeing the requests at all.
>>>
>>> Long story short, I did my testing in the 4.1 merge window and rc phase
>>> on machines without SRIOV enabled, but when you enable SRIOV in the mlx4
>>> driver, the current driver seems to have broken QP0/QP1 multiplexing
>>> support because the host becomes unable to join the IPoIB multicast
>>> groups.  In addition, with SRIOV enabled, mlx4_en throws corruption
>>> errors on reboot and requires that the machine be power cycled as
>>> opposed to rebooting cleanly.  From what I can tell, the 4.0 release
>>
>> Doug,
>>
>> So now my weekend mood is busted too, probably was a mistake to pick
>> into my gmail account (but I can't promise to never do it again) -- NM
>> I'll manage.
>
> Trust me, I understand :-(
>
>> AFAIK, our regression systems for upstream do run SRIOV tests, and as
>> I know very well, I've been working on upstream code with mlx4 SRIOV
>> over the last couple of weeks on daily manner (I've been using net and
>> net-next but it should be good coverage)... I wonder what fell between
>> the cracks here... let's see -- but **please** be more precise when
>> you report on breakage (here and elsewhere):
>
> Sorry, it was 1:30am my time when I wrote that.  I wanted to alert you
> to the issue, but I was also tired and needed sleep.
>
>> 1. set ipoib debug flags (both of them) and do ifdown/ifup to the NIC
>> instance that fails joining groups (which? you didn't say if this is
>> total failure e.g of the IPv4 multicast group or of some other
>> group/s) and send the resulted log
>
> Total failure of multicast group.  The logs are unhelpful.  They are
> basically a bunch of "joining mgid blah" "failed to join mgid blah,
> error -110".  And it's all instances that do this.  No joins complete.

You mentioned mlx4_core options of "probe_vf=0 num_vfs=7
port_type_array=1,2" so you're in SRIOV mode but the join failures
happen to the PF IPoIB instance, or you are probing VF/s in a VM and
see the failure there?



>> 2. re "broken QP0/QP1 multiplexing support" that this means you see
>> address resolution failure with rdma-cm apps? indeed, no ping, no
>> rping... but this doesn't mean QP0/QP1 multiplexing broken. If you
>> have ping (ICMP) working, try
>>
>> $ rping -dvs
>> $ rping -dvca SERVER
>>
>> and send us the output
>
> This is unhelpful too.  For any of the afflicted interfaces (all IPoIB
> interfaces), rping fails to resolve the address to the server.  Other
> interfaces (RoCE) work fine.

This makes sense, no functioning IPoIB --> no address resolution.


>> 3. Re "with SRIOV enabled, mlx4_en throws corruption errors on reboot"
>> - show them to us
>>
>> To sum up: Send us some boring dmesg outputs from your problematic
>> setup that go beyond your analysis, as well as your "lspci | grep nox"
>> output + the dmesg of mlx4_core when loaded with debug_level=1 (I'd
>> like to see the FW version and various other outputs).
>
> It will take me a while to capture all you requested.  When it goes
> down, it's 10 minutes per reboot cycle to collect more information.
> However, as I just learned, the mlx4_en problem happens with or without
> SRIOV.  So, it's probably related to my vlan setup.  I managed to catch
> some dmesg output.  Here it is:
>
> [24891.205735] ------------[ cut here ]------------
> [24891.227362] WARNING: CPU: 1 PID: 36115 at lib/list_debug.c:59
> __list_del_entry+0xa1/0xd0()
> [24891.265535] list_del corruption. prev->next should be
> ffff8800bd845028, but was           (null)
> [24891.308640] Modules linked in: sch_mqprio 8021q garp mrp bridge stp
> llc xprtrdma sunrpc ib_isert iscsi_target_mod ib_iser libiscsi
> scsi_transport_iscsi ib_srpt target_core_mod ib_srp scsi_transport_srp
> rdma_ucm ib_ucm ib_uverbs ib_umad rdma_cm ib_cm iw_cm
> x86_pkg_temp_thermal coretemp kvm_intel kvm crct10dif_pclmul
> crc32_pclmul crc32c_intel ghash_clmulni_intel aesni_intel ipmi_ssif lrw
> gf128mul glue_helper ablk_helper cryptd iTCO_wdt hpilo
> iTCO_vendor_support ipmi_si 8250_fintek lpc_ich microcode wmi
> ipmi_msghandler hpwdt pcspkr serio_raw ioatdma acpi_power_meter mfd_core
> sb_edac dca pcc_cpufreq edac_core shpchp acpi_cpufreq sch_fq_codel xfs
> libcrc32c mlx4_en(-) vxlan ip6_udp_tunnel udp_tunnel ib_sa ib_mad
> ib_core ib_addr ata_generic pata_acpi mgag200 syscopyarea sysfillrect
> sysimgblt i2c_algo_bit drm_kms_helper ttm sd_mod drm tg3 ata_piix ptp
> libata mlx4_core hpsa i2c_core pps_core dm_mirror dm_region_hash dm_log
> dm_mod [last unloaded: mlx4_ib]
> ** 3035 printk messages dropped ** [24891.640030]  drm_kms_helper ttm
> sd_mod drm tg3 ata_piix ptp libata mlx4_core hpsa i2c_core pps_core
> dm_mirror dm_region_hash dm_log dm_mod [last unloaded: mlx4_ib]
> [24891.640031] CPU: 1 PID: 36115 Comm: rmmod Tainted: G        W
> 4.0.0+ #53
> [24891.640032] Hardware name: HP ProLiant DL360p Gen8, BIOS P71 12/20/2013
> [24891.640033]  0000000000000000 0000000062127936 ffff880809743c28
> ffffffff816a3be5
> [24891.640035]  0000000000000000 ffff880809743c80 ffff880809743c68
> ffffffff8107bdaa
> [24891.640036]  0000000000000004 ffff8808041eee28 ffffffffc0138000
> ffff880809743dc0
> [24891.640036] Call Trace:
> [24891.640038]  [<ffffffff816a3be5>] dump_stack+0x45/0x57
> [24891.640039]  [<ffffffff8107bdaa>] warn_slowpath_common+0x8a/0xc0
> [24891.640041]  [<ffffffff8107be35>] warn_slowpath_fmt+0x55/0x70
> [24891.640043]  [<ffffffff8119faca>] ? kvfree+0x2a/0x40
> [24891.640044]  [<ffffffff813353f1>] __list_del_entry+0xa1/0xd0
> [24891.640045]  [<ffffffff81335431>] list_del+0x11/0x40
> [24891.640048]  [<ffffffff815b4cf5>] qdisc_list_del+0x25/0x30
> [24891.640049]  [<ffffffff815b2fa5>] qdisc_destroy+0x35/0xb0
> [24891.640050]  [<ffffffff815b4150>] dev_shutdown+0x50/0xd0
> [24891.640052]  [<ffffffff815894f0>] rollback_registered_many+0x160/0x300
> [24891.640053]  [<ffffffff815896d0>] rollback_registered+0x40/0x70
> [24891.640055]  [<ffffffff8158ac48>] unregister_netdevice_queue+0x48/0x80
> [24891.640056]  [<ffffffff8158aca0>] unregister_netdev+0x20/0x30
> [24891.640059]  [<ffffffffc01a21c8>] mlx4_en_destroy_netdev+0xf8/0x130
> [mlx4_en]
> [24891.640062]  [<ffffffffc019311b>] mlx4_en_remove+0xfb/0x110 [mlx4_en]
> [24891.640067]  [<ffffffffc00de638>] mlx4_remove_device+0x88/0xd0
> [mlx4_core]
> [24891.640073]  [<ffffffffc00de6c3>] mlx4_unregister_interface+0x43/0x80
> [mlx4_core]
> [24891.640077]  [<ffffffffc01a4b28>] mlx4_en_cleanup+0x10/0x12 [mlx4_en]
> [24891.640078]  [<ffffffff811021ac>] SyS_delete_module+0x1ac/0x230
> [24891.640079]  [<ffffffff81099c4c>] ? task_work_run+0xbc/0xf0
> [24891.640081]  [<ffffffff816aaeee>] system_call_fastpath+0x12/0x71
> [24891.640081] ---[ end trace 66118cded2cc8f95 ]---
> [24891.640083] ------------[ cut here ]------------
> [24891.640084] WARNING: CPU: 1 PID: 36115 at lib/list_debug.c:59
> __list_del_entry+0xa1/0xd0()
> [24891.640084] list_del corruption. prev->next should be
> ffff8808041ef028, but was dead000000100100
> [24891.640103] Modules linked in: sch_mqprio 8021q garp mrp bridge stp
> llc xprtrdma sunrpc ib_isert iscsi_target_mod ib_iser libiscsi
> scsi_transport_iscsi ib_srpt target_core_mod ib_srp scsi_transport_srp
> rdma_ucm ib_ucm ib_uverbs ib_umad rdma_cm ib_cm iw_cm
> x86_pkg_temp_thermal coretemp kvm_intel kvm crct10dif_pclmul
> crc32_pclmul crc32c_intel ghash_clmulni_intel aesni_intel ipmi_ssif lrw
> gf128mul glue_helper ablk_helper cryptd iTCO_wdt hpilo
> iTCO_vendor_support ipmi_si 8250_fintek lpc_ich microcode wmi
> ipmi_msghandler hpwdt pcspkr serio_raw ioatdma acpi_power_meter mfd_core
> sb_edac dca pcc_cpufreq edac_core shpchp acpi_cpufreq sch_fq_codel xfs
> libcrc32c mlx4_en(-) vxlan ip6_udp_tunnel udp_tunnel ib_sa ib_mad
> ib_core ib_addr ata_generic pata_acpi mgag200 syscopyarea sysfillrect
> sysimgblt i2c_algo_bit drm_kms_helper ttm sd_mod drm tg3 ata_piix ptp
> libata mlx4_core hpsa i2c_core pps_core dm_mirror dm_region_hash dm_log
> dm_mod [last unloaded: mlx4_ib]
> [24891.640108] CPU: 1 PID: 36115 Comm: rmmod Tainted: G        W
> 4.0.0+ #53
> [24891.640108] Hardware name: HP ProLiant DL360p Gen8, BIOS P71 12/20/2013
> [24891.640109]  0000000000000000 0000000062127936 ffff880809743c28
> ffffffff816a3be5
> [24891.640110]  0000000000000000 ffff880809743c80 ffff880809743c68
> ffffffff8107bdaa
> [24891.640111]  0000000000000004 ffff8808041ef028 ffffffffc0138000
> ffff880809743dc0
> [24891.640112] Call Trace:
> [24891.640114]  [<ffffffff816a3be5>] dump_stack+0x45/0x57
> [24891.640116]  [<ffffffff8107bdaa>] warn_slowpath_common+0x8a/0xc0
> [24891.640118]  [<ffffffff8107be35>] warn_slowpath_fmt+0x55/0x70
> [24891.640119]  [<ffffffff8119faca>] ? kvfree+0x2a/0x40
> [24891.640121]  [<ffffffff813353f1>] __list_del_entry+0xa1/0xd0
> [24891.640121]  [<ffffffff81335431>] list_del+0x11/0x40
> [24891.640123]  [<ffffffff815b4cf5>] qdisc_list_del+0x25/0x30
> [24891.640124]  [<ffffffff815b2fa5>] qdisc_destroy+0x35/0xb0
> [24891.640126]  [<ffffffff815b4150>] dev_shutdown+0x50/0xd0
> [24891.640127]  [<ffffffff815894f0>] rollback_registered_many+0x160/0x300
> [24891.640129]  [<ffffffff815896d0>] rollback_registered+0x40/0x70
> [24891.640130]  [<ffffffff8158ac48>] unregister_netdevice_queue+0x48/0x80
> [24891.640132]  [<ffffffff8158aca0>] unregister_netdev+0x20/0x30
> [24891.640135]  [<ffffffffc01a21c8>] mlx4_en_destroy_netdev+0xf8/0x130
> [mlx4_en]
> [24891.640138]  [<ffffffffc019311b>] mlx4_en_remove+0xfb/0x110 [mlx4_en]
> [24891.640143]  [<ffffffffc00de638>] mlx4_remove_device+0x88/0xd0
> [mlx4_core]
> [24891.640149]  [<ffffffffc00de6c3>] mlx4_unregister_interface+0x43/0x80
> [mlx4_core]
> [24891.640153]  [<ffffffffc01a4b28>] mlx4_en_cleanup+0x10/0x12 [mlx4_en]
> [24891.640154]  [<ffffffff811021ac>] SyS_delete_module+0x1ac/0x230
> [24891.640155]  [<ffffffff81099c4c>] ? task_work_run+0xbc/0xf0
> [24891.640156]  [<ffffffff816aaeee>] system_call_fastpath+0x12/0x71
> [24891.640157] ---[ end trace 66118cded2cc8f96 ]---
> [24891.640159] ------------[ cut here ]------------
>
> You'll note in the very beginning of that is a comment from the kernel
> that some printk messages were lost.  So, I can't guarantee how accurate
> the trace is.
>
> The setup I have that seems to reliably reproduce this is base eth
> device using dhcp/mtu9000, vlan1 w/dhcp, vlan2 w/dhcp, all RoCE capable
> interface.  However, if I manually ifdown all of the interfaces before
> trying to remove the mlx4_en module, the call trace doesn't happen, so
> it's definitely related to the removal of multiple devices in the reboot
> handler (or on the command line if you rmmod mlx4_en when multiple
> interfaces are live on a single port).

OK, removal of multiple devices in the reboot sequence is concrete
scheme which we will try out and see what's broken.

Or.


> After rebooting, I got a dmesg output (attached).  The process to get
> this output was as follows:
>
> Boot with SRIOV disabled (everything works fine):
>
> Port 1 - IPoIB w/dhcp, connected mode, mtu 65520
> Port 1 - IPoIB pkey 0002 w/dhcp, connected mode, mtu 65520
> Port 1 - IPoIB pkey 0004 w/dhcp - mgid 0016, connected mode, mtu 65520
> Port 1 - IPoIB pkey 0006 w/dhcp, connected mode, mtu 65520
> Port 2 - RoCE w/dhcp, mtu 9000
> Port 2 - RoCE vlan 43 w/dhcp, mtu 9000
> Port 2 - RoCE vlan 45 w/dhcp, mtu 9000
>
> Manually down all IPoIB and RoCE interfaces using ifdown
> rmmod mlx4_* ib_ipoib
> enable SRIOV and debug messages
> modprobe mlx4_core
> modprobe ib_ipoib
> dmesg > dmesg.out
>
>>> kernel has this problem too, and it still exists at least as far as
>>> 4.1-rc7 + all of my queued up -next patches.
>>>
>>> From my /etc/modprobe.d/mlx4.conf file if you want to try and duplicate:
>>>
>>> options mlx4_core probe_vf=0 num_vfs=7 port_type_array=1,2
>>> options mlx4_en pfctx=0x28 pfcrx=0x28
>>
>> AFAIK pfctx/pfcrx are eight bits, not sure what's  the 0x20 is for
>
> They are 8 bits.  I have both priority 3 and priority 5 as no drop.
> Hence 0x28.

sorry, my stupid mistake.


>>> And I'm guessing that your internal regression tests must not have a
>>> machine in IB/Eth SRIOV mode as a standard config.  I would consider
>>> adding it to the mix.  I have it myself, but only on a few machines and
>>> I don't always use them for initial testing.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
