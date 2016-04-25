From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH] IB/mlx4: trivial fix of spelling mistake on "argument"
Date: Mon, 25 Apr 2016 13:04:09 -0700
Message-ID: <571E7839.1030403@sandisk.com>
References: <1461612410-27604-1-git-send-email-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1461612410-27604-1-git-send-email-colin.king-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Colin King <colin.king-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Jiri Kosina <trivial-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 04/25/2016 12:26 PM, Colin King wrote:
> From: Colin Ian King <colin.king-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
>
> fix spelling mistake, argumant -> argument
>
> Signed-off-by: Colin Ian King <colin.king-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
> ---
>   drivers/infiniband/hw/mlx4/main.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/infiniband/hw/mlx4/main.c b/drivers/infiniband/hw/mlx4/main.c
> index f014eaf..b01ef6e 100644
> --- a/drivers/infiniband/hw/mlx4/main.c
> +++ b/drivers/infiniband/hw/mlx4/main.c
> @@ -1601,7 +1601,7 @@ static int __mlx4_ib_create_flow(struct ib_qp *qp, struct ib_flow_attr *flow_att
>   	else if (ret == -ENXIO)
>   		pr_err("Device managed flow steering is disabled. Fail to register network rule.\n");
>   	else if (ret)
> -		pr_err("Invalid argumant. Fail to register network rule.\n");
> +		pr_err("Invalid argument. Fail to register network rule.\n");
>
>   	mlx4_free_cmd_mailbox(mdev->dev, mailbox);
>   	return ret;

Reviewed-by: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
