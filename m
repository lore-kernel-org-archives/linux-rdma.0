From: "Amrani, Ram" <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Subject: RE: Configuration of cq->cqe is lower than entries by 1
Date: Mon, 14 Nov 2016 12:05:12 +0000
Message-ID: <SN1PR07MB22071D220A9067F58E1F09DAF8BC0@SN1PR07MB2207.namprd07.prod.outlook.com>
References: <SN1PR07MB22076C5DE03F1939603C554CF8BC0@SN1PR07MB2207.namprd07.prod.outlook.com>
 <20161114120153.GC4240@leon.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20161114120153.GC4240-2ukJVAZIZ/Y@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> There is addition of 1 in mlx4_ib_create_cq():
> 192         entries      =3D roundup_pow_of_two(entries + 1);
> 193         cq->ibcq.cqe =3D entries - 1;

I thought something else might hide there.
Thanks,
Ram

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
