From: Wengang Wang <wen.gang.wang-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] IB/mlx4: correct order of variables in log
Date: Thu, 8 Oct 2015 11:30:15 +0800
Message-ID: <5615E347.6050006@oracle.com>
References: <1443406123-15234-1-git-send-email-wen.gang.wang@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=gbk;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1443406123-15234-1-git-send-email-wen.gang.wang-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Wengang Wang <wen.gang.wang-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi,

Any comment on this patch?

thanks,
wengang

=D4=DA 2015=C4=EA09=D4=C228=C8=D5 10:08, Wengang Wang =D0=B4=B5=C0:
> There is a mis-order in mlx4 log. Fix it.
>
> Signed-off-by: Wengang Wang <wen.gang.wang-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> ---
>   drivers/net/ethernet/mellanox/mlx4/cmd.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/net/ethernet/mellanox/mlx4/cmd.c b/drivers/net/e=
thernet/mellanox/mlx4/cmd.c
> index 0a32020..150fbb3 100644
> --- a/drivers/net/ethernet/mellanox/mlx4/cmd.c
> +++ b/drivers/net/ethernet/mellanox/mlx4/cmd.c
> @@ -1010,7 +1010,7 @@ static int mlx4_MAD_IFC_wrapper(struct mlx4_dev=
 *dev, int slave,
>   		if (!(smp->mgmt_class =3D=3D IB_MGMT_CLASS_SUBN_LID_ROUTED &&
>   		      smp->method =3D=3D IB_MGMT_METHOD_GET) || network_view) {
>   			mlx4_err(dev, "Unprivileged slave %d is trying to execute a Subn=
et MGMT MAD, class 0x%x, method 0x%x, view=3D%s for attr 0x%x. Rejectin=
g\n",
> -				 slave, smp->method, smp->mgmt_class,
> +				 slave, smp->mgmt_class, smp->method,
>   				 network_view ? "Network" : "Host",
>   				 be16_to_cpu(smp->attr_id));
>   			return -EPERM;

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
