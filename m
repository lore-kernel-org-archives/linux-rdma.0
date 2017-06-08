From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH rdma-next 1/5] RDMA/netlink: Remove netlink clients
 infrastructure
Date: Thu, 8 Jun 2017 08:29:25 -0700
Message-ID: <88fb8d57-cd02-78bc-3045-c09f62c280b9@sandisk.com>
References: <20170608143852.9072-1-leon@kernel.org>
 <20170608143852.9072-2-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170608143852.9072-2-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 06/08/17 07:38, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> 
> RDMA netlink has complicated infrastructure to add and remove netlink
> clients to NETLINK_RDMA family. This complicates the code and not in
> use because not many clients are available (3 clients) and most of them
> (2 clients) are statically compiled together with netlink.c.
> 
> The following patch refactors RDMA netlink and opens door for the future
> patches which will be able to get rid of a lot of dead iwcm* code.

Hello Leon,

There are multiple changes in this patch:
- Renaming ibnl_add_client() and ibnl_remove_client() into
rdma_nl_register() and rdma_nl_unregister().
- Removal of the module pointers from ibnl_ls_cb_table[].
- Conversion of client_list from a linked list into an array
(rdma_nl_types[]).

Could this patch have been split?

> +static bool is_nl_msg_valid(unsigned int type, unsigned int op)
>  {
> -	[ ... ]
> +	unsigned int max_num_ops;
> +
> +	switch (type) {
> +	case RDMA_NL_RDMA_CM:
> +		max_num_ops = RDMA_NL_RDMA_CM_NUM_OPS;
> +		break;
> +	case RDMA_NL_IWCM:
> +		max_num_ops = RDMA_NL_IWPM_NUM_OPS;
> +		break;
> +	case RDMA_NL_LS:
> +		max_num_ops = RDMA_NL_LS_NUM_OPS;
> +		break;
> +	case RDMA_NL_RSVD:
> +	case RDMA_NL_I40IW:
> +	default:
> +		return false;
>  	}
> +	return (op < max_num_ops) ? true : false;
> +}

Can this code be made more compact by storing the *_NUM_OPS constants in
an array?

> +void rdma_nl_register(unsigned int index,
> +		      const struct ibnl_client_cbs cb_table[])
>  {
> -	[ ... ]
> -	return -EINVAL;
> +	rdma_nl_types[index].cb_table = cb_table;
> +	mutex_unlock(&rdma_nl_mutex);
> +}
> +EXPORT_SYMBOL(rdma_nl_register);

Shouldn't this function return an error code or print a warning message
if rdma_nl_types[index].cb_table had already been set?

Otherwise this patch looks like a welcome cleanup and simplification to me.

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
