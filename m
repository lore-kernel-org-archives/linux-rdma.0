From: "Amrani, Ram" <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Subject: RE: Querying the GID from a Provider Library
Date: Thu, 2 Feb 2017 10:54:17 +0000
Message-ID: <SN1PR07MB220707BD6ED8C61E74B33513F84C0@SN1PR07MB2207.namprd07.prod.outlook.com>
References: <SN1PR07MB22070E07E3610AFDD7F6DD97F84D0@SN1PR07MB2207.namprd07.prod.outlook.com>
 <d435251a-00a9-9304-afed-76aa46f0aa26@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <d435251a-00a9-9304-afed-76aa46f0aa26-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> ibv_query_gid is used all around by vendors, it serves as some helper
> function which is exported from libibverbs, you can just use it.

OK, thanks.
=20
> Re 'ibv_cmd_query_gid' looks like some 'dead' code that should be delted.

I'll send a patch on Sunday.

Thanks,
Ram


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
