From: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH v2 for-next 5/7] IB/mlx4: Add IB counters table
Date: Thu, 24 Dec 2015 12:12:59 +0200
Message-ID: <567BC52B.4030801@dev.mellanox.co.il>
References: <1444909482-17113-1-git-send-email-eranbe@mellanox.com>
 <1444909482-17113-6-git-send-email-eranbe@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1444909482-17113-6-git-send-email-eranbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Eran Ben Elisha <eranbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This patch seems to generate a list corruption [1] when I test
with Doug's for-4.5 tree.

Eran, care to take a look at this?

[1]:
mlx4_core: Mellanox ConnectX core driver v2.2-1 (Feb, 2014) 

mlx4_core: Initializing 0000:04:00.0 

mlx4_core 0000:04:00.0: PCIe link speed is 8.0GT/s, device supports 
8.0GT/s
mlx4_core 0000:04:00.0: PCIe link width is x8, device supports x8 

<mlx4_ib> mlx4_ib_add: mlx4_ib: Mellanox ConnectX InfiniBand driver 
v2.2-1 (Feb 2014)
<mlx4_ib> mlx4_ib_add: counter index 0 for port 1 allocated 0 

<mlx4_ib> mlx4_ib_add: counter index 1 for port 2 allocated 0 

BUG: unable to handle kernel NULL pointer dereference at 
(null)
IP: [<ffffffff81274e36>] __list_add+0x26/0xd0 

PGD 46da14067 PUD 46daa0067 PMD 0 

Oops: 0000 [#1] SMP 

Modules linked in: mlx4_ib(+) ib_sa ib_mad mlx4_core mlx5_ib mlx5_core 
ib_core ib_addr netconsole configfs nfsv3 nfs fscache cfg80211 rfkill 
x86_pkg_temp_thermal coretemp kvm_intel kvm irqbypass crc32c_intel 
aesni_intel aes_x86_64 glue_helper lrw dm_mod gf128mul ablk_helper 
cryptd iTCO_wdt iTCO_vendor_support sb_edac shpchp ipmi_si ioatdma 
lpc_ich mfd_core edac_core pcspkr wmi ipmi_msghandler i2c_i801 
acpi_cpufreq nfsd auth_rpcgss nfs_acl lockd grace sunrpc ip_tables ext4 
mbcache jbd2 sd_mod isci libsas igb serio_raw ahci ptp pps_core libahci 
i2c_algo_bit scsi_transport_sas i2c_core dca ipv6 autofs4 [last 
unloaded: mlx5_core] 

CPU: 0 PID: 1737 Comm: modprobe Not tainted 4.4.0-rc6+ #107 
 

Hardware name: Supermicro SYS-1027R-WRF/X9DRW, BIOS 3.0a 08/08/2013 
 

task: ffff8804673da800 ti: ffff880466694000 task.ti: ffff880466694000 
 

RIP: 0010:[<ffffffff81274e36>]  [<ffffffff81274e36>] 
__list_add+0x26/0xd0 

RSP: 0018:ffff880466697898  EFLAGS: 00010246 
 

RAX: 00000000ffffffff RBX: ffff8804666978c8 RCX: ffff8804673da800 
 

RDX: ffff88086b8539b8 RSI: 0000000000000000 RDI: ffff8804666978c8 
 

RBP: ffff8804666978b8 R08: 0000000000000000 R09: 0000000000000001 
 

R10: 0000000000000000 R11: 000000000000fffe R12: ffff88086b8539b8 
 

R13: 0000000000000000 R14: ffff88086b8539b8 R15: ffff880466697908
FS:  00007f37a02cf700(0000) GS:ffff88047fc00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000000 CR3: 000000046b6ee000 CR4: 00000000000406f0
Stack:
  ffff8804673da800 ffff88086b8539b0 ffff8804673da800 ffff88086b8539b4
  ffff880466697958 ffffffff8154f7be ffff880466697904 0000000000000292
  ffff880466697938 ffffffff81259bc1 0000000000007f49 80000000024000c0
Call Trace:
  [<ffffffff8154f7be>] __mutex_lock_slowpath+0x6e/0x110
  [<ffffffff81259bc1>] ? ida_simple_get+0x91/0x100
  [<ffffffff811d354e>] ? kernfs_next_descendant_post+0x1e/0x90
  [<ffffffff811d3646>] ? kernfs_activate+0x86/0xf0
  [<ffffffff8154f87e>] mutex_lock+0x1e/0x40
  [<ffffffffa00fb083>] iboe_process_mad+0x73/0x180 [mlx4_ib]
  [<ffffffffa00fba36>] mlx4_ib_process_mad+0xd6/0x110 [mlx4_ib]
  [<ffffffffa06b4703>] get_perf_mad+0x103/0x140 [ib_core]
  [<ffffffffa06b4764>] get_counter_table+0x24/0x40 [ib_core]
  [<ffffffff8115846e>] ? __kmalloc+0xde/0xe0
  [<ffffffffa06b4895>] add_port+0x115/0x3f0 [ib_core]
  [<ffffffffa06b4c5e>] ib_device_register_sysfs+0xee/0x160 [ib_core]
  [<ffffffffa06b5e05>] ib_register_device+0x1d5/0x300 [ib_core]
  [<ffffffffa010282b>] mlx4_ib_add+0x78b/0xd00 [mlx4_ib]
  [<ffffffffa08027ce>] mlx4_add_device+0x3e/0xb0 [mlx4_core]
  [<ffffffffa0802957>] mlx4_register_interface+0x87/0xe0 [mlx4_core]
  [<ffffffffa0096055>] mlx4_ib_init+0x55/0x72 [mlx4_ib]
  [<ffffffffa0096000>] ? 0xffffffffa0096000
  [<ffffffff81000368>] do_one_initcall+0xa8/0x1c0
  [<ffffffff810ca5bf>] do_init_module+0x5f/0x210
  [<ffffffff810cc267>] load_module+0x5d7/0x700
  [<ffffffff810c97a0>] ? mod_sysfs_teardown+0x140/0x140
  [<ffffffff810c91f0>] ? module_sect_show+0x20/0x20
  [<ffffffff810cc44b>] SyS_finit_module+0xbb/0xf0
  [<ffffffff81551757>] entry_SYSCALL_64_fastpath+0x12/0x6a
Code: 90 90 90 90 90 55 48 89 e5 48 83 ec 20 48 89 5d e8 4c 89 65 f0 48 
89 fb 4c 89 6d f8 4c 8b 42 08 49 89 f5 49 89 d4 49 39 f0 75 31 <4d> 8b 
45 00 4d 39 c4 75 6f 4c 39 e3 74 45 4c 39 eb 74 40 49 89
RIP  [<ffffffff81274e36>] __list_add+0x26/0xd0
  RSP <ffff880466697898>
CR2: 0000000000000000
---[ end trace 5f4fe0ca857661e6 ]---
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
