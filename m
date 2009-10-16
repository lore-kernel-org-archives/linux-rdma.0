From: Joe Landman <landman-nyOC7EYE20mM0MU9lROt9DlRY1/6cnIP@public.gmane.org>
Subject: kernel BUG at drivers/pci/intel-iommu.c:1278
Date: Fri, 16 Oct 2009 12:47:15 -0400
Message-ID: <4AD8A393.3040907@scalableinformatics.com>
Reply-To: landman-nyOC7EYE20mM0MU9lROt9DlRY1/6cnIP@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Anand Babu Periasamy <ab-+FkPdpiNhgJBDgjK7y7TUQ@public.gmane.org>, Joe Landman <landman-nyOC7EYE20mM0MU9lROt9DlRY1/6cnIP@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

[Not a subscriber, please respond to me in a cc]

A customer tripped an infiniband-kernel bug this morning.  Using 
glusterfs (v2.0.7) atop OFED 1.5-beta1 on a 2.6.28.10 kernel, we saw this:

(nicer version on http://pastebin.com/f3ad09818 )

Anything I should look for?  I know 2.6.28 is not being developed any 
further.  Should I start looking at 2.6.31 to help with this?

----

Oct 16 08:02:18 darwin kernel: [11012.909697] fuse init (API version 7.10)
Oct 16 08:03:00 darwin kernel: [11054.630042] ------------[ cut here 
]------------
Oct 16 08:03:00 darwin kernel: [11054.630089] kernel BUG at 
drivers/pci/intel-iommu.c:1278!
Oct 16 08:03:00 darwin kernel: [11054.630134] invalid opcode: 0000 [#1] SMP
Oct 16 08:03:00 darwin kernel: [11054.630244] last sysfs file: 
/sys/devices/system/cpu/cpu0/cache/index0/coherency_line_size
Oct 16 08:03:00 darwin kernel: [11054.630294] CPU 10
Oct 16 08:03:00 darwin kernel: [11054.630388] Modules linked in: fuse 
xprtrdma svcrdma ipmi_si ipmi_devintf ipmi_msghandler autofs4 nfs nfs_acl
  tun lockd sunrpc af_packet cpufreq_ondemand acpi_cpufreq freq_table 
rdma_ucm ib_sdp rdma_cm iw_cm ib_addr ib_ipoib ib_cm ib_sa ipv6 ib_uverbs
ib_umad iw_nes libcrc32c iw_cxgb3 cxgb3 mlx4_ib mlx4_core binfmt_misc 
xfs dm_multipath scsi_dh wmi video output rfkill input_polldev sbs sbshc
pci_slot fan container battery ac parport_pc lp parport nvram 
pata_jmicron pata_acpi hid_dell hid_pl hid_cypress hid_gyration 
hid_bright hid_so
ny hid_samsung hid_microsoft hid_monterey hid_ezkey hid_apple hid_a4tech 
hid_logitech usbmouse hid_cherry hid_sunplus hid_petalynx usbkbd hid_b
elkin sg hid_chicony usbhid hid thermal evdev button processor 
thermal_sys megaraid_sas ohci1394 jmicron ieee1394 ib_mthca ib_mad 
ib_core evbug
  psmouse serio_raw igb dca inet_lro i2c_i801 i2c_core iTCO_wdt 
iTCO_vendor_support shpchp pci_hotplug pcspkr raid0 libiscsi 
scsi_transport_iscs
i raid1 sr_mod cdrom mpts
Oct 16 08:03:00 darwin kernel: s mptscsih mptbase scsi_transport_sas 
raid456 md_mod async_xor async_memcpy async_tx xor arcmsr ata_piix ata_gen
eric dm_snapshot dm_zero dm_mirror dm_region_hash dm_log dm_mod ahci 
libata sd_mod crc_t10dif scsi_mod ext3 jbd mbcache uhci_hcd ohci_hcd ehci_
hcd usbcore [last unloaded: microcode]
Oct 16 08:03:00 darwin kernel: [11054.635434] Pid: 31408, comm: 
glusterfs Not tainted 2.6.28.10 #1
Oct 16 08:03:00 darwin kernel: [11054.635491] RIP: 
0010:[<ffffffff8038b400>]  [<ffffffff8038b400>] 
domain_page_mapping+0x100/0x110
Oct 16 08:03:00 darwin kernel: [11054.635602] RSP: 0018:ffff880750c71c08 
  EFLAGS: 00010206
Oct 16 08:03:00 darwin kernel: [11054.635657] RAX: ffff8806d9c99ff0 RBX: 
00000000008f2d7a RCX: ffff8806d9c99ff0
Oct 16 08:03:00 darwin kernel: [11054.635715] RDX: 00000006b559c003 RSI: 
0000000000000286 RDI: 0000000000000286
Oct 16 08:03:00 darwin kernel: [11054.635773] RBP: ffff880750c71c38 R08: 
0000000000000003 R09: 0000000000000000
Oct 16 08:03:00 darwin kernel: [11054.635831] R10: 0000000000000002 R11: 
0000000000000000 R12: ffff88093cf36200
Oct 16 08:03:00 darwin kernel: [11054.635889] R13: 00000000008f2d7a R14: 
00000000f7dfe000 R15: 0000000000000003
Oct 16 08:03:00 darwin kernel: [11054.635947] FS: 
00000000427fb940(0063) GS:ffff88093cc5d480(0000) knlGS:0000000000000000
Oct 16 08:03:00 darwin kernel: [11054.636021] CS:  0010 DS: 0000 ES: 
0000 CR0: 0000000080050033
Oct 16 08:03:00 darwin kernel: [11054.636077] CR2: 00007f97faf40008 CR3: 
00000007bc5ee000 CR4: 00000000000006e0
Oct 16 08:03:00 darwin kernel: [11054.636135] DR0: 0000000000000000 DR1: 
0000000000000000 DR2: 0000000000000000
Oct 16 08:03:00 darwin kernel: [11054.636193] DR3: 0000000000000000 DR6: 
00000000ffff0ff0 DR7: 0000000000000400
Oct 16 08:03:00 darwin kernel: [11054.636253] Process glusterfs (pid: 
31408, threadinfo ffff880750c70000, task ffff8809341b8000)
Oct 16 08:03:00 darwin kernel: [11054.636330] Stack:
Oct 16 08:03:00 darwin kernel: [11054.636379]  00000000008f2d7b 
ffff880924990fe0 0000000000001000 00000000f7dfe000
Oct 16 08:03:00 darwin kernel: [11054.636532]  0000000000000000 
000000000000007f ffff880750c71cb8 ffffffff8038d774
Oct 16 08:03:00 darwin kernel: [11054.636761]  0000000021d2e000 
ffff880f3c520080 0000007e50c71c98 ffff880f3c520000
Oct 16 08:03:00 darwin kernel: [11054.637045] Call Trace:
Oct 16 08:03:00 darwin kernel: [11054.637095]  [<ffffffff8038d774>] 
intel_map_sg+0x1f4/0x310
Oct 16 08:03:00 darwin kernel: [11054.637188]  [<ffffffffa02f5269>] 
ib_umem_get+0x309/0x430 [ib_core]
Oct 16 08:03:00 darwin kernel: [11054.637284]  [<ffffffffa0325a82>] 
mthca_reg_user_mr+0xb2/0x420 [ib_mthca]
Oct 16 08:03:00 darwin kernel: [11054.637379]  [<ffffffff804c6071>] ? 
_spin_lock_irq+0x11/0x20
Oct 16 08:03:00 darwin kernel: [11054.637467]  [<ffffffff804c5e91>] ? 
__down_read+0xb1/0xcc
Oct 16 08:03:00 darwin kernel: [11054.637554]  [<ffffffff804c4de9>] ? 
down_read+0x9/0x10
Oct 16 08:03:00 darwin kernel: [11054.637641]  [<ffffffffa0635617>] ? 
idr_read_uobj+0x27/0x50 [ib_uverbs]
Oct 16 08:03:00 darwin kernel: [11054.637732]  [<ffffffffa0638d49>] 
ib_uverbs_reg_mr+0x159/0x290 [ib_uverbs]
Oct 16 08:03:00 darwin kernel: [11054.637824]  [<ffffffff80370996>] ? 
__up_read+0x46/0xb0
Oct 16 08:03:00 darwin kernel: [11054.637911]  [<ffffffff8025def9>] ? 
up_read+0x9/0x10
Oct 16 08:03:00 darwin kernel: [11054.637998]  [<ffffffffa0634273>] 
ib_uverbs_write+0xb3/0xd0 [ib_uverbs]
Oct 16 08:03:00 darwin kernel: [11054.638088]  [<ffffffff802c418d>] ? 
rw_verify_area+0x6d/0xd0
Oct 16 08:03:00 darwin kernel: [11054.638176]  [<ffffffff802c4897>] 
vfs_write+0xc7/0x180
Oct 16 08:03:00 darwin kernel: [11054.638262]  [<ffffffff802c4ea0>] 
sys_write+0x50/0x90
Oct 16 08:03:00 darwin kernel: [11054.638349]  [<ffffffff8020c30a>] 
system_call_fastpath+0x16/0x1b
Oct 16 08:03:00 darwin kernel: [11054.638438] Code: 48 3b 5d d0 75 9f 31 
c0 48 83 c4 08 5b 41 5c 41 5d 41 5e 41 5f c9 c3 48 83 c4 08 b8 f4 ff f
f ff 5b 41 5c 41 5d 41 5e 41 5f c9 c3 <0f> 0b eb fe 66 66 66 2e 0f 1f 84 
00 00 00 00 00 55 48 89 e5 e8
Oct 16 08:03:00 darwin kernel: [11054.639578] RIP  [<ffffffff8038b400>] 
domain_page_mapping+0x100/0x110
Oct 16 08:03:00 darwin kernel: [11054.639578]  RSP <ffff880750c71c08>
Oct 16 08:03:00 darwin kernel: [11054.640823] ---[ end trace 
19da44418168d139 ]---
Oct 16 08:06:18 darwin kernel: [11252.630900] rpcrdma: connection to 
192.168.11.240:2050 on mthca0, memreg 6 slots 32 ird 4
Oct 16 08:11:18 darwin kernel: [11552.630920] rpcrdma: connection to 
192.168.11.240:2050 closed (-103)
Oct 16 08:13:21 darwin shutdown[31589]: shutting down for system reboot


-- 
Joe Landman
landman-nyOC7EYE20mM0MU9lROt9DlRY1/6cnIP@public.gmane.org
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
