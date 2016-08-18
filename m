From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: RE: [PATCH libibverbs 2/3] Add support for TCP segmentation offload
 (TSO)
Date: Thu, 18 Aug 2016 07:55:08 +0000
Message-ID: <HE1PR05MB1418BA4382257289AB9DEA63CE150@HE1PR05MB1418.eurprd05.prod.outlook.com>
References: <1469708382-29408-1-git-send-email-yishaih@mellanox.com>
 <1469708382-29408-3-git-send-email-yishaih@mellanox.com>
 <80ff6d05-201a-3fa6-deab-2dbb035a89c3@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <80ff6d05-201a-3fa6-deab-2dbb035a89c3-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Bodong Wang <bodong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> From: Or Gerlitz
> Sent: Thursday, August 18, 2016 9:06 AM
> To: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org; linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; Bodong Wang
> <bodong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>; Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>; Tal Alon
> <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Subject: Re: [PATCH libibverbs 2/3] Add support for TCP segmentation
> offload (TSO)
>=20
> On 7/28/2016 3:19 PM, Yishai Hadas wrote:
> > 3) Add IBV_WC_TSO to be used as part of poll_cq to report a TSO
> completion.
>=20
> why is that needed? what's the proposed/possible applicative usage of
> that bit?

It's consistent with the kernel API that adds similar bit for LSO.
http://lxr.free-electrons.com/source/include/rdma/ib_verbs.h#L842

Specifically, it can give an application an accurate  knowledge about the c=
ompletion type
as done for other cases as part of ibv_post_send as of IBV_WC_BIND_MW,
IBV_WC_LOCAL_INV, etc.



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
