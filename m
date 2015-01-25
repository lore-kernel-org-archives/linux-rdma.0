From: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH 1/4] IB/uverbs: ex_query_device: fail if output buffer
 size does not match
Date: Sun, 25 Jan 2015 17:29:01 +0200
Message-ID: <54C50BBD.5000009@mellanox.com>
References: <cover.1421931555.git.ydroneaud@opteya.com>
 <d60715123c640bc7b720ad11a9faa3af78950aa6.1421931555.git.ydroneaud@opteya.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <d60715123c640bc7b720ad11a9faa3af78950aa6.1421931555.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Shachar Raindel <raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 22/01/2015 15:28, Yann Droneaud wrote:
> Instead of silently truncating extended QUERY_DEVICE uverb's
> response, see commit 5a77abf9a97a ("IB/core: Add support for
> extended query device caps")), this patch makes function
> ib_uverbs_ex_query_device() check the available space in the
> response buffer against the requested features set in comp_mask
> (currently only IB_USER_VERBS_EX_QUERY_DEVICE_ODP per commit
> 860f10a799c8 ("IB/core: Add flags for on demand paging support").

Currently you only need to check two possible sizes. With each
additional field you will need to check another size. Sooner or later
someone will forget to add a check and will create a non-backward
compatible kernel.

> If the response buffer is not large enough to store the expected
> response, -ENOSPC is returned to userspace so that it can adjust
> the size of its buffer.
> 
> Note: as offsetof() is used to retrieve the size of the lower chunk
> of the response, beware that it only works if the upper chunk
> is right after, without any implicit padding. And, as the size of
> the latter chunk is added to the base size, implicit padding at the
> end of the structure is not taken in account. Both point must be
> taken in account when extending the uverbs functionalities.

Another point future contributors will easily miss.

> Link: http://mid.gmane.org/cover.1421931555.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org
> Cc: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Cc: Shachar Raindel <raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Cc: Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Cc: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Signed-off-by: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
> ---
>  drivers/infiniband/core/uverbs_cmd.c | 13 ++++++++++++-
>  1 file changed, 12 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
> index 532d8eba8b02..8668b328b7e6 100644
> --- a/drivers/infiniband/core/uverbs_cmd.c
> +++ b/drivers/infiniband/core/uverbs_cmd.c
> @@ -3302,6 +3302,7 @@ int ib_uverbs_ex_query_device(struct ib_uverbs_file *file,
>  	struct ib_uverbs_ex_query_device  cmd;
>  	struct ib_device_attr attr;
>  	struct ib_device *device;
> +	size_t resp_len;
>  	int err;
>  
>  	device = file->device->ib_dev;
> @@ -3315,6 +3316,11 @@ int ib_uverbs_ex_query_device(struct ib_uverbs_file *file,
>  	if (cmd.reserved)
>  		return -EINVAL;
>  
> +	resp_len = offsetof(typeof(resp), odp_caps);
> +
> +	if (ucore->outlen < resp_len)
> +		return -ENOSPC;
> +
>  	err = device->query_device(device, &attr);
>  	if (err)
>  		return err;
> @@ -3325,6 +3331,11 @@ int ib_uverbs_ex_query_device(struct ib_uverbs_file *file,
>  
>  #ifdef CONFIG_INFINIBAND_ON_DEMAND_PAGING
>  	if (cmd.comp_mask & IB_USER_VERBS_EX_QUERY_DEVICE_ODP) {
> +		resp_len += sizeof(resp.odp_caps);
> +
> +		if (ucore->outlen < resp_len)
> +			return -ENOSPC;
> +
>  		resp.odp_caps.general_caps = attr.odp_caps.general_caps;
>  		resp.odp_caps.per_transport_caps.rc_odp_caps =
>  			attr.odp_caps.per_transport_caps.rc_odp_caps;
> @@ -3336,7 +3347,7 @@ int ib_uverbs_ex_query_device(struct ib_uverbs_file *file,
>  	}
>  #endif
>  
> -	err = ib_copy_to_udata(ucore, &resp, sizeof(resp));
> +	err = ib_copy_to_udata(ucore, &resp, resp_len);
>  	if (err)
>  		return err;
>  
> 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
