From: "Verma, Rahul" <Rahul.Verma@cavium.com>
Subject: RE: [PATCH rdma-next] RDMA/qedr: remove set but not used variable
 'ctx'
Date: Mon, 3 Sep 2018 09:22:49 +0000
Message-ID: <CO2PR07MB2709148C026CE62A04804E92910C0@CO2PR07MB2709.namprd07.prod.outlook.com>
References: <1535774026-160694-1-git-send-email-yuehaibing@huawei.com>
 <SN6PR07MB50241FB1FF44E657987475A4900D0@SN6PR07MB5024.namprd07.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <SN6PR07MB50241FB1FF44E657987475A4900D0@SN6PR07MB5024.namprd07.prod.outlook.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: YueHaibing <yuehaibing@huawei.com>, "Kalderon, Michal" <Michal.Kalderon@cavium.com>, "Elior, Ariel" <Ariel.Elior@cavium.com>, Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>
Cc: "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org


> -----Original Message-----
> From: YueHaibing <yuehaibing@huawei.com>
> Sent: Saturday, September 1, 2018 6:54 AM
> To: Kalderon, Michal <Michal.Kalderon@cavium.com>; Elior, Ariel
> <Ariel.Elior@cavium.com>; Doug Ledford <dledford@redhat.com>; Jason
> Gunthorpe <jgg@ziepe.ca>
> Cc: YueHaibing <yuehaibing@huawei.com>; linux-rdma@vger.kernel.org;
> linux-kernel@vger.kernel.org; kernel-janitors@vger.kernel.org
> Subject: [PATCH rdma-next] RDMA/qedr: remove set but not used variable
> 'ctx'
>
> External Email
>
> Fixes gcc '-Wunused-but-set-variable' warning:
>
> drivers/infiniband/hw/qedr/verbs.c: In function 'qedr_create_srq':
> drivers/infiniband/hw/qedr/verbs.c:1450:24: warning:
>  variable 'ctx' set but not used [-Wunused-but-set-variable]
>
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>
> ---
>  drivers/infiniband/hw/qedr/verbs.c | 2 --
>  1 file changed, 2 deletions(-)
>
> diff --git a/drivers/infiniband/hw/qedr/verbs.c
> b/drivers/infiniband/hw/qedr/verbs.c
> index 8cc3df2..9d4d165 100644
> --- a/drivers/infiniband/hw/qedr/verbs.c
> +++ b/drivers/infiniband/hw/qedr/verbs.c
> @@ -1447,7 +1447,6 @@ struct ib_srq *qedr_create_srq(struct ib_pd
> *ibpd,
>         u64 pbl_base_addr, phy_prod_pair_addr;
>         struct ib_ucontext *ib_ctx =3D NULL;
>         struct qedr_srq_hwq_info *hw_srq;
> -       struct qedr_ucontext *ctx =3D NULL;
>         u32 page_cnt, page_size;
>         struct qedr_srq *srq;
>         int rc =3D 0;
> @@ -1473,7 +1472,6 @@ struct ib_srq *qedr_create_srq(struct ib_pd
> *ibpd,
>
>         if (udata && ibpd->uobject && ibpd->uobject->context) {
>                 ib_ctx =3D ibpd->uobject->context;
> -               ctx =3D get_qedr_ucontext(ib_ctx);
>
>                 if (ib_copy_from_udata(&ureq, udata, sizeof(ureq))) {
>                         DP_ERR(dev,

Thank Yue.
Acked-by: Rahul Verma <rahul.verma@cavium.com>=20
