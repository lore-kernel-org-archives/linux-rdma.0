From: "Amrani, Ram" <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Subject: RE: [PATCH rdma v1 0/1] IB/core: Fix input len in multiple user verbs
Date: Thu, 6 Jul 2017 12:24:34 +0000
Message-ID: <BN3PR07MB25782522FB09A41FA47742A8F8D50@BN3PR07MB2578.namprd07.prod.outlook.com>
References: <1498572282-22370-1-git-send-email-Ram.Amrani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1498572282-22370-1-git-send-email-Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "Elior, Ariel" <Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> This patch follows [1] that fixed three verbs and extends that fix to
> the other verbs as well.
>=20
> This fix is required for qedr to support existing and future libraries.
>=20
> I was able to test the fix only partially due to its scope hence careful
> review is required, and testing, of course.
>=20
> v0->v1:
>  * Updated vendor verbs to match the core changes.
>=20
>=20
> [1] https://www.spinics.net/lists/linux-rdma/msg33405.html
>=20
> Ram Amrani (1):
>   IB/core: Fix input len in multiple user verbs
>=20
>  drivers/infiniband/core/uverbs_cmd.c         | 70 ++++++++++++++++------=
------
>  drivers/infiniband/hw/mlx5/cq.c              |  6 +--
>  drivers/infiniband/hw/mlx5/main.c            | 11 ++---
>  drivers/infiniband/hw/mthca/mthca_provider.c |  2 +-
>  4 files changed, 46 insertions(+), 43 deletions(-)
>=20
> --
> 1.8.3.1

Hi Doug,
Are you OK with applying the patch or do you expect ACKs for mlx5 and mthca=
?

Thanks,
Ram

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
