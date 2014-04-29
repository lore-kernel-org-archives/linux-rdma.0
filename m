From: bugzilla-daemon-590EEB7GvNiWaY/ihj7yzEB+6BGkLq7r@public.gmane.org
Subject: [Bug 75051] New: Restarting opensm after having changed the port
 mode triggers a kernel crash
Date: Tue, 29 Apr 2014 13:01:12 +0000
Message-ID: <bug-75051-11804@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=75051

            Bug ID: 75051
           Summary: Restarting opensm after having changed the port mode
                    triggers a kernel crash
           Product: Drivers
           Version: 2.5
    Kernel Version: 3.15-rc3
          Hardware: All
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: Infiniband/RDMA
          Assignee: drivers_infiniband-rdma-ztI5WcYan/vQLgFONoPN62D2FQJk+8+b@public.gmane.org
          Reporter: bvanassche-HInyCGIudOg@public.gmane.org
        Regression: No

How to reproduce:

# zgrep SLUB_DEBUG /proc/config.gz 
CONFIG_SLUB_DEBUG=y
CONFIG_SLUB_DEBUG_ON=y
# /etc/init.d/opensmd restart
# rmmod ib_ipoib
# for f in $(find /sys/devices/pci* -name 'mlx4_port[12]'); do echo eth >$f;
done
# for f in $(find /sys/devices/pci* -name 'mlx4_port[12]'); do echo ib >$f;
done
# /etc/init.d/opensmd restart

Result:

general protection fault: 0000 [#1] PREEMPT SMP 
Modules linked in: netconsole configfs fuse ip6table_filter ip6_tables
iptable_filter ip_tables ebtable_nat ebtables x_tables 8021q garp bridge stp
llc rdma_ucm rdma_cm iw_cm af_packet ib_cm ib_uverbs ib_umad mlx4_en mlx4_ib
ib_sa ib_mad ib_core ib_addr x86_pkg_temp_thermal kvm_intel
snd_hda_codec_realtek kvm snd_hda_codec_generic snd_hda_codec_hdmi
snd_hda_intel crc32c_intel snd_hda_controller snd_hda_codec microcode snd_hwdep
snd_pcm pcspkr sr_mod cdrom snd_seq snd_seq_device snd_timer snd e1000e
mlx4_core i2c_i801 lpc_ich ptp soundcore mfd_core pps_core wmi acpi_cpufreq
button sg dm_mod autofs4 ext4 crc16 mbcache jbd2 sd_mod crc_t10dif
crct10dif_common hid_generic usbhid hid radeon ahci i2c_algo_bit libahci
drm_kms_helper ttm ehci_pci xhci_hcd ehci_hcd libata drm agpgart usbcore
usb_common i2c_core processor thermal_sys hwmon scsi_dh_alua scsi_dh scsi_mod
[last unloaded: ib_ipoib]
CPU: 1 PID: 1155 Comm: opensm Not tainted 3.15.0-rc3-debug+ #1
Hardware name: MSI MS-7737/Big Bang-XPower II (MS-7737), BIOS V1.5 10/16/2012
task: ffff8800362d4440 ti: ffff880098fe0000 task.ti: ffff880098fe0000
RIP: 0010:[<ffffffff810cc65c>]  [<ffffffff810cc65c>] module_put+0x2c/0x170
RSP: 0018:ffff880098fe1e70  EFLAGS: 00010292
RAX: 0000000000000001 RBX: 6b6b6b6b6b6b6b6b RCX: 0000000000000000
RDX: ffff8800362d4440 RSI: ffffffff81781ec9 RDI: ffffffff81798bd5
RBP: ffff880098fe1e88 R08: ffff880837153a18 R09: 0000000100180012
R10: 0000000000000000 R11: 0000000000000000 R12: 6b6b6b6b6b6b6b6b
R13: ffff880834893418 R14: ffff88083ba2aaa0 R15: ffff880836cd49a0
FS:  00007fecf218b700(0000) GS:ffff88085fc20000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fece857c9e0 CR3: 00000000363f1000 CR4: 00000000000407e0
Stack:
 6b6b6b6b6b6b6b6b 0000000000000008 ffff880834893418 ffff880098fe1ea0
 ffffffff81190f20 ffff880836638300 ffff880098fe1ee8 ffffffff8118e2ce
 ffff880834893418 ffff880836638310 0000000000000000 ffffffff81c00b80
Call Trace:
 [<ffffffff81190f20>] cdev_put+0x20/0x30
 [<ffffffff8118e2ce>] __fput+0x1ae/0x1f0
 [<ffffffff8118e35e>] ____fput+0xe/0x10
 [<ffffffff810723bc>] task_work_run+0xac/0xe0
 [<ffffffff81002a9f>] do_notify_resume+0x9f/0xc0
 [<ffffffff814b8398>] int_signal+0x12/0x17
Code: 66 66 66 90 55 48 85 ff 48 89 e5 41 55 41 54 49 89 fc 53 74 46 bf 01 00
00 00 e8 20 6f 3e 00 48 c7 c7 c9 1e 78 81 e8 b4 36 1a 00 <49> 8b 84 24 28 02 00
00 65 48 ff 40 08 4c 8b 6d 08 66 66 66 66 
RIP  [<ffffffff810cc65c>] module_put+0x2c/0x170
 RSP <ffff880098fe1e70>
---[ end trace 210a5e5844460ad2 ]---
BUG: sleeping function called from invalid context at kernel/locking/rwsem.c:20
in_atomic(): 1, irqs_disabled(): 0, pid: 1155, name: opensm
INFO: lockdep is turned off.
Preemption disabled at:[<ffffffff81190f20>] cdev_put+0x20/0x30

CPU: 1 PID: 1155 Comm: opensm Tainted: G      D       3.15.0-rc3-debug+ #1
Hardware name: MSI MS-7737/Big Bang-XPower II (MS-7737), BIOS V1.5 10/16/2012
 ffff8800362d4440 ffff880098fe1c40 ffffffff814a6550 0000000000000000
 ffff880098fe1c68 ffffffff8107ea60 ffff8808360f72a8 ffff880098fe1dc8
 ffff8800362d4440 ffff880098fe1c88 ffffffff814ad3c4 0000000000000000
Call Trace:
 [<ffffffff814a6550>] dump_stack+0x4e/0x7a
 [<ffffffff8107ea60>] __might_sleep+0x160/0x250
 [<ffffffff814ad3c4>] down_read+0x24/0x60
 [<ffffffff81061aa4>] exit_signals+0x24/0x130
 [<ffffffff8104d133>] do_exit+0xb3/0xc70
 [<ffffffff810adf7d>] ? kmsg_dump+0x1ad/0x220
 [<ffffffff810addf5>] ? kmsg_dump+0x25/0x220
 [<ffffffff814b04ea>] oops_end+0x8a/0xd0
 [<ffffffff8100631b>] die+0x4b/0x70
 [<ffffffff814afede>] do_general_protection+0x11e/0x1b0
 [<ffffffff814af7b2>] general_protection+0x22/0x30
 [<ffffffff810cc65c>] ? module_put+0x2c/0x170
 [<ffffffff81190f20>] cdev_put+0x20/0x30
 [<ffffffff8118e2ce>] __fput+0x1ae/0x1f0
 [<ffffffff8118e35e>] ____fput+0xe/0x10
 [<ffffffff810723bc>] task_work_run+0xac/0xe0
 [<ffffffff81002a9f>] do_notify_resume+0x9f/0xc0
 [<ffffffff814b8398>] int_signal+0x12/0x17
note: opensm[1155] exited with preempt_count 1

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
