From: Wengang Wang <wen.gang.wang-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH V3] IB/mlx4: Use vmalloc for WR buffers when needed
Date: Thu, 17 Dec 2015 10:39:32 +0800
Message-ID: <56722064.2050105@oracle.com>
References: <1444282024-11425-1-git-send-email-wen.gang.wang@oracle.com>
 <17CFA44C-D58F-49C0-B3CE-95D38C08E16B@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <17CFA44C-D58F-49C0-B3CE-95D38C08E16B-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matthew Finlay <Matt-goXnUAHYgFxWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Matt,

Yes, you are right.
Since the patch is already merged in, I am going to make a separated=20
patch for that.

thanks,
wengang

=E5=9C=A8 2015=E5=B9=B412=E6=9C=8812=E6=97=A5 04:28, Matthew Finlay =E5=
=86=99=E9=81=93:
> Hi Wengang,
>
> I was going through your patch set here, and it seems that you missed=
 changing kfree to kvfree in mlx4_ib_destroy_srq().  In the current cod=
e if the srq wrid is allocated using vmalloc, then on cleanup we will u=
se kfree, which is a bug.
>
> Thanks,
> -matt
>
>
>
>
> On 10/7/15, 10:27 PM, "linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org on behalf of =
Wengang Wang" <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org on behalf of wen.gang.w=
ang-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org> wrote:
>
>> There are several hits that WR buffer allocation(kmalloc) failed.
>> It failed at order 3 and/or 4 contigous pages allocation. At the sam=
e time
>> there are actually 100MB+ free memory but well fragmented.
>> So try vmalloc when kmalloc failed.
>>
>> Signed-off-by: Wengang Wang <wen.gang.wang-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
>> Acked-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>> ---
>> drivers/infiniband/hw/mlx4/qp.c  | 19 +++++++++++++------
>> drivers/infiniband/hw/mlx4/srq.c | 11 ++++++++---
>> 2 files changed, 21 insertions(+), 9 deletions(-)
>>
>> diff --git a/drivers/infiniband/hw/mlx4/qp.c b/drivers/infiniband/hw=
/mlx4/qp.c
>> index 4ad9be3..3ccbd3a 100644
>> --- a/drivers/infiniband/hw/mlx4/qp.c
>> +++ b/drivers/infiniband/hw/mlx4/qp.c
>> @@ -34,6 +34,7 @@
>> #include <linux/log2.h>
>> #include <linux/slab.h>
>> #include <linux/netdevice.h>
>> +#include <linux/vmalloc.h>
>>
>> #include <rdma/ib_cache.h>
>> #include <rdma/ib_pack.h>
>> @@ -786,8 +787,14 @@ static int create_qp_common(struct mlx4_ib_dev =
*dev, struct ib_pd *pd,
>> 		if (err)
>> 			goto err_mtt;
>>
>> -		qp->sq.wrid  =3D kmalloc(qp->sq.wqe_cnt * sizeof (u64), gfp);
>> -		qp->rq.wrid  =3D kmalloc(qp->rq.wqe_cnt * sizeof (u64), gfp);
>> +		qp->sq.wrid =3D kmalloc(qp->sq.wqe_cnt * sizeof(u64), gfp);
>> +		if (!qp->sq.wrid)
>> +			qp->sq.wrid =3D __vmalloc(qp->sq.wqe_cnt * sizeof(u64),
>> +						gfp, PAGE_KERNEL);
>> +		qp->rq.wrid =3D kmalloc(qp->rq.wqe_cnt * sizeof(u64), gfp);
>> +		if (!qp->rq.wrid)
>> +			qp->rq.wrid =3D __vmalloc(qp->rq.wqe_cnt * sizeof(u64),
>> +						gfp, PAGE_KERNEL);
>> 		if (!qp->sq.wrid || !qp->rq.wrid) {
>> 			err =3D -ENOMEM;
>> 			goto err_wrid;
>> @@ -874,8 +881,8 @@ err_wrid:
>> 		if (qp_has_rq(init_attr))
>> 			mlx4_ib_db_unmap_user(to_mucontext(pd->uobject->context), &qp->db=
);
>> 	} else {
>> -		kfree(qp->sq.wrid);
>> -		kfree(qp->rq.wrid);
>> +		kvfree(qp->sq.wrid);
>> +		kvfree(qp->rq.wrid);
>> 	}
>>
>> err_mtt:
>> @@ -1050,8 +1057,8 @@ static void destroy_qp_common(struct mlx4_ib_d=
ev *dev, struct mlx4_ib_qp *qp,
>> 					      &qp->db);
>> 		ib_umem_release(qp->umem);
>> 	} else {
>> -		kfree(qp->sq.wrid);
>> -		kfree(qp->rq.wrid);
>> +		kvfree(qp->sq.wrid);
>> +		kvfree(qp->rq.wrid);
>> 		if (qp->mlx4_ib_qp_type & (MLX4_IB_QPT_PROXY_SMI_OWNER |
>> 		    MLX4_IB_QPT_PROXY_SMI | MLX4_IB_QPT_PROXY_GSI))
>> 			free_proxy_bufs(&dev->ib_dev, qp);
>> diff --git a/drivers/infiniband/hw/mlx4/srq.c b/drivers/infiniband/h=
w/mlx4/srq.c
>> index dce5dfe..8d133c4 100644
>> --- a/drivers/infiniband/hw/mlx4/srq.c
>> +++ b/drivers/infiniband/hw/mlx4/srq.c
>> @@ -34,6 +34,7 @@
>> #include <linux/mlx4/qp.h>
>> #include <linux/mlx4/srq.h>
>> #include <linux/slab.h>
>> +#include <linux/vmalloc.h>
>>
>> #include "mlx4_ib.h"
>> #include "user.h"
>> @@ -172,8 +173,12 @@ struct ib_srq *mlx4_ib_create_srq(struct ib_pd =
*pd,
>>
>> 		srq->wrid =3D kmalloc(srq->msrq.max * sizeof (u64), GFP_KERNEL);
>> 		if (!srq->wrid) {
>> -			err =3D -ENOMEM;
>> -			goto err_mtt;
>> +			srq->wrid =3D __vmalloc(srq->msrq.max * sizeof(u64),
>> +					      GFP_KERNEL, PAGE_KERNEL);
>> +			if (!srq->wrid) {
>> +				err =3D -ENOMEM;
>> +				goto err_mtt;
>> +			}
>> 		}
>> 	}
>>
>> @@ -204,7 +209,7 @@ err_wrid:
>> 	if (pd->uobject)
>> 		mlx4_ib_db_unmap_user(to_mucontext(pd->uobject->context), &srq->db=
);
>> 	else
>> -		kfree(srq->wrid);
>> +		kvfree(srq->wrid);
>>
>> err_mtt:
>> 	mlx4_mtt_cleanup(dev->dev, &srq->mtt);
>> --=20
>> 2.1.0
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-rdma=
" in
>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> N=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BDr=EF=BF=BD=EF=BF=BDy=EF=
=BF=BD=EF=BF=BD=EF=BF=BDb=EF=BF=BDX=EF=BF=BD=EF=BF=BD=C7=A7v=EF=BF=BD^=EF=
=BF=BD)=DE=BA{.n=EF=BF=BD+=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD{=EF=BF=BD=
=EF=BF=BD=D9=9A=EF=BF=BD{ay=EF=BF=BD=1D=CA=87=DA=99=EF=BF=BD,j=07=EF=BF=
=BD=EF=BF=BDf=EF=BF=BD=EF=BF=BD=EF=BF=BDh=EF=BF=BD=EF=BF=BD=EF=BF=BDz=EF=
=BF=BD=1E=EF=BF=BDw=EF=BF=BD=EF=BF=BD=EF=BF=BD=0C=EF=BF=BD=EF=BF=BD=EF=BF=
=BDj:+v=EF=BF=BD=EF=BF=BD=EF=BF=BDw=EF=BF=BDj=EF=BF=BDm=EF=BF=BD=EF=BF=BD=
=EF=BF=BD=EF=BF=BD=07=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BDzZ+=EF=BF=BD=EF=
=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=DD=A2j"=EF=BF=BD=EF=BF=BD!tml=3D

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
