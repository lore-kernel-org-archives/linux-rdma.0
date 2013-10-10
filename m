From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH for-next] IB/core: clarify overflow/underflow checks on
 ib_create/destroy_flow
Date: Thu, 10 Oct 2013 11:15:20 +0300
Message-ID: <52566218.4080202@mellanox.com>
References: <1379855171-16576-1-git-send-email-matanb@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1379855171-16576-1-git-send-email-matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Cc: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Hadar Har-Zion <hadarh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, shawn.bohrer-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 22/09/2013 16:06, Matan Barak wrote:
> This patch fixes the following issues:
> 1. Unneeded checks were removed
> 2. Removed the fixed size out of flow_attr.size and by thus
>     simplifying the checks.
> 3. Remove a 32bit hole on 64bit systems with strict alignment
>     in struct ib_kern_flow_att by adding a reserved field.
>
> Signed-off-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Roland, I just realized that this patch from Matan which fixes some 
3.12-rc1 issues that
were spotted over the list isn't applied which is pretty bad. Lets get 
it in  - Yann please rebase
your other fixes on top of this one - which also include issues you 
pointed on.

Or.

> ---
> Hi Roland,
>
> This patch cleans up the overflow/underflow checks for flow stearing uverbs
> commands. The issues were discovered by Yann Droneaud's review.
> Clauses 2 & 3 affects user space, but since there isn't an official release
> of linux kernel with flow steering support nor an official userspace for
> this feature (at least nothing that I'm aware of), I don't think that's a
> problem.
>
> Thanks,
> Matan
>
>   drivers/infiniband/core/uverbs_cmd.c |   27 ++++++++++++---------------
>   include/uapi/rdma/ib_user_verbs.h    |    1 +
>   2 files changed, 13 insertions(+), 15 deletions(-)
>
> diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
> index 9a0c5d7..404f45b 100644
> --- a/drivers/infiniband/core/uverbs_cmd.c
> +++ b/drivers/infiniband/core/uverbs_cmd.c
> @@ -2851,7 +2851,6 @@ ssize_t ib_uverbs_create_flow(struct ib_uverbs_file *file,
>   	void *kern_spec;
>   	void *ib_spec;
>   	int i;
> -	int kern_attr_size;
>   
>   	if (out_len < sizeof(resp))
>   		return -ENOSPC;
> @@ -2866,15 +2865,11 @@ ssize_t ib_uverbs_create_flow(struct ib_uverbs_file *file,
>   	     !capable(CAP_NET_ADMIN)) || !capable(CAP_NET_RAW))
>   		return -EPERM;
>   
> -	if (cmd.flow_attr.num_of_specs < 0 ||
> -	    cmd.flow_attr.num_of_specs > IB_FLOW_SPEC_SUPPORT_LAYERS)
> +	if (cmd.flow_attr.num_of_specs > IB_FLOW_SPEC_SUPPORT_LAYERS)
>   		return -EINVAL;
>   
> -	kern_attr_size = cmd.flow_attr.size - sizeof(cmd) -
> -			 sizeof(struct ib_uverbs_cmd_hdr_ex);
> -
> -	if (cmd.flow_attr.size < 0 || cmd.flow_attr.size > in_len ||
> -	    kern_attr_size < 0 || kern_attr_size >
> +	if (cmd.flow_attr.size > (in_len - sizeof(cmd) - sizeof(struct
> +	    ib_uverbs_cmd_hdr_ex)) || cmd.flow_attr.size >
>   	    (cmd.flow_attr.num_of_specs * sizeof(struct ib_kern_spec)))
>   		return -EINVAL;
>   
> @@ -2885,13 +2880,12 @@ ssize_t ib_uverbs_create_flow(struct ib_uverbs_file *file,
>   
>   		memcpy(kern_flow_attr, &cmd.flow_attr, sizeof(*kern_flow_attr));
>   		if (copy_from_user(kern_flow_attr + 1, buf + sizeof(cmd),
> -				   kern_attr_size)) {
> +				   cmd.flow_attr.size)) {
>   			err = -EFAULT;
>   			goto err_free_attr;
>   		}
>   	} else {
>   		kern_flow_attr = &cmd.flow_attr;
> -		kern_attr_size = sizeof(cmd.flow_attr);
>   	}
>   
>   	uobj = kmalloc(sizeof(*uobj), GFP_KERNEL);
> @@ -2923,19 +2917,22 @@ ssize_t ib_uverbs_create_flow(struct ib_uverbs_file *file,
>   
>   	kern_spec = kern_flow_attr + 1;
>   	ib_spec = flow_attr + 1;
> -	for (i = 0; i < flow_attr->num_of_specs && kern_attr_size > 0; i++) {
> +	for (i = 0; i < flow_attr->num_of_specs &&
> +	     cmd.flow_attr.size > offsetof(struct ib_kern_spec, reserved) &&
> +	     cmd.flow_attr.size >=
> +	     ((struct ib_kern_spec *)kern_spec)->size; i++) {
>   		err = kern_spec_to_ib_spec(kern_spec, ib_spec);
>   		if (err)
>   			goto err_free;
>   		flow_attr->size +=
>   			((union ib_flow_spec *) ib_spec)->size;
> -		kern_attr_size -= ((struct ib_kern_spec *) kern_spec)->size;
> +		cmd.flow_attr.size -= ((struct ib_kern_spec *)kern_spec)->size;
>   		kern_spec += ((struct ib_kern_spec *) kern_spec)->size;
>   		ib_spec += ((union ib_flow_spec *) ib_spec)->size;
>   	}
> -	if (kern_attr_size) {
> -		pr_warn("create flow failed, %d bytes left from uverb cmd\n",
> -			kern_attr_size);
> +	if (cmd.flow_attr.size || (i != flow_attr->num_of_specs)) {
> +		pr_warn("create flow failed, flow %d: %d bytes left from uverb cmd\n",
> +			i, cmd.flow_attr.size);
>   		goto err_free;
>   	}
>   	flow_id = ib_create_flow(qp, flow_attr, IB_FLOW_DOMAIN_USER);
> diff --git a/include/uapi/rdma/ib_user_verbs.h b/include/uapi/rdma/ib_user_verbs.h
> index f1939cf..20f8531 100644
> --- a/include/uapi/rdma/ib_user_verbs.h
> +++ b/include/uapi/rdma/ib_user_verbs.h
> @@ -924,6 +924,7 @@ struct ib_kern_flow_attr {
>   
>   struct ib_uverbs_create_flow  {
>   	__u32 comp_mask;
> +	__u32 reserved;
>   	__u64 response;
>   	__u32 qp_handle;
>   	struct ib_kern_flow_attr flow_attr;

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
