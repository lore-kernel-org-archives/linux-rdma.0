From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: Re: [PATCH v2] IB/core: Fix two kernel warnings triggered by rxe
 registration
Date: Wed, 3 Jan 2018 20:04:14 -0700
Message-ID: <20180104030414.GA663@ziepe.ca>
References: <20180103212818.10351-1-bart.vanassche@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20180103212818.10351-1-bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wed, Jan 03, 2018 at 01:28:18PM -0800, Bart Van Assche wrote:
> Avoid that the following two warnings are reported when registering an
> rxe device:
> 
> WARNING: CPU: 2 PID: 1005 at drivers/infiniband/core/device.c:449 ib_register_device+0x591/0x640 [ib_core]
> CPU: 2 PID: 1005 Comm: run_tests Not tainted 4.15.0-rc4-dbg+ #2
> Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.0.0-prebuilt.qemu-project.org 04/01/2014
> RIP: 0010:ib_register_device+0x591/0x640 [ib_core]
> Call Trace:
>  rxe_register_device+0x3c6/0x470 [rdma_rxe]
>  rxe_add+0x543/0x5e0 [rdma_rxe]
>  rxe_net_add+0x37/0xb0 [rdma_rxe]
>  rxe_param_set_add+0x5a/0x120 [rdma_rxe]
>  param_attr_store+0x5e/0xc0
>  module_attr_store+0x19/0x30
>  sysfs_kf_write+0x3d/0x50
>  kernfs_fop_write+0x116/0x1a0
>  __vfs_write+0x23/0x120
>  vfs_write+0xbe/0x1b0
>  SyS_write+0x44/0xa0
>  entry_SYSCALL_64_fastpath+0x23/0x9a
> 
> WARNING: CPU: 2 PID: 1005 at drivers/infiniband/core/sysfs.c:1279 ib_device_register_sysfs+0x11d/0x160 [ib_core]
> CPU: 2 PID: 1005 Comm: run_tests Tainted: G        W        4.15.0-rc4-dbg+ #2
> Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.0.0-prebuilt.qemu-project.org 04/01/2014
> RIP: 0010:ib_device_register_sysfs+0x11d/0x160 [ib_core]
> Call Trace:
>  ib_register_device+0x3f7/0x640 [ib_core]
>  rxe_register_device+0x3c6/0x470 [rdma_rxe]
>  rxe_add+0x543/0x5e0 [rdma_rxe]
>  rxe_net_add+0x37/0xb0 [rdma_rxe]
>  rxe_param_set_add+0x5a/0x120 [rdma_rxe]
>  param_attr_store+0x5e/0xc0
>  module_attr_store+0x19/0x30
>  sysfs_kf_write+0x3d/0x50
>  kernfs_fop_write+0x116/0x1a0
>  __vfs_write+0x23/0x120
>  vfs_write+0xbe/0x1b0
>  SyS_write+0x44/0xa0
>  entry_SYSCALL_64_fastpath+0x23/0x9a
> 
> Fixes: 99db9494035f ("IB/core: Remove ib_device.dma_device")
> Signed-off-by: Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
> Cc: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Cc: stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org # v4.11

Applied to for-next thanks

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
