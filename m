From: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: RE: [PATCH] IB/core: Restore I/O MMU, s390 and powerpc support
Date: Wed, 8 Mar 2017 17:48:11 +0000
Message-ID: <VI1PR0502MB3008C44D1D0B213B91697A8AD12E0@VI1PR0502MB3008.eurprd05.prod.outlook.com>
References: <1D08B61A9CF0974AA09887BE32D889DA0DBFCB@ULS-OP-MBXIP03.sdcorp.global.sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <Bart.VanAssche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Sebastian Ott <sebott-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Bart,

I tested with mlx5 with/without enabling iommu.
I haven't tested rxe.

Reviewed-by: parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
Tested-by: parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org

Parav

> -----Original Message-----
> From: Parav Pandit
> Sent: Tuesday, March 7, 2017 6:51 PM
> To: 'Bart Van Assche' <Bart.VanAssche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>; Doug Ledford
> <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Cc: Sebastian Ott <sebott-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>; linux-
> rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Subject: RE: [PATCH] IB/core: Restore I/O MMU, s390 and powerpc support
>=20
> Hi Bart,
>=20
> This fix looks good to me.
> I haven't had chance to test it yet.
>=20
> Parav
>=20
> > -----Original Message-----
> > From: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-rdma-
> > owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of Bart Van Assche
> > Sent: Tuesday, March 7, 2017 4:57 PM
> > To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> > Cc: Sebastian Ott <sebott-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>; Parav Pandit
> > <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>; linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > Subject: [PATCH] IB/core: Restore I/O MMU, s390 and powerpc support
> >
> > Avoid that the following error message is reported on the console
> > while loading an RDMA driver with I/O MMU support enabled:
> >
> > DMAR: Allocating domain for mlx5_0 failed
> >
> > Ensure that DMA mapping operations that use to_pci_dev() to access to
> > struct pci_dev see the correct PCI device. E.g. the s390 and powerpc
> > DMA mapping operations use to_pci_dev() even with I/O MMU support
> disabled.
> >
> > This patch preserves the following changes of the DMA mapping updates
> > patch series:
> > - Introduction of dma_virt_ops.
> > - Removal of ib_device.dma_ops.
> > - Removal of struct ib_dma_mapping_ops.
> > - Removal of an if-statement from each ib_dma_*() operation.
> > - IB HW drivers no longer set dma_device directly.
> >
> > Reported-by: Sebastian Ott <sebott-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
> > Reported-by: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> > Fixes: commit 99db9494035f ("IB/core: Remove ib_device.dma_device")
> > Signed-off-by: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
> > ---
> >  drivers/infiniband/core/device.c | 26 ++++++++++++++++++++------
> >  include/rdma/ib_verbs.h          | 30 +++++++++++++++++-------------
> >  2 files changed, 37 insertions(+), 19 deletions(-)
> >
> > diff --git a/drivers/infiniband/core/device.c
> > b/drivers/infiniband/core/device.c
> > index 593d2ce6ec7c..addf869045cc 100644
> > --- a/drivers/infiniband/core/device.c
> > +++ b/drivers/infiniband/core/device.c
> > @@ -336,12 +336,26 @@ int ib_register_device(struct ib_device *device,
> >  	struct device *parent =3D device->dev.parent;
> >
> >  	WARN_ON_ONCE(!parent);
> > -	if (!device->dev.dma_ops)
> > -		device->dev.dma_ops =3D parent->dma_ops;
> > -	if (!device->dev.dma_mask)
> > -		device->dev.dma_mask =3D parent->dma_mask;
> > -	if (!device->dev.coherent_dma_mask)
> > -		device->dev.coherent_dma_mask =3D parent-
> > >coherent_dma_mask;
> > +	WARN_ON_ONCE(device->dma_device);
> > +	if (device->dev.dma_ops) {
> > +		/*
> > +		 * The caller provided custom DMA operations. Copy the
> > +		 * DMA-related fields that are used by e.g.
> > dma_alloc_coherent()
> > +		 * into device->dev.
> > +		 */
> > +		device->dma_device =3D &device->dev;
> > +		if (!device->dev.dma_mask)
> > +			device->dev.dma_mask =3D parent->dma_mask;
> > +		if (!device->dev.coherent_dma_mask)
> > +			device->dev.coherent_dma_mask =3D
> > +				parent->coherent_dma_mask;
> > +	} else {
> > +		/*
> > +		 * The caller did not provide custom DMA operations. Use the
> > +		 * DMA mapping operations of the parent device.
> > +		 */
> > +		device->dma_device =3D parent;
> > +	}
> >
> >  	mutex_lock(&device_mutex);
> >
> > diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h index
> > 0f1813c13687..99e4423eb2b8 100644
> > --- a/include/rdma/ib_verbs.h
> > +++ b/include/rdma/ib_verbs.h
> > @@ -1863,6 +1863,9 @@ struct ib_port_immutable {  };
> >
> >  struct ib_device {
> > +	/* Do not access @dma_device directly from ULP nor from HW
> > drivers. */
> > +	struct device                *dma_device;
> > +
> >  	char                          name[IB_DEVICE_NAME_MAX];
> >
> >  	struct list_head              event_handler_list;
> > @@ -3007,7 +3010,7 @@ static inline int ib_req_ncomp_notif(struct
> > ib_cq *cq, int wc_cnt)
> >   */
> >  static inline int ib_dma_mapping_error(struct ib_device *dev, u64
> > dma_addr)  {
> > -	return dma_mapping_error(&dev->dev, dma_addr);
> > +	return dma_mapping_error(dev->dma_device, dma_addr);
> >  }
> >
> >  /**
> > @@ -3021,7 +3024,7 @@ static inline u64 ib_dma_map_single(struct
> > ib_device *dev,
> >  				    void *cpu_addr, size_t size,
> >  				    enum dma_data_direction direction)  {
> > -	return dma_map_single(&dev->dev, cpu_addr, size, direction);
> > +	return dma_map_single(dev->dma_device, cpu_addr, size,
> > direction);
> >  }
> >
> >  /**
> > @@ -3035,7 +3038,7 @@ static inline void ib_dma_unmap_single(struct
> > ib_device *dev,
> >  				       u64 addr, size_t size,
> >  				       enum dma_data_direction direction)  {
> > -	dma_unmap_single(&dev->dev, addr, size, direction);
> > +	dma_unmap_single(dev->dma_device, addr, size, direction);
> >  }
> >
> >  /**
> > @@ -3052,7 +3055,7 @@ static inline u64 ib_dma_map_page(struct
> > ib_device *dev,
> >  				  size_t size,
> >  					 enum dma_data_direction direction)
> {
> > -	return dma_map_page(&dev->dev, page, offset, size, direction);
> > +	return dma_map_page(dev->dma_device, page, offset, size,
> > direction);
> >  }
> >
> >  /**
> > @@ -3066,7 +3069,7 @@ static inline void ib_dma_unmap_page(struct
> > ib_device *dev,
> >  				     u64 addr, size_t size,
> >  				     enum dma_data_direction direction)  {
> > -	dma_unmap_page(&dev->dev, addr, size, direction);
> > +	dma_unmap_page(dev->dma_device, addr, size, direction);
> >  }
> >
> >  /**
> > @@ -3080,7 +3083,7 @@ static inline int ib_dma_map_sg(struct ib_device
> > *dev,
> >  				struct scatterlist *sg, int nents,
> >  				enum dma_data_direction direction)  {
> > -	return dma_map_sg(&dev->dev, sg, nents, direction);
> > +	return dma_map_sg(dev->dma_device, sg, nents, direction);
> >  }
> >
> >  /**
> > @@ -3094,7 +3097,7 @@ static inline void ib_dma_unmap_sg(struct
> > ib_device *dev,
> >  				   struct scatterlist *sg, int nents,
> >  				   enum dma_data_direction direction)  {
> > -	dma_unmap_sg(&dev->dev, sg, nents, direction);
> > +	dma_unmap_sg(dev->dma_device, sg, nents, direction);
> >  }
> >
> >  static inline int ib_dma_map_sg_attrs(struct ib_device *dev, @@
> > -3102,7
> > +3105,8 @@ static inline int ib_dma_map_sg_attrs(struct ib_device
> > +*dev,
> >  				      enum dma_data_direction direction,
> >  				      unsigned long dma_attrs)
> >  {
> > -	return dma_map_sg_attrs(&dev->dev, sg, nents, direction,
> > dma_attrs);
> > +	return dma_map_sg_attrs(dev->dma_device, sg, nents, direction,
> > +				dma_attrs);
> >  }
> >
> >  static inline void ib_dma_unmap_sg_attrs(struct ib_device *dev, @@ -
> > 3110,7 +3114,7 @@ static inline void ib_dma_unmap_sg_attrs(struct
> > ib_device *dev,
> >  					 enum dma_data_direction direction,
> >  					 unsigned long dma_attrs)
> >  {
> > -	dma_unmap_sg_attrs(&dev->dev, sg, nents, direction, dma_attrs);
> > +	dma_unmap_sg_attrs(dev->dma_device, sg, nents, direction,
> > dma_attrs);
> >  }
> >  /**
> >   * ib_sg_dma_address - Return the DMA address from a scatter/gather
> > entry @@ -3152,7 +3156,7 @@ static inline void
> > ib_dma_sync_single_for_cpu(struct ib_device *dev,
> >  					      size_t size,
> >  					      enum dma_data_direction dir)  {
> > -	dma_sync_single_for_cpu(&dev->dev, addr, size, dir);
> > +	dma_sync_single_for_cpu(dev->dma_device, addr, size, dir);
> >  }
> >
> >  /**
> > @@ -3167,7 +3171,7 @@ static inline void
> > ib_dma_sync_single_for_device(struct ib_device *dev,
> >  						 size_t size,
> >  						 enum dma_data_direction
> > dir)
> >  {
> > -	dma_sync_single_for_device(&dev->dev, addr, size, dir);
> > +	dma_sync_single_for_device(dev->dma_device, addr, size, dir);
> >  }
> >
> >  /**
> > @@ -3182,7 +3186,7 @@ static inline void *ib_dma_alloc_coherent(struct
> > ib_device *dev,
> >  					   dma_addr_t *dma_handle,
> >  					   gfp_t flag)
> >  {
> > -	return dma_alloc_coherent(&dev->dev, size, dma_handle, flag);
> > +	return dma_alloc_coherent(dev->dma_device, size, dma_handle,
> > flag);
> >  }
> >
> >  /**
> > @@ -3196,7 +3200,7 @@ static inline void ib_dma_free_coherent(struct
> > ib_device *dev,
> >  					size_t size, void *cpu_addr,
> >  					dma_addr_t dma_handle)
> >  {
> > -	dma_free_coherent(&dev->dev, size, cpu_addr, dma_handle);
> > +	dma_free_coherent(dev->dma_device, size, cpu_addr,
> > dma_handle);
> >  }
> >
> >  /**
> > --
> > 2.12.0
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-rdma"
> > in the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org More
> majordomo
> > info at http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
