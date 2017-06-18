From: "Amrani, Ram" <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Subject: RE: rdma-core 13 fails to build on Ubuntu 16.04.1 LTS
Date: Sun, 18 Jun 2017 07:12:58 +0000
Message-ID: <BN3PR07MB25780C5525947AD92E43BF6BF8C70@BN3PR07MB2578.namprd07.prod.outlook.com>
References: <CO2PR07MB2584B40776D19F8302B387F2F8C00@CO2PR07MB2584.namprd07.prod.outlook.com>
 <20170615164036.GA23773@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170615164036.GA23773-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> > Is this a known issue?
>=20
> Yes, you need to cherry pick this patch for ARM:
>=20
> commit 3f26e322622e93546f1b3a1a89c788adcebedcbe
> Author: Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Date:   Wed Mar 22 22:12:24 2017 -0400
>=20
>     Fix udma_to_device_barrier on aarch64
>=20
>     The definition for udma_to_device_barrier on aarch64 is missing. Look=
s
>     like an oversight in the commit that removed the old barrier macros a=
nd
>     added this one.
>=20
>     Fixes: 85a5529dead5 ("Remove the old barrier macros")
>     Signed-off-by: Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>     Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
>=20
> Jason


Thanks

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
