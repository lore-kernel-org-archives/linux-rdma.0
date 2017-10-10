From: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: RE: Is ib_mtu iboe_get_mtu() slightly off?
Date: Tue, 10 Oct 2017 15:26:33 +0000
Message-ID: <VI1PR0502MB3008D0FAE7FC51CE627D5ADED1750@VI1PR0502MB3008.eurprd05.prod.outlook.com>
References: <CAL1RGDX33tBR=x2sOp_F1605SY5nu_6YALr-XYE_LiuvsHQ1ng@mail.gmail.com>
 <VI1PR0502MB300886CB47BB3DFDE098A26AD1660@VI1PR0502MB3008.eurprd05.prod.outlook.com>
 <1507556073.46071.27.camel@redhat.com>
 <20171009134131.GB1252@mtr-leonro.local>
 <BN3PR07MB25781502CA573FB383805E48F8750@BN3PR07MB2578.namprd07.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <BN3PR07MB25781502CA573FB383805E48F8750-EldUQEzkDQfpW3VS/XPqkOFPX92sqiQdvxpqHgZTriW3zl9H0oFU5g@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Amrani, Ram" <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org



> -----Original Message-----
> From: Amrani, Ram [mailto:Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org]
> Sent: Tuesday, October 10, 2017 5:30 AM
> To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>; Doug Ledford
> <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>; Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>; Roland Dreier
> <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>; linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Subject: RE: Is ib_mtu iboe_get_mtu() slightly off?
>=20
> >     Fixes: 3c86aa70bf67 ("RDMA/cm: Add RDMA CM support for IBoE devices=
")
> >     Signed-off-by: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> >     Reviewed-by: Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> >     Reported-by: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
> >     Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
>=20
> Hi Parav, All,
> Shouldn't the overhead calculation take into account RoCEv2 too, i.e. inc=
lude
> the UDP header length?
>=20
Yes. I will roll v1 with inclusion of UDP header as well.
Now that we have RoCEv2 GIDs as default, it make sense to always include UD=
P header in calculation.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
