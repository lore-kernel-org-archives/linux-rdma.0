From: Johannes Thumshirn <jthumshirn-l3A5Bk7waGM@public.gmane.org>
Subject: Re: [PATCH rdma-next 2/2] IB/rxe: Set dma_mask and coherent_dma_mask
Date: Thu, 22 Jun 2017 16:18:40 +0200
Message-ID: <20170622141840.GO5670@linux-x5ow.site>
References: <20170622141000.9899-1-leon@kernel.org>
 <20170622141000.9899-2-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170622141000.9899-2-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yonatan Cohen <yonatanc-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Jun 22, 2017 at 05:10:00PM +0300, Leon Romanovsky wrote:
> From: yonatanc <yonatanc-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> 
> The RXE coupled with dummy device causes to the kernel panic attached
> below.  The panic happens when ib_register_device tries to set dma_mask
> by accessing a NULLed parent device.
> 
> The RXE does not actually use DMA, so we can set the dma_mask
> to architecture value.
> 
> [16240.199689] RIP: 0010:ib_register_device+0x468/0x5a0 [ib_core]
> [16240.205289] RSP: 0018:ffffc9000220fc10 EFLAGS: 00010246
> [16240.209909] RAX: 0000000000000024 RBX: ffff880220d1a2a8 RCX: 0000000000000000
> [16240.212244] RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000009
> [16240.214385] RBP: ffffc9000220fcb0 R08: 0000000000000000 R09: 000000000000023f
> [16240.254465] R10: 0000000000000007 R11: 0000000000000000 R12: 0000000000000000
> [16240.259467] R13: 0000000000000000 R14: 0000000000000000 R15: ffff880220d1a2a8
> [16240.263314] FS:  00007fd8ecca0740(0000) GS:ffff8802364c0000(0000) knlGS:0000000000000000
> [16240.267292] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [16240.273503] CR2: 0000000000000218 CR3: 00000002253ba000 CR4: 00000000000006e0
> [16240.277066] Call Trace:
> [16240.281836]  ? __kmalloc+0x26f/0x280
> [16240.286596]  rxe_register_device+0x297/0x300 [rdma_rxe]
> [16240.291377]  rxe_add+0x535/0x5b0 [rdma_rxe]
> [16240.297586]  rxe_net_add+0x3e/0xc0 [rdma_rxe]
> [16240.302375]  rxe_param_set_add+0x65/0x144 [rdma_rxe]
> [16240.307769]  param_attr_store+0x68/0xd0
> [16240.311640]  module_attr_store+0x1d/0x30
> [16240.316421]  sysfs_kf_write+0x3a/0x50
> [16240.317802]  kernfs_fop_write+0xff/0x180
> [16240.322989]  __vfs_write+0x37/0x140
> [16240.328164]  ? handle_mm_fault+0xce/0x240
> [16240.333340]  vfs_write+0xb2/0x1b0
> [16240.335013]  SyS_write+0x55/0xc0
> [16240.340632]  entry_SYSCALL_64_fastpath+0x1a/0xa9
> 
> Fixes: 8700e3e7c485 ("Soft RoCE driver")
> Signed-off-by: Yonatan Cohen <yonatanc-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Reviewed-by: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> ---

Reviewed-by: Johannes Thumshirn <jthumshirn-l3A5Bk7waGM@public.gmane.org>
-- 
Johannes Thumshirn                                          Storage
jthumshirn-l3A5Bk7waGM@public.gmane.org                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
