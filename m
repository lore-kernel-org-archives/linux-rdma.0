From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH v2 4/4] IB/core: extended command: add a common extended
 response header
Date: Tue, 8 Oct 2013 14:58:52 +0300
Message-ID: <5253F37C.90508@mellanox.com>
References: <cover.1381177342.git.ydroneaud@opteya.com> <9e111d8215c1fd86b75db17f2c890f0f28e0d076.1381177342.git.ydroneaud@opteya.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <9e111d8215c1fd86b75db17f2c890f0f28e0d076.1381177342.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Cc: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, Igor Ivanov <Igor.Ivanov-wN0M4riKYwLQT0dZR+AlfA@public.gmane.org>, Hadar Hen Zion <hadarh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 7/10/2013 11:49 PM, Yann Droneaud wrote:
> This patch introduces a common response header for extended commands.
>
> This common header is designed to hold
> - the returned comp_mask,
> - the response sizes from core/ (eg. uverbs) and hw/ (eg. provider).
>
> This header is part of the core response buffer, consuming 8 bytes,
> so response buffer should be at least large enough to hold it.
>
> To make the behavior consistent between command and response,
> the command header is taken in account while checking command size,
> just like it was for current commands.
>
> In order to be able to report the size of the response from core/
> and hw/, UDATA structures passed to handler functions are updated
> each time space is used response buffer.
> To report the comp_mask of the response, a pointer to comp_mask is
> given as an input/output parameter of handler functions.
>
> This provide a common framework to handle comp_mask for all extend
> responses, additionally having the response buffer size would help
> userspace to better handle extended response.
>
> The new layout for command and response buffer is:
>
> - command:
>
>      +----------------------------------------+
>      | flags     |   00      00    |  command |
>      |        in_words    |   out_words       |
>      +----------------------------------------+
>      |                 response               |
>      |                 response               |
>      | provider_in_words | provider_out_words |
>      |                comp_mask               |
>      +----------------------------------------+
>      |                                        |
>      .             <uverbs input>             .
>      .             (in_words * 8)             .
>      .     - sizeof(hdr) - sizeof(ex_hdr)     .
>      |                                        |
>      +----------------------------------------+
>      |                                        |
>      .             <provider input>           .
>      .          (provider_in_words * 8)       .
>      |                                        |
>      +----------------------------------------+
>
> - response, if present:
>
>      +----------------------------------------+
>      |               <extended                |
>      |             response header>           |
>      +----------------------------------------+
>      |                                        |
>      .           <uverbs output space>        .
>      .             (out_words * 8)            .
>      .            - sizeof(ex_resp)           .
>      |                                        |
>      +----------------------------------------+
>      |                                        |
>      .         <provider output space>        .
>      .         (provider_out_words * 8)       .
>      |                                        |
>      +----------------------------------------+
>
> For a successful command, the response buffer will be
> presented with an updated header:
>
>      +----------------------------------------+
>      |                comp_mask               |
>      |     out_words     | provider_out_words |
>      +----------------------------------------+
>      |                                        |
>      .             <uverbs output>            .
>      .             (out_words * 8)            .
>      .            - sizeof(ex_resp)           .
>      |                                        |
>      +----------------------------------------+
>      |                                        |
>      .            <provider output>           .
>      .         (provider_out_words * 8)       .
>      |                                        |
>      +----------------------------------------+
>
> The most notable drawbacks of this approach are:
> - increase in complexity,
> - inability to handle error gracefully when writing the response header.
>
> Cc: Igor Ivanov <Igor.Ivanov-wN0M4riKYwLQT0dZR+AlfA@public.gmane.org>
> Cc: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Signed-off-by: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
> Link: http://marc.info/?i=cover.1381177342.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org
> Link: http://mid.gmane.org/cover.1381177342.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org
> ---
>   drivers/infiniband/core/uverbs.h      |  2 +-
>   drivers/infiniband/core/uverbs_cmd.c  | 17 +++++++----
>   drivers/infiniband/core/uverbs_main.c | 54 +++++++++++++++++++++++++++++------
>   include/rdma/ib_verbs.h               | 22 ++++++++++++++
>   include/uapi/rdma/ib_user_verbs.h     |  8 +++++-
>   5 files changed, 87 insertions(+), 16 deletions(-)
>
> diff --git a/drivers/infiniband/core/uverbs.h b/drivers/infiniband/core/uverbs.h
> index 03f6a0a..a1df33f 100644
> --- a/drivers/infiniband/core/uverbs.h
> +++ b/drivers/infiniband/core/uverbs.h
> @@ -230,7 +230,7 @@ IB_UVERBS_DECLARE_CMD(close_xrcd);
>   	int ib_uverbs_ex_##name(struct ib_uverbs_file *file,	\
>   				struct ib_udata *ucore,		\
>   				struct ib_udata *uhw,		\
> -				__u32 comp_mask)
> +				__u32 *comp_mask)
>
>   IB_UVERBS_DECLARE_EX_CMD(create_flow);
>   IB_UVERBS_DECLARE_EX_CMD(destroy_flow);
> diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
> index 3b09f1d..3d2f0ad 100644
> --- a/drivers/infiniband/core/uverbs_cmd.c
> +++ b/drivers/infiniband/core/uverbs_cmd.c
> @@ -2634,7 +2634,7 @@ static int kern_spec_to_ib_spec(struct ib_kern_spec *kern_spec,
>   int ib_uverbs_ex_create_flow(struct ib_uverbs_file *file,
>   			     struct ib_udata *ucore,
>   			     struct ib_udata *uhw,
> -			     __u32 comp_mask)
> +			     __u32 *comp_mask)
>   {
>   	struct ib_uverbs_create_flow	  cmd;
>   	struct ib_uverbs_create_flow_resp resp;
> @@ -2649,7 +2649,7 @@ int ib_uverbs_ex_create_flow(struct ib_uverbs_file *file,
>   	int i;
>   	int kern_attr_size;
>
> -	if (comp_mask)
> +	if (*comp_mask)
>   		return -EINVAL;
>
>   	if (ucore->inlen != sizeof(cmd))
> @@ -2662,8 +2662,7 @@ int ib_uverbs_ex_create_flow(struct ib_uverbs_file *file,
>   	if (err)
>   		return err;
>
> -	ucore->inbuf += sizeof(cmd);
> -	ucore->inlen -= sizeof(cmd);
> +	ib_udata_consume_in(ucore, sizeof(cmd));
>
>   	if ((cmd.flow_attr.type == IB_FLOW_ATTR_SNIFFER &&
>   	     !capable(CAP_NET_ADMIN)) || !capable(CAP_NET_RAW))
> @@ -2693,6 +2692,7 @@ int ib_uverbs_ex_create_flow(struct ib_uverbs_file *file,
>   			err = -EFAULT;
>   			goto err_free_attr;
>   		}
> +		ib_udata_consume_in(ucore, kern_attr_size);
>   	} else {
>   		kern_flow_attr = &cmd.flow_attr;
>   		kern_attr_size = sizeof(cmd.flow_attr);
> @@ -2763,6 +2763,8 @@ int ib_uverbs_ex_create_flow(struct ib_uverbs_file *file,
>   	if (err)
>   		goto err_copy;
>
> +	ib_udata_consume_out(ucore, sizeof(resp));
> +
>   	put_qp_read(qp);
>   	mutex_lock(&file->mutex);
>   	list_add_tail(&uobj->list, &file->ucontext->rule_list);
> @@ -2774,6 +2776,9 @@ int ib_uverbs_ex_create_flow(struct ib_uverbs_file *file,
>   	kfree(flow_attr);
>   	if (cmd.flow_attr.num_of_specs)
>   		kfree(kern_flow_attr);
> +
> +	*comp_mask = 0;
> +
>   	return 0;
>   err_copy:
>   	idr_remove_uobj(&ib_uverbs_rule_idr, uobj);
> @@ -2794,14 +2799,14 @@ err_free_attr:
>   int ib_uverbs_ex_destroy_flow(struct ib_uverbs_file *file,
>   			      struct ib_udata *ucore,
>   			      struct ib_udata *uhw,
> -			      __u32 comp_mask)
> +			      __u32 *comp_mask)
>   {
>   	struct ib_uverbs_destroy_flow	cmd;
>   	struct ib_flow			*flow_id;
>   	struct ib_uobject		*uobj;
>   	int				ret;
>
> -	if (comp_mask)
> +	if (*comp_mask)
>   		return -EINVAL;
>
>   	if (ucore->inlen != sizeof(cmd))
> diff --git a/drivers/infiniband/core/uverbs_main.c b/drivers/infiniband/core/uverbs_main.c
> index a9687dd..12b44a2 100644
> --- a/drivers/infiniband/core/uverbs_main.c
> +++ b/drivers/infiniband/core/uverbs_main.c
> @@ -120,7 +120,7 @@ static ssize_t (*uverbs_cmd_table[])(struct ib_uverbs_file *file,
>   static int (*uverbs_ex_cmd_table[])(struct ib_uverbs_file *file,
>   				    struct ib_udata *ucore,
>   				    struct ib_udata *uhw,
> -				    __u32 comp_mask) = {
> +				    __u32 *comp_mask) = {
>   	[IB_USER_VERBS_EX_CMD_CREATE_FLOW]	= ib_uverbs_ex_create_flow,
>   	[IB_USER_VERBS_EX_CMD_DESTROY_FLOW]	= ib_uverbs_ex_destroy_flow
>   };
> @@ -636,8 +636,13 @@ static ssize_t ib_uverbs_write(struct file *filp, const char __user *buf,
>   		__u32 command;
>
>   		struct ib_uverbs_ex_cmd_hdr ex_hdr;
> +		struct ib_uverbs_ex_resp_hdr ex_resp;
>   		struct ib_udata ucore;
>   		struct ib_udata uhw;
> +		unsigned long response;
> +		size_t ucore_outlen = 0;
> +		size_t uhw_outlen = 0;
> +		__u32 comp_mask;
>   		int err;
>
>   		if (hdr.command & ~(__u32)(IB_USER_VERBS_CMD_FLAGS_MASK |
> @@ -662,13 +667,12 @@ static ssize_t ib_uverbs_write(struct file *filp, const char __user *buf,
>   		if (copy_from_user(&ex_hdr, buf + sizeof(hdr), sizeof(ex_hdr)))
>   			return -EFAULT;
>
> -		count -= sizeof(hdr) + sizeof(ex_hdr);
> -		buf += sizeof(hdr) + sizeof(ex_hdr);
> -
>   		if ((hdr.in_words + ex_hdr.provider_in_words) * 8 != count)
>   			return -EINVAL;
>
> -		if (ex_hdr.response) {
> +		response = (unsigned long)ex_hdr.response;
> +
> +		if (response) {
>   			if (!hdr.out_words && !ex_hdr.provider_out_words)
>   				return -EINVAL;
>   		} else {
> @@ -678,24 +682,58 @@ static ssize_t ib_uverbs_write(struct file *filp, const char __user *buf,
>
>   		INIT_UDATA(&ucore,
>   			   (hdr.in_words) ? buf : 0,
> -			   (unsigned long)ex_hdr.response,
> +			   response,
>   			   hdr.in_words * 8,
>   			   hdr.out_words * 8);
>
> +		ib_udata_consume_in(&ucore, sizeof(hdr) + sizeof(ex_hdr));
> +
> +		if (response) {
> +
> +			ucore_outlen = ucore.outlen; /* keep in mind total available len
> +							(including response header size) */
> +
> +			err = ib_udata_consume_out(&ucore, sizeof(ex_resp));
> +			if (err)
> +				return err;
> +
> +			/* fail early to not have to recover from invalid response buffer */
> +			memset(&ex_resp, 0, sizeof(ex_resp));
> +			if (copy_to_user((void __user *)response,
> +					 &ex_resp, sizeof(ex_resp)))
> +				return -EFAULT;
> +		}
> +
>   		INIT_UDATA(&uhw,
>   			   (ex_hdr.provider_in_words) ? buf + ucore.inlen : 0,
> -			   (ex_hdr.provider_out_words) ? (unsigned long)ex_hdr.response + ucore.outlen : 0,
> +			   (ex_hdr.provider_out_words) ? response + ucore.outlen : 0,
>   			   ex_hdr.provider_in_words * 8,
>   			   ex_hdr.provider_out_words * 8);
>
> +		if (response)
> +			uhw_outlen = uhw.outlen;
> +
> +		comp_mask = ex_hdr.comp_mask;
> +
>   		err = uverbs_ex_cmd_table[command](file,
>   						   &ucore,
>   						   &uhw,
> -						   ex_hdr.comp_mask);
> +						   &comp_mask);
>
>   		if (err)
>   			return err;
>
> +		if (response) {
> +
> +			ex_resp.comp_mask = comp_mask;
> +			ex_resp.out_words = (ucore_outlen - ucore.outlen) / 8;
> +			ex_resp.provider_out_words = (uhw_outlen - uhw.outlen) / 8;
> +
> +			if (copy_to_user((void __user *)response,
> +					 &ex_resp, sizeof(ex_resp)))
> +				return -EFAULT;
> +		}
> +
>   		return count;
>   	}
>
> diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
> index a06fc12..9dd7dad 100644
> --- a/include/rdma/ib_verbs.h
> +++ b/include/rdma/ib_verbs.h
> @@ -1478,6 +1478,28 @@ static inline int ib_copy_to_udata(struct ib_udata *udata, void *src, size_t len
>   	return copy_to_user(udata->outbuf, src, len) ? -EFAULT : 0;
>   }
>
> +static inline int ib_udata_consume_in(struct ib_udata *udata, size_t len)
> +{
> +	if (udata->inlen < len)
> +		return -EINVAL;
> +
> +	udata->inlen -= len;
> +	udata->inbuf += len;
> +
> +	return 0;
> +}
> +
> +static inline int ib_udata_consume_out(struct ib_udata *udata, size_t len)
> +{
> +	if (udata->outlen < len)
> +		return -ENOSPC;
> +
> +	udata->outlen -= len;
> +	udata->outbuf += len;
> +
> +	return 0;
> +}
> +
>   /**
>    * ib_modify_qp_is_ok - Check that the supplied attribute mask
>    * contains all required attributes and no attributes not allowed for
> diff --git a/include/uapi/rdma/ib_user_verbs.h b/include/uapi/rdma/ib_user_verbs.h
> index 13b3008..0da06d0 100644
> --- a/include/uapi/rdma/ib_user_verbs.h
> +++ b/include/uapi/rdma/ib_user_verbs.h
> @@ -142,6 +142,12 @@ struct ib_uverbs_ex_cmd_hdr {
>   	__u32 comp_mask;
>   };
>
> +struct ib_uverbs_ex_resp_hdr {
> +	__u32 comp_mask;
> +	__u16 out_words;
> +	__u16 provider_out_words;
> +};
> +
>   struct ib_uverbs_get_context {
>   	__u64 response;
>   	__u64 driver_data[0];
> @@ -778,8 +784,8 @@ struct ib_uverbs_create_flow  {
>   };
>
>   struct ib_uverbs_create_flow_resp {
> -	__u32 comp_mask;
>   	__u32 flow_handle;
> +	__u32 reserved;
>   };
>
>   struct ib_uverbs_destroy_flow  {
>

Hi

Nice work on the patches.

Regarding the last patch, you are right that it simplifies things for 
creating new uverbs where command parts are in-lined one after another, 
but the infrastructure got a bit more complex.

If we're going to this direction, I think the we should also deal with 
the problem of extending one of the command parts. Currently, we'll have 
to put a comp_mask in the in-lined command part, consume this command 
part and then continue with the other parts. It might be better than 
using a pointer, but this put the burden of serializing the command 
buffer into the kernel structures onto the uverb command writer.
We might want to avoid this.

Furthermore, the comp_mask of the command is different than the 
comp_mask of the response. Therefore, I don't think we should pass the 
command's comp_mask to the uverb as a pointer, but just pass a pointer 
to value 0 that the uverb will set.

Regards,
Matan
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
