From: Devesh Sharma <desh.t2-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH V4 9/9] IB/mlx4: Enable mlx4_ib support for MODIFY_QP_EX
Date: Thu, 12 Sep 2013 10:56:31 +0530
Message-ID: <CAGgPuS1tAiyA3TZ5_fpua3ue6JrZ9ruS+O+QU-7t28i0dZ7cUw@mail.gmail.com>
References: <1378824099-22150-1-git-send-email-ogerlitz@mellanox.com>
	<1378824099-22150-10-git-send-email-ogerlitz@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1378824099-22150-10-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi Or,

I don't see any patches to librdmacm/libibverbs git to call _EX
version of uverbs commands. The patch you have pointed in v4-0 patch
still seems to be incomplete. Are these broken?

On Tue, Sep 10, 2013 at 8:11 PM, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote:
> From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>
> mlx4_ib driver should indicate that it supports
> MODIFY_QP_EX user verbs extended command.
>
> Signed-off-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> ---
>  drivers/infiniband/hw/mlx4/main.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/infiniband/hw/mlx4/main.c b/drivers/infiniband/hw/mlx4/main.c
> index 7a29ad5..77c87d0 100644
> --- a/drivers/infiniband/hw/mlx4/main.c
> +++ b/drivers/infiniband/hw/mlx4/main.c
> @@ -1755,7 +1755,8 @@ static void *mlx4_ib_add(struct mlx4_dev *dev)
>                 (1ull << IB_USER_VERBS_CMD_QUERY_SRQ)           |
>                 (1ull << IB_USER_VERBS_CMD_DESTROY_SRQ)         |
>                 (1ull << IB_USER_VERBS_CMD_CREATE_XSRQ)         |
> -               (1ull << IB_USER_VERBS_CMD_OPEN_QP);
> +               (1ull << IB_USER_VERBS_CMD_OPEN_QP)             |
> +               (1ull << IB_USER_VERBS_CMD_MODIFY_QP_EX);
>
>         ibdev->ib_dev.query_device      = mlx4_ib_query_device;
>         ibdev->ib_dev.query_port        = mlx4_ib_query_port;
> --
> 1.7.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
