From: "Boyer, Andrew" <Andrew.Boyer-8PEkshWhKlo@public.gmane.org>
Subject: Re: [rdma-next 8/8] RDMA: Use defines instead of hard coded value
 for phys_state
Date: Wed, 23 Aug 2017 14:59:52 +0000
Message-ID: <D5C31047.1DB0A%Andrew.Boyer@emc.com>
References: <20170815091431.12822-1-leon@kernel.org>
 <20170815091431.12822-9-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170815091431.12822-9-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Content-Language: en-US
Content-ID: <8CB822C066D8074AB117B8D63CCE2689-/m+UfqrgI5Tvk4DGDgVwFwC/G2K4zDHf@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org



On 8/15/17, 5:14 AM, "linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org on behalf of Leon
Romanovsky" <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org on behalf of
leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:

>From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>
>There are new defines to express the physical state of the link, so
>let's reuse them instead hard-coded values.
>
>Signed-off-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>---
>diff --git a/drivers/infiniband/sw/rxe/rxe_param.h
>b/drivers/infiniband/sw/rxe/rxe_param.h
>index 1b596fbbe251..475767262102 100644
>--- a/drivers/infiniband/sw/rxe/rxe_param.h
>+++ b/drivers/infiniband/sw/rxe/rxe_param.h
>@@ -157,7 +157,7 @@ enum rxe_port_param {
> 	RXE_PORT_ACTIVE_WIDTH		=3D IB_WIDTH_1X,
> 	RXE_PORT_ACTIVE_SPEED		=3D 1,
> 	RXE_PORT_PKEY_TBL_LEN		=3D 64,
>-	RXE_PORT_PHYS_STATE		=3D 2,
>+	RXE_PORT_PHYS_STATE		=3D RDMA_LINK_PHYS_STATE_POLLING,
> 	RXE_PORT_SUBNET_PREFIX		=3D 0xfe80000000000000ULL,
> };

You can also remove IB_PHYS_STATE_* from rxe.h and the places where
they=B9re used.

>=20
>--=20
>2.14.0
>
>--
>To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
>the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
