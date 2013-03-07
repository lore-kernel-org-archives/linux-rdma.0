From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: mlx4 module loading fail
Date: Thu, 7 Mar 2013 17:34:10 +0200
Message-ID: <5138B372.4020201@mellanox.com>
References: <96353B6F8A3DAE4BBC51047BD0E6BAC20913A5@DEWDFEMB17A.global.corp.sap>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <96353B6F8A3DAE4BBC51047BD0E6BAC20913A5-v0w1aZ/WxVLTw0Kyn31wWKuC/IaeJB0jHWlK3eZauXw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hudzia, Benoit" <benoit.hudzia-y6kNeMnOB+c@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 07/03/2013 13:18, Hudzia, Benoit wrote:
> I am currently experiencing some trouble with my connectx2 cards. I  have been doing test with smallish server without any problem and this week I upgraded to a more beefier option. However I fail to be able setup the IB card with our current kernel.
> The servers spec are as follow:
> 	* 4x 10 core Intel(R) Xeon(R) CPU E7- 4870  @ 2.40GHz stepping 02
> 	* 1TB of RAM
> 	* 1 connectx2 IB
>
> Kernel Version : 3.5.0 Note if I downgrade to a 3.2 kernel I do not experience this issue. However I am forced to work with a 3.5 or higher. Can somebody help me with that?

Hi Benoit,

As was suggested here can you try 3.8 or 3.9-rc1, this will help a lot 
to isolate the problem, but even before that, the warning you are 
getting is as of
allocation with order > MAX_ORDER, what's MAX_ORDER under your 
configuration and what value do you provide to mlx4_buddy_init from 
mlx4_init_mr_table (did you modify that code?)

Or.

>
> Kernel log trace:
>
> Mar  7 03:12:27 bi-heca-02 kernel: [    7.423038] ------------[ cut here ]------------
> Mar  7 03:12:27 bi-heca-02 kernel: [    7.423049] WARNING: at mm/page_alloc.c:2298 __alloc_pages_nodemask+0x2b9/0x810()
> Mar  7 03:12:27 bi-heca-02 kernel: [    7.423050] Hardware name: QSSC-S4R
> Mar  7 03:12:27 bi-heca-02 kernel: [    7.423051] Modules linked in: joydev coretemp kvm_intel kvm microcode pcspkr ixgbe mlx4_core(+) igb mdio ioatdma i2c_i801 hid_generic lpc_ich i2c_core mfd_core dca tpm_tis tpm tpm_bios acpi_memhotpl
> ug evbug crc32c_intel megaraid_sas usbhid hid
> Mar  7 03:12:27 bi-heca-02 kernel: [    7.423078] Pid: 949, comm: modprobe Not tainted 3.5.0-heca-dev-34dd48a+ #29
> Mar  7 03:12:27 bi-heca-02 kernel: [    7.423079] Call Trace:
> Mar  7 03:12:27 bi-heca-02 kernel: [    7.423088]  [<ffffffff8104baef>] warn_slowpath_common+0x7f/0xc0
> Mar  7 03:12:27 bi-heca-02 kernel: [    7.423091]  [<ffffffff8104bb4a>] warn_slowpath_null+0x1a/0x20
> Mar  7 03:12:27 bi-heca-02 kernel: [    7.423093]  [<ffffffff811028b9>] __alloc_pages_nodemask+0x2b9/0x810
> Mar  7 03:12:27 bi-heca-02 kernel: [    7.423096]  [<ffffffff81102785>] ? __alloc_pages_nodemask+0x185/0x810
> Mar  7 03:12:27 bi-heca-02 kernel: [    7.423101]  [<ffffffff81137086>] alloc_pages_current+0xb6/0x120
> Mar  7 03:12:27 bi-heca-02 kernel: [    7.423105]  [<ffffffff810fe02e>] __get_free_pages+0xe/0x40
> Mar  7 03:12:27 bi-heca-02 kernel: [    7.423108]  [<ffffffff8113fcff>] kmalloc_order_trace+0x3f/0xd0
> Mar  7 03:12:27 bi-heca-02 kernel: [    7.423110]  [<ffffffff810fe02e>] ? __get_free_pages+0xe/0x40
> Mar  7 03:12:27 bi-heca-02 kernel: [    7.423113]  [<ffffffff811405e0>] __kmalloc+0x100/0x160
> Mar  7 03:12:27 bi-heca-02 kernel: [    7.423131]  [<ffffffffa01ba35d>] mlx4_buddy_init+0xed/0x1a0 [mlx4_core]
> Mar  7 03:12:27 bi-heca-02 kernel: [    7.423140]  [<ffffffffa01bb8aa>] mlx4_init_mr_table+0xca/0x150 [mlx4_core]
> Mar  7 03:12:27 bi-heca-02 kernel: [    7.423148]  [<ffffffffa01b6fa7>] mlx4_setup_hca.part.12+0xf7/0x4e0 [mlx4_core]
> Mar  7 03:12:27 bi-heca-02 kernel: [    7.423156]  [<ffffffffa01aaeef>] ? mlx4_bitmap_init+0x8f/0xb0 [mlx4_core]
> Mar  7 03:12:27 bi-heca-02 kernel: [    7.423164]  [<ffffffffa01b73bb>] mlx4_setup_hca+0x2b/0x70 [mlx4_core]
> Mar  7 03:12:27 bi-heca-02 kernel: [    7.423172]  [<ffffffffa01b7ba4>] __mlx4_init_one+0x744/0x960 [mlx4_core]
> Mar  7 03:12:27 bi-heca-02 kernel: [    7.423179]  [<ffffffffa01c55b6>] mlx4_init_one+0x3d/0x42 [mlx4_core]
> Mar  7 03:12:27 bi-heca-02 kernel: [    7.423186]  [<ffffffff812e6e56>] pci_call_probe+0x96/0xb0
> Mar  7 03:12:27 bi-heca-02 kernel: [    7.423189]  [<ffffffff812e8019>] pci_device_probe+0x79/0xa0
> Mar  7 03:12:27 bi-heca-02 kernel: [    7.423194]  [<ffffffff813894fa>] ? driver_sysfs_add+0x7a/0xb0
> Mar  7 03:12:27 bi-heca-02 kernel: [    7.423196]  [<ffffffff813896b8>] really_probe+0x68/0x200
> Mar  7 03:12:27 bi-heca-02 kernel: [    7.423198]  [<ffffffff81389982>] driver_probe_device+0x22/0x30
> Mar  7 03:12:27 bi-heca-02 kernel: [    7.423200]  [<ffffffff81389a3b>] __driver_attach+0xab/0xb0
> Mar  7 03:12:27 bi-heca-02 kernel: [    7.423202]  [<ffffffff81389990>] ? driver_probe_device+0x30/0x30
> Mar  7 03:12:27 bi-heca-02 kernel: [    7.423205]  [<ffffffff81387c46>] bus_for_each_dev+0x56/0x90
> Mar  7 03:12:27 bi-heca-02 kernel: [    7.423207]  [<ffffffff813892fe>] driver_attach+0x1e/0x20
> Mar  7 03:12:27 bi-heca-02 kernel: [    7.423210]  [<ffffffff81388ed0>] bus_add_driver+0x1a0/0x270
> Mar  7 03:12:27 bi-heca-02 kernel: [    7.423216]  [<ffffffffa01d2031>] ? mlx4_catas_init+0x31/0x31 [mlx4_core]
> Mar  7 03:12:27 bi-heca-02 kernel: [    7.423218]  [<ffffffff81389f86>] driver_register+0x76/0x130
> Mar  7 03:12:27 bi-heca-02 kernel: [    7.423223]  [<ffffffff8157aa9d>] ? notifier_call_chain+0x4d/0x70
> Mar  7 03:12:27 bi-heca-02 kernel: [    7.423227]  [<ffffffff8109f0b0>] ? add_kallsyms+0x1e0/0x1e0
> Mar  7 03:12:27 bi-heca-02 kernel: [    7.423233]  [<ffffffffa01d2031>] ? mlx4_catas_init+0x31/0x31 [mlx4_core]
> Mar  7 03:12:27 bi-heca-02 kernel: [    7.423235]  [<ffffffff812e7d85>] __pci_register_driver+0x55/0xd0
> Mar  7 03:12:27 bi-heca-02 kernel: [    7.423241]  [<ffffffffa01d2031>] ? mlx4_catas_init+0x31/0x31 [mlx4_core]
> Mar  7 03:12:27 bi-heca-02 kernel: [    7.423246]  [<ffffffffa01d20dd>] mlx4_init+0xac/0xec [mlx4_core]
> Mar  7 03:12:27 bi-heca-02 kernel: [    7.423250]  [<ffffffff8100203f>] do_one_initcall+0x3f/0x170
> Mar  7 03:12:27 bi-heca-02 kernel: [    7.423253]  [<ffffffff810a18bf>] sys_init_module+0x8f/0x200
> Mar  7 03:12:27 bi-heca-02 kernel: [    7.423257]  [<ffffffff8157f0a9>] system_call_fastpath+0x16/0x1b
> Mar  7 03:12:27 bi-heca-02 kernel: [    7.423259] ---[ end trace 8886e8f0c535939d ]---
> Mar  7 03:12:27 bi-heca-02 kernel: [    7.423263] mlx4_core 0000:86:00.0: Failed to initialize memory region table, aborting.
> Mar  7 03:12:27 bi-heca-02 kernel: [    8.431444] mlx4_core: probe of 0000:86:00.0 failed with error -12
>

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
