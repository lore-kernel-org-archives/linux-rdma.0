From: "Amrani, Ram" <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Subject: RE: max_inline_data in ibv_rc_pingpong
Date: Wed, 28 Dec 2016 09:45:08 +0000
Message-ID: <SN1PR07MB220732025C454D5E5EF69527F8680@SN1PR07MB2207.namprd07.prod.outlook.com>
References: <SN1PR07MB22079DB9A8D87699539DBB01F8970@SN1PR07MB2207.namprd07.prod.outlook.com>
 <a412a47f-74ad-cc09-4003-11b93e59f5f8@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <a412a47f-74ad-cc09-4003-11b93e59f5f8-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Elior, Ariel" <Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> Based on man page cap is an in/out structure
> "..the values will be greater than or equal to the values requested".
>=20
> The below example demonstrates a case that there is enough space for
> using inline data for the given input size. It may happen as of some
> alignment on the WQE calculated size and is based on vendor
> implementation.
>=20
> In a real application usually an explicit value is set before calling
> ibv_create_qp to achieve a size that is required by the application for
> its needs.


I would prefer it to use an explicit value instead of per-driver residual v=
alue.
This allows for better understanding of what is actually going on.
One of our customers used it for latency comparisons between devices and go=
t different values, not knowing that with one driver he was using inline an=
d with the other he isn't.
Will you be OK with a "-I" parameter as in perftest?

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
