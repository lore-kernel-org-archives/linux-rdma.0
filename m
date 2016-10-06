From: "Amrani, Ram" <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH qedr 04/10] qedr: Add support for PD,PKEY and CQ verbs
Date: Thu, 6 Oct 2016 18:34:44 +0000
Message-ID: <SN1PR07MB2207C35D34DEBA9D8DA13322F8C70@SN1PR07MB2207.namprd07.prod.outlook.com>
References: <1475682483-9878-1-git-send-email-Ram.Amrani@cavium.com>
 <1475682483-9878-5-git-send-email-Ram.Amrani@cavium.com>,<20161006133357.GP9282@leon.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20161006133357.GP9282-2ukJVAZIZ/Y@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Elior, Ariel" <Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, "Kalderon, Michal" <Michal.Kalderon-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, "Mintz, Yuval" <Yuval.Mintz-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, "Borundia, Rajesh" <Rajesh.Borundia-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


>> +=A0=A0=A0=A0 pd =3D kzalloc(sizeof(*pd), GFP_KERNEL);
>> +=A0=A0=A0=A0 if (!pd) {
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 DP_ERR(dev, "failed to alloce PD\n=
");
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 return ERR_PTR(-ENOMEM);
>> +=A0=A0=A0=A0 }
>> +
>> +=A0=A0=A0=A0 if (!dev->rdma_ctx) {
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 DP_ERR(dev, "invlaid RDMA context\=
n");
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 return ERR_PTR(-EINVAL);
>
>Don't you want to free pd which was allocated a couple of lines before?

Good catch. Thanks.

>> +=A0=A0=A0=A0 pbe =3D (struct regpair *)pbl_tbl->va;
>> +=A0=A0=A0=A0 if (!pbe) {
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 DP_ERR(dev, "pbe is NULL\n");
>
>=A0????

Yep,=A0I'll change=A0this.    =
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
