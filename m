From: Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH libmlx5] Add support for create/destroy flow
Date: Wed, 3 Feb 2016 19:12:53 +0200
Message-ID: <56B23515.2060904@dev.mellanox.co.il>
References: <1453904796-17573-1-git-send-email-maorg@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1453904796-17573-1-git-send-email-maorg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Maor Gottlieb <maorg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 1/27/2016 4:26 PM, Maor Gottlieb wrote:
> Add a call to the extended version of ibv_create_flow and
> ibv_destroy_flow.
>
> Signed-off-by: Maor Gottlieb <maorg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> ---
>   src/mlx5.c | 2 ++
>   1 file changed, 2 insertions(+)
>
> diff --git a/src/mlx5.c b/src/mlx5.c
> index e44898a..9dff4cc 100644
> --- a/src/mlx5.c
> +++ b/src/mlx5.c
> @@ -584,6 +584,8 @@ static int mlx5_init_context(struct verbs_device *vdev,
>   	verbs_set_ctx_op(v_ctx, create_srq_ex, mlx5_create_srq_ex);
>   	verbs_set_ctx_op(v_ctx, get_srq_num, mlx5_get_srq_num);
>   	verbs_set_ctx_op(v_ctx, query_device_ex, mlx5_query_device_ex);
> +	verbs_set_ctx_op(v_ctx, ibv_create_flow, ibv_cmd_create_flow);
> +	verbs_set_ctx_op(v_ctx, ibv_destroy_flow, ibv_cmd_destroy_flow);
>
>   	return 0;
>
>

Applied, thanks.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
