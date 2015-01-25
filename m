From: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH 3/4] IB/uverbs: ex_query_device: check request's comp_mask
Date: Sun, 25 Jan 2015 17:23:19 +0200
Message-ID: <54C50A67.6040306@mellanox.com>
References: <cover.1421931555.git.ydroneaud@opteya.com>
 <063956366559d6919693aabb324bab83d676bc28.1421931555.git.ydroneaud@opteya.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <063956366559d6919693aabb324bab83d676bc28.1421931555.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Shachar Raindel <raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 22/01/2015 15:28, Yann Droneaud wrote:
> This patch ensures the extended QUERY_DEVICE uverbs request's
> comp_mask has only known values. If userspace returns unknown
> features, -EINVAL will be returned, allowing to probe/discover
> which features are currently supported by the kernel.

This probing process will be much more cumbersome than it needs to be
because userspace will have to call QUERY_DEVICE repetitively with
different comp_mask fields until it finds out the exact set of supported
bits.

> Moreover, it also ensure the requested features set in comp_mask
> are sequentially set, not skipping intermediate features, eg. the
> "highest" requested feature also request all the "lower" ones.
> This way each new feature will have to be stacked on top of the
> existing ones: this is especially important for the request and
> response data structures where fields are added after the
> current ones when expanded to support a new feature.

I think it is perfectly acceptable that not all drivers will implement
all available features, and so you shouldn't enforce this requirement.
Also, it makes the comp_mask nothing more than a wasteful version number
between 0 and 63.

In the specific case of QUERY_DEVICE you might argue that there isn't
any need for input comp_mask, only for output, and then you may enforce
the input comp_mask will always be zero. However, you will in any case
need to be able to extended the size of the response in the future.

> 
> Link: http://mid.gmane.org/cover.1421931555.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org
> Cc: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Cc: Shachar Raindel <raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Cc: Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Cc: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Signed-off-by: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
> ---
>  drivers/infiniband/core/uverbs_cmd.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
> index 8668b328b7e6..80a1c90f1dbf 100644
> --- a/drivers/infiniband/core/uverbs_cmd.c
> +++ b/drivers/infiniband/core/uverbs_cmd.c
> @@ -3313,6 +3313,12 @@ int ib_uverbs_ex_query_device(struct ib_uverbs_file *file,
>  	if (err)
>  		return err;
>  
> +	if (cmd.comp_mask & (cmd.comp_mask + 1))
> +		return -EINVAL;
> +
> +	if (cmd.comp_mask & ~(__u32)IB_USER_VERBS_EX_QUERY_DEVICE_ODP)
> +		return -EINVAL;
> +
>  	if (cmd.reserved)
>  		return -EINVAL;
>  
> 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
