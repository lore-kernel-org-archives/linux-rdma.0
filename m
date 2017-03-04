From: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: RE: v4.11 mlx5 regression
Date: Sat, 4 Mar 2017 02:45:48 +0000
Message-ID: <VI1PR0502MB30087231A9B791711F87ABC2D12A0@VI1PR0502MB3008.eurprd05.prod.outlook.com>
References: <alpine.LFD.2.20.1702272047120.2997@schleppi.fritz.box>
         <1488233058.2597.1.camel@sandisk.com>
         <alpine.LFD.2.20.1702280950380.2045@schleppi.fritz.box>
         <1488300599.2370.5.camel@sandisk.com>
         <VI1PR0502MB30082C037BEE60367954ED0FD1560@VI1PR0502MB3008.eurprd05.prod.outlook.com>
         <1488312028.2370.12.camel@sandisk.com>
         <742435998.40235677.1488312819300.JavaMail.zimbra@redhat.com>
         <VI1PR0502MB30087B8BB5E6733E92E96D62D1560@VI1PR0502MB3008.eurprd05.prod.outlook.com>
 <1488578667.25946.1.camel@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1488578667.25946.1.camel-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <Bart.VanAssche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, "loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Bart,

> -----Original Message-----
> From: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-rdma-
> owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of Bart Van Assche
> Sent: Friday, March 3, 2017 4:05 PM
> To: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>; loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
> Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
> Subject: Re: v4.11 mlx5 regression
>=20
> On Tue, 2017-02-28 at 20:34 +0000, Parav Pandit wrote:
> > In middle of debugging/using setup right now for other issue.
> > I am basically using nvme-rdma target mode code and somewhere in path
> of MR or QP setup it fails.
> > I am suspecting MR because QP1 creation has passed.
> > I will get to the bottom of this to provide traces tomorrow.
>=20
Sorry. I didn't any chance last whole week to debug it.

> Hello Parav,
>=20
> The I/O MMU was disabled while I prepared and tested the patch series tha=
t
> reworks DMA support for RDMA drivers. I assume that the error message
> you reported means that the I/O MMU was enabled on your test setup?=20

Yes. Iommu is enabled.

>If so, can you check whether the patch below makes the mlx5 driver (and al=
l
> other RDMA
> drivers) work again on your test setup?
>=20
I tested this patch. It works with mlx5 driver.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
