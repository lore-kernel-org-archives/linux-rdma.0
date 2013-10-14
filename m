From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH 2/9] IB/core: Includes flow attribute size in uverbs create_flow
Date: Mon, 14 Oct 2013 14:01:53 +0300
Message-ID: <525BCF21.3090706@mellanox.com>
References: <cover.1381510045.git.ydroneaud@opteya.com> <a83e37e225cd16e5a556b35dcadc7a1234519c2a.1381510045.git.ydroneaud@opteya.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <a83e37e225cd16e5a556b35dcadc7a1234519c2a.1381510045.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 11/10/2013 20:18, Yann Droneaud wrote:
> In patch "IB/core: clarify overflow/underflow checks on ib_create/destroy_flow",
> the meaning of the size field was modified to only represent
> the size of the flow_spec appended to the flow_attr structure.
>
> The size of the flow_attr structure must be added when
> allocating memory for the whole flow_attr + flow_specs
> buffer.

wait, patch #2 fixes a problem introduced in patch #1? if this is the 
case, why not change patch #1?
> Signed-off-by: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
> Link: http://marc.info/?i=cover.1381510045.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org
> Link: http://mid.gmane.org/cover.1381510045.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org
> ---
>   drivers/infiniband/core/uverbs_cmd.c | 5 +++--
>   1 file changed, 3 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
> index 63c2700..3b732f6 100644
> --- a/drivers/infiniband/core/uverbs_cmd.c
> +++ b/drivers/infiniband/core/uverbs_cmd.c
> @@ -2677,7 +2677,8 @@ ssize_t ib_uverbs_create_flow(struct ib_uverbs_file *file,
>   		return -EINVAL;
>   
>   	if (cmd.flow_attr.num_of_specs) {
> -		kern_flow_attr = kmalloc(cmd.flow_attr.size, GFP_KERNEL);
> +		kern_flow_attr = kmalloc(sizeof(*kern_flow_attr) + cmd.flow_attr.size,
> +					 GFP_KERNEL);
>   		if (!kern_flow_attr)
>   			return -ENOMEM;
>   
> @@ -2705,7 +2706,7 @@ ssize_t ib_uverbs_create_flow(struct ib_uverbs_file *file,
>   		goto err_uobj;
>   	}
>   
> -	flow_attr = kmalloc(cmd.flow_attr.size, GFP_KERNEL);
> +	flow_attr = kmalloc(sizeof(*flow_attr) + cmd.flow_attr.size, GFP_KERNEL);
>   	if (!flow_attr) {
>   		err = -ENOMEM;
>   		goto err_put;

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
