From: Bart Van Assche <Bart.VanAssche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH v3 29/37] IB/rxe: Switch from dma_device to dev.parent
Date: Fri, 27 Jan 2017 22:14:51 +0000
Message-ID: <1485555269.13218.10.camel@sandisk.com>
References: <20170120210437.26389-1-bart.vanassche@sandisk.com>
         <20170120210437.26389-30-bart.vanassche@sandisk.com>
         <D4AFCE43.A031%Andrew.Boyer@emc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <D4AFCE43.A031%Andrew.Boyer-mb1K0bWo544@public.gmane.org>
Content-Language: en-US
Content-ID: <B61838521E343F48B5774D3D28C8B35A-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Andrew.Boyer-8PEkshWhKlo@public.gmane.org" <Andrew.Boyer-8PEkshWhKlo@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, 2017-01-26 at 21:06 +0000, Boyer, Andrew wrote:
> On 1/20/17, 4:04 PM, "linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org on behalf of Bart
> Van Assche" <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org on behalf of
> bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org> wrote:
>=20
> > Prepare for removal of ib_device.dma_device.
> >=20
> > Signed-off-by: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
> > Cc: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> > ---
> > drivers/infiniband/sw/rxe/rxe_verbs.c | 6 +++---
> > 1 file changed, 3 insertions(+), 3 deletions(-)
> >=20
> > @@ -1234,7 +1234,7 @@ int rxe_register_device(struct rxe_dev *rxe)
> > 	dev->node_type =3D RDMA_NODE_IB_CA;
> > 	dev->phys_port_cnt =3D 1;
> > 	dev->num_comp_vectors =3D RXE_NUM_COMP_VECTORS;
> > -	dev->dma_device =3D rxe->ifc_ops->dma_device(rxe);
> > +	dev->dev.parent =3D rxe->ifc_ops->dma_device(rxe);
> > 	dev->local_dma_lkey =3D 0;
> > 	dev->node_guid =3D rxe->ifc_ops->node_guid(rxe);
> > 	dev->dma_ops =3D &rxe_dma_mapping_ops;
>=20
> ifc_ops was recently removed, so this will be a minor merge conflict.

Hello Andrew,

Thanks for the review.

Doug, do you expect me to resolve this merge conflict by rebasing this
patch series (something Linus doesn't like) once Linus has pulled your
v4.11 pull request or are you going to explain to Linus how he should
resolve this merge conflict himself?

Thanks,

Bart.=
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
