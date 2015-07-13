From: Wengang Wang <wen.gang.wang-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] rds: rds_ib_device.refcount overflow
Date: Mon, 13 Jul 2015 09:18:58 +0800
Message-ID: <55A31202.1030408@oracle.com>
References: <1436164511-2411-1-git-send-email-wen.gang.wang@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=gbk;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1436164511-2411-1-git-send-email-wen.gang.wang-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi Doug,

How do you think about this patch?

thanks,
wengang

=D4=DA 2015=C4=EA07=D4=C206=C8=D5 14:35, Wengang Wang =D0=B4=B5=C0:
> Fixes: 3e0249f9c05c ("RDS/IB: add refcount tracking to struct rds_ib_=
device")
>
> There lacks a dropping on rds_ib_device.refcount in case rds_ib_alloc=
_fmr
> failed(mr pool running out). this lead to the refcount overflow.
>
> A complain in line 117(see following) is seen. From vmcore:
> s_ib_rdma_mr_pool_depleted is 2147485544 and rds_ibdev->refcount is -=
2147475448.
> That is the evidence the mr pool is used up. so rds_ib_alloc_fmr is v=
ery likely
> to return ERR_PTR(-EAGAIN).
>
> 115 void rds_ib_dev_put(struct rds_ib_device *rds_ibdev)
> 116 {
> 117         BUG_ON(atomic_read(&rds_ibdev->refcount) <=3D 0);
> 118         if (atomic_dec_and_test(&rds_ibdev->refcount))
> 119                 queue_work(rds_wq, &rds_ibdev->free_work);
> 120 }
>
> fix is to drop refcount when rds_ib_alloc_fmr failed.
>
> Signed-off-by: Wengang Wang <wen.gang.wang-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> Reviewed-by: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> ---
>   net/rds/ib_rdma.c | 4 +++-
>   1 file changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/net/rds/ib_rdma.c b/net/rds/ib_rdma.c
> index 273b8bf..657ba9f 100644
> --- a/net/rds/ib_rdma.c
> +++ b/net/rds/ib_rdma.c
> @@ -759,8 +759,10 @@ void *rds_ib_get_mr(struct scatterlist *sg, unsi=
gned long nents,
>   	}
>  =20
>   	ibmr =3D rds_ib_alloc_fmr(rds_ibdev);
> -	if (IS_ERR(ibmr))
> +	if (IS_ERR(ibmr)) {
> +		rds_ib_dev_put(rds_ibdev);
>   		return ibmr;
> +	}
>  =20
>   	ret =3D rds_ib_map_fmr(rds_ibdev, ibmr, sg, nents);
>   	if (ret =3D=3D 0)

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
