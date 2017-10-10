From: "Amrani, Ram" <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Subject: RE: Is ib_mtu iboe_get_mtu() slightly off?
Date: Tue, 10 Oct 2017 10:29:31 +0000
Message-ID: <BN3PR07MB25781502CA573FB383805E48F8750@BN3PR07MB2578.namprd07.prod.outlook.com>
References: <CAL1RGDX33tBR=x2sOp_F1605SY5nu_6YALr-XYE_LiuvsHQ1ng@mail.gmail.com>
 <VI1PR0502MB300886CB47BB3DFDE098A26AD1660@VI1PR0502MB3008.eurprd05.prod.outlook.com>
 <1507556073.46071.27.camel@redhat.com>
 <20171009134131.GB1252@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171009134131.GB1252-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> https://git.kernel.org/pub/scm/linux/kernel/git/leon/linux-rdma.git/commi=
t/?h=3Drdma-next&id=3D51ed6735dd59008aea4d7308416ed994b277f168
>=20
> commit 51ed6735dd59008aea4d7308416ed994b277f168
> Author: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Date:   Thu Oct 5 10:33:12 2017 -0500
>=20
>     IB/core: Take into account optional XRC header and mandatory ICRC for=
 RoCE MTU
>=20
>     This fix considers optional XRC header size and mandatory ICRC 4 byte=
s in
>     calculation of path MTU, by considering additional 8 bytes, path MTU =
calculation
>     is more accurate.
>=20
>     Link: https://www.spinics.net/lists/linux-rdma/msg54558.html
>     Fixes: 3c86aa70bf67 ("RDMA/cm: Add RDMA CM support for IBoE devices")
>     Signed-off-by: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>     Reviewed-by: Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>     Reported-by: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
>     Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

Hi Parav, All,
Shouldn't the overhead calculation take into account RoCEv2 too,
i.e. include the UDP header length?

Thanks,
Ram

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
