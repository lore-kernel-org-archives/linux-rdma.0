From: Bernard Metzler <BMT-OA+xvbQnYDHMbYB6QlFGEg@public.gmane.org>
Subject: Re: NFS/RDMA - client crash on mount
Date: Wed, 30 May 2012 14:46:33 +0200
Message-ID: <OFE0E8C87E.2CEC4F01-ONC1257A0E.0045C64E-C1257A0E.004632D6@ch.ibm.com>
References: <20120530114338.GA28445@nautica> <20120530122858.GB29006@nautica>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120530122858.GB29006@nautica>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dominique Martinet <asmadeus-9aU+PIKW3UvdtAWm4Da02A@public.gmane.org>
Cc: linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


For siw, the dma_device->bus is currently not set, which will cause
the crash.

As we were testing NFS/RDMA we just disabled that fix for some Mellanox
device.

I agree I probably have to find a more consistent way to fake real dma
hardware. Any suggestions?

Thanks,
Bernard.

linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org wrote on 05/30/2012 02:28:58 PM:

> From: Dominique Martinet <asmadeus-9aU+PIKW3UvdtAWm4Da02A@public.gmane.org>
> To: linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
> Date: 05/30/2012 02:29 PM
> Subject: Re: NFS/RDMA - client crash on mount
> Sent by: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>
> Hi,
>
> Well don't mind me, it was soft-iwarp related afterall.
> It would look like siw doesn't like 2K MTU like a few other devices,
> adding it in the list in net/sunrpc/xprtrdma/verbs.c around line 880
> made the crash just disappear.
>
> It's not something easy to patch though given siw is out of tree, why is
> the MTU 2k by default? Isn't there a way to get capatibilities out of
> the devices, other than an hard-coded list like this?
>
> (this:
> /* XXX Tavor device performs badly with 2K MTU! */
> if (strnicmp(ia->ri_id->device->dma_device->bus->name, "pci", 3) == 0)
> {
>    struct pci_dev *pcid = to_pci_dev(ia->ri_id->device->dma_device);
>    if (pcid->device == PCI_DEVICE_ID_MELLANOX_TAVOR &&
>        (pcid->vendor == PCI_VENDOR_ID_MELLANOX ||
>        pcid->vendor == PCI_VENDOR_ID_TOPSPIN)) {
>       struct ib_qp_attr attr = {
>          .path_mtu = IB_MTU_1024
>       };
>       rc = ib_modify_qp(ia->ri_id->qp, &attr, IB_QP_PATH_MTU);
>    }
> })
>
>
> Sorry for the noise then, thanks to everyone who bothered to read my
> mail.
>
> --
> Dominique Martinet
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
