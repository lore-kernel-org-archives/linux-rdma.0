From: "Amrani, Ram" <Ram.Amrani@cavium.com>
Subject: RE: [PATCH] RDMA/qedr: Use zeroing memory allocator than
 allocator/memset
Date: Sun, 31 Dec 2017 13:09:42 +0000
Message-ID: <BN3PR07MB25781C0289D6C5D55B712BD3F81B0@BN3PR07MB2578.namprd07.prod.outlook.com>
References: <1514723463-5859-1-git-send-email-himanshujha199640@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1514723463-5859-1-git-send-email-himanshujha199640@gmail.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Himanshu Jha <himanshujha199640@gmail.com>, "dledford@redhat.com" <dledford@redhat.com>
Cc: "Kalderon, Michal" <Michal.Kalderon@cavium.com>, "Elior, Ariel" <Ariel.Elior@cavium.com>, "jgg@ziepe.ca" <jgg@ziepe.ca>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

> Use dma_zalloc_coherent for allocating zeroed
> memory and remove unnecessary memset function.
>=20
> Done using Coccinelle.
> Generated-by: scripts/coccinelle/api/alloc/kzalloc-simple.cocci
> 0-day tested with no failures.
>=20
> Suggested-by: Luis R. Rodriguez <mcgrof@kernel.org>
> Signed-off-by: Himanshu Jha <himanshujha199640@gmail.com>
> ---
>  drivers/infiniband/hw/qedr/verbs.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
>=20
> diff --git a/drivers/infiniband/hw/qedr/verbs.c b/drivers/infiniband/hw/q=
edr/verbs.c
> index b26aa88..3b9c898 100644
> --- a/drivers/infiniband/hw/qedr/verbs.c
> +++ b/drivers/infiniband/hw/qedr/verbs.c
> @@ -604,12 +604,11 @@ static struct qedr_pbl *qedr_alloc_pbl_tbl(struct q=
edr_dev *dev,
>  		return ERR_PTR(-ENOMEM);
>=20
>  	for (i =3D 0; i < pbl_info->num_pbls; i++) {
> -		va =3D dma_alloc_coherent(&pdev->dev, pbl_info->pbl_size,
> -					&pa, flags);
> +		va =3D dma_zalloc_coherent(&pdev->dev, pbl_info->pbl_size,
> +					 &pa, flags);
>  		if (!va)
>  			goto err;
>=20
> -		memset(va, 0, pbl_info->pbl_size);
>  		pbl_table[i].va =3D va;
>  		pbl_table[i].pa =3D pa;
>  	}
> --
> 2.7.4

Acked-by: Ram Amrani <Ram.Amrani@cavium.com>

Thanks,
Ram
