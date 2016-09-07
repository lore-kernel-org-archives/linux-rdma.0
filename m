From: Adit Ranadive <aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
Subject: RE: [PATCH v3 04/15] IB/pvrdma: Add functions for Verbs support
Date: Wed, 7 Sep 2016 17:00:13 +0000
Message-ID: <BLUPR0501MB836F2A8282244C2821DC346C5F80@BLUPR0501MB836.namprd05.prod.outlook.com>
References: <1470266864-16888-1-git-send-email-aditr@vmware.com>
 <1470266864-16888-5-git-send-email-aditr@vmware.com>
 <20160825073000.GA12093@yuval-lap>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160825073000.GA12093@yuval-lap>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, pv-drivers <pv-drivers-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>, "Jorgen S. Hansen" <jhansen-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>, Aditya Sarwade <asarwade-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>, George Zhang <georgezhang-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>, Bryan Tan <bryantan-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Aug 25, 2016 at 00:32:13 -0700, Yuval Shaia wrote:
> On Wed, Aug 03, 2016 at 04:27:33PM -0700, Adit Ranadive wrote:
> > This patch implements the remaining Verbs functions registered with
> > the core RDMA stack.
> >
> > Changes v2->v3:
> >  - Removed the boolean from pvrdma_cmd_post call.
> >
> > Reviewed-by: Jorgen Hansen <jhansen-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
> > Reviewed-by: George Zhang <georgezhang-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
> > Reviewed-by: Aditya Sarwade <asarwade-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
> > Reviewed-by: Bryan Tan <bryantan-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
> > Signed-off-by: Adit Ranadive <aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
> > ---
> >  drivers/infiniband/hw/pvrdma/pvrdma_verbs.c | 593
> > ++++++++++++++++++++++++++++
> > drivers/infiniband/hw/pvrdma/pvrdma_verbs.h | 108 +++++
> >  2 files changed, 701 insertions(+)
> >  create mode 100644 drivers/infiniband/hw/pvrdma/pvrdma_verbs.c
> >  create mode 100644 drivers/infiniband/hw/pvrdma/pvrdma_verbs.h

...

> > +
> > +	err =3D pvrdma_cmd_post(to_vdev(ibdev), &req, &rsp);
> > +	if (err < 0 || rsp.hdr.ack !=3D PVRDMA_CMD_QUERY_PKEY_RESP) {
> > +		struct pvrdma_dev *dev =3D to_vdev(ibdev);
> > +
> > +		dev_warn(&dev->pdev->dev, "could not query device
> pkey\n");
>=20
> Error description or at least error code would help.
> (this apply to all cmd errors below)

Ok. I separated this out so that we log the error correctly.

>=20
> > +		return -EFAULT;
> > +	}
> > +
> > +	*pkey =3D rsp.query_pkey_resp.pkey;
> > +
> > +	return 0;
> > +}
> > +
> > +enum rdma_link_layer pvrdma_port_link_layer(struct ib_device *ibdev,
> > +					    u8 port)
> > +{
> > +	return IB_LINK_LAYER_ETHERNET;
> > +}
> > +
> > +int pvrdma_modify_device(struct ib_device *ibdev, int mask,
> > +			 struct ib_device_modify *props)
> > +{
> > +	unsigned long flags;
> > +	int ret;
> > +
> > +	if (mask & ~(IB_DEVICE_MODIFY_SYS_IMAGE_GUID |
> > +		     IB_DEVICE_MODIFY_NODE_DESC)) {
> > +		struct pvrdma_dev *dev =3D to_vdev(ibdev);
> > +
> > +		dev_warn(&dev->pdev->dev, "unsupported device modify
> mask\n");
> > +		ret =3D -EOPNOTSUPP;
> > +		goto err_out;
> > +	}
> > +
> > +	if (mask & IB_DEVICE_MODIFY_NODE_DESC) {
> > +		spin_lock_irqsave(&to_vdev(ibdev)->desc_lock, flags);
> > +		memcpy(ibdev->node_desc, props->node_desc, 64);
> > +		spin_unlock_irqrestore(&to_vdev(ibdev)->desc_lock, flags);
> > +	}
> > +
> > +	if (mask & IB_DEVICE_MODIFY_SYS_IMAGE_GUID) {
> > +		mutex_lock(&to_vdev(ibdev)->port_mutex);
> > +		to_vdev(ibdev)->sys_image_guid =3D
> > +			cpu_to_be64(props->sys_image_guid);
> > +		mutex_unlock(&to_vdev(ibdev)->port_mutex);
> > +	}
>=20
> Suggesting restructure:
> 	if (mask & IB_DEVICE_MODIFY_NODE_DESC) {
> 		do stuff
> 		goto out;
> 	}
> 	if (mask & IB_DEVICE_MODIFY_SYS_IMAGE_GUID) {
> 		do stuff
> 		goto out;
> 	}
>=20
> 	dev_warn(&dev->pdev->dev, "Unsupported device modify mask
> 0x%x\n", mask);
> 	ret =3D -EOPNOTSUPP;
>=20
> out:
> 	return err;
>=20
> Reasons:
> 1. Code will be easy to maintain when adding support for new mask.
> 2. Less & and | operations.
>=20

Thanks for the suggestion but not sure if that would work. We need to=20
check whether the mask is correct, which means checking if either one or
both the masks is/are specified. Also, if both masks are specified we need =
to
do stuff for both. In your suggestion, if the DEVICE_MODIFY mask is specifi=
ed
we would skip the SYS_IMAGE mask.

I did remove the goto though in the first if check and the other suggestion=
s.

Thanks,
Adit
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
