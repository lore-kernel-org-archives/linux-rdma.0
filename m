From: Vladimir Sokolovsky <vlad-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [BUG] Bad page map in process ibv_devinfo
Date: Sun, 13 Nov 2011 10:26:36 +0200
Message-ID: <4EBF7F3C.2020804@dev.mellanox.co.il>
References: <1321110951.99968.YahooMailNeo@web24712.mail.ird.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1321110951.99968.YahooMailNeo-06aSuiz6pSvyX4RqAA4FmIglqE1Y4D90QQ4Iyu8u01E@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Lukas Razik <linux-GLgANOly0l1BDLzU/O5InQ@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 11/12/2011 05:15 PM, Lukas Razik wrote:
> Hello Mr. Sokolovsky,
>
> i've built OFED-1.5.3.2 for a linux-2.6.39.4 sparc64 (vanilla) kernel. The IPoIB stuff works fine.
>
> If I run 'ibv_devinfo' I get:
> ---
>
> hca_id: mlx4_0
>          transport:                      InfiniBand (0)
>          fw_ver:                         2.6.628
>          node_guid:                      0003:ba00:0100:b1d8
>          sys_image_guid:                 0003:ba00:0100:b1db
>          vendor_id:                      0x03ba
>          vendor_part_id:                 25418
>          hw_ver:                         0xA0
>          board_id:                       SUN0070000001
>          phys_port_cnt:                  2
>                  port:   1
>                          state:                  PORT_ACTIVE (4)
>                          max_mtu:                2048 (4)
>                          active_mtu:             2048 (4)
>                          sm_lid:                 1
>                          port_lid:               6
>                          port_lmc:               0x00
>                          link_layer:             IB[...]
> ---
>


Hello Lukas,
Try to update HCA's firmware to the latest version (http://www.mellanox.com/content/pages.php?pg=firmware_download).

Regards,
Vladimir



> But I also get this BUG message from the kernel:
> ---
> [ 9305.698663] swap_free: Bad swap file entry 100005e000061800
> [ 9305.698791] BUG: Bad page map in process ibv_devinfo  pte:bc0000c300104848 pmd:00f38054
> [ 9305.698908] addr:fffff80100114000 vm_flags:000844fa anon_vma:          (null) mapping:fffff807f313a410 index:6180082
> [ 9305.699087] vma->vm_file->f_op->mmap: ib_uverbs_mmap+0x8/0x38 [ib_uverbs]
> [ 9305.699135] Call Trace:
> [ 9305.699174]  [00000000004cd558] unmap_vmas+0x514/0x7f4
> [ 9305.699302]  [00000000004d1274] unmap_region+0xb4/0x164
> [ 9305.699383]  [00000000004d22c0] do_munmap+0x2a8/0x31c
> [ 9305.699467]  [000000000042d350] SyS_64_munmap+0x88/0xa8
> [ 9305.699550]  [0000000000406154] linux_sparc_syscall+0x34/0x44
> ---
>
>
> I've the following
> - System: Sun T5120 (SPARC64)
>
> - OS: Debian 6.0.3
> - IB-card:
> # lspci -s 12:00
>
> 12:00.0 InfiniBand: Mellanox Technologies MT25418 [ConnectX VPI PCIe 2.0 2.5GT/s - IB DDR / 10GigE] (rev a0)
>
>
> And same BUG messages with:
> - OFED-1.5.3.2 with linux-2.6.38 (vanilla)
>
> - OFED-1.5.4-rc4 with linux-2.6.39.4 (vanilla)
>
>
> The problem is that I also get such messages when I run openmpi over openib (naturally with another process name than 'ibv_devinfo'). Then mpirun dies with an error message. Hence I can't use MPI over the Infiniband cards...
>
>
> So is there something I could try to do to get these cards working?
> Can I give you more debug information?
>
>
> I'm very happy about any help!
>
>
> Regards,
> Lukas
>
>
>
> PS:
> My kernel-config:
> http://net.razik.de/linux/T5120/config-2.6.39.4-razik-2011-11-05
>
>
> The OFED-packets I've installed:
>
> ---
>
> kernel-ib
> ofed-scripts
> libibverbs
> libibverbs-devel
> libibverbs-utils
> libmlx4
> libmlx4-devel
> libibumad
> libibumad-devel
> libibmad
> libibmad-devel
> librdmacm
> librdmacm-utils
> librdmacm-devel
> opensm-libs
> ibutils
> infiniband-diags
> ofed-docs
> mpi-selector
> openmpi_gcc
> mpitests_openmpi_gcc
> ---
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
