From: "Amrani, Ram" <Ram.Amrani@cavium.com>
Subject: RE: [PATCH] RDMA/qedr: Fix some error handling
Date: Sun, 19 Feb 2017 11:46:34 +0000
Message-ID: <SN1PR07MB220717357BB9DABB438CFD94F85F0@SN1PR07MB2207.namprd07.prod.outlook.com>
References: <20170218112815.9329-1-christophe.jaillet@wanadoo.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170218112815.9329-1-christophe.jaillet@wanadoo.fr>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Christophe JAILLET <christophe.jaillet@wanadoo.fr>, "dledford@redhat.com" <dledford@redhat.com>, "sean.hefty@intel.com" <sean.hefty@intel.com>, "hal.rosenstock@gmail.com" <hal.rosenstock@gmail.com>, "Kalderon, Michal" <Michal.Kalderon@cavium.com>, "Borundia, Rajesh" <Rajesh.Borundia@cavium.com>, "weiyongjun1@huawei.com" <weiyongjun1@huawei.com>
Cc: "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

> 'qedr_alloc_pbl_tbl()' can not return NULL.
>=20
> In qedr_init_user_queue():
>  - simplify the test for the return value, no need to test for NULL
>  - propagate the error pointer if needed, otherwise 0 (success) is return=
ed.
>    This is spurious.
>=20
> In init_mr_info():
>  - test the return value with IS_ERR
>  - propagate the error pointer if needed instead of an exlictit -ENOMEM.
>    This is a no-op as the only error pointer that we can have here is
>    already -ENOMEM
>=20
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> ---
>  drivers/infiniband/hw/qedr/verbs.c | 10 ++++++----
>  1 file changed, 6 insertions(+), 4 deletions(-)
>=20
> diff --git a/drivers/infiniband/hw/qedr/verbs.c b/drivers/infiniband/hw/q=
edr/verbs.c
> index ef83a3f322d6..0c51657af151 100644
> --- a/drivers/infiniband/hw/qedr/verbs.c
> +++ b/drivers/infiniband/hw/qedr/verbs.c
> @@ -771,8 +771,10 @@ static inline int qedr_init_user_queue(struct ib_uco=
ntext *ib_ctx,
>  		goto err0;
>=20
>  	q->pbl_tbl =3D qedr_alloc_pbl_tbl(dev, &q->pbl_info, GFP_KERNEL);
> -	if (IS_ERR_OR_NULL(q->pbl_tbl))
> +	if (IS_ERR(q->pbl_tbl)) {
> +		rc =3D PTR_ERR(q->pbl_tbl);
>  		goto err0;
> +	}
>=20
>  	qedr_populate_pbls(dev, q->umem, q->pbl_tbl, &q->pbl_info);
>=20
> @@ -2105,8 +2107,8 @@ static int init_mr_info(struct qedr_dev *dev, struc=
t mr_info *info,
>  		goto done;
>=20
>  	info->pbl_table =3D qedr_alloc_pbl_tbl(dev, &info->pbl_info, GFP_KERNEL=
);
> -	if (!info->pbl_table) {
> -		rc =3D -ENOMEM;
> +	if (IS_ERR(info->pbl_table)) {
> +		rc =3D PTR_ERR(info->pbl_table);
>  		goto done;
>  	}
>=20
> @@ -2117,7 +2119,7 @@ static int init_mr_info(struct qedr_dev *dev, struc=
t mr_info *info,
>  	 * list and allocating another one
>  	 */
>  	tmp =3D qedr_alloc_pbl_tbl(dev, &info->pbl_info, GFP_KERNEL);
> -	if (!tmp) {
> +	if (IS_ERR(tmp)) {
>  		DP_DEBUG(dev, QEDR_MSG_MR, "Extra PBL is not allocated\n");
>  		goto done;
>  	}
> --
> 2.9.3


Acked-by: Ram Amrani <Ram.Amrani@cavium.com>

Merci
