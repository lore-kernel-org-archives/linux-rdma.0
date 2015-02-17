From: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH RE-RESEND V2 for-next 1/5] IB/core: When marshaling ucma
 path from user-space, clear unused fields
Date: Tue, 17 Feb 2015 14:24:36 -0500
Message-ID: <CAJ3xEMgm28o9HiieNMVLCfCB1E9H_=VCUJ9eKBbE5oOvHtd0bA@mail.gmail.com>
References: <1423137232-24587-1-git-send-email-ogerlitz@mellanox.com>
	<1423137232-24587-2-git-send-email-ogerlitz@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1423137232-24587-2-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ilya Nelkenbaum <ilyan-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Feb 5, 2015 at 6:53 AM, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote:
> From: Ilya Nelkenbaum <ilyan-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>
> When marsheling a user path to the kernel struct ib_sa_path, need
> to zero smac, dmac and set the vlan id to the "no vlan" value.

Other patches in the series had some comments and on-going discussion,
this one is critical fix for the apps that hit the bug, please pick it
up

>
> This is to ensure that Ethernet attributes are not used with
> InfiniBand QPs.
>
> Fixes: dd5f03beb4f7 ("IB/core: Ethernet L2 attributes in verbs/cm structures")
> Signed-off-by: Ilya Nelkenbaum <ilyan-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> ---
>  drivers/infiniband/core/ucma.c |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/infiniband/core/ucma.c b/drivers/infiniband/core/ucma.c
> index 56a4b7c..45d67e9 100644
> --- a/drivers/infiniband/core/ucma.c
> +++ b/drivers/infiniband/core/ucma.c
> @@ -1124,6 +1124,9 @@ static int ucma_set_ib_path(struct ucma_context *ctx,
>         if (!optlen)
>                 return -EINVAL;
>
> +       memset(&sa_path, 0, sizeof(sa_path));
> +       sa_path.vlan_id = 0xffff;
> +
>         ib_sa_unpack_path(path_data->path_rec, &sa_path);
>         ret = rdma_set_ib_paths(ctx->cm_id, &sa_path, 1);
>         if (ret)
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
