From: konrad wilk <konrad.wilk-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [Xen-devel] BUG: bad page map under Xen
Date: Mon, 21 Oct 2013 08:59:32 -0400
Message-ID: <52652534.2040303@oracle.com>
References: <20131021115740.GN20913@ics.muni.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20131021115740.GN20913-8qz54MUs51PtwjQa/ONI9g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Lukas Hejtmanek <xhejtman-8qz54MUs51PtwjQa/ONI9g@public.gmane.org>
Cc: xen-devel-GuqFBffKawuEi8DpZVb4nw@public.gmane.org, roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


On 10/21/2013 7:57 AM, Lukas Hejtmanek wrote:
> Hello,
>
> I'm trying to get SR-IOV working under Xen (4.2). It almost works except
> memory bug. This is easily reproducible just in Dom0.
>
> I have Connect-X3 card with the latest firmware. OFED 2.0-3 drivers. I tried
> 3.2 kernel from Debian, 3.10 kernel from Debian and vanila 3.11.5 kernel. All
> are the same.

Ha! Funny you mention that. I had been looking at this.
> As soon as I issue ibv_devinfo command, it produces the following messages
> into dmesg. Problem is that with ib_rdma_bw command, I get more of those
> messages and moreover, oom killer gets confused and kills almost all
> processes.
>
> [23502.645455] mlx4_core 0000:06:00.0: mlx4_ib: Port 1 logical link is up
> [23550.181907] <mlx4_ib> check_flow_steering_support: Device managed flow steering is unavailable for IB port in multifunction env.
> [23550.183822] swap_free: Unused swap offset entry 00000001
> [23550.183868] BUG: Bad page map in process ibv_devinfo  pte:00000200 pmd:1b7df4067
> [23550.183939] addr:00007f7ef5e18000 vm_flags:400844fa anon_vma:          (null) mapping:ffff8801b83c0480 index:380fe0882
> [23550.184022] vma->vm_file->f_op->mmap: ib_uverbs_mmap+0x0/0x2d [ib_uverbs]
> [23550.195382] Pid: 13813, comm: ibv_devinfo Tainted: G           O 3.2.0-0.bpo.4-amd64 #1 Debian 3.2.41-2+deb7u2~bpo60+1+zs4
> [23550.195461] Call Trace:
> [23550.195508]  [<ffffffff810d9009>] ? print_bad_pte+0x1f5/0x20d
> [23550.195553]  [<ffffffff810db083>] ? unmap_vmas+0x5fe/0x814
> [23550.195601]  [<ffffffff810c68dd>] ? __add_page_to_lru_list+0x53/0x53
> [23550.195647]  [<ffffffff810df2de>] ? unmap_region+0x9f/0x102
> [23550.195694]  [<ffffffff8100d722>] ? __switch_to+0x23b/0x2b1
> [23550.195741]  [<ffffffff8103d870>] ? pick_next_task_fair+0xfc/0x10c
> [23550.195788]  [<ffffffff810463a2>] ? finish_task_switch+0x53/0xc7
> [23550.195832]  [<ffffffff810e01f7>] ? do_munmap+0x281/0x2eb
> [23550.195875]  [<ffffffff810e02a0>] ? sys_munmap+0x3f/0x55
> [23550.195921]  [<ffffffff8136e51c>] ? system_call_fastpath+0x16/0x1b
> [23550.195965] Disabling lock debugging due to kernel taint
> [23550.196412] <mlx4_ib> check_flow_steering_support: Device managed flow steering is unavailable for IB port in multifunction env.
> [23550.198303] swap_free: Unused swap offset entry 00000001
> [23550.198348] BUG: Bad page map in process ibv_devinfo  pte:00000200 pmd:1b7df4067
> [23550.198424] addr:00007f7ef5e18000 vm_flags:400844fa anon_vma:          (null) mapping:ffff8801b83c09a0 index:380fe0082
..
> this happens only if running under Xen. Native kernel in the same version is OK.
>
> Is it a known bug or is something wrong with BIOS/firmware?
>
It is a bug in the drivers I believe. The issue is that the mapping 
created for the second mmap
call is done without VM_IO and on an PFN that is RAM (and not the BAR). 
But I am not entirely
sure and hopefully this week will have a better idea and fix. Stay tuned.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
