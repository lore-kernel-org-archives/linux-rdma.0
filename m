From: "Boyer, Andrew" <Andrew.Boyer-8PEkshWhKlo@public.gmane.org>
Subject: Re: [PATCH v3 29/37] IB/rxe: Switch from dma_device to dev.parent
Date: Thu, 26 Jan 2017 21:06:07 +0000
Message-ID: <D4AFCE43.A031%Andrew.Boyer@emc.com>
References: <20170120210437.26389-1-bart.vanassche@sandisk.com>
 <20170120210437.26389-30-bart.vanassche@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170120210437.26389-30-bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Content-Language: en-US
Content-ID: <C0CF7EB314877F4A8F41EB32AE23ECFB-/m+UfqrgI5Tvk4DGDgVwFwC/G2K4zDHf@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org



On 1/20/17, 4:04 PM, "linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org on behalf of Bart
Van Assche" <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org on behalf of
bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org> wrote:

>Prepare for removal of ib_device.dma_device.
>
>Signed-off-by: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
>Cc: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>---
> drivers/infiniband/sw/rxe/rxe_verbs.c | 6 +++---
> 1 file changed, 3 insertions(+), 3 deletions(-)
>
>@@ -1234,7 +1234,7 @@ int rxe_register_device(struct rxe_dev *rxe)
> 	dev->node_type =3D RDMA_NODE_IB_CA;
> 	dev->phys_port_cnt =3D 1;
> 	dev->num_comp_vectors =3D RXE_NUM_COMP_VECTORS;
>-	dev->dma_device =3D rxe->ifc_ops->dma_device(rxe);
>+	dev->dev.parent =3D rxe->ifc_ops->dma_device(rxe);
> 	dev->local_dma_lkey =3D 0;
> 	dev->node_guid =3D rxe->ifc_ops->node_guid(rxe);
> 	dev->dma_ops =3D &rxe_dma_mapping_ops;

ifc_ops was recently removed, so this will be a minor merge conflict.

Reviewed-by: Andrew Boyer <andrew.boyer-8PEkshWhKlo@public.gmane.org>

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
