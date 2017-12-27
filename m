From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: Re: [PATCH] IB/core: Fix two kernel warnings triggered by rxe
 registration
Date: Wed, 27 Dec 2017 15:56:47 -0700
Message-ID: <20171227225647.GJ25436@ziepe.ca>
References: <20171222213852.3481-1-bart.vanassche@wdc.com>
 <20171225102839.GD2942@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20171225102839.GD2942-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Mon, Dec 25, 2017 at 12:28:39PM +0200, Leon Romanovsky wrote:
> On Fri, Dec 22, 2017 at 01:38:52PM -0800, Bart Van Assche wrote:
> > Avoid that the following two warnings are reported when registering an
> > rxe device:
> >
> > WARNING: CPU: 2 PID: 1005 at drivers/infiniband/core/device.c:449 ib_register_device+0x591/0x640 [ib_core]
> > CPU: 2 PID: 1005 Comm: run_tests Not tainted 4.15.0-rc4-dbg+ #2
> > Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.0.0-prebuilt.qemu-project.org 04/01/2014
> > RIP: 0010:ib_register_device+0x591/0x640 [ib_core]
> > Call Trace:
> >  rxe_register_device+0x3c6/0x470 [rdma_rxe]
> >  rxe_add+0x543/0x5e0 [rdma_rxe]
> >  rxe_net_add+0x37/0xb0 [rdma_rxe]
> >  rxe_param_set_add+0x5a/0x120 [rdma_rxe]
> >  param_attr_store+0x5e/0xc0
> >  module_attr_store+0x19/0x30
> >  sysfs_kf_write+0x3d/0x50
> >  kernfs_fop_write+0x116/0x1a0
> >  __vfs_write+0x23/0x120
> >  vfs_write+0xbe/0x1b0
> >  SyS_write+0x44/0xa0
> >  entry_SYSCALL_64_fastpath+0x23/0x9a
> >
> > WARNING: CPU: 2 PID: 1005 at drivers/infiniband/core/sysfs.c:1279 ib_device_register_sysfs+0x11d/0x160 [ib_core]
> > CPU: 2 PID: 1005 Comm: run_tests Tainted: G        W        4.15.0-rc4-dbg+ #2
> > Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.0.0-prebuilt.qemu-project.org 04/01/2014
> > RIP: 0010:ib_device_register_sysfs+0x11d/0x160 [ib_core]
> > Call Trace:
> >  ib_register_device+0x3f7/0x640 [ib_core]
> >  rxe_register_device+0x3c6/0x470 [rdma_rxe]
> >  rxe_add+0x543/0x5e0 [rdma_rxe]
> >  rxe_net_add+0x37/0xb0 [rdma_rxe]
> >  rxe_param_set_add+0x5a/0x120 [rdma_rxe]
> >  param_attr_store+0x5e/0xc0
> >  module_attr_store+0x19/0x30
> >  sysfs_kf_write+0x3d/0x50
> >  kernfs_fop_write+0x116/0x1a0
> >  __vfs_write+0x23/0x120
> >  vfs_write+0xbe/0x1b0
> >  SyS_write+0x44/0xa0
> >  entry_SYSCALL_64_fastpath+0x23/0x9a
> >
> > Fixes: commit 99db9494035f ("IB/core: Remove ib_device.dma_device")
> 
> 	^^^^^^ redundant
> 
> > Signed-off-by: Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
> > Cc: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> > Cc: stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org # v4.11
> >  drivers/infiniband/core/device.c | 2 +-
> >  drivers/infiniband/core/sysfs.c  | 1 -
> >  2 files changed, 1 insertion(+), 2 deletions(-)
> >
> > diff --git a/drivers/infiniband/core/device.c b/drivers/infiniband/core/device.c
> > index 30914f3baa5f..b9d7570e9989 100644
> > +++ b/drivers/infiniband/core/device.c
> > @@ -446,7 +446,6 @@ int ib_register_device(struct ib_device *device,
> >  	struct ib_udata uhw = {.outlen = 0, .inlen = 0};
> >  	struct device *parent = device->dev.parent;
> >
> > -	WARN_ON_ONCE(!parent);
> >  	WARN_ON_ONCE(device->dma_device);
> >  	if (device->dev.dma_ops) {
> 
> I understand that it fixed warning for you, but why is it correct?
> You are using "parent" in this "if (device->dev.dma_ops)" too.

If no parent is specified then the caller must provide a full set of
DMA data and none should be copied from the parent.

Presumably rxe does this, and has no parent because it is a virtual
device.

I'm a little more worried about the ib_device_register_sysfs - why was
the WARN_ON ever there?

What do you think about this as a clarification Bart?

diff --git a/drivers/infiniband/core/device.c b/drivers/infiniband/core/device.c
index bb2686d56d3c65..c535c7803d80a7 100644
--- a/drivers/infiniband/core/device.c
+++ b/drivers/infiniband/core/device.c
@@ -446,7 +446,6 @@ int ib_register_device(struct ib_device *device,
 	struct ib_udata uhw = {.outlen = 0, .inlen = 0};
 	struct device *parent = device->dev.parent;
 
-	WARN_ON_ONCE(!parent);
 	WARN_ON_ONCE(device->dma_device);
 	if (device->dev.dma_ops) {
 		/*
@@ -455,16 +454,20 @@ int ib_register_device(struct ib_device *device,
 		 * into device->dev.
 		 */
 		device->dma_device = &device->dev;
-		if (!device->dev.dma_mask)
-			device->dev.dma_mask = parent->dma_mask;
-		if (!device->dev.coherent_dma_mask)
-			device->dev.coherent_dma_mask =
-				parent->coherent_dma_mask;
+
+		if (parent) {
+			if (!device->dev.dma_mask)
+				device->dev.dma_mask = parent->dma_mask;
+			if (!device->dev.coherent_dma_mask)
+				device->dev.coherent_dma_mask =
+					parent->coherent_dma_mask;
+		}
 	} else {
 		/*
 		 * The caller did not provide custom DMA operations. Use the
 		 * DMA mapping operations of the parent device.
 		 */
+		WARN_ON_ONCE(!parent);
 		device->dma_device = parent;
 	}
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
